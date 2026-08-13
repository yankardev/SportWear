using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface ISolicitudConfeccionRepositorio
{
    List<SolicitudConfeccion> Listar(string? buscar = null);

    SolicitudConfeccion? ObtenerPorId(int id);

    void Insertar(SolicitudConfeccion solicitud);

    void ActualizarEstado(int id, string estado);

    List<SolicitudConfeccion> ListarPorCliente(int clienteId);
}