using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class UsuarioRepositorio : IUsuarioRepositorio
{
    private readonly ConexionBD _conexionBD;

    public UsuarioRepositorio(ConexionBD conexionBD)
    {
        _conexionBD = conexionBD;
    }

    public Usuario? ObtenerPorCorreo(string correo)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Usuario_ObtenerPorCorreo", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@Correo", SqlDbType.VarChar, 150).Value = correo.Trim();
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        return lector.Read() ? MapearUsuario(lector) : null;
    }

    public List<Usuario> Listar(string? buscar = null)
    {
        var lista = new List<Usuario>();
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Usuario_Listar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@Buscar", SqlDbType.NVarChar, 150).Value =
            string.IsNullOrWhiteSpace(buscar) ? DBNull.Value : buscar.Trim();
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        while (lector.Read()) lista.Add(MapearUsuario(lector));
        return lista;
    }

    public List<Rol> ListarRolesActivos()
    {
        var lista = new List<Rol>();
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Rol_ListarActivos", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        while (lector.Read())
        {
            lista.Add(new Rol
            {
                RolId = Convert.ToInt32(lector["RolId"]),
                Nombre = lector["Nombre"]?.ToString() ?? string.Empty,
                Descripcion = lector["Descripcion"] == DBNull.Value ? null : lector["Descripcion"].ToString(),
                Activo = Convert.ToBoolean(lector["Activo"])
            });
        }
        return lista;
    }

    public Usuario? ObtenerPorId(int id)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Usuario_ObtenerPorId", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = id;
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        return lector.Read() ? MapearUsuario(lector) : null;
    }

    public void Insertar(Usuario usuario)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Usuario_Insertar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        AgregarParametros(comando, usuario, incluirId: false, incluirEstado: false);
        comando.Parameters.Add("@ClaveHash", SqlDbType.VarChar, 64).Value = usuario.ClaveHash;
        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public void Actualizar(Usuario usuario)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Usuario_Actualizar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        AgregarParametros(comando, usuario, incluirId: true, incluirEstado: true);
        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public void Eliminar(int id)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Usuario_Eliminar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = id;
        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public void CambiarClave(int id, string claveHash)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Usuario_CambiarClave", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = id;
        comando.Parameters.Add("@ClaveHash", SqlDbType.VarChar, 64).Value = claveHash;
        conexion.Open();
        comando.ExecuteNonQuery();
    }

    private static Usuario MapearUsuario(SqlDataReader lector)
    {
        return new Usuario
        {
            UsuarioId = Convert.ToInt32(lector["UsuarioId"]),
            RolId = Convert.ToInt32(lector["RolId"]),
            NombreRol = lector["NombreRol"]?.ToString() ?? string.Empty,
            Nombres = lector["Nombres"]?.ToString() ?? string.Empty,
            Apellidos = lector["Apellidos"]?.ToString() ?? string.Empty,
            Correo = lector["Correo"]?.ToString() ?? string.Empty,
            ClaveHash = lector["ClaveHash"] == DBNull.Value ? string.Empty : lector["ClaveHash"]?.ToString() ?? string.Empty,
            Telefono = lector["Telefono"] == DBNull.Value ? null : lector["Telefono"].ToString(),
            Activo = Convert.ToBoolean(lector["Activo"]),
            FechaRegistro = lector["FechaRegistro"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(lector["FechaRegistro"])
        };
    }

    private static void AgregarParametros(SqlCommand comando, Usuario usuario, bool incluirId, bool incluirEstado)
    {
        if (incluirId) comando.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = usuario.UsuarioId;
        comando.Parameters.Add("@RolId", SqlDbType.Int).Value = usuario.RolId;
        comando.Parameters.Add("@Nombres", SqlDbType.NVarChar, 100).Value = usuario.Nombres.Trim();
        comando.Parameters.Add("@Apellidos", SqlDbType.NVarChar, 100).Value = usuario.Apellidos.Trim();
        comando.Parameters.Add("@Correo", SqlDbType.VarChar, 150).Value = usuario.Correo.Trim();
        comando.Parameters.Add("@Telefono", SqlDbType.NVarChar, 20).Value = string.IsNullOrWhiteSpace(usuario.Telefono) ? DBNull.Value : usuario.Telefono.Trim();
        if (incluirEstado) comando.Parameters.Add("@Activo", SqlDbType.Bit).Value = usuario.Activo;
    }
}
