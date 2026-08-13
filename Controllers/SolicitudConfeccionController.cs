using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;
using SportWear.Web.ViewModels;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR","VENTAS","PRODUCCION")]
public class SolicitudConfeccionController : Controller
{
    private readonly ISolicitudConfeccionRepositorio _solicitudRepositorio;
    private readonly IClienteRepositorio _clienteRepositorio;
    private readonly IProductoRepositorio _productoRepositorio;

    public SolicitudConfeccionController(
        ISolicitudConfeccionRepositorio solicitudRepositorio,
        IClienteRepositorio clienteRepositorio,
        IProductoRepositorio productoRepositorio)
    {
        _solicitudRepositorio = solicitudRepositorio;
        _clienteRepositorio = clienteRepositorio;
        _productoRepositorio = productoRepositorio;
    }

    // GET: /SolicitudConfeccion
    public IActionResult Index(string? buscar)
    {
        var solicitudes = _solicitudRepositorio.Listar(buscar);

        ViewBag.Buscar = buscar;

        return View(solicitudes);
    }

    // GET: /SolicitudConfeccion/Registrar
    [HttpGet]
    [AutorizarRol("ADMINISTRADOR", "VENTAS")]
    public IActionResult Registrar(int? clienteId = null)
    {
        var modelo = CargarFormulario();
        if (clienteId.HasValue)
        {
            modelo.Solicitud.ClienteId = clienteId.Value;
        }
        return View(modelo);
    }

    // POST: /SolicitudConfeccion/Registrar
    [HttpPost]
    [ValidateAntiForgeryToken]
    [AutorizarRol("ADMINISTRADOR", "VENTAS")]
    public IActionResult Registrar(
        SolicitudConfeccionFormularioViewModel modelo)
    {
        if (!ModelState.IsValid)
        {
            CargarListas(modelo);
            return View(modelo);
        }

        try
        {
            _solicitudRepositorio.Insertar(modelo.Solicitud);

            return RedirectToAction(
                nameof(ConfirmarOtraSolicitud),
                new
                {
                    clienteId = modelo.Solicitud.ClienteId
                }
            );
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(
                string.Empty,
                ex.Message
            );

            CargarListas(modelo);

            return View(modelo);
        }
    }

    // GET: /SolicitudConfeccion/Detalle/5
    public IActionResult Detalle(int id)
    {
        var solicitud = _solicitudRepositorio.ObtenerPorId(id);

        if (solicitud is null)
        {
            return NotFound();
        }

        var producto = _productoRepositorio.ObtenerPorId(
                solicitud.ProductoId
            );

        ViewBag.ImagenProducto =
            producto?.ImagenUrl;

        return View(solicitud);
    }

    // POST: /SolicitudConfeccion/ActualizarEstado
    [HttpPost]
    [ValidateAntiForgeryToken]
    [AutorizarRol("ADMINISTRADOR", "VENTAS")]
    public IActionResult ActualizarEstado(
        int id,
        string estado)
    {
        try
        {
            _solicitudRepositorio.ActualizarEstado(
                id,
                estado
            );

            TempData["Exito"] =
                "Estado actualizado correctamente.";
        }
        catch (SqlException ex)
        {
            TempData["Error"] = ex.Message;
        }

        return RedirectToAction(
            nameof(Detalle),
            new { id }
        );
    }

    private SolicitudConfeccionFormularioViewModel
        CargarFormulario()
    {
        return new SolicitudConfeccionFormularioViewModel
        {
            Clientes = _clienteRepositorio.ListarActivos(),

            Productos =
                _productoRepositorio.ListarPersonalizables()
        };
    }

    private void CargarListas(
        SolicitudConfeccionFormularioViewModel modelo)
    {
        modelo.Clientes =
            _clienteRepositorio.ListarActivos();

        modelo.Productos =
            _productoRepositorio.ListarPersonalizables();
    }

    [HttpGet]
    [AutorizarRol("ADMINISTRADOR", "VENTAS")]
    public IActionResult ConfirmarOtraSolicitud(int clienteId)
    {
        var cliente =
            _clienteRepositorio.ObtenerPorId(clienteId);

        if (cliente is null)
        {
            return RedirectToAction(nameof(Index));
        }

        ViewBag.ClienteId = cliente.ClienteId;

        ViewBag.ClienteNombre =
            $"{cliente.Nombres} {cliente.Apellidos}";

        return View();
    }
}