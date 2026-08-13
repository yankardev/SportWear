using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class ReporteRepositorio : IReporteRepositorio
{
    private readonly ConexionBD _conexionBD;

    public ReporteRepositorio(ConexionBD conexionBD)
    {
        _conexionBD = conexionBD;
    }

    public ReporteResumen ObtenerResumen()
    {
        var reporte = new ReporteResumen();

        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Reporte_ResumenGeneral", conexion);
        comando.CommandType = CommandType.StoredProcedure;

        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();

        if (lector.Read())
        {
            reporte.TotalProductos = Convert.ToInt32(lector["TotalProductos"]);
            reporte.TotalClientes = Convert.ToInt32(lector["TotalClientes"]);
            reporte.TotalSolicitudes = Convert.ToInt32(lector["TotalSolicitudes"]);
            reporte.TotalCotizaciones = Convert.ToInt32(lector["TotalCotizaciones"]);
            reporte.TotalPedidos = Convert.ToInt32(lector["TotalPedidos"]);
            reporte.PedidosPendientes = Convert.ToInt32(lector["PedidosPendientes"]);
            reporte.TotalVentas = Convert.ToDecimal(lector["TotalVentas"]);
        }

        if (lector.NextResult())
        {
            while (lector.Read())
            {
                reporte.PedidosPorEstado.Add(new ReportePedidoEstado
                {
                    Estado = lector["Estado"]?.ToString() ?? string.Empty,
                    Cantidad = Convert.ToInt32(lector["Cantidad"]),
                    Total = Convert.ToDecimal(lector["Total"])
                });
            }
        }

        if (lector.NextResult())
        {
            while (lector.Read())
            {
                reporte.ProductosMasSolicitados.Add(new ReporteProductoSolicitado
                {
                    ProductoId = Convert.ToInt32(lector["ProductoId"]),
                    Producto = lector["Producto"]?.ToString() ?? string.Empty,
                    TotalSolicitudes = Convert.ToInt32(lector["TotalSolicitudes"]),
                    TotalUnidades = Convert.ToInt32(lector["TotalUnidades"])
                });
            }
        }

        if (lector.NextResult())
        {
            while (lector.Read())
            {
                reporte.ClientesConMasSolicitudes.Add(new ReporteClienteSolicitud
                {
                    ClienteId = Convert.ToInt32(lector["ClienteId"]),
                    Cliente = lector["Cliente"]?.ToString() ?? string.Empty,
                    TotalSolicitudes = Convert.ToInt32(lector["TotalSolicitudes"]),
                    TotalCotizado = Convert.ToDecimal(lector["TotalCotizado"])
                });
            }
        }

        return reporte;
    }
}
