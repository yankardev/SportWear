using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.Models;

public class Usuario
{
    public int UsuarioId { get; set; }

    [Display(Name = "Rol")]
    public int RolId { get; set; }

    public string NombreRol { get; set; } = string.Empty;

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

    public string ClaveHash { get; set; } = string.Empty;

    [Display(Name = "Teléfono")]
    [StringLength(20)]
    public string? Telefono { get; set; }

    public bool Activo { get; set; }
    public DateTime FechaRegistro { get; set; }
}
