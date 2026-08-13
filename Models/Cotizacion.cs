using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.Models;

public class Cotizacion
{
    public int CotizacionId { get; set; }

    public int SolicitudId { get; set; }

    public int UsuarioId { get; set; }

    public string Codigo { get; set; } = string.Empty;

    public string Estado { get; set; } = string.Empty;

    [Display(Name = "Fecha de emisión")]
    public DateTime FechaEmision { get; set; }

    [Display(Name = "Fecha de vencimiento")]
    public DateTime? FechaVencimiento { get; set; }

    [Display(Name = "Precio unitario")]
    public decimal PrecioUnitario { get; set; }

    [Display(Name = "Descuento")]
    public decimal DescuentoPorcentaje { get; set; }

    public decimal Subtotal { get; set; }

    public decimal Igv { get; set; }

    public decimal Total { get; set; }

    public string? Observaciones { get; set; }

    public string? PdfUrl { get; set; }

    // Datos obtenidos mediante JOIN
    public string NombreCliente { get; set; } = string.Empty;

    public string NombreProducto { get; set; } = string.Empty;

    public int Cantidad { get; set; }

    public string? Documento { get; set; }

    public string? Telefono { get; set; }

    public string? Correo { get; set; }

    public string? Talla { get; set; }

    public string? Color { get; set; }

    public string? Material { get; set; }

    public string? TipoEstampado { get; set; }

    public string? TextoPersonalizado { get; set; }
}