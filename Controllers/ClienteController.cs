using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;
using SportWear.Web.Models;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR","VENTAS")]
public class ClienteController : Controller
{
    private readonly IClienteRepositorio _repo;

    public ClienteController(IClienteRepositorio repo)
    {
        _repo = repo;
    }

    // GET: /Cliente
    public IActionResult Index(string? buscar, int pagina = 1)
    {
        const int tamano = 5;

        List<Cliente> clientes;
        int total;

        if (!string.IsNullOrWhiteSpace(buscar))
        {
            clientes = _repo.Listar(buscar);
            total = clientes.Count;
        }
        else
        {
            clientes = _repo.ListarPaginado(pagina, tamano, out total);
        }

        ViewBag.Buscar = buscar;
        ViewBag.Pagina = pagina;
        ViewBag.TotalPaginas = (int)Math.Ceiling(total / (double)tamano);

        return View(clientes);
    }

    // GET
    [HttpGet]
    public IActionResult Registrar()
    {
        return View(new Cliente());
    }

    // POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Registrar(Cliente cliente)
    {
        if (!ModelState.IsValid)
            return View(cliente);

        _repo.Insertar(cliente);

        TempData["Exito"] = "Cliente registrado correctamente.";

        return RedirectToAction(nameof(Index));
    }

    // GET
    [HttpGet]
    public IActionResult Editar(int id)
    {
        var cliente = _repo.ObtenerPorId(id);

        if (cliente == null)
            return NotFound();

        return View(cliente);
    }

    // POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Editar(Cliente cliente)
    {
        if (!ModelState.IsValid)
            return View(cliente);

        _repo.Actualizar(cliente);

        TempData["Exito"] = "Cliente actualizado correctamente.";

        return RedirectToAction(nameof(Index));
    }

    // GET
    public IActionResult Detalle(int id)
    {
        var cliente = _repo.ObtenerPorId(id);

        if (cliente == null)
            return NotFound();

        return View(cliente);
    }

    // POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Eliminar(int id)
    {
        _repo.Eliminar(id);

        TempData["Exito"] = "Cliente eliminado correctamente.";

        return RedirectToAction(nameof(Index));
    }
}