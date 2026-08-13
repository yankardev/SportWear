using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.Models;

public class Cliente
{
    public int ClienteId { get; set; }

    [Required(ErrorMessage = "Los nombres son obligatorios.")]
    [StringLength(100)]
    public string Nombres { get; set; } = string.Empty;

    [Required(ErrorMessage = "Los apellidos son obligatorios.")]
    [StringLength(100)]
    public string Apellidos { get; set; } = string.Empty;

    [Required(ErrorMessage = "El documento es obligatorio.")]
    [StringLength(15)]
    public string Documento { get; set; } = string.Empty;

    [Phone]
    [StringLength(20)]
    public string? Telefono { get; set; }

    [EmailAddress]
    [StringLength(120)]
    public string? Correo { get; set; }

    [StringLength(200)]
    public string? Direccion { get; set; }

    public bool Activo { get; set; } = true;

    public DateTime FechaRegistro { get; set; }
}