using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class ClienteRepositorio : IClienteRepositorio
{
    private readonly ConexionBD _conexionBD;

    public ClienteRepositorio(ConexionBD conexionBD)
    {
        _conexionBD = conexionBD;
    }

    public List<Cliente> Listar(string? buscar = null)
    {
        var lista = new List<Cliente>();

        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Cliente_Listar",
            conexion
        );

        comando.CommandType = CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@Buscar",
            SqlDbType.NVarChar,
            100
        ).Value = string.IsNullOrWhiteSpace(buscar)
            ? DBNull.Value
            : buscar.Trim();

        conexion.Open();

        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            lista.Add(MapearCliente(lector));
        }

        return lista;
    }

    public List<Cliente> ListarActivos()
    {
        var lista = new List<Cliente>();

        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Cliente_ListarActivos",
            conexion
        );

        comando.CommandType = CommandType.StoredProcedure;

        conexion.Open();

        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            lista.Add(MapearCliente(lector));
        }

        return lista;
    }

    public Cliente? ObtenerPorId(int id)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Cliente_ObtenerPorId",
            conexion
        );

        comando.CommandType = CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@ClienteId",
            SqlDbType.Int
        ).Value = id;

        conexion.Open();

        using SqlDataReader lector = comando.ExecuteReader();

        return lector.Read()
            ? MapearCliente(lector)
            : null;
    }

    public Cliente? ObtenerPorDocumento(string documento)
    {
        using SqlConnection cn = _conexionBD.CrearConexion(); 
        using SqlCommand cmd = new( "dbo.sp_Cliente_ObtenerPorDocumento", cn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add( "@Documento",SqlDbType.NVarChar,15).Value = documento.Trim();
        cn.Open();
        using SqlDataReader lector = cmd.ExecuteReader();
        return lector.Read() ? MapearCliente(lector) : null;
    }

    public int Insertar(Cliente cliente)
    {
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand cmd = new( "dbo.sp_Cliente_Insertar",cn);
        cmd.CommandType = CommandType.StoredProcedure;
        AgregarParametros(
            cmd,        
            cliente,
            incluirId: false,
            incluirEstado: false
        );
        cn.Open();
        object? resultado =cmd.ExecuteScalar();
        return resultado == null || resultado == DBNull.Value
                ? 0 : Convert.ToInt32(resultado);
    }

    public void Actualizar(Cliente cliente)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Cliente_Actualizar",
            conexion
        );

        comando.CommandType = CommandType.StoredProcedure;

        AgregarParametros(
            comando,
            cliente,
            incluirId: true,
            incluirEstado: true
        );

        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public void Eliminar(int id)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Cliente_Eliminar",
            conexion
        );

        comando.CommandType = CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@ClienteId",
            SqlDbType.Int
        ).Value = id;

        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public List<Cliente> ListarPaginado(
        int pagina,
        int tamano,
        out int total)
    {
        var lista = new List<Cliente>();

        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Cliente_ListarPaginado",
            conexion
        );

        comando.CommandType = CommandType.StoredProcedure;

        comando.Parameters.Add(
            "@Pagina",
            SqlDbType.Int
        ).Value = pagina;

        comando.Parameters.Add(
            "@Tamano",
            SqlDbType.Int
        ).Value = tamano;

        SqlParameter parametroTotal = comando.Parameters.Add(
            "@Total",
            SqlDbType.Int
        );

        parametroTotal.Direction = ParameterDirection.Output;

        conexion.Open();

        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            lista.Add(MapearCliente(lector));
        }

        lector.Close();

        total = parametroTotal.Value == DBNull.Value
            ? 0
            : Convert.ToInt32(parametroTotal.Value);

        return lista;
    }

    private static Cliente MapearCliente(SqlDataReader lector)
    {
        return new Cliente
        {
            ClienteId = Convert.ToInt32(lector["ClienteId"]),

            Nombres = lector["Nombres"]?.ToString()
                ?? string.Empty,

            Apellidos = lector["Apellidos"]?.ToString()
                ?? string.Empty,

            Documento = lector["Documento"]?.ToString()
                ?? string.Empty,

            Telefono = lector["Telefono"] == DBNull.Value
                ? null
                : lector["Telefono"].ToString(),

            Correo = lector["Correo"] == DBNull.Value
                ? null
                : lector["Correo"].ToString(),

            Direccion = lector["Direccion"] == DBNull.Value
                ? null
                : lector["Direccion"].ToString(),

            Activo = Convert.ToBoolean(lector["Activo"]),

            FechaRegistro = Convert.ToDateTime(
                lector["FechaRegistro"]
            )
        };
    }

    private static void AgregarParametros(
        SqlCommand comando,
        Cliente cliente,
        bool incluirId,
        bool incluirEstado)
    {
        if (incluirId)
        {
            comando.Parameters.Add(
                "@ClienteId",
                SqlDbType.Int
            ).Value = cliente.ClienteId;
        }

        comando.Parameters.Add(
            "@Nombres",
            SqlDbType.NVarChar,
            100
        ).Value = cliente.Nombres.Trim();

        comando.Parameters.Add(
            "@Apellidos",
            SqlDbType.NVarChar,
            100
        ).Value = cliente.Apellidos.Trim();

        comando.Parameters.Add(
            "@Documento",
            SqlDbType.NVarChar,
            15
        ).Value = cliente.Documento.Trim();

        comando.Parameters.Add(
            "@Telefono",
            SqlDbType.NVarChar,
            20
        ).Value = string.IsNullOrWhiteSpace(cliente.Telefono)
            ? DBNull.Value
            : cliente.Telefono.Trim();

        comando.Parameters.Add(
            "@Correo",
            SqlDbType.NVarChar,
            120
        ).Value = string.IsNullOrWhiteSpace(cliente.Correo)
            ? DBNull.Value
            : cliente.Correo.Trim();

        comando.Parameters.Add(
            "@Direccion",
            SqlDbType.NVarChar,
            200
        ).Value = string.IsNullOrWhiteSpace(cliente.Direccion)
            ? DBNull.Value
            : cliente.Direccion.Trim();

        if (incluirEstado)
        {
            comando.Parameters.Add(
                "@Activo",
                SqlDbType.Bit
            ).Value = cliente.Activo;
        }
    }
}