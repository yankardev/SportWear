using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface IClienteRepositorio
{
    List<Cliente> Listar(string? buscar = null);
    List<Cliente> ListarActivos();
    List<Cliente> ListarPaginado( int pagina, int tamano, out int total);
    Cliente? ObtenerPorId(int id);
    Cliente? ObtenerPorDocumento(string documento);
    int Insertar(Cliente cliente);
    void Actualizar(Cliente cliente);
    void Eliminar(int id);
}