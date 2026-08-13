using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.ViewModels;

public class CambiarClaveViewModel
{
    public int UsuarioId { get; set; }
    public string NombreUsuario { get; set; } = string.Empty;

    [Required(ErrorMessage = "La nueva contraseña es obligatoria.")]
    [MinLength(6, ErrorMessage = "La contraseña debe tener al menos 6 caracteres.")]
    [DataType(DataType.Password)]
    [Display(Name = "Nueva contraseña")]
    public string NuevaClave { get; set; } = string.Empty;

    [Required(ErrorMessage = "Confirme la nueva contraseña.")]
    [DataType(DataType.Password)]
    [Compare(nameof(NuevaClave), ErrorMessage = "Las contraseñas no coinciden.")]
    [Display(Name = "Confirmar contraseña")]
    public string ConfirmarClave { get; set; } = string.Empty;
}
