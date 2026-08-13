namespace SportWear.Web.Models;

public class EstadoPedido
{
    public int EstadoPedidoId { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public int Orden { get; set; }
    public bool Activo { get; set; }
}
