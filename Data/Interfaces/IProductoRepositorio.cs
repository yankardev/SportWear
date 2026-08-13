using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface IProductoRepositorio
{
    List<Producto> Listar(string? buscar = null);
    List<Producto> ListarPaginado( int pagina,int tamano, out int total);
    Producto? ObtenerPorId(int id);
    void Insertar(Producto producto);
    void Actualizar(Producto producto);
    void Eliminar(int id);

    List<Producto> ListarPersonalizables();
}