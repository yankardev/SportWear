using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.Models;

public class Venta
{
    public int VentaId { get; set; }
    public int ClienteId { get; set; }
    public string Codigo { get; set; } = string.Empty;
    public DateTime FechaVenta { get; set; }
    public string Destinatario { get; set; } = string.Empty;
    public string Telefono { get; set; } = string.Empty;
    public string Direccion { get; set; } = string.Empty;
    public decimal Subtotal { get; set; }
    public decimal Igv { get; set; }
    public decimal Total { get; set; }
    public string Estado { get; set; } = string.Empty;
    public string NombreCliente { get; set; } = string.Empty;
    public List<VentaDetalle> Detalles { get; set; } = new();
}

public class VentaDetalle
{
    public int VentaDetalleId { get; set; }
    public int VentaId { get; set; }
    public int ProductoId { get; set; }
    public string NombreProducto { get; set; } = string.Empty;
    public string? ImagenUrl { get; set; }
    public string? Talla { get; set; }
    public int Cantidad { get; set; }
    public decimal PrecioUnitario { get; set; }
    public decimal Subtotal { get; set; }
}

public class VentaDetalleEntrada
{
    public int ProductoId { get; set; }
    public string Talla { get; set; } = string.Empty;
    public int Cantidad { get; set; }
}
