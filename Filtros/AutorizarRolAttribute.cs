using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace SportWear.Web.Filtros;

public class AutorizarRolAttribute : ActionFilterAttribute
{
    private readonly string[] _rolesPermitidos;

    public AutorizarRolAttribute(params string[] rolesPermitidos)
    {
        _rolesPermitidos = rolesPermitidos;
    }

    public override void OnActionExecuting(ActionExecutingContext context)
    {
        int? usuarioId = context.HttpContext.Session.GetInt32("UsuarioId");
        string? rol = context.HttpContext.Session.GetString("Rol");

        // No inició sesión como usuario interno.
        if (usuarioId is null)
        {
            context.Result = new RedirectToActionResult("Login", "Auth", null);
            return;
        }

        bool permitido =
            !string.IsNullOrWhiteSpace(rol)
            && _rolesPermitidos.Any(r =>
                r.Equals(rol, StringComparison.OrdinalIgnoreCase));

        if (permitido)
        {
            return;
        }

        // Evita bucles si existiera un usuario antiguo con rol CLIENTE.
        if (rol != null && rol.Equals("CLIENTE", StringComparison.OrdinalIgnoreCase))
        {
            context.HttpContext.Session.Remove("UsuarioId");
            context.HttpContext.Session.Remove("NombreUsuario");
            context.HttpContext.Session.Remove("Rol");

            context.Result = new RedirectToActionResult("Login", "ClientePortal", null);
            return;
        }

        if (context.Controller is Controller controller)
        {
            controller.TempData["Error"] = "No tienes permiso para acceder a esta sección.";
        }

        context.Result = new RedirectToActionResult("Index", "Administracion", null);
    }
}
