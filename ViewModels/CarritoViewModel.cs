namespace SportWear.Web.ViewModels;

public class CarritoSesionItem
{
    public int ProductoId { get; set; }
    public string Talla { get; set; } = string.Empty;
    public int Cantidad { get; set; }
}

public class CarritoItemViewModel
{
    public int ProductoId { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string? ImagenUrl { get; set; }
    public string Talla { get; set; } = string.Empty;
    public decimal PrecioUnitario { get; set; }
    public int Cantidad { get; set; }
    public int Stock { get; set; }
    public decimal Subtotal => PrecioUnitario * Cantidad;
}

public class CarritoViewModel
{
    public List<CarritoItemViewModel> Items { get; set; } = new();
    public int CantidadTotal => Items.Sum(x => x.Cantidad);
    // PrecioBase se considera precio final de tienda (IGV incluido).
    public decimal Total => Items.Sum(x => x.Subtotal);
    public decimal Subtotal => Math.Round(Total / 1.18m, 2, MidpointRounding.AwayFromZero);
    public decimal Igv => Total - Subtotal;
}
