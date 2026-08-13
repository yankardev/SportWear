using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;
using SportWear.Web.Models;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR", "VENTAS","PRODUCCION")]
public class PedidoController : Controller
{
    private readonly IPedidoRepositorio _pedidoRepositorio;
    private readonly ICotizacionRepositorio _cotizacionRepositorio;

    public PedidoController(
        IPedidoRepositorio pedidoRepositorio,
        ICotizacionRepositorio cotizacionRepositorio)
    {
        _pedidoRepositorio = pedidoRepositorio;
        _cotizacionRepositorio = cotizacionRepositorio;
    }

    public IActionResult Index(string? buscar)
    {
        var pedidos = _pedidoRepositorio.Listar(buscar);
        ViewBag.Buscar = buscar;
        return View(pedidos);
    }

    public IActionResult Detalle(int id)
    {
        var pedido = _pedidoRepositorio.ObtenerPorId(id);

        if (pedido is null)
            return NotFound();

        ViewBag.SiguienteEstado =
            ObtenerSiguienteEstado(pedido.NombreEstado);

        return View(pedido);
    }

    [HttpGet]
    [AutorizarRol("ADMINISTRADOR", "VENTAS")]
    public IActionResult Registrar(int cotizacionId)
    {
        var cotizacion = _cotizacionRepositorio.ObtenerPorId(cotizacionId);
        if (cotizacion is null) return NotFound();

        var pedido = new Pedido
        {
            CotizacionId = cotizacion.CotizacionId,
            CodigoCotizacion = cotizacion.Codigo,
            NombreCliente = cotizacion.NombreCliente,
            NombreProducto = cotizacion.NombreProducto,
            Cantidad = cotizacion.Cantidad,
            Subtotal = cotizacion.Subtotal,
            Igv = cotizacion.Igv,
            Total = cotizacion.Total,
            Destinatario = cotizacion.NombreCliente,
            TelefonoEntrega = cotizacion.Telefono,
            FechaEntregaEstimada = DateTime.Today.AddDays(15)
        };

        return View(pedido);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [AutorizarRol("ADMINISTRADOR", "VENTAS")]
    public IActionResult Registrar(Pedido pedido)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId is null)
        {
            return RedirectToAction("Login", "Auth");
        }

        if (!ModelState.IsValid)
        {
            var cotizacion = _cotizacionRepositorio.ObtenerPorId(pedido.CotizacionId);
            if (cotizacion is not null)
            {
                pedido.CodigoCotizacion = cotizacion.Codigo;
                pedido.NombreCliente = cotizacion.NombreCliente;
                pedido.NombreProducto = cotizacion.NombreProducto;
                pedido.Cantidad = cotizacion.Cantidad;
                pedido.Subtotal = cotizacion.Subtotal;
                pedido.Igv = cotizacion.Igv;
                pedido.Total = cotizacion.Total;
            }
            return View(pedido);
        }

        try
        {
            pedido.UsuarioId = usuarioId.Value;
            _pedidoRepositorio.Generar(pedido);
            TempData["Exito"] = "Pedido registrado correctamente.";
            return RedirectToAction(nameof(Index));
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            return View(pedido);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [AutorizarRol("ADMINISTRADOR", "PRODUCCION")]
    public IActionResult AvanzarEstado(int pedidoId)
    {
        var pedido = _pedidoRepositorio.ObtenerPorId(pedidoId);
        if (pedido is null)
            return NotFound();

        string? siguienteEstado = ObtenerSiguienteEstado(pedido.NombreEstado);

        if (siguienteEstado is null)
        {
            TempData["Error"] = "El pedido ya no tiene una etapa siguiente.";

            return RedirectToAction(nameof(Detalle), new { id = pedidoId } );
        }

        var estado = _pedidoRepositorio.ListarEstados()
                .FirstOrDefault(e =>
                    e.Nombre.Equals(siguienteEstado,StringComparison.OrdinalIgnoreCase));
        if (estado is null)
        {
            TempData["Error"] = $"No se encontró el estado {siguienteEstado}.";
            return RedirectToAction(nameof(Detalle),new { id = pedidoId });
        }
        try
        {
            _pedidoRepositorio.ActualizarEstado(pedidoId, estado.EstadoPedidoId);
            TempData["Exito"] = $"Pedido actualizado a {estado.Nombre}.";
        }
        catch (SqlException ex)
        {
            TempData["Error"] = ex.Message;
        }

        return RedirectToAction(
            nameof(Detalle),
            new { id = pedidoId }
        );
    }
    private static string? ObtenerSiguienteEstado(string estadoActual)
    {
        return estadoActual.ToUpper() switch
        {
            "APROBADO" => "DISEÑO",
            "DISEÑO" => "CONFECCION",
            "CONFECCION" => "LISTO",
            "LISTO" => "ENTREGADO",
            _ => null
        };
    }
}
