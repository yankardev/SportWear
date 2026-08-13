using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class FavoritoRepositorio : IFavoritoRepositorio
{
    private readonly ConexionBD _conexionBD;

    public FavoritoRepositorio(ConexionBD conexionBD)
    {
        _conexionBD = conexionBD;
    }

    public List<Producto> ListarPorCliente(int clienteId)
    {
        var productos = new List<Producto>();

        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Favorito_ListarPorCliente", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;

        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();

        while (lector.Read())
        {
            productos.Add(new Producto
            {
                ProductoId = Convert.ToInt32(lector["ProductoId"]),
                CategoriaId = Convert.ToInt32(lector["CategoriaId"]),
                NombreCategoria = lector["NombreCategoria"]?.ToString() ?? string.Empty,
                Nombre = lector["Nombre"]?.ToString() ?? string.Empty,
                Descripcion = lector["Descripcion"] == DBNull.Value ? null : lector["Descripcion"].ToString(),
                PrecioBase = Convert.ToDecimal(lector["PrecioBase"]),
                ImagenUrl = lector["ImagenUrl"] == DBNull.Value ? null : lector["ImagenUrl"].ToString(),
                Personalizable = Convert.ToBoolean(lector["Personalizable"]),
                Stock = Convert.ToInt32(lector["Stock"]),
                Activo = Convert.ToBoolean(lector["Activo"]),
                FechaRegistro = Convert.ToDateTime(lector["FechaRegistro"])
            });
        }

        return productos;
    }

    public void Agregar(int clienteId, int productoId)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Favorito_Agregar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;
        comando.Parameters.Add("@ProductoId", SqlDbType.Int).Value = productoId;

        conexion.Open();
        comando.ExecuteNonQuery();
    }

    public void Eliminar(int clienteId, int productoId)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Favorito_Eliminar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@ClienteId", SqlDbType.Int).Value = clienteId;
        comando.Parameters.Add("@ProductoId", SqlDbType.Int).Value = productoId;

        conexion.Open();
        comando.ExecuteNonQuery();
    }
}
