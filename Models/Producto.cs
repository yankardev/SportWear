using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.Models;

public class Producto
{
    public int ProductoId { get; set; }
    [Required(ErrorMessage = "Debe seleccionar una categoría.")]
    [Display(Name = "Categoría")]
    public int CategoriaId { get; set; }
    public string NombreCategoria { get; set; } = string.Empty;
    [Required(ErrorMessage = "El nombre es obligatorio.")]
    [StringLength(120, ErrorMessage = "El nombre no puede superar los 120 caracteres.")]
    public string Nombre { get; set; } = string.Empty;
    [StringLength(500,ErrorMessage = "La descripción no puede superar los 500 caracteres.")]
    public string? Descripcion { get; set; }
    [Required(ErrorMessage = "El precio es obligatorio.")]
    [Range(0.01,100000,ErrorMessage = "El precio debe ser mayor que cero.")]
    [Display(Name = "Precio base")]
    public decimal PrecioBase { get; set; }
    [Display(Name = "Imagen")]
    public string? ImagenUrl { get; set; }
    [Display(Name = "Personalizable")]
    public bool Personalizable { get; set; }

    [Display(Name = "Stock")]
    [Range(0, 100000, ErrorMessage = "El stock no puede ser negativo.")]
    public int Stock { get; set; }

    public bool Activo { get; set; } = true;
    public DateTime FechaRegistro { get; set; }
}