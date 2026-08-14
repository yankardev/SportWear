using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class ClienteAccesoRepositorio : IClienteAccesoRepositorio
{
    private readonly ConexionBD _conexionBD;

    public ClienteAccesoRepositorio(ConexionBD conexionBD)
        => _conexionBD = conexionBD;

    public ClienteAcceso? ObtenerPorCorreo(string correo)
    {
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand cmd = new("dbo.sp_ClienteAcceso_ObtenerPorCorreo", cn);

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@Correo", SqlDbType.VarChar, 150).Value = correo.Trim();

        cn.Open();

        using SqlDataReader lector = cmd.ExecuteReader();

        if (!lector.Read())
            return null;

        return MapearClienteAcceso(lector);
    }

    public ClienteAcceso? ObtenerPorClienteId(int clienteId)
    {
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand cmd = new("dbo.sp_ClienteAcceso_ObtenerPorClienteId", cn);

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;

        cn.Open();

        using SqlDataReader lector = cmd.ExecuteReader();

        if (!lector.Read())
            return null;

        return MapearClienteAcceso(lector);
    }

    public void Insertar(ClienteAcceso acceso)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_ClienteAcceso_Insertar", conexion);

        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@ClienteId", SqlDbType.Int).Value = acceso.ClienteId;
        comando.Parameters.Add("@Correo", SqlDbType.VarChar, 150).Value = acceso.Correo.Trim();
        comando.Parameters.Add("@ClaveHash", SqlDbType.VarChar, 64).Value = acceso.ClaveHash;

        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public void CambiarClave(int clienteId, string claveHash)
    {
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand cmd = new("dbo.sp_ClienteAcceso_CambiarClave", cn);

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;
        cmd.Parameters.Add("@ClaveHash", SqlDbType.VarChar, 64).Value = claveHash;

        cn.Open();
        cmd.ExecuteNonQuery();
    }

    public void RestablecerClaveAdmin(
        int clienteId,
        string correo,
        string claveHash,
        bool activo)
    {
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand cmd = new("dbo.sp_ClienteAcceso_RestablecerClaveAdmin", cn);

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;
        cmd.Parameters.Add("@Correo", SqlDbType.VarChar, 150).Value = correo.Trim();
        cmd.Parameters.Add("@ClaveHash", SqlDbType.VarChar, 64).Value = claveHash;
        cmd.Parameters.Add("@Activo", SqlDbType.Bit).Value = activo;

        cn.Open();
        cmd.ExecuteNonQuery();
    }

    private static ClienteAcceso MapearClienteAcceso(SqlDataReader dr)
    {
        return new ClienteAcceso
        {
            ClienteAccesoId = Convert.ToInt32(dr["ClienteAccesoId"]),
            ClienteId = Convert.ToInt32(dr["ClienteId"]),
            Correo = dr["Correo"]?.ToString() ?? string.Empty,
            ClaveHash = dr["ClaveHash"]?.ToString() ?? string.Empty,
            Activo = Convert.ToBoolean(dr["Activo"]),
            FechaRegistro = Convert.ToDateTime(dr["FechaRegistro"]),
            Nombres = dr["Nombres"]?.ToString() ?? string.Empty,
            Apellidos = dr["Apellidos"]?.ToString() ?? string.Empty
        };
    }
}
