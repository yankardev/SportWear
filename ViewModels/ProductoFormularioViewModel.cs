using SportWear.Web.Models;

namespace SportWear.Web.ViewModels;

public class ProductoFormularioViewModel
{
    public Producto Producto { get; set; } = new();

    public List<Categoria> Categorias { get; set; } = new();
}