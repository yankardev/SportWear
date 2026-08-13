using SportWear.Web.Models;

namespace SportWear.Web.ViewModels;

public class MiCuentaClienteViewModel
{
    public int ClienteId { get; set; }
    public string NombreCompleto { get; set; } = string.Empty;
    public string Correo { get; set; } = string.Empty;
    public List<SolicitudConfeccion> Solicitudes { get; set; } = new();
    public List<Cotizacion> Cotizaciones { get; set; } = new();
    public List<Pedido> Pedidos { get; set; } = new();
    public List<Venta> Ventas { get; set; } = new();
}