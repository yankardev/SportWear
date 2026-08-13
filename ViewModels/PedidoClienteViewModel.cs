using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.ViewModels;

public class PedidoClienteViewModel
{
    public int CotizacionId { get; set; }

    public string CodigoCotizacion { get; set; } = string.Empty;

    public string NombreProducto { get; set; } = string.Empty;

    public int Cantidad { get; set; }

    public decimal Total { get; set; }

    [Required(ErrorMessage = "El destinatario es obligatorio.")]
    [StringLength(150)]
    public string Destinatario { get; set; } = string.Empty;

    [Required(ErrorMessage = "El teléfono de entrega es obligatorio.")]
    [StringLength(20)]
    public string TelefonoEntrega { get; set; } = string.Empty;

    [Required(ErrorMessage = "La dirección de entrega es obligatoria.")]
    [StringLength(250)]
    public string DireccionEntrega { get; set; } = string.Empty;

    [Required(ErrorMessage = "El distrito de entrega es obligatorio.")]
    [StringLength(100)]
    public string DistritoEntrega { get; set; } = string.Empty;

    [StringLength(250)]
    public string? ReferenciaEntrega { get; set; }

    [StringLength(1000)]
    public string? Observaciones { get; set; }
}
