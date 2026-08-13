using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface IUsuarioRepositorio
{
    Usuario? ObtenerPorCorreo(string correo);
    List<Usuario> Listar(string? buscar = null);
    List<Rol> ListarRolesActivos();
    Usuario? ObtenerPorId(int id);
    void Insertar(Usuario usuario);
    void Actualizar(Usuario usuario);
    void Eliminar(int id);
    void CambiarClave(int id, string claveHash);
}
