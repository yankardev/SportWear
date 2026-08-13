using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class SolicitudConfeccionRepositorio
    : ISolicitudConfeccionRepositorio
{
    private readonly ConexionBD _conexionBD;

    public SolicitudConfeccionRepositorio(
        ConexionBD conexionBD)
    {
        _conexionBD = conexionBD;
    }

    public List<SolicitudConfeccion> Listar(
        string? buscar = null)
    {
        var lista = new List<SolicitudConfeccion>();

        using SqlConnection conexion =
            _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_SolicitudConfeccion_Listar",
            conexion);

        comando.CommandType =
            CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@Buscar",
            SqlDbType.NVarChar,
            120
        ).Value = string.IsNullOrWhiteSpace(buscar)
            ? DBNull.Value
            : buscar.Trim();

        conexion.Open();

        using SqlDataReader lector =
            comando.ExecuteReader();

        while (lector.Read())
        {
            lista.Add(MapearSolicitud(lector));
        }

        return lista;
    }

    public SolicitudConfeccion? ObtenerPorId(int id)
    {
        using SqlConnection conexion =
            _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_SolicitudConfeccion_ObtenerPorId",
            conexion);

        comando.CommandType =
            CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@SolicitudId",
            SqlDbType.Int
        ).Value = id;

        conexion.Open();

        using SqlDataReader lector =
            comando.ExecuteReader();

        return lector.Read()
            ? MapearSolicitud(lector)
            : null;
    }

    public void Insertar(
        SolicitudConfeccion solicitud)
    {
        using SqlConnection conexion =
            _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_SolicitudConfeccion_Insertar",
            conexion);

        comando.CommandType =
            CommandType.StoredProcedure;

        AgregarParametros(comando, solicitud);

        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public void ActualizarEstado(
        int id,
        string estado)
    {
        using SqlConnection conexion =
            _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_SolicitudConfeccion_ActualizarEstado",
            conexion);

        comando.CommandType =
            CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@SolicitudId",
            SqlDbType.Int
        ).Value = id;

        comando.Parameters.Add(
            "@Estado",
            SqlDbType.NVarChar,
            20
        ).Value = estado;

        conexion.Open();
        comando.ExecuteNonQuery();
    }

    private static SolicitudConfeccion MapearSolicitud(SqlDataReader lector)
    {
        return new SolicitudConfeccion
        {
            SolicitudId =
                Convert.ToInt32(lector["SolicitudId"]),

            ClienteId =
                Convert.ToInt32(lector["ClienteId"]),

            NombreCliente =
                lector["NombreCliente"]?.ToString()
                ?? string.Empty,

            ProductoId =
                Convert.ToInt32(lector["ProductoId"]),

            NombreProducto =
                lector["NombreProducto"]?.ToString()
                ?? string.Empty,

            Cantidad =
                Convert.ToInt32(lector["Cantidad"]),

            Talla =
                lector["Talla"]?.ToString()
                ?? string.Empty,

            Color =
                lector["Color"]?.ToString()
                ?? string.Empty,

            Material =
                lector["Material"]?.ToString()
                ?? string.Empty,

            TipoEstampado =
                lector["TipoEstampado"] == DBNull.Value
                    ? null
                    : lector["TipoEstampado"].ToString(),

            TextoPersonalizado =
                lector["TextoPersonalizado"] == DBNull.Value
                    ? null
                    : lector["TextoPersonalizado"].ToString(),

            ArchivoDisenoUrl =
                lector["ArchivoDisenoUrl"] == DBNull.Value
                    ? null
                    : lector["ArchivoDisenoUrl"].ToString(),

            Observaciones =
                lector["Observaciones"] == DBNull.Value
                    ? null
                    : lector["Observaciones"].ToString(),

            Estado =
                lector["Estado"]?.ToString()
                ?? string.Empty,

            FechaRegistro =
                Convert.ToDateTime(
                    lector["FechaRegistro"])
        };
    }

    public List<SolicitudConfeccion> ListarPorCliente(
    int clienteId)
    {
        var lista = new List<SolicitudConfeccion>();

        using SqlConnection conexion =
            _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_SolicitudConfeccion_ListarPorCliente",
            conexion
        );

        comando.CommandType =
            CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@ClienteId",
            SqlDbType.Int
        ).Value = clienteId;

        conexion.Open();

        using SqlDataReader lector =
            comando.ExecuteReader();

        while (lector.Read())
        {
            lista.Add(MapearSolicitud(lector));
        }

        return lista;
    }

    private static void AgregarParametros(
        SqlCommand comando,
        SolicitudConfeccion solicitud)
    {
        comando.Parameters.Add(
            "@ClienteId",
            SqlDbType.Int
        ).Value = solicitud.ClienteId;

        comando.Parameters.Add(
            "@ProductoId",
            SqlDbType.Int
        ).Value = solicitud.ProductoId;

        comando.Parameters.Add(
            "@Cantidad",
            SqlDbType.Int
        ).Value = solicitud.Cantidad;

        comando.Parameters.Add(
            "@Talla",
            SqlDbType.NVarChar,
            20
        ).Value = solicitud.Talla.Trim();

        comando.Parameters.Add(
            "@Color",
            SqlDbType.NVarChar,
            50
        ).Value = solicitud.Color.Trim();

        comando.Parameters.Add(
            "@Material",
            SqlDbType.NVarChar,
            100
        ).Value = solicitud.Material.Trim();

        comando.Parameters.Add(
            "@TipoEstampado",
            SqlDbType.NVarChar,
            100
        ).Value =
            string.IsNullOrWhiteSpace(
                solicitud.TipoEstampado)
                ? DBNull.Value
                : solicitud.TipoEstampado.Trim();

        comando.Parameters.Add(
            "@TextoPersonalizado",
            SqlDbType.NVarChar,
            150
        ).Value =
            string.IsNullOrWhiteSpace(
                solicitud.TextoPersonalizado)
                ? DBNull.Value
                : solicitud.TextoPersonalizado.Trim();

        comando.Parameters.Add(
            "@ArchivoDisenoUrl",
            SqlDbType.NVarChar,
            500
        ).Value =
            string.IsNullOrWhiteSpace(
                solicitud.ArchivoDisenoUrl)
                ? DBNull.Value
                : solicitud.ArchivoDisenoUrl.Trim();

        comando.Parameters.Add(
            "@Observaciones",
            SqlDbType.NVarChar,
            500
        ).Value =
            string.IsNullOrWhiteSpace(
                solicitud.Observaciones)
                ? DBNull.Value
                : solicitud.Observaciones.Trim();
    }
}