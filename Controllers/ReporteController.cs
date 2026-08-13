using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR")]
public class ReporteController : Controller
{
    private readonly IReporteRepositorio _reporteRepositorio;
    private readonly IPedidoRepositorio _pedidoRepositorio;

    public ReporteController(
        IReporteRepositorio reporteRepositorio,
        IPedidoRepositorio pedidoRepositorio)
    {
        _reporteRepositorio = reporteRepositorio;
        _pedidoRepositorio = pedidoRepositorio;
    }

    public IActionResult Index(
        string? estado,
        DateTime? desde,
        DateTime? hasta,
        int pagina = 1)
    {
        const int tamanoPagina = 5;

        if (pagina < 1)
            pagina = 1;

        var pedidos = _pedidoRepositorio.Listar();

        if (!string.IsNullOrWhiteSpace(estado))
        {
            pedidos = pedidos
                .Where(p => p.NombreEstado.Equals(
                    estado,
                    StringComparison.OrdinalIgnoreCase))
                .ToList();
        }

        if (desde.HasValue)
        {
            pedidos = pedidos
                .Where(p => p.FechaPedido.Date >= desde.Value.Date)
                .ToList();
        }

        if (hasta.HasValue)
        {
            pedidos = pedidos
                .Where(p => p.FechaPedido.Date <= hasta.Value.Date)
                .ToList();
        }

        int totalRegistros = pedidos.Count;
        int totalPaginas = Math.Max(
            1,
            (int)Math.Ceiling(totalRegistros / (double)tamanoPagina));

        if (pagina > totalPaginas)
            pagina = totalPaginas;

        var pedidosPagina = pedidos
            .OrderByDescending(p => p.FechaPedido)
            .Skip((pagina - 1) * tamanoPagina)
            .Take(tamanoPagina)
            .ToList();

        ViewBag.PedidosReporte = pedidosPagina;
        ViewBag.Estados = _pedidoRepositorio.ListarEstados();
        ViewBag.EstadoSeleccionado = estado;
        ViewBag.Desde = desde?.ToString("yyyy-MM-dd");
        ViewBag.Hasta = hasta?.ToString("yyyy-MM-dd");
        ViewBag.Pagina = pagina;
        ViewBag.TotalPaginas = totalPaginas;
        ViewBag.TotalRegistros = totalRegistros;

        return View(_reporteRepositorio.ObtenerResumen());
    }
}
