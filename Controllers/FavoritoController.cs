using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;

namespace SportWear.Web.Controllers;

public class FavoritoController : Controller
{
    private readonly IFavoritoRepositorio _favoritoRepositorio;

    public FavoritoController(IFavoritoRepositorio favoritoRepositorio)
    {
        _favoritoRepositorio = favoritoRepositorio;
    }

    [HttpGet]
    public IActionResult Index()
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");
        if (clienteId is null)
        {
            TempData["MensajeError"] = "Inicia sesión para consultar tus favoritos.";
            return RedirectToAction("Login", "ClientePortal");
        }

        return View(_favoritoRepositorio.ListarPorCliente(clienteId.Value));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Agregar(int productoId, string? returnUrl = null)
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");
        if (clienteId is null)
        {
            if (!string.IsNullOrWhiteSpace(returnUrl) && Url.IsLocalUrl(returnUrl))
                HttpContext.Session.SetString("ClienteReturnUrl", returnUrl);

            TempData["MensajeError"] = "Inicia sesión para guardar favoritos.";
            return RedirectToAction("Login", "ClientePortal");
        }

        try
        {
            _favoritoRepositorio.Agregar(clienteId.Value, productoId);
            TempData["MensajeExito"] = "Producto agregado a favoritos.";
        }
        catch (SqlException ex)
        {
            TempData["MensajeError"] = ex.Message;
        }

        if (!string.IsNullOrWhiteSpace(returnUrl) && Url.IsLocalUrl(returnUrl))
            return LocalRedirect(returnUrl);

        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Eliminar(int productoId)
    {
        int? clienteId = HttpContext.Session.GetInt32("ClienteId");
        if (clienteId is null)
            return RedirectToAction("Login", "ClientePortal");

        _favoritoRepositorio.Eliminar(clienteId.Value, productoId);
        TempData["MensajeExito"] = "Producto eliminado de favoritos.";
        return RedirectToAction(nameof(Index));
    }
}
