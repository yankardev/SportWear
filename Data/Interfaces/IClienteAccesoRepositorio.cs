using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface IClienteAccesoRepositorio
{
    ClienteAcceso? ObtenerPorCorreo(string correo);

    void Insertar(ClienteAcceso acceso);
}