using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.Models;

public class SolicitudConfeccion
{
    public int SolicitudId { get; set; }

    [Required(ErrorMessage = "Debe seleccionar un cliente.")]
    public int ClienteId { get; set; }

    public string NombreCliente { get; set; } = string.Empty;

    [Required(ErrorMessage = "Debe seleccionar un producto.")]
    public int ProductoId { get; set; }

    public string NombreProducto { get; set; } = string.Empty;

    [Range(1, 10000, ErrorMessage = "La cantidad debe ser mayor que cero.")]
    public int Cantidad { get; set; }

    [Required(ErrorMessage = "La talla es obligatoria.")]
    [StringLength(20)]
    public string Talla { get; set; } = string.Empty;

    [Required(ErrorMessage = "El color es obligatorio.")]
    [StringLength(50)]
    public string Color { get; set; } = string.Empty;

    [Required(ErrorMessage = "El material es obligatorio.")]
    [StringLength(100)]
    public string Material { get; set; } = string.Empty;

    [Display(Name = "Tipo de estampado")]
    [StringLength(100)]
    public string? TipoEstampado { get; set; }

    [Display(Name = "Texto personalizado")]
    [StringLength(150)]
    public string? TextoPersonalizado { get; set; }

    [Display(Name = "Archivo de diseño")]
    public string? ArchivoDisenoUrl { get; set; }

    [StringLength(500)]
    public string? Observaciones { get; set; }

    public string Estado { get; set; } = "PENDIENTE";

    public DateTime FechaRegistro { get; set; }
}