using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class VentaRepositorio : IVentaRepositorio
{
    private readonly ConexionBD _conexionBD;

    public VentaRepositorio(ConexionBD conexionBD)
    {
        _conexionBD = conexionBD;
    }

    public int Registrar(
        int clienteId,
        string destinatario,
        string telefono,
        string direccion,
        List<VentaDetalleEntrada> detalles)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Venta_Registrar", conexion);
        comando.CommandType = CommandType.StoredProcedure;

        comando.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;
        comando.Parameters.Add("@Destinatario", SqlDbType.NVarChar, 150).Value = destinatario.Trim();
        comando.Parameters.Add("@Telefono", SqlDbType.NVarChar, 20).Value = telefono.Trim();
        comando.Parameters.Add("@Direccion", SqlDbType.NVarChar, 250).Value = direccion.Trim();

        DataTable tabla = new();
        tabla.Columns.Add("ProductoId", typeof(int));
        tabla.Columns.Add("Cantidad", typeof(int));
        tabla.Columns.Add("Talla", typeof(string));

        foreach (var detalle in detalles)
        {
            tabla.Rows.Add(detalle.ProductoId, detalle.Cantidad, detalle.Talla);
        }

        SqlParameter parametroDetalle = comando.Parameters.AddWithValue("@Detalle", tabla);
        parametroDetalle.SqlDbType = SqlDbType.Structured;
        parametroDetalle.TypeName = "dbo.VentaDetalleTipo";

        SqlParameter ventaId = comando.Parameters.Add("@VentaId", SqlDbType.Int);
        ventaId.Direction = ParameterDirection.Output;

        conexion.Open();
        comando.ExecuteNonQuery();

        return Convert.ToInt32(ventaId.Value);
    }

    public List<Venta> Listar(string? buscar = null)
    {
        var ventas = new List<Venta>();

        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Venta_Listar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@Buscar", SqlDbType.NVarChar, 150).Value =
            string.IsNullOrWhiteSpace(buscar) ? DBNull.Value : buscar.Trim();

        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            ventas.Add(MapearVenta(lector));
        }

        return ventas;
    }

    public List<Venta> ListarPorCliente(int clienteId)
    {
        var ventas = new List<Venta>();

        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Venta_ListarPorCliente", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;

        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            ventas.Add(MapearVenta(lector));
        }

        return ventas;
    }

    public Venta? ObtenerPorId(int ventaId)
    {
        Venta? venta = null;

        using SqlConnection conexion = _conexionBD.CrearConexion();
        conexion.Open();

        using (SqlCommand comando = new("dbo.sp_Venta_ObtenerPorId", conexion))
        {
            comando.CommandType = CommandType.StoredProcedure;
            comando.Parameters.Add("@VentaId", SqlDbType.Int).Value = ventaId;

            using SqlDataReader lector = comando.ExecuteReader();
            if (lector.Read())
            {
                venta = MapearVenta(lector);
            }
        }

        if (venta is null)
        {
            return null;
        }

        using (SqlCommand comando = new("dbo.sp_VentaDetalle_ListarPorVenta", conexion))
        {
            comando.CommandType = CommandType.StoredProcedure;
            comando.Parameters.Add("@VentaId", SqlDbType.Int).Value = ventaId;

            using SqlDataReader lector = comando.ExecuteReader();
            while (lector.Read())
            {
                venta.Detalles.Add(new VentaDetalle
                {
                    VentaDetalleId = Convert.ToInt32(lector["VentaDetalleId"]),
                    VentaId = Convert.ToInt32(lector["VentaId"]),
                    ProductoId = Convert.ToInt32(lector["ProductoId"]),
                    NombreProducto = lector["NombreProducto"]?.ToString() ?? string.Empty,
                    ImagenUrl = lector["ImagenUrl"] == DBNull.Value ? null : lector["ImagenUrl"].ToString(),
                    Talla = lector["Talla"] == DBNull.Value ? null : lector["Talla"].ToString(),
                    Cantidad = Convert.ToInt32(lector["Cantidad"]),
                    PrecioUnitario = Convert.ToDecimal(lector["PrecioUnitario"]),
                    Subtotal = Convert.ToDecimal(lector["Subtotal"])
                });
            }
        }

        return venta;
    }

    public void ActualizarEstado(int ventaId, string estado)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Venta_ActualizarEstado", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@VentaId", SqlDbType.Int).Value = ventaId;
        comando.Parameters.Add("@Estado", SqlDbType.NVarChar, 30).Value = estado.Trim();

        conexion.Open();
        comando.ExecuteNonQuery();
    }

    private static Venta MapearVenta(SqlDataReader lector)
    {
        return new Venta
        {
            VentaId = Convert.ToInt32(lector["VentaId"]),
            ClienteId = Convert.ToInt32(lector["ClienteId"]),
            Codigo = lector["Codigo"]?.ToString() ?? string.Empty,
            FechaVenta = Convert.ToDateTime(lector["FechaVenta"]),
            Destinatario = lector["Destinatario"]?.ToString() ?? string.Empty,
            Telefono = lector["Telefono"]?.ToString() ?? string.Empty,
            Direccion = lector["Direccion"]?.ToString() ?? string.Empty,
            Subtotal = Convert.ToDecimal(lector["Subtotal"]),
            Igv = Convert.ToDecimal(lector["Igv"]),
            Total = Convert.ToDecimal(lector["Total"]),
            Estado = lector["Estado"]?.ToString() ?? string.Empty,
            NombreCliente = lector["NombreCliente"]?.ToString() ?? string.Empty
        };
    }
}
