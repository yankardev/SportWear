using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class ProductoRepositorio : IProductoRepositorio
{
    private readonly ConexionBD _conexionBD;
    public ProductoRepositorio(ConexionBD conexionBD) => _conexionBD = conexionBD;
    public List<Producto> Listar(string? buscar = null)
    {
        var productos = new List<Producto>();
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new( "dbo.sp_Producto_Listar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@Buscar", SqlDbType.NVarChar,120).Value = string.IsNullOrWhiteSpace(buscar)
            ? DBNull.Value : buscar.Trim();
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        while (lector.Read())
        {
            productos.Add(MapearProducto(lector));
        }
        return productos;
    }

    public Producto? ObtenerPorId(int id)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new( "dbo.sp_Producto_ObtenerPorId", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add( "@ProductoId", SqlDbType.Int).Value = id;
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        return lector.Read()? MapearProducto(lector): null;
    }
    public void Insertar(Producto producto)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new("dbo.sp_Producto_Insertar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        AgregarParametros(
            comando,
            producto,
            incluirId: false,
            incluirEstado: false
        );

        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public void Actualizar(Producto producto)
    {
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand comando = new( "dbo.sp_Producto_Actualizar", cn);
        comando.CommandType = CommandType.StoredProcedure;
        AgregarParametros(
            comando,
            producto,
            incluirId: true,
            incluirEstado: true
        );
        cn.Open();
        comando.ExecuteNonQuery();
    }

    public void Eliminar(int id)
    {
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand cmd = new("dbo.sp_Producto_Eliminar", cn );
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@ProductoId",SqlDbType.Int).Value = id;
        cn.Open();
        cmd.ExecuteNonQuery();
    }

    public List<Producto> ListarPaginado( int pagina, int tamano, out int total)
    {
        var productos = new List<Producto>();
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new( "dbo.sp_Producto_ListarPaginado", conexion );
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
            productos.Add(MapearProducto(lector));
        }

        lector.Close();

        total = parametroTotal.Value == DBNull.Value
            ? 0
            : Convert.ToInt32(parametroTotal.Value);

        return productos;
    }

    public List<Producto> ListarPersonalizables()
    {
        var productos = new List<Producto>();

        using SqlConnection conexion = _conexionBD.CrearConexion();

        using SqlCommand comando = new(
            "dbo.sp_Producto_ListarPersonalizables",
            conexion);

        comando.CommandType = CommandType.StoredProcedure;

        conexion.Open();

        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            productos.Add(MapearProducto(lector));
        }

        return productos;
    }
    private static Producto MapearProducto(SqlDataReader lector)
    {
        return new Producto
        {
            ProductoId = Convert.ToInt32(lector["ProductoId"]),

            CategoriaId = Convert.ToInt32(lector["CategoriaId"]),

            NombreCategoria = lector["NombreCategoria"]?.ToString() ?? "",

            Nombre = lector["Nombre"]?.ToString() ?? "",

            Descripcion = lector["Descripcion"] == DBNull.Value
                ? null
                : lector["Descripcion"].ToString(),

            PrecioBase = Convert.ToDecimal(lector["PrecioBase"]),

            ImagenUrl = lector["ImagenUrl"] == DBNull.Value
                ? null
                : lector["ImagenUrl"].ToString(),

            Personalizable = Convert.ToBoolean(lector["Personalizable"]),

            Stock = Convert.ToInt32(lector["Stock"]),

            Activo = Convert.ToBoolean(lector["Activo"]),

            FechaRegistro = Convert.ToDateTime(lector["FechaRegistro"])
        };
    }

    private static void AgregarParametros(SqlCommand cmd, Producto producto,bool incluirId,bool incluirEstado = false)
    {
        if (incluirId)
        {
            cmd.Parameters.Add("@ProductoId",SqlDbType.Int).Value = producto.ProductoId;
        }

        cmd.Parameters.Add("@CategoriaId", SqlDbType.Int).Value = producto.CategoriaId;
        cmd.Parameters.Add(
            "@Nombre",
            SqlDbType.NVarChar,
            120
        ).Value = producto.Nombre.Trim();

        cmd.Parameters.Add(
            "@Descripcion",
            SqlDbType.NVarChar,
            500
        ).Value = string.IsNullOrWhiteSpace(producto.Descripcion)
            ? DBNull.Value
            : producto.Descripcion.Trim();

        SqlParameter precio = cmd.Parameters.Add(
            "@PrecioBase",
            SqlDbType.Decimal
        );

        precio.Precision = 10;
        precio.Scale = 2;
        precio.Value = producto.PrecioBase;

        cmd.Parameters.Add(
            "@ImagenUrl",
            SqlDbType.NVarChar,
            500
        ).Value = string.IsNullOrWhiteSpace(producto.ImagenUrl)
            ? DBNull.Value
            : producto.ImagenUrl.Trim();

        cmd.Parameters.Add(
            "@Personalizable",
            SqlDbType.Bit
        ).Value = producto.Personalizable;

        cmd.Parameters.Add(
            "@Stock",
            SqlDbType.Int
        ).Value = producto.Stock;

        // SOLO algunos procedimientos reciben @Activo
        if (incluirEstado)
        {
            cmd.Parameters.Add(
                "@Activo",
                SqlDbType.Bit
            ).Value = producto.Activo;
        }
    }
}