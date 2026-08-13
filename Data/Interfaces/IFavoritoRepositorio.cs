using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface IFavoritoRepositorio
{
    List<Producto> ListarPorCliente(int clienteId);
    void Agregar(int clienteId, int productoId);
    void Eliminar(int clienteId, int productoId);
}
