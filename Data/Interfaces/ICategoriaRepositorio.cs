using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface ICategoriaRepositorio
{
    List<Categoria> Listar(string? buscar = null);

    List<Categoria> ListarPaginado(int pagina, int tamano, out int total);

    Categoria? ObtenerPorId(int id);

    void Insertar(Categoria categoria);

    void Actualizar(Categoria categoria);

    void Eliminar(int id);

    List<Categoria> ListarActivas();
}