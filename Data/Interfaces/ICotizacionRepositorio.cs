using SportWear.Web.Models;

namespace SportWear.Web.Data.Interfaces;

public interface ICotizacionRepositorio
{
    List<Cotizacion> Listar(string? buscar = null);

    Cotizacion? ObtenerPorId(int id);

    void Generar(int solicitudId, int usuarioId);

    List<Cotizacion> ListarPorCliente(int clienteId);
}