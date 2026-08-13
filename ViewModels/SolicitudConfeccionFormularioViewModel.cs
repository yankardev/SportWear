using SportWear.Web.Models;

namespace SportWear.Web.ViewModels;

public class SolicitudConfeccionFormularioViewModel
{
    public SolicitudConfeccion Solicitud { get; set; } = new();

    public List<Cliente> Clientes { get; set; } = new();

    public List<Producto> Productos { get; set; } = new();
}