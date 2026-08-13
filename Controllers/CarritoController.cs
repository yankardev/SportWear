using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Extensions;
using SportWear.Web.Models;
using SportWear.Web.ViewModels;

namespace SportWear.Web.Controllers;

public class CarritoController : Controller
{
    private const string ClaveCarrito = "CarritoDirecto";
    private static readonly string[] TallasPermitidas = ["S", "M", "L", "XL"];

    private readonly IProductoRepositorio _productoRepositorio;
    private readonly IClienteRepositorio _clienteRepositorio;
    private readonly IVentaRepositorio _ventaRepositorio;

    public CarritoController(
        IProductoRepositorio productoRepositorio,
        IClienteRepositorio clienteRepositorio,
        IVentaRepositorio ventaRepositorio)
    {
        _productoRepositorio = productoRepositorio;
        _clienteRepositorio = clienteRepositorio;
        _ventaRepositorio = ventaRepositorio;
    }

    [HttpGet]
    public IActionResult Index()
    {
        return View(ConstruirCarrito());
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Agregar(
        int productoId,
        string? talla,
        int cantidad = 1,
        string? returnUrl = null)
    {
        var producto = _productoRepositorio.ObtenerPorId(productoId);

        if (producto is null || !producto.Activo || producto.Personalizable)
        {
            TempData["MensajeError"] = "El producto no está disponible para venta directa.";
            return Redirigir(returnUrl);
        }

        string? tallaNormalizada = NormalizarTalla(talla);
        if (tallaNormalizada is null)
        {
            TempData["MensajeError"] = "Selecciona una talla válida: S, M, L o XL.";
            return Redirigir(returnUrl);
        }

        if (cantidad < 1)
            cantidad = 1;

        if (producto.Stock <= 0)
        {
            TempData["MensajeError"] = "El producto se encuentra sin stock.";
            return Redirigir(returnUrl);
        }

        var carrito = ObtenerSesion();
        var item = carrito.FirstOrDefault(x =>
            x.ProductoId == productoId &&
            string.Equals(x.Talla, tallaNormalizada, StringComparison.OrdinalIgnoreCase));

        int unidadesActualesProducto = carrito
            .Where(x => x.ProductoId == productoId)
            .Sum(x => x.Cantidad);

        int nuevaCantidadTotalProducto = unidadesActualesProducto + cantidad;

        if (nuevaCantidadTotalProducto > producto.Stock)
        {
            TempData["MensajeError"] = $"Solo hay {producto.Stock} unidades disponibles de {producto.Nombre}.";
            return Redirigir(returnUrl);
        }

        if (item is null)
        {
            carrito.Add(new CarritoSesionItem
            {
                ProductoId = productoId,
                Talla = tallaNormalizada,
                Cantidad = cantidad
            });
        }
        else
        {
            item.Cantidad += cantidad;
        }

        GuardarSesion(carrito);
        TempData["MensajeExito"] = $"{producto.Nombre} - talla {tallaNormalizada} fue agregado al carrito.";
        return Redirigir(returnUrl);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Actualizar(int productoId, string talla, int cantidad)
    {
        string? tallaNormalizada = NormalizarTalla(talla);
        if (tallaNormalizada is null)
            return RedirectToAction(nameof(Index));

        var carrito = ObtenerSesion();
        var item = carrito.FirstOrDefault(x =>
            x.ProductoId == productoId &&
            string.Equals(x.Talla, tallaNormalizada, StringComparison.OrdinalIgnoreCase));

        if (item is null)
            return RedirectToAction(nameof(Index));

        if (cantidad <= 0)
        {
            carrito.Remove(item);
            GuardarSesion(carrito);
            return RedirectToAction(nameof(Index));
        }

        var producto = _productoRepositorio.ObtenerPorId(productoId);
        if (producto is null || !producto.Activo || producto.Personalizable)
        {
            carrito.Remove(item);
            GuardarSesion(carrito);
            TempData["MensajeError"] = "El producto ya no está disponible.";
            return RedirectToAction(nameof(Index));
        }

        int otrasTallas = carrito
            .Where(x => x.ProductoId == productoId && !ReferenceEquals(x, item))
            .Sum(x => x.Cantidad);

        if (otrasTallas + cantidad > producto.Stock)
        {
            TempData["MensajeError"] = $"Solo hay {producto.Stock} unidades disponibles de {producto.Nombre} considerando todas las tallas del carrito.";
            return RedirectToAction(nameof(Index));
        }

        item.Cantidad = cantidad;
        GuardarSesion(carrito);
        TempData["MensajeExito"] = "Cantidad actualizada.";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Eliminar(int productoId, string talla)
    {
        string? tallaNormalizada = NormalizarTalla(talla);
        var carrito = ObtenerSesion();

        carrito.RemoveAll(x =>
            x.ProductoId == productoId &&
            string.Equals(x.Talla, tallaNormalizada, StringComparison.OrdinalIgnoreCase));

        GuardarSesion(carrito);
        TempData["MensajeExito"] = "Producto retirado del carrito.";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Vaciar()
    {
        GuardarSesion(new List<CarritoSesionItem>());
        TempData["MensajeExito"] = "El carrito fue vaciado.";
        return RedirectToAction(nameof(Index));
    }

    [HttpGet]
    public IActionResult Checkout()
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");
        if (clienteId is null)
        {
            HttpContext.Session.SetString("ClienteReturnUrl", "/Carrito/Checkout");
            TempData["MensajeError"] = "Inicia sesión como cliente para finalizar la compra.";
            return RedirectToAction("Login", "ClientePortal");
        }

        var carrito = ConstruirCarrito();
        if (!carrito.Items.Any())
        {
            TempData["MensajeError"] = "Tu carrito está vacío.";
            return RedirectToAction(nameof(Index));
        }

        var cliente = _clienteRepositorio.ObtenerPorId(clienteId.Value);
        if (cliente is null)
            return RedirectToAction("Login", "ClientePortal");

        return View(new CheckoutViewModel
        {
            Destinatario = $"{cliente.Nombres} {cliente.Apellidos}".Trim(),
            Telefono = cliente.Telefono ?? string.Empty,
            Direccion = cliente.Direccion ?? string.Empty,
            Carrito = carrito
        });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Checkout(CheckoutViewModel modelo)
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");
        if (clienteId is null)
            return RedirectToAction("Login", "ClientePortal");

        modelo.Carrito = ConstruirCarrito();

        if (!modelo.Carrito.Items.Any())
            ModelState.AddModelError(string.Empty, "Tu carrito está vacío.");

        if (!ModelState.IsValid)
            return View(modelo);

        try
        {
            var detalles = modelo.Carrito.Items
                .Select(x => new VentaDetalleEntrada
                {
                    ProductoId = x.ProductoId,
                    Talla = x.Talla,
                    Cantidad = x.Cantidad
                })
                .ToList();

            int ventaId = _ventaRepositorio.Registrar(
                clienteId.Value,
                modelo.Destinatario,
                modelo.Telefono,
                modelo.Direccion,
                detalles);

            GuardarSesion(new List<CarritoSesionItem>());
            return RedirectToAction(nameof(Confirmacion), new { id = ventaId });
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            modelo.Carrito = ConstruirCarrito();
            return View(modelo);
        }
    }

    [HttpGet]
    public IActionResult Confirmacion(int id)
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");
        if (clienteId is null)
            return RedirectToAction("Login", "ClientePortal");

        var venta = _ventaRepositorio.ObtenerPorId(id);
        if (venta is null || venta.ClienteId != clienteId.Value)
            return NotFound();

        return View(venta);
    }

    private List<CarritoSesionItem> ObtenerSesion()
    {
        return HttpContext.Session.GetObject<List<CarritoSesionItem>>(ClaveCarrito)
            ?? new List<CarritoSesionItem>();
    }

    private void GuardarSesion(List<CarritoSesionItem> carrito)
    {
        HttpContext.Session.SetObject(ClaveCarrito, carrito);
        HttpContext.Session.SetInt32("CarritoCantidad", carrito.Sum(x => x.Cantidad));
    }

    private CarritoViewModel ConstruirCarrito()
    {
        var sesion = ObtenerSesion();
        var validos = new List<CarritoSesionItem>();
        var modelo = new CarritoViewModel();

        foreach (var grupoProducto in sesion.GroupBy(x => x.ProductoId))
        {
            var producto = _productoRepositorio.ObtenerPorId(grupoProducto.Key);
            if (producto is null || !producto.Activo || producto.Personalizable || producto.Stock <= 0)
                continue;

            int stockRestante = producto.Stock;

            foreach (var item in grupoProducto)
            {
                string? talla = NormalizarTalla(item.Talla);
                if (talla is null || stockRestante <= 0)
                    continue;

                int cantidad = Math.Min(Math.Max(item.Cantidad, 0), stockRestante);
                if (cantidad <= 0)
                    continue;

                stockRestante -= cantidad;

                validos.Add(new CarritoSesionItem
                {
                    ProductoId = producto.ProductoId,
                    Talla = talla,
                    Cantidad = cantidad
                });

                modelo.Items.Add(new CarritoItemViewModel
                {
                    ProductoId = producto.ProductoId,
                    Nombre = producto.Nombre,
                    ImagenUrl = producto.ImagenUrl,
                    Talla = talla,
                    PrecioUnitario = producto.PrecioBase,
                    Cantidad = cantidad,
                    Stock = producto.Stock
                });
            }
        }

        GuardarSesion(validos);
        return modelo;
    }

    private static string? NormalizarTalla(string? talla)
    {
        if (string.IsNullOrWhiteSpace(talla))
            return null;

        string valor = talla.Trim().ToUpperInvariant();
        return TallasPermitidas.Contains(valor) ? valor : null;
    }

    private IActionResult Redirigir(string? returnUrl)
    {
        if (!string.IsNullOrWhiteSpace(returnUrl) && Url.IsLocalUrl(returnUrl))
            return LocalRedirect(returnUrl);

        return RedirectToAction(nameof(Index));
    }
}
