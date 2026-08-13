using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.ViewModels;

public class RegistroClienteViewModel
{
    [Required(ErrorMessage = "Ingrese sus nombres.")]
    [StringLength(100)]
    public string Nombres { get; set; } = string.Empty;
    [Required(ErrorMessage = "Ingrese sus apellidos.")]
    [StringLength(100)]
    public string Apellidos { get; set; } = string.Empty;
    [Required(ErrorMessage = "Ingrese su documento.")]
    [StringLength(15)]
    public string Documento { get; set; } = string.Empty;
    [Required(ErrorMessage = "Ingrese su teléfono.")]
    [StringLength(20)]
    public string Telefono { get; set; } = string.Empty;
    [Required(ErrorMessage = "Ingrese su correo.")]
    [EmailAddress(ErrorMessage = "Ingrese un correo válido.")]
    [StringLength(150)]
    public string Correo { get; set; } = string.Empty;
    [Required(ErrorMessage = "Ingrese una contraseña.")]
    [StringLength(50,MinimumLength = 6,ErrorMessage = "La contraseña debe tener al menos 6 caracteres.")]
    public string Clave { get; set; } = string.Empty;
    [Required(ErrorMessage = "Confirme su contraseña.")]
    [Compare( "Clave", ErrorMessage = "Las contraseñas no coinciden.")]
    public string ConfirmarClave { get; set; } = string.Empty;
}