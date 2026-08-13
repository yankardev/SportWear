using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.ViewModels
{
    public class CotizacionPublicaViewModel
    {
        public int ProductoId { get; set; }
        public string? NombreProducto { get; set; }
        public decimal PrecioBase { get; set; }
        [Required(ErrorMessage = "Ingrese sus nombres.")]
        [StringLength(100)]
        public string Nombres { get; set; } = string.Empty;
        [Required(ErrorMessage = "Ingrese sus apellidos.")]
        [StringLength(100)]
        public string Apellidos { get; set; } = string.Empty;
        [Required(ErrorMessage = "Ingrese su documento.")]
        [StringLength(15)]
        public string Documento { get; set; } = string.Empty;
        [Required(ErrorMessage = "Ingrese su teléfono.")]
        [StringLength(20)]
        public string Telefono { get; set; } = string.Empty;
        [Required(ErrorMessage = "Ingrese su correo.")]
        [EmailAddress(ErrorMessage = "Ingrese un correo válido.")]
        [StringLength(120)]
        public string Correo { get; set; } = string.Empty;
        [Required(ErrorMessage = "Ingrese la cantidad.")]
        [Range(1, 10000, ErrorMessage = "La cantidad debe ser mayor que cero.")]
        public int Cantidad { get; set; }
        [Required(ErrorMessage = "Seleccione una talla.")]
        public string Talla { get; set; } = string.Empty;
        [Required(ErrorMessage = "Ingrese un color.")]
        public string Color { get; set; } = string.Empty;
        [Required(ErrorMessage = "Ingrese el material.")]
        public string Material { get; set; } = string.Empty;
        public string? TipoEstampado { get; set; }
        public string? TextoPersonalizado { get; set; }
        public string? Observaciones { get; set; }
    }
}