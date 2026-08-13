using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.Models;

public class Pedido
{
    public int PedidoId { get; set; }
    public int UsuarioId { get; set; }
    public int CotizacionId { get; set; }
    public int EstadoPedidoId { get; set; }
    public string Codigo { get; set; } = string.Empty;

    [Display(Name = "Fecha del pedido")]
    public DateTime FechaPedido { get; set; }

    [Display(Name = "Fecha estimada de entrega")]
    [DataType(DataType.Date)]
    public DateTime? FechaEntregaEstimada { get; set; }

    [StringLength(150)]
    public string? Destinatario { get; set; }

    [Display(Name = "Teléfono de entrega")]
    [StringLength(20)]
    public string? TelefonoEntrega { get; set; }

    [Display(Name = "Dirección de entrega")]
    [StringLength(250)]
    public string? DireccionEntrega { get; set; }

    [Display(Name = "Distrito de entrega")]
    [StringLength(100)]
    public string? DistritoEntrega { get; set; }

    [Display(Name = "Referencia de entrega")]
    [StringLength(250)]
    public string? ReferenciaEntrega { get; set; }

    public decimal Subtotal { get; set; }
    public decimal Igv { get; set; }
    public decimal Total { get; set; }

    [StringLength(1000)]
    public string? Observaciones { get; set; }

    public string Estado { get; set; } = string.Empty;

    // Datos obtenidos mediante JOIN
    public string NombreEstado { get; set; } = string.Empty;
    public string CodigoCotizacion { get; set; } = string.Empty;
    public string NombreCliente { get; set; } = string.Empty;
    public string NombreProducto { get; set; } = string.Empty;
    public int Cantidad { get; set; }
    public string? Documento { get; set; }
    public string? TelefonoCliente { get; set; }
    public string? Correo { get; set; }
    public string? Talla { get; set; }
    public string? Color { get; set; }
    public string? Material { get; set; }
    public string? TipoEstampado { get; set; }
}
