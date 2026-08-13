using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;
using SportWear.Web.ViewModels;

namespace SportWear.Web.Controllers
{
    public class CatalogoController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IClienteRepositorio _clienteRepositorio;
        private readonly ISolicitudConfeccionRepositorio _solicitudRepositorio;

        public CatalogoController(
            IHttpClientFactory httpClientFactory,
            IClienteRepositorio clienteRepositorio,
            ISolicitudConfeccionRepositorio solicitudRepositorio)
        {
            _httpClientFactory = httpClientFactory;
            _clienteRepositorio = clienteRepositorio;
            _solicitudRepositorio = solicitudRepositorio;
        }

        // =====================================================
        // CATÁLOGO DE VENTA DIRECTA
        // Personalizable = false
        // =====================================================
        public async Task<IActionResult> Index()
        {
            var cliente = _httpClientFactory.CreateClient();
            cliente.BaseAddress = new Uri($"{Request.Scheme}://{Request.Host}");

            var productos = await cliente.GetFromJsonAsync<List<Producto>>(
                "/api/productosapi"
            );

            productos ??= new List<Producto>();

            productos = productos
                .Where(p => p.Activo && !p.Personalizable)
                .ToList();

            ViewBag.EsPersonalizable = false;
            ViewBag.TituloCatalogo = "Tienda SportWear";
            ViewBag.DescripcionCatalogo =
                "Prendas deportivas listas para comprar a precio fijo.";

            return View(productos);
        }

        // =====================================================
        // CATÁLOGO DE PRODUCTOS PERSONALIZADOS
        // Personalizable = true
        // =====================================================
        public async Task<IActionResult> Personalizados()
        {
            var cliente = _httpClientFactory.CreateClient();
            cliente.BaseAddress = new Uri($"{Request.Scheme}://{Request.Host}");

            var productos = await cliente.GetFromJsonAsync<List<Producto>>(
                "/api/productosapi"
            );

            productos ??= new List<Producto>();

            productos = productos
                .Where(p => p.Activo && p.Personalizable)
                .ToList();

            ViewBag.EsPersonalizable = true;
            ViewBag.TituloCatalogo = "Ropa personalizada";
            ViewBag.DescripcionCatalogo =
                "Elige un modelo y solicita una cotización según cantidad, tela, color y estampado.";

            return View("Index", productos);
        }

        // =====================================================
        // DETALLE
        // Puede mostrar ambos tipos de producto
        // =====================================================
        public async Task<IActionResult> Detalle(int id)
        {
            var producto = await ObtenerProductoAsync(id);

            if (producto == null || !producto.Activo)
            {
                return NotFound();
            }

            return View(producto);
        }

        // =====================================================
        // COTIZAR - GET
        // Requiere que el CLIENTE haya iniciado sesión.
        // De esta forma la solicitud queda asociada al mismo
        // ClienteId que usa Mi Cuenta.
        // =====================================================
        [HttpGet]
        public async Task<IActionResult> Cotizar(int id)
        {
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");

            if (clienteId == null)
            {
                GuardarRetornoCotizacion(id);
                TempData["MensajeError"] =
                    "Inicia sesión como cliente para solicitar una cotización.";

                return RedirectToAction("Login", "ClientePortal");
            }

            var producto = await ObtenerProductoAsync(id);

            if (producto == null ||
                !producto.Activo ||
                !producto.Personalizable)
            {
                return NotFound();
            }

            var cliente = _clienteRepositorio.ObtenerPorId(clienteId.Value);

            if (cliente == null || !cliente.Activo)
            {
                LimpiarSesionCliente();
                GuardarRetornoCotizacion(id);

                TempData["MensajeError"] =
                    "Tu sesión de cliente ya no es válida. Inicia sesión nuevamente.";

                return RedirectToAction("Login", "ClientePortal");
            }

            var modelo = new CotizacionPublicaViewModel
            {
                ProductoId = producto.ProductoId,
                NombreProducto = producto.Nombre,
                PrecioBase = producto.PrecioBase,
                Nombres = cliente.Nombres,
                Apellidos = cliente.Apellidos,
                Documento = cliente.Documento,
                Telefono = cliente.Telefono ?? string.Empty,
                Correo = cliente.Correo ??
                         HttpContext.Session.GetString("ClienteCorreo") ??
                         string.Empty
            };

            return View(modelo);
        }

        // =====================================================
        // COTIZAR - POST
        // La identidad del cliente NO se toma del formulario.
        // Siempre se usa ClienteId de la sesión autenticada.
        // =====================================================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Cotizar(
            CotizacionPublicaViewModel modelo)
        {
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");

            if (clienteId == null)
            {
                GuardarRetornoCotizacion(modelo.ProductoId);
                TempData["MensajeError"] =
                    "Tu sesión terminó. Inicia sesión nuevamente para continuar con la cotización.";

                return RedirectToAction("Login", "ClientePortal");
            }

            var cliente = _clienteRepositorio.ObtenerPorId(clienteId.Value);

            if (cliente == null || !cliente.Activo)
            {
                LimpiarSesionCliente();
                GuardarRetornoCotizacion(modelo.ProductoId);

                TempData["MensajeError"] =
                    "Tu cuenta de cliente no está disponible. Inicia sesión nuevamente.";

                return RedirectToAction("Login", "ClientePortal");
            }

            // Estos campos pertenecen a la cuenta autenticada.
            // No validamos ni confiamos en valores enviados desde el navegador.
            ModelState.Remove(nameof(modelo.Nombres));
            ModelState.Remove(nameof(modelo.Apellidos));
            ModelState.Remove(nameof(modelo.Documento));
            ModelState.Remove(nameof(modelo.Telefono));
            ModelState.Remove(nameof(modelo.Correo));

            CargarDatosCliente(modelo, cliente);

            var producto = await ObtenerProductoAsync(modelo.ProductoId);

            if (producto == null ||
                !producto.Activo ||
                !producto.Personalizable)
            {
                ModelState.AddModelError(
                    string.Empty,
                    "El producto seleccionado ya no está disponible para cotización."
                );

                return View(modelo);
            }

            modelo.NombreProducto = producto.Nombre;
            modelo.PrecioBase = producto.PrecioBase;

            if (!ModelState.IsValid)
            {
                return View(modelo);
            }

            var solicitud = new SolicitudConfeccion
            {
                // CORRECCIÓN CLAVE:
                // La solicitud queda ligada al cliente que inició sesión.
                ClienteId = cliente.ClienteId,
                ProductoId = modelo.ProductoId,
                Cantidad = modelo.Cantidad,
                Talla = modelo.Talla,
                Color = modelo.Color,
                Material = modelo.Material,
                TipoEstampado = modelo.TipoEstampado,
                TextoPersonalizado = modelo.TextoPersonalizado,
                ArchivoDisenoUrl = null,
                Observaciones = modelo.Observaciones,
                Estado = "PENDIENTE"
            };

            _solicitudRepositorio.Insertar(solicitud);

            TempData["MensajeExito"] =
                "Tu solicitud de cotización fue enviada correctamente y ya puedes verla en Mi Cuenta.";

            return RedirectToAction(nameof(Confirmacion));
        }

        public IActionResult Confirmacion()
        {
            return View();
        }

        // =====================================================
        // MÉTODOS AUXILIARES
        // =====================================================
        private async Task<Producto?> ObtenerProductoAsync(int id)
        {
            var cliente = _httpClientFactory.CreateClient();
            cliente.BaseAddress = new Uri($"{Request.Scheme}://{Request.Host}");

            var respuesta = await cliente.GetAsync($"/api/productosapi/{id}");

            if (!respuesta.IsSuccessStatusCode)
            {
                return null;
            }

            return await respuesta.Content.ReadFromJsonAsync<Producto>();
        }

        private void GuardarRetornoCotizacion(int productoId)
        {
            string returnUrl = Url.Action(
                nameof(Cotizar),
                "Catalogo",
                new { id = productoId }
            ) ?? $"/Catalogo/Cotizar/{productoId}";

            HttpContext.Session.SetString("ClienteReturnUrl", returnUrl);
        }

        private static void CargarDatosCliente(
            CotizacionPublicaViewModel modelo,
            Cliente cliente)
        {
            modelo.Nombres = cliente.Nombres;
            modelo.Apellidos = cliente.Apellidos;
            modelo.Documento = cliente.Documento;
            modelo.Telefono = cliente.Telefono ?? string.Empty;
            modelo.Correo = cliente.Correo ?? string.Empty;
        }

        private void LimpiarSesionCliente()
        {
            HttpContext.Session.Remove("ClienteId");
            HttpContext.Session.Remove("ClienteNombre");
            HttpContext.Session.Remove("ClienteCorreo");
        }
    }
}
