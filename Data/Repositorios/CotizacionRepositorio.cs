using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class CotizacionRepositorio : ICotizacionRepositorio
{
    private readonly ConexionBD _conexionBD;
    public CotizacionRepositorio(ConexionBD conexionBD)
    {
        _conexionBD = conexionBD;
    }
    public List<Cotizacion> Listar(string? buscar = null)
    {
        var cotizaciones = new List<Cotizacion>();
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand cmd = new("dbo.sp_Cotizacion_Listar",cn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@Buscar",SqlDbType.NVarChar,120).Value = string.IsNullOrWhiteSpace(buscar)
            ? DBNull.Value : buscar.Trim();
        cn.Open();
        using SqlDataReader lector = cmd.ExecuteReader();
        while (lector.Read())
        {
            cotizaciones.Add( MapearCotizacionListado(lector));
        }
        return cotizaciones;
    }
    public Cotizacion? ObtenerPorId(int id)
    {
        using SqlConnection conexion =
            _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Cotizacion_ObtenerPorId",
            conexion
        );

        comando.CommandType =
            CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@CotizacionId",
            SqlDbType.Int
        ).Value = id;

        conexion.Open();

        using SqlDataReader lector =
            comando.ExecuteReader();

        return lector.Read()
            ? MapearCotizacionDetalle(lector)
            : null;
    }
    public void Generar(int solicitudId,int usuarioId)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Cotizacion_Generar",conexion);
        comando.CommandType =CommandType.StoredProcedure;
        comando.Parameters.Add("@SolicitudId",SqlDbType.Int).Value = solicitudId;
        comando.Parameters.Add("@UsuarioId",SqlDbType.Int).Value = usuarioId;
        conexion.Open();
        comando.ExecuteNonQuery();
    }
    private static Cotizacion MapearCotizacionListado(SqlDataReader dr)
    {
        return new Cotizacion
        {
            CotizacionId = Convert.ToInt32(dr["CotizacionId"]),
            SolicitudId = Convert.ToInt32(dr["SolicitudId"]),
            UsuarioId = Convert.ToInt32(dr["UsuarioId"]),
            Codigo = dr["Codigo"]?.ToString() ?? string.Empty,
            Estado = dr["Estado"]?.ToString() ?? string.Empty,
            FechaEmision = Convert.ToDateTime(dr["FechaEmision"]),
            FechaVencimiento = dr["FechaVencimiento"] == DBNull.Value
                    ? null : Convert.ToDateTime(dr["FechaVencimiento"]),
            PrecioUnitario = Convert.ToDecimal(dr["PrecioUnitario"]),
            DescuentoPorcentaje = Convert.ToDecimal( dr["DescuentoPorcentaje"]),
            Subtotal = Convert.ToDecimal( dr["Subtotal"]),
            Igv = Convert.ToDecimal(dr["Igv"]),
            Total = Convert.ToDecimal(dr["Total"]),
            Observaciones = dr["Observaciones"] == DBNull.Value
                    ? null : dr["Observaciones"].ToString(),
            PdfUrl = dr["PdfUrl"] == DBNull.Value
                    ? null : dr["PdfUrl"].ToString(),
            NombreCliente = dr["NombreCliente"]?.ToString()
                ?? string.Empty,
            NombreProducto = dr["NombreProducto"]?.ToString()
                ?? string.Empty,
            Cantidad = Convert.ToInt32(dr["Cantidad"])
        };
    }
    private static Cotizacion MapearCotizacionDetalle(SqlDataReader dr)
    {
        Cotizacion cotizacion = MapearCotizacionListado(dr);
        cotizacion.Documento = dr["Documento"] == DBNull.Value
                ? null : dr["Documento"].ToString();
        cotizacion.Telefono = dr["Telefono"] == DBNull.Value
                ? null : dr["Telefono"].ToString();
        cotizacion.Correo = dr["Correo"] == DBNull.Value
                ? null : dr["Correo"].ToString();
        cotizacion.Talla =  dr["Talla"] == DBNull.Value
                ? null : dr["Talla"].ToString();
        cotizacion.Color =  dr["Color"] == DBNull.Value
                ? null : dr["Color"].ToString();
        cotizacion.Material = dr["Material"] == DBNull.Value
                ? null : dr["Material"].ToString();
        cotizacion.TipoEstampado = dr["TipoEstampado"] == DBNull.Value
                ? null : dr["TipoEstampado"].ToString();
        cotizacion.TextoPersonalizado = dr["TextoPersonalizado"] == DBNull.Value
                ? null : dr["TextoPersonalizado"].ToString();
        return cotizacion;
    }
    public List<Cotizacion> ListarPorCliente(int clienteId)
    {
        var lista = new List<Cotizacion>();
        using SqlConnection cn = _conexionBD.CrearConexion();

        using SqlCommand cmd = new("dbo.sp_Cotizacion_ListarPorCliente",cn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;
        cn.Open();
        using SqlDataReader lector =cmd.ExecuteReader();
        while (lector.Read())
        {
            lista.Add(MapearCotizacionListado(lector));
        }
        return lista;
    }
}