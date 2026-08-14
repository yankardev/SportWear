using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.ViewModels;

public class CambiarClaveClienteViewModel
{
    public int ClienteId { get; set; }

    public string NombreCliente { get; set; } = string.Empty;

    public string Correo { get; set; } = string.Empty;

    public bool TieneAcceso { get; set; }

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
