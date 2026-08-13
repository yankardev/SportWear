using System.ComponentModel.DataAnnotations;
using SportWear.Web.Models;

namespace SportWear.Web.ViewModels;

public class UsuarioFormularioViewModel
{
    public int UsuarioId { get; set; }

    [Required(ErrorMessage = "Seleccione un rol.")]
    [Display(Name = "Rol")]
    public int RolId { get; set; }

    [Required(ErrorMessage = "Los nombres son obligatorios.")]
    [StringLength(100)]
    public string Nombres { get; set; } = string.Empty;

    [Required(ErrorMessage = "Los apellidos son obligatorios.")]
    [StringLength(100)]
    public string Apellidos { get; set; } = string.Empty;

    [Required(ErrorMessage = "El correo es obligatorio.")]
    [EmailAddress(ErrorMessage = "Ingrese un correo válido.")]
    [StringLength(150)]
    public string Correo { get; set; } = string.Empty;

    [Display(Name = "Teléfono")]
    [StringLength(20)]
    public string? Telefono { get; set; }

    [DataType(DataType.Password)]
    [Display(Name = "Contraseña")]
    [MinLength(6, ErrorMessage = "La contraseña debe tener al menos 6 caracteres.")]
    public string? Clave { get; set; }

    [DataType(DataType.Password)]
    [Display(Name = "Confirmar contraseña")]
    [Compare(nameof(Clave), ErrorMessage = "Las contraseñas no coinciden.")]
    public string? ConfirmarClave { get; set; }

    public bool Activo { get; set; } = true;
    public List<Rol> Roles { get; set; } = new();
}
