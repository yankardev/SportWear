using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface IClienteAccesoRepositorio
{
    ClienteAcceso? ObtenerPorCorreo(string correo);

    ClienteAcceso? ObtenerPorClienteId(int clienteId);

    void Insertar(ClienteAcceso acceso);

    void CambiarClave(int clienteId, string claveHash);

    void RestablecerClaveAdmin(
        int clienteId,
        string correo,
        string claveHash,
        bool activo
    );
}
