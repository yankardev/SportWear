using Microsoft.AspNetCore.Mvc;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Services;
using SportWear.Web.ViewModels;

namespace SportWear.Web.Controllers;

public class AuthController : Controller
{
    private readonly IUsuarioRepositorio _usuarioRepositorio;

    public AuthController(IUsuarioRepositorio usuarioRepositorio)
    {
        _usuarioRepositorio = usuarioRepositorio;
    }

    // GET: /Auth/Login
    [HttpGet]
    public IActionResult Login()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");

        if (usuarioId is not null)
        {
            string rol = HttpContext.Session.GetString("Rol") ?? string.Empty;

            // Los clientes usan un acceso separado: ClientePortal.
            if (rol.Equals("CLIENTE", StringComparison.OrdinalIgnoreCase))
            {
                LimpiarSesionInterna();
                return RedirectToAction("Login", "ClientePortal");
            }

            return RedirectToAction("Index", "Administracion");
        }

        return View();
    }

    // POST: /Auth/Login
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Login(LoginViewModel modelo)
    {
        if (!ModelState.IsValid)
        {
            return View(modelo);
        }

        var usuario = _usuarioRepositorio.ObtenerPorCorreo(modelo.Correo);

        if (usuario is null)
        {
            ModelState.AddModelError(string.Empty, "El correo o la contraseña son incorrectos.");
            return View(modelo);
        }

        bool claveCorrecta = ClaveService.Verificar(modelo.Clave, usuario.ClaveHash);

        if (!claveCorrecta)
        {
            ModelState.AddModelError(string.Empty, "El correo o la contraseña son incorrectos.");
            return View(modelo);
        }

        // CLIENTE no pertenece al acceso administrativo.
        // Su autenticación se realiza mediante ClientePortal / ClienteAcceso.
        if (usuario.NombreRol.Equals("CLIENTE", StringComparison.OrdinalIgnoreCase))
        {
            ModelState.AddModelError(
                string.Empty,
                "El perfil CLIENTE debe iniciar sesión desde el portal de clientes."
            );

            return View(modelo);
        }

        HttpContext.Session.SetInt32("UsuarioId", usuario.UsuarioId);
        HttpContext.Session.SetString("NombreUsuario", $"{usuario.Nombres} {usuario.Apellidos}");
        HttpContext.Session.SetString("Rol", usuario.NombreRol);

        TempData["Exito"] = $"Bienvenido, {usuario.Nombres}.";

        return RedirectToAction("Index", "Administracion");
    }

    // POST: /Auth/Logout
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Logout()
    {
        LimpiarSesionInterna();
        return RedirectToAction("Login", "Auth");
    }

    private void LimpiarSesionInterna()
    {
        HttpContext.Session.Remove("UsuarioId");
        HttpContext.Session.Remove("NombreUsuario");
        HttpContext.Session.Remove("Rol");
    }
}
