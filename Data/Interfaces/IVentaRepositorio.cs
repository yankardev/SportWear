using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface IVentaRepositorio
{
    int Registrar(
        int clienteId,
        string destinatario,
        string telefono,
        string direccion,
        List<VentaDetalleEntrada> detalles);

    List<Venta> Listar(string? buscar = null);
    List<Venta> ListarPorCliente(int clienteId);
    Venta? ObtenerPorId(int ventaId);
    void ActualizarEstado(int ventaId, string estado);
}
