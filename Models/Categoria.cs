using System.ComponentModel.DataAnnotations;

namespace SportWear.Web.Models;

public class Categoria
{
    public int CategoriaId { get; set; }

    [Required(ErrorMessage = "El nombre es obligatorio.")]
    [StringLength(100)]
    public string Nombre { get; set; } = string.Empty;

    [StringLength(300)]
    public string? Descripcion { get; set; }

    public bool Activo { get; set; } = true;

    public DateTime FechaRegistro { get; set; }
}