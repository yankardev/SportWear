using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.ViewModels;

public class LoginClienteViewModel
{
    [Required(ErrorMessage = "Ingrese su correo.")]
    [EmailAddress(ErrorMessage = "Ingrese un correo válido.")]
    public string Correo { get; set; } = string.Empty;
    [Required(ErrorMessage = "Ingrese su contraseña.")]
    public string Clave { get; set; } = string.Empty;
}