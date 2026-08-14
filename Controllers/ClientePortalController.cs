using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Data.Repositorios;
using Microsoft.Data.SqlClient;
using SportWear.Web.Services;
using SportWear.Web.Models;
using SportWear.Web.ViewModels;
using System.Security.Cryptography;
using System.Text;

namespace SportWear.Web.Controllers;

public class ClientePortalController : Controller
{
    private readonly IClienteRepositorio _clienteRepositorio;
    private readonly IClienteAccesoRepositorio _accesoRepositorio;
    private readonly ISolicitudConfeccionRepositorio _solicitudRepositorio;
    private readonly ICotizacionRepositorio _cotizacionRepositorio;
    private readonly IPedidoRepositorio _pedidoRepositorio;
    private readonly IVentaRepositorio _ventaRepositorio;
    private readonly CotizacionPdfService _pdfService;

    public ClientePortalController(
       IClienteRepositorio clienteRepositorio,
       IClienteAccesoRepositorio accesoRepositorio,
       ISolicitudConfeccionRepositorio solicitudRepositorio,
       ICotizacionRepositorio cotizacionRepositorio,
       IPedidoRepositorio pedidoRepositorio,
       IVentaRepositorio ventaRepositorio,
       CotizacionPdfService pdfService)
    {
        _clienteRepositorio = clienteRepositorio;
        _accesoRepositorio = accesoRepositorio;
        _solicitudRepositorio = solicitudRepositorio;
        _cotizacionRepositorio = cotizacionRepositorio;
        _pedidoRepositorio = pedidoRepositorio;
        _ventaRepositorio = ventaRepositorio;
        _pdfService = pdfService;
    }

    [HttpGet]
    public IActionResult Registro()
    {
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Registro(RegistroClienteViewModel modelo)
    {
        if (!ModelState.IsValid) return View(modelo);
        var accesoExistente = _accesoRepositorio.ObtenerPorCorreo(modelo.Correo);
        if (accesoExistente != null)
        {
            ModelState.AddModelError(nameof(modelo.Correo),"Este correo ya tiene una cuenta registrada.");
            return View(modelo);
        }
        var cliente = _clienteRepositorio.ObtenerPorDocumento(modelo.Documento);
        int clienteId;

        if (cliente == null)
        {
            var nuevoCliente = new Cliente
            {
                Nombres = modelo.Nombres,
                Apellidos = modelo.Apellidos,
                Documento = modelo.Documento,
                Telefono = modelo.Telefono,
                Correo = modelo.Correo,
                Direccion = null,
                Activo = true
            };

            try
            {
                clienteId = _clienteRepositorio.Insertar(nuevoCliente);
            }
            catch (SqlException ex) when (ex.Number == 2601 || ex.Number == 2627)
            {
                ModelState.AddModelError(nameof(modelo.Documento),
                    "Ya existe un cliente activo con este documento.");
                return View(modelo);
            }
        }
        else
        {
            if (!cliente.Activo)
            {
                ModelState.AddModelError(nameof(modelo.Documento),
                    "Este documento pertenece a un cliente inactivo. Solicita su reactivación.");
                return View(modelo);
            }

            var accesoDelCliente = _accesoRepositorio.ObtenerPorClienteId(cliente.ClienteId);
            if (accesoDelCliente != null)
            {
                ModelState.AddModelError(nameof(modelo.Documento),
                    "Este documento ya tiene una cuenta registrada.");
                return View(modelo);
            }

            clienteId = cliente.ClienteId;
        }

        var nuevoAcceso = new ClienteAcceso
        {
            ClienteId = clienteId,
            Correo = modelo.Correo,
            ClaveHash = GenerarHash(modelo.Clave),
            Activo = true
        };

        try
        {
            _accesoRepositorio.Insertar(nuevoAcceso);
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            return View(modelo);
        }

        TempData["MensajeExito"] = "Tu cuenta fue creada correctamente.";
        return RedirectToAction(nameof(Login));
    }

    [HttpGet]
    public IActionResult Login()
    {
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Login(LoginClienteViewModel modelo)
    {
        if (!ModelState.IsValid)
        {
            return View(modelo);
        }
        var acceso = _accesoRepositorio.ObtenerPorCorreo(modelo.Correo);
        if (acceso == null)
        {
            ModelState.AddModelError(string.Empty, "Correo o contraseña incorrectos.");
             return View(modelo);
        }

        if (!acceso.Activo)
        {
            ModelState.AddModelError(string.Empty, "La cuenta se encuentra inactiva." );
            return View(modelo);
        }
        string hashIngresado =  GenerarHash(modelo.Clave);
        if (hashIngresado != acceso.ClaveHash)
        {
            ModelState.AddModelError(string.Empty,"Correo o contraseña incorrectos.");
            return View(modelo);
        }

        HttpContext.Session.SetInt32("ClienteId",acceso.ClienteId);
        HttpContext.Session.SetString( "ClienteNombre", $"{acceso.Nombres} {acceso.Apellidos}");
        HttpContext.Session.SetString("ClienteCorreo",acceso.Correo);

        string? returnUrl = HttpContext.Session.GetString("ClienteReturnUrl");
        HttpContext.Session.Remove("ClienteReturnUrl");

        if (!string.IsNullOrWhiteSpace(returnUrl) && Url.IsLocalUrl(returnUrl))
        {
            return LocalRedirect(returnUrl);
        }

        return RedirectToAction("Index", "Catalogo");
    }

    [HttpGet]
    public IActionResult MiCuenta()
    {
        int? clienteId =
            HttpContext.Session.GetInt32(
                "ClienteId"
            );

        if (clienteId == null)
        {
            return RedirectToAction(
                nameof(Login)
            );
        }

        var cliente =
            _clienteRepositorio.ObtenerPorId(
                clienteId.Value
            );

        if (cliente == null || !cliente.Activo)
        {
            HttpContext.Session.Clear();

            TempData["MensajeError"] =
                "Tu cuenta se encuentra inactiva.";

            return RedirectToAction(
                nameof(Login)
            );
        }

        var modelo =
            new MiCuentaClienteViewModel
            {
                ClienteId =
                    cliente.ClienteId,

                NombreCompleto =
                    $"{cliente.Nombres} {cliente.Apellidos}",

                Correo =
                    cliente.Correo ?? string.Empty,

                Solicitudes =
                    _solicitudRepositorio
                        .ListarPorCliente(
                            cliente.ClienteId
                        ),

                Cotizaciones =
                    _cotizacionRepositorio
                        .ListarPorCliente(
                            cliente.ClienteId
                        ),

                Pedidos =
                    _pedidoRepositorio
                        .ListarPorCliente(
                            cliente.ClienteId
                        ),

                Ventas =
                    _ventaRepositorio
                        .ListarPorCliente(
                            cliente.ClienteId
                        )
            };

        return View(modelo);
    }

    [HttpGet]
    public IActionResult DescargarCotizacion(int id)
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");

        if (clienteId is null)
        {
            return RedirectToAction(nameof(Login));
        }

        bool perteneceAlCliente = _cotizacionRepositorio
            .ListarPorCliente(clienteId.Value)
            .Any(c => c.CotizacionId == id);

        if (!perteneceAlCliente)
        {
            return NotFound();
        }

        var cotizacion = _cotizacionRepositorio.ObtenerPorId(id);

        if (cotizacion is null)
        {
            return NotFound();
        }

        byte[] archivo = _pdfService.Generar(cotizacion);

        return File(
            archivo,
            "application/pdf",
            $"{cotizacion.Codigo}.pdf"
        );
    }

    [HttpGet]
    public IActionResult IniciarPedido(int cotizacionId)
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");

        if (clienteId is null)
        {
            HttpContext.Session.SetString(
                "ClienteReturnUrl",
                Url.Action(nameof(IniciarPedido), new { cotizacionId }) ?? "/ClientePortal/MiCuenta"
            );

            return RedirectToAction(nameof(Login));
        }

        bool perteneceAlCliente = _cotizacionRepositorio
            .ListarPorCliente(clienteId.Value)
            .Any(c => c.CotizacionId == cotizacionId);

        if (!perteneceAlCliente)
        {
            return NotFound();
        }

        if (_pedidoRepositorio
            .ListarPorCliente(clienteId.Value)
            .Any(p => p.CotizacionId == cotizacionId))
        {
            TempData["MensajeExito"] = "Esta cotización ya tiene un pedido iniciado.";
            return Redirect(Url.Action(nameof(MiCuenta)) + "#pedidos");
        }

        var cotizacion = _cotizacionRepositorio.ObtenerPorId(cotizacionId);
        var cliente = _clienteRepositorio.ObtenerPorId(clienteId.Value);

        if (cotizacion is null || cliente is null)
        {
            return NotFound();
        }

        var modelo = new PedidoClienteViewModel
        {
            CotizacionId = cotizacion.CotizacionId,
            CodigoCotizacion = cotizacion.Codigo,
            NombreProducto = cotizacion.NombreProducto,
            Cantidad = cotizacion.Cantidad,
            Total = cotizacion.Total,
            Destinatario = $"{cliente.Nombres} {cliente.Apellidos}",
            TelefonoEntrega = cliente.Telefono ?? string.Empty,
            DireccionEntrega = cliente.Direccion ?? string.Empty
        };

        return View(modelo);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult IniciarPedido(PedidoClienteViewModel modelo)
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");

        if (clienteId is null)
        {
            return RedirectToAction(nameof(Login));
        }

        bool perteneceAlCliente = _cotizacionRepositorio
            .ListarPorCliente(clienteId.Value)
            .Any(c => c.CotizacionId == modelo.CotizacionId);

        if (!perteneceAlCliente)
        {
            return NotFound();
        }

        var cotizacion = _cotizacionRepositorio.ObtenerPorId(modelo.CotizacionId);

        if (cotizacion is null)
        {
            return NotFound();
        }

        if (_pedidoRepositorio
            .ListarPorCliente(clienteId.Value)
            .Any(p => p.CotizacionId == modelo.CotizacionId))
        {
            TempData["MensajeExito"] = "Esta cotización ya tiene un pedido iniciado.";
            return Redirect(Url.Action(nameof(MiCuenta)) + "#pedidos");
        }

        if (!ModelState.IsValid)
        {
            modelo.CodigoCotizacion = cotizacion.Codigo;
            modelo.NombreProducto = cotizacion.NombreProducto;
            modelo.Cantidad = cotizacion.Cantidad;
            modelo.Total = cotizacion.Total;
            return View(modelo);
        }

        try
        {
            var pedido = new Pedido
            {
                CotizacionId = cotizacion.CotizacionId,

                // Se conserva como responsable interno al usuario que emitió
                // la cotización. El cliente es quien aprueba e inicia el pedido.
                UsuarioId = cotizacion.UsuarioId,

                FechaEntregaEstimada = DateTime.Today.AddDays(15),
                Destinatario = modelo.Destinatario,
                TelefonoEntrega = modelo.TelefonoEntrega,
                DireccionEntrega = modelo.DireccionEntrega,
                DistritoEntrega = modelo.DistritoEntrega,
                ReferenciaEntrega = modelo.ReferenciaEntrega,
                Observaciones = modelo.Observaciones
            };

            _pedidoRepositorio.Generar(pedido);

            TempData["MensajeExito"] =
                "Cotización aprobada. Tu pedido fue iniciado correctamente.";

            return Redirect(Url.Action(nameof(MiCuenta)) + "#pedidos");
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            modelo.CodigoCotizacion = cotizacion.Codigo;
            modelo.NombreProducto = cotizacion.NombreProducto;
            modelo.Cantidad = cotizacion.Cantidad;
            modelo.Total = cotizacion.Total;
            return View(modelo);
        }
    }

    [HttpGet]
    public IActionResult CambiarClave()
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");

        if (clienteId is null)
            return RedirectToAction(nameof(Login));

        var cliente = _clienteRepositorio.ObtenerPorId(clienteId.Value);

        if (cliente == null || !cliente.Activo)
        {
            HttpContext.Session.Clear();
            TempData["MensajeError"] = "Tu cuenta se encuentra inactiva.";
            return RedirectToAction(nameof(Login));
        }

        return View(new CambiarClaveClientePortalViewModel());
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult CambiarClave(CambiarClaveClientePortalViewModel modelo)
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");

        if (clienteId is null)
            return RedirectToAction(nameof(Login));

        var cliente = _clienteRepositorio.ObtenerPorId(clienteId.Value);

        if (cliente == null || !cliente.Activo)
        {
            HttpContext.Session.Clear();
            TempData["MensajeError"] = "Tu cuenta se encuentra inactiva.";
            return RedirectToAction(nameof(Login));
        }

        if (!ModelState.IsValid)
            return View(modelo);

        var acceso = _accesoRepositorio.ObtenerPorClienteId(clienteId.Value);

        if (acceso == null || !acceso.Activo)
        {
            HttpContext.Session.Clear();
            return RedirectToAction(nameof(Login));
        }

        string hashActual = GenerarHash(modelo.ClaveActual);

        if (!string.Equals(hashActual, acceso.ClaveHash, StringComparison.OrdinalIgnoreCase))
        {
            ModelState.AddModelError(nameof(modelo.ClaveActual),
                "La contraseña actual no es correcta.");
            return View(modelo);
        }

        string nuevoHash = GenerarHash(modelo.NuevaClave);

        if (string.Equals(nuevoHash, acceso.ClaveHash, StringComparison.OrdinalIgnoreCase))
        {
            ModelState.AddModelError(nameof(modelo.NuevaClave),
                "La nueva contraseña debe ser diferente a la actual.");
            return View(modelo);
        }

        try
        {
            _accesoRepositorio.CambiarClave(clienteId.Value, nuevoHash);
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            return View(modelo);
        }

        HttpContext.Session.Clear();
        TempData["MensajeExito"] =
            "Tu contraseña fue actualizada correctamente. Inicia sesión nuevamente.";

        return RedirectToAction(nameof(Login));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Salir()
    {
        HttpContext.Session.Remove("ClienteId");
        HttpContext.Session.Remove("ClienteNombre");
        HttpContext.Session.Remove("ClienteCorreo");
        return RedirectToAction("Index", "Catalogo");
    }

    private static string GenerarHash(string texto)
    {
        using SHA256 sha256 = SHA256.Create();
        byte[] bytes =  Encoding.UTF8.GetBytes(texto);
        byte[] hash = sha256.ComputeHash(bytes);
        return Convert.ToHexString(hash);
    }
}