using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.ViewModels;

public class CheckoutViewModel
{
    [Required(ErrorMessage = "El destinatario es obligatorio.")]
    [StringLength(150)]
    [Display(Name = "Destinatario")]
    public string Destinatario { get; set; } = string.Empty;

    [Required(ErrorMessage = "El teléfono es obligatorio.")]
    [StringLength(20)]
    [Display(Name = "Teléfono")]
    public string Telefono { get; set; } = string.Empty;

    [Required(ErrorMessage = "La dirección es obligatoria.")]
    [StringLength(250)]
    [Display(Name = "Dirección de entrega")]
    public string Direccion { get; set; } = string.Empty;

    public CarritoViewModel Carrito { get; set; } = new();
}
