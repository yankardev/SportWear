using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class CategoriaRepositorio : ICategoriaRepositorio
{
    private readonly ConexionBD _conexionBD;

    public CategoriaRepositorio(ConexionBD conexionBD) =>  _conexionBD = conexionBD;

    public List<Categoria> Listar(string? buscar = null)
    {
        var lista = new List<Categoria>();
        using SqlConnection cn = _conexionBD.CrearConexion();

        using SqlCommand cmd = new("dbo.sp_Categoria_Listar", cn);

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@Buscar", SqlDbType.NVarChar, 100)
            .Value = string.IsNullOrWhiteSpace(buscar)
                ? DBNull.Value : buscar.Trim();
        cn.Open();
        using SqlDataReader lector = cmd.ExecuteReader();
        while (lector.Read())
        {
            lista.Add(MapearCategoria(lector));
        }
        return lista;
    }

    public Categoria? ObtenerPorId(int id)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando =
            new("dbo.sp_Categoria_ObtenerPorId", conexion);

        comando.CommandType = CommandType.StoredProcedure;

        comando.Parameters.Add("@CategoriaId", SqlDbType.Int)
            .Value = id;

        conexion.Open();

        using SqlDataReader lector = comando.ExecuteReader();

        return lector.Read()
            ? MapearCategoria(lector)
            : null;
    }

    public void Insertar(Categoria categoria)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando =
            new("dbo.sp_Categoria_Insertar", conexion);

        comando.CommandType = CommandType.StoredProcedure;

        AgregarParametros(
            comando,
            categoria,
            incluirId: false,
            incluirEstado: false);

        conexion.Open();

        comando.ExecuteNonQuery();
    }

    public void Actualizar(Categoria categoria)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando =
            new("dbo.sp_Categoria_Actualizar", conexion);

        comando.CommandType = CommandType.StoredProcedure;

        AgregarParametros(
            comando,
            categoria,
            incluirId: true,
            incluirEstado: true);

        conexion.Open();

        comando.ExecuteNonQuery();
    }

    public void Eliminar(int id)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando =
            new("dbo.sp_Categoria_Eliminar", conexion);

        comando.CommandType = CommandType.StoredProcedure;

        comando.Parameters.Add("@CategoriaId", SqlDbType.Int)
            .Value = id;

        conexion.Open();

        comando.ExecuteNonQuery();
    }

    public List<Categoria> ListarPaginado(
        int pagina,
        int tamano,
        out int total)
    {
        var lista = new List<Categoria>();

        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando =
            new("dbo.sp_Categoria_ListarPaginado", conexion);

        comando.CommandType = CommandType.StoredProcedure;

        comando.Parameters.Add("@Pagina", SqlDbType.Int).Value = pagina;

        comando.Parameters.Add("@Tamano", SqlDbType.Int).Value = tamano;

        SqlParameter parametroTotal =
            comando.Parameters.Add("@Total", SqlDbType.Int);

        parametroTotal.Direction = ParameterDirection.Output;

        conexion.Open();

        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            lista.Add(MapearCategoria(lector));
        }

        lector.Close();

        total = parametroTotal.Value == DBNull.Value
            ? 0
            : Convert.ToInt32(parametroTotal.Value);

        return lista;
    }

    private static Categoria MapearCategoria(SqlDataReader lector)
    {
        return new Categoria
        {
            CategoriaId = Convert.ToInt32(lector["CategoriaId"]),

            Nombre = lector["Nombre"]?.ToString() ?? "",

            Descripcion = lector["Descripcion"] == DBNull.Value
                ? null
                : lector["Descripcion"].ToString(),

            Activo = Convert.ToBoolean(lector["Activo"]),

            FechaRegistro = Convert.ToDateTime(
                lector["FechaRegistro"])
        };
    }

    private static void AgregarParametros(
        SqlCommand comando,
        Categoria categoria,
        bool incluirId,
        bool incluirEstado = false)
    {
        if (incluirId)
        {
            comando.Parameters.Add("@CategoriaId",
                SqlDbType.Int).Value = categoria.CategoriaId;
        }

        comando.Parameters.Add("@Nombre",
            SqlDbType.NVarChar, 100).Value = categoria.Nombre.Trim();

        comando.Parameters.Add("@Descripcion",
            SqlDbType.NVarChar, 300).Value =
            string.IsNullOrWhiteSpace(categoria.Descripcion)
            ? DBNull.Value
            : categoria.Descripcion.Trim();

        if (incluirEstado)
        {
            comando.Parameters.Add("@Activo",
                SqlDbType.Bit).Value = categoria.Activo;
        }
    }

    public List<Categoria> ListarActivas()
    {
        var lista = new List<Categoria>();

        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Categoria_ListarActivas",
            conexion);

        comando.CommandType = CommandType.StoredProcedure;

        conexion.Open();

        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            lista.Add(MapearCategoria(lector));
        }

        return lista;
    }
}