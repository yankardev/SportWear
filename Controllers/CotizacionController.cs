using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;
using SportWear.Web.Services;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR", "VENTAS")]
public class CotizacionController : Controller
{
    private readonly ICotizacionRepositorio _cotizacionRepositorio;
    private readonly CotizacionPdfService _pdfService;
    private readonly ISolicitudConfeccionRepositorio _solicitudRepositorio;
    private readonly IProductoRepositorio _productoRepositorio;

    public CotizacionController(ICotizacionRepositorio cotizacionRepositorio, CotizacionPdfService pdfService,
                  ISolicitudConfeccionRepositorio solicitudRepositorio, IProductoRepositorio productoRepositorio)
    {
        _cotizacionRepositorio = cotizacionRepositorio;
        _pdfService = pdfService;
        _solicitudRepositorio = solicitudRepositorio;
        _productoRepositorio = productoRepositorio;
    }

    // GET: /Cotizacion
    public IActionResult Index(string? buscar)
    {
        var cotizaciones =
            _cotizacionRepositorio.Listar(buscar);

        ViewBag.Buscar = buscar;

        return View(cotizaciones);
    }

    // GET: /Cotizacion/Detalle/5
    public IActionResult Detalle(int id)
    {
        var cotizacion = _cotizacionRepositorio.ObtenerPorId(id);

        if (cotizacion is null)
        {
            return NotFound();
        }
        var solicitud = _solicitudRepositorio.ObtenerPorId(cotizacion.SolicitudId);
        if (solicitud is not null)
        {
            var producto =  _productoRepositorio.ObtenerPorId(solicitud.ProductoId);
            ViewBag.ImagenProducto = producto?.ImagenUrl;
        }
        return View(cotizacion);
    }

    // GET: /Cotizacion/DescargarPdf/5
    [HttpGet]
    public IActionResult DescargarPdf(int id)
    {
        var cotizacion =
            _cotizacionRepositorio.ObtenerPorId(id);

        if (cotizacion is null)
        {
            return NotFound();
        }

        byte[] archivo =
            _pdfService.Generar(cotizacion);

        string nombreArchivo =
            $"{cotizacion.Codigo}.pdf";

        return File(
            archivo,
            "application/pdf",
            nombreArchivo
        );
    }
    // POST: /Cotizacion/Generar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Generar(int solicitudId)
    {
        int? usuarioId =
            HttpContext.Session.GetInt32("UsuarioId");

        if (usuarioId is null)
        {
            return RedirectToAction(
                "Login",
                "Auth"
            );
        }

        try
        {
            _cotizacionRepositorio.Generar(
                solicitudId,
                usuarioId.Value
            );

            TempData["Exito"] =
                "Cotización generada correctamente.";

            return RedirectToAction(nameof(Index));
        }
        catch (SqlException ex)
        {
            TempData["Error"] = ex.Message;

            return RedirectToAction(
                "Detalle",
                "SolicitudConfeccion",
                new { id = solicitudId }
            );
        }
    }
}