namespace SportWear.Web.Models;

public class ReporteResumen
{
    public int TotalProductos { get; set; }
    public int TotalClientes { get; set; }
    public int TotalSolicitudes { get; set; }
    public int TotalCotizaciones { get; set; }
    public int TotalPedidos { get; set; }
    public int PedidosPendientes { get; set; }
    public decimal TotalVentas { get; set; }

    public List<ReportePedidoEstado> PedidosPorEstado { get; set; } = new();
    public List<ReporteProductoSolicitado> ProductosMasSolicitados { get; set; } = new();
    public List<ReporteClienteSolicitud> ClientesConMasSolicitudes { get; set; } = new();
}

public class ReportePedidoEstado
{
    public string Estado { get; set; } = string.Empty;
    public int Cantidad { get; set; }
    public decimal Total { get; set; }
}

public class ReporteProductoSolicitado
{
    public int ProductoId { get; set; }
    public string Producto { get; set; } = string.Empty;
    public int TotalSolicitudes { get; set; }
    public int TotalUnidades { get; set; }
}

public class ReporteClienteSolicitud
{
    public int ClienteId { get; set; }
    public string Cliente { get; set; } = string.Empty;
    public int TotalSolicitudes { get; set; }
    public decimal TotalCotizado { get; set; }
}
