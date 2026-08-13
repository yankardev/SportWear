using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;

namespace SportWear.Web.Controllers;

[AutorizarRol( "ADMINISTRADOR","VENTAS", "PRODUCCION")]
public class AdministracionController : Controller
{
    private readonly IReporteRepositorio _reporteRepositorio;

    public AdministracionController(IReporteRepositorio reporteRepositorio)
    {
        _reporteRepositorio = reporteRepositorio;
    }

    public IActionResult Index()
    {
        return View(_reporteRepositorio.ObtenerResumen());
    }
}
