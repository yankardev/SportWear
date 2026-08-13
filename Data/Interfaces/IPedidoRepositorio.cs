using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface IPedidoRepositorio
{
    List<Pedido> Listar(string? buscar = null);
    Pedido? ObtenerPorId(int id);
    List<EstadoPedido> ListarEstados();
    void Generar(Pedido pedido);
    void ActualizarEstado(int pedidoId, int estadoPedidoId);
    List<Pedido> ListarPorCliente(int clienteId);
}
