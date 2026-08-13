using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR", "VENTAS")]
public class VentaController : Controller
{
    private readonly IVentaRepositorio _ventaRepositorio;

    public VentaController(IVentaRepositorio ventaRepositorio)
    {
        _ventaRepositorio = ventaRepositorio;
    }

    public IActionResult Index(string? buscar)
    {
        ViewBag.Buscar = buscar;
        return View(_ventaRepositorio.Listar(buscar));
    }

    public IActionResult Detalle(int id)
    {
        var venta = _ventaRepositorio.ObtenerPorId(id);
        return venta is null ? NotFound() : View(venta);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult ActualizarEstado(int ventaId, string estado)
    {
        try
        {
            _ventaRepositorio.ActualizarEstado(ventaId, estado);
            TempData["Exito"] = "Estado de la venta actualizado correctamente.";
        }
        catch (SqlException ex)
        {
            TempData["Error"] = ex.Message;
        }

        return RedirectToAction(nameof(Detalle), new { id = ventaId });
    }
}
