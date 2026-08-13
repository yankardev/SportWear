using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Filtros;
using SportWear.Web.Models;
using SportWear.Web.Services;
using SportWear.Web.ViewModels;

namespace SportWear.Web.Controllers;

[AutorizarRol("ADMINISTRADOR")]
public class UsuarioController : Controller
{
    private readonly IUsuarioRepositorio _repo;

    public UsuarioController(IUsuarioRepositorio repo)
    {
        _repo = repo;
    }

    private bool EsAdministrador() =>
        HttpContext.Session.GetString("Rol") == "ADMINISTRADOR";

    private IActionResult? ValidarAcceso()
    {
        if (HttpContext.Session.GetInt32("UsuarioId") is null)
            return RedirectToAction("Login", "Auth");

        if (!EsAdministrador())
        {
            TempData["Error"] = "No tiene permiso para gestionar usuarios.";
            return RedirectToAction("Index", "Administracion");
        }

        return null;
    }


    // =========================================================
    // ROLES PERMITIDOS PARA USUARIOS INTERNOS
    // No mostramos el rol CLIENTE
    // =========================================================
    private List<Rol> ObtenerRolesPermitidos()
    {
        return _repo.ListarRolesActivos()
            .Where(r => !r.Nombre.Equals(
                "CLIENTE",
                StringComparison.OrdinalIgnoreCase))
            .ToList();
    }


    // =========================================================
    // VALIDAR QUE NO SE ENVÍE CLIENTE MANUALMENTE
    // =========================================================
    private bool EsRolCliente(int rolId)
    {
        return _repo.ListarRolesActivos()
            .Any(r =>
                r.RolId == rolId &&
                r.Nombre.Equals(
                    "CLIENTE",
                    StringComparison.OrdinalIgnoreCase));
    }


    public IActionResult Index(string? buscar)
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;

        ViewBag.Buscar = buscar;

        return View(_repo.Listar(buscar));
    }


    // =========================================================
    // REGISTRAR - GET
    // =========================================================
    [HttpGet]
    public IActionResult Registrar()
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;

        return View(new UsuarioFormularioViewModel
        {
            Activo = true,

            // Solo ADMINISTRADOR, VENTAS y PRODUCCION
            Roles = ObtenerRolesPermitidos()
        });
    }


    // =========================================================
    // REGISTRAR - POST
    // =========================================================
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Registrar(
        UsuarioFormularioViewModel modelo)
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;


        if (string.IsNullOrWhiteSpace(modelo.Clave))
        {
            ModelState.AddModelError(
                nameof(modelo.Clave),
                "La contraseña es obligatoria."
            );
        }


        // Evita registrar CLIENTE incluso manipulando el formulario
        if (EsRolCliente(modelo.RolId))
        {
            ModelState.AddModelError(
                nameof(modelo.RolId),
                "El perfil CLIENTE no puede registrarse desde Usuarios."
            );
        }


        if (!ModelState.IsValid)
        {
            modelo.Roles =
                ObtenerRolesPermitidos();

            return View(modelo);
        }


        try
        {
            _repo.Insertar(new Usuario
            {
                RolId = modelo.RolId,
                Nombres = modelo.Nombres,
                Apellidos = modelo.Apellidos,
                Correo = modelo.Correo,
                Telefono = modelo.Telefono,
                ClaveHash =
                    ClaveService.GenerarHash(
                        modelo.Clave!
                    ),
                Activo = true
            });


            TempData["Exito"] =
                "Usuario registrado correctamente.";

            return RedirectToAction(
                nameof(Index)
            );
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(
                string.Empty,
                ex.Message
            );

            modelo.Roles =
                ObtenerRolesPermitidos();

            return View(modelo);
        }
    }


    // =========================================================
    // EDITAR - GET
    // =========================================================
    [HttpGet]
    public IActionResult Editar(int id)
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;


        var usuario =
            _repo.ObtenerPorId(id);

        if (usuario is null)
            return NotFound();


        return View(
            new UsuarioFormularioViewModel
            {
                UsuarioId =
                    usuario.UsuarioId,

                RolId =
                    usuario.RolId,

                Nombres =
                    usuario.Nombres,

                Apellidos =
                    usuario.Apellidos,

                Correo =
                    usuario.Correo,

                Telefono =
                    usuario.Telefono,

                Activo =
                    usuario.Activo,

                Roles =
                    ObtenerRolesPermitidos()
            }
        );
    }


    // =========================================================
    // EDITAR - POST
    // =========================================================
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Editar(
        UsuarioFormularioViewModel modelo)
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;


        ModelState.Remove(
            nameof(modelo.Clave)
        );

        ModelState.Remove(
            nameof(modelo.ConfirmarClave)
        );


        // Tampoco permitir cambiar un usuario a CLIENTE
        if (EsRolCliente(modelo.RolId))
        {
            ModelState.AddModelError(
                nameof(modelo.RolId),
                "El perfil CLIENTE no puede asignarse a un usuario interno."
            );
        }


        if (!ModelState.IsValid)
        {
            modelo.Roles =
                ObtenerRolesPermitidos();

            return View(modelo);
        }


        try
        {
            _repo.Actualizar(new Usuario
            {
                UsuarioId =
                    modelo.UsuarioId,

                RolId =
                    modelo.RolId,

                Nombres =
                    modelo.Nombres,

                Apellidos =
                    modelo.Apellidos,

                Correo =
                    modelo.Correo,

                Telefono =
                    modelo.Telefono,

                Activo =
                    modelo.Activo
            });


            TempData["Exito"] =
                "Usuario actualizado correctamente.";

            return RedirectToAction(
                nameof(Index)
            );
        }
        catch (SqlException ex)
        {
            ModelState.AddModelError(
                string.Empty,
                ex.Message
            );

            modelo.Roles =
                ObtenerRolesPermitidos();

            return View(modelo);
        }
    }


    // =========================================================
    // DETALLE
    // =========================================================
    public IActionResult Detalle(int id)
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;


        var usuario =
            _repo.ObtenerPorId(id);

        return usuario is null
            ? NotFound()
            : View(usuario);
    }


    // =========================================================
    // CAMBIAR CLAVE - GET
    // =========================================================
    [HttpGet]
    public IActionResult CambiarClave(int id)
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;


        var usuario =
            _repo.ObtenerPorId(id);

        if (usuario is null)
            return NotFound();


        return View(
            new CambiarClaveViewModel
            {
                UsuarioId =
                    usuario.UsuarioId,

                NombreUsuario =
                    $"{usuario.Nombres} {usuario.Apellidos}"
            }
        );
    }


    // =========================================================
    // CAMBIAR CLAVE - POST
    // =========================================================
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult CambiarClave(
        CambiarClaveViewModel modelo)
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;


        if (!ModelState.IsValid)
            return View(modelo);


        _repo.CambiarClave(
            modelo.UsuarioId,
            ClaveService.GenerarHash(
                modelo.NuevaClave
            )
        );


        TempData["Exito"] =
            "Contraseña actualizada correctamente.";

        return RedirectToAction(
            nameof(Index)
        );
    }


    // =========================================================
    // ELIMINAR
    // =========================================================
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Eliminar(int id)
    {
        var acceso = ValidarAcceso();

        if (acceso is not null)
            return acceso;


        int? usuarioSesion =
            HttpContext.Session
                .GetInt32("UsuarioId");


        if (usuarioSesion == id)
        {
            TempData["Error"] =
                "No puede desactivar su propio usuario.";

            return RedirectToAction(
                nameof(Index)
            );
        }


        _repo.Eliminar(id);


        TempData["Exito"] =
            "Usuario desactivado correctamente.";

        return RedirectToAction(
            nameof(Index)
        );
    }
}