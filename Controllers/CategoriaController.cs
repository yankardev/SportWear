using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;
using SportWear.Web.Models;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR")]
public class CategoriaController : Controller
{
    private readonly ICategoriaRepositorio _repo;
    public CategoriaController(ICategoriaRepositorio repo) =>  _repo = repo;

    // GET: /Categoria
    public IActionResult Index(string? buscar, int pagina = 1)
    {
        const int tamano = 5;
        List<Categoria> categorias;
        int total;
        if (!string.IsNullOrWhiteSpace(buscar))
        {
            categorias = _repo.Listar(buscar);
            total = categorias.Count;
        }
        else
        {
            categorias = _repo.ListarPaginado(pagina, tamano, out total);
        }

        ViewBag.Buscar = buscar;
        ViewBag.Pagina = pagina;
        ViewBag.TotalPaginas = (int)Math.Ceiling(total / (double)tamano);
        ViewData["Title"] = "Categorías";
        return View(categorias);
    }

    // GET
    [HttpGet]
    public IActionResult Registrar()
    {
        ViewData["Title"] = "Registrar categoría";
        return View(new Categoria());
    }

    // POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Registrar(Categoria categoria)
    {
        if (!ModelState.IsValid)
            return View(categoria);

        _repo.Insertar(categoria);

        TempData["Exito"] = "Categoría registrada correctamente.";
        return RedirectToAction(nameof(Index));
    }

    // GET
    [HttpGet]
    public IActionResult Editar(int id)
    {
        var categoria = _repo.ObtenerPorId(id);
        if (categoria == null)
            return NotFound();

        ViewData["Title"] = "Editar categoría";
        return View(categoria);
    }

    // POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Editar(Categoria categoria)
    {
        if (!ModelState.IsValid)
            return View(categoria);
        _repo.Actualizar(categoria);
        TempData["Exito"] =  "Categoría actualizada correctamente.";
        return RedirectToAction(nameof(Index));
    }

    // GET
    public IActionResult Detalle(int id)
    {
        var categoria = _repo.ObtenerPorId(id);
        if (categoria == null)
            return NotFound();
        ViewData["Title"] = "Detalle categoría";
        return View(categoria);
    }

    // POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Eliminar(int id)
    {
        _repo.Eliminar(id);
        TempData["Exito"] = "Categoría desactivada correctamente.";
        return RedirectToAction(nameof(Index));
    }
}