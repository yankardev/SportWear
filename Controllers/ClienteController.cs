using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;
using SportWear.Web.Models;
using Microsoft.Data.SqlClient;
using SportWear.Web.Services;
using SportWear.Web.ViewModels;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR","VENTAS")]
public class ClienteController : Controller
{
    private readonly IClienteRepositorio _repo;
    private readonly IClienteAccesoRepositorio _accesoRepo;

    public ClienteController( IClienteRepositorio repo,  IClienteAccesoRepositorio accesoRepo)
    {
        _repo = repo;
        _accesoRepo = accesoRepo;
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

        try
        {
            _repo.Insertar(cliente);

            TempData["Exito"] = "Cliente registrado correctamente.";
            return RedirectToAction(nameof(Index));
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(
                string.Empty,
                ex.Number == 2601 || ex.Number == 2627
                    ? "Ya existe otro cliente activo con el mismo documento."
                    : ex.Message
            );

            return View(cliente);
        }
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

        try
        {
            _repo.Actualizar(cliente);

            TempData["Exito"] =
                "Cliente actualizado correctamente.";

            return RedirectToAction(nameof(Index));
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(
                string.Empty,
                ex.Number == 2601 || ex.Number == 2627
                    ? "Ya existe otro cliente activo con el mismo documento."
                    : ex.Message
            );

            return View(cliente);
        }
    }

    // GET
    public IActionResult Detalle(int id)
    {
        var cliente = _repo.ObtenerPorId(id);

        if (cliente == null)
            return NotFound();

        return View(cliente);
    }
    [HttpGet]
    [AutorizarRol("ADMINISTRADOR")]
    public IActionResult CambiarClave(int id)
    {
        var cliente = _repo.ObtenerPorId(id);

        if (cliente == null)
            return NotFound();

        if (string.IsNullOrWhiteSpace(cliente.Correo))
        {
            TempData["Error"] =
                "El cliente no tiene correo registrado. Edítalo antes de crear o restablecer su acceso.";

            return RedirectToAction(nameof(Index));
        }

        var acceso = _accesoRepo.ObtenerPorClienteId(id);

        return View(new CambiarClaveClienteViewModel
        {
            ClienteId = cliente.ClienteId,
            NombreCliente = $"{cliente.Nombres} {cliente.Apellidos}",
            Correo = cliente.Correo,
            TieneAcceso = acceso != null
        });
    }


    [HttpPost]
    [ValidateAntiForgeryToken]
    [AutorizarRol("ADMINISTRADOR")]
    public IActionResult CambiarClave(CambiarClaveClienteViewModel modelo)
    {
        var cliente = _repo.ObtenerPorId(modelo.ClienteId);

        if (cliente == null)
            return NotFound();

        modelo.NombreCliente = $"{cliente.Nombres} {cliente.Apellidos}";
        modelo.Correo = cliente.Correo ?? string.Empty;
        modelo.TieneAcceso = _accesoRepo.ObtenerPorClienteId(cliente.ClienteId) != null;

        if (string.IsNullOrWhiteSpace(cliente.Correo))
        {
            ModelState.AddModelError(
                string.Empty,
                "El cliente no tiene correo registrado. Debes registrarlo antes de crear su acceso."
            );

            return View(modelo);
        }

        if (!ModelState.IsValid)
            return View(modelo);

        try
        {
            _accesoRepo.RestablecerClaveAdmin(
                cliente.ClienteId,
                cliente.Correo,
                ClaveService.GenerarHash(modelo.NuevaClave),
                cliente.Activo
            );

            TempData["Exito"] = modelo.TieneAcceso
                ? "Contraseña del cliente restablecida correctamente."
                : "Acceso del cliente creado y contraseña registrada correctamente.";

            return RedirectToAction(nameof(Index));
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            return View(modelo);
        }
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