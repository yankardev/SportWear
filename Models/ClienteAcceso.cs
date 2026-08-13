namespace SportWear.Web.Models;

public class ClienteAcceso
{
    public int ClienteAccesoId { get; set; }
    public int ClienteId { get; set; }
    public string Correo { get; set; } = string.Empty;
    public string ClaveHash { get; set; } = string.Empty;
    public bool Activo { get; set; }
    public DateTime FechaRegistro { get; set; }

    // Campos auxiliares para mostrar información del cliente
    public string Nombres { get; set; } = string.Empty;
    public string Apellidos { get; set; } = string.Empty;
}