using System.Data;
using Microsoft.Data.SqlClient;
using SportWear.Web.Data.Interfaces;
using SportWear.Web.Models;

namespace SportWear.Web.Data.Repositorios;

public class PedidoRepositorio : IPedidoRepositorio
{
    private readonly ConexionBD _conexionBD;
    public PedidoRepositorio(ConexionBD conexionBD) => _conexionBD = conexionBD;
    public List<Pedido> Listar(string? buscar = null)
    {
        var pedidos = new List<Pedido>();
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Pedido_Listar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@Buscar", SqlDbType.NVarChar, 120).Value =
            string.IsNullOrWhiteSpace(buscar) ? DBNull.Value : buscar.Trim();
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        while (lector.Read())
        {
            pedidos.Add(MapearListado(lector));
        }
        return pedidos;
    }

    public Pedido? ObtenerPorId(int id)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Pedido_ObtenerPorId", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@PedidoId", SqlDbType.Int).Value = id;
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        return lector.Read() ? MapearDetalle(lector) : null;
    }

    public List<EstadoPedido> ListarEstados()
    {
        var estados = new List<EstadoPedido>();
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_EstadoPedido_Listar", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        while (lector.Read())
        {
            estados.Add(new EstadoPedido
            {
                EstadoPedidoId = Convert.ToInt32(lector["EstadoPedidoId"]),
                Nombre = lector["Nombre"]?.ToString() ?? string.Empty,
                Orden = Convert.ToInt32(lector["Orden"]),
                Activo = Convert.ToBoolean(lector["Activo"])
            });
        }
        return estados;
    }

    public void Generar(Pedido pedido)
    {
        using SqlConnection cn = _conexionBD.CrearConexion();
        using SqlCommand cmd = new("dbo.sp_Pedido_Generar", cn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add("@CotizacionId", SqlDbType.Int).Value = pedido.CotizacionId;
        cmd.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = pedido.UsuarioId;
        cmd.Parameters.Add("@FechaEntregaEstimada", SqlDbType.Date).Value =
            (object?)pedido.FechaEntregaEstimada?.Date ?? DBNull.Value;
        cmd.Parameters.Add("@Destinatario", SqlDbType.NVarChar, 150).Value =
            string.IsNullOrWhiteSpace(pedido.Destinatario) ? DBNull.Value : pedido.Destinatario.Trim();
        cmd.Parameters.Add("@TelefonoEntrega", SqlDbType.NVarChar, 20).Value =
            string.IsNullOrWhiteSpace(pedido.TelefonoEntrega) ? DBNull.Value : pedido.TelefonoEntrega.Trim();
        cmd.Parameters.Add("@DireccionEntrega", SqlDbType.NVarChar, 250).Value =
            string.IsNullOrWhiteSpace(pedido.DireccionEntrega) ? DBNull.Value : pedido.DireccionEntrega.Trim();
        cmd.Parameters.Add("@DistritoEntrega", SqlDbType.NVarChar, 100).Value =
            string.IsNullOrWhiteSpace(pedido.DistritoEntrega) ? DBNull.Value : pedido.DistritoEntrega.Trim();
        cmd.Parameters.Add("@ReferenciaEntrega", SqlDbType.NVarChar, 250).Value =
            string.IsNullOrWhiteSpace(pedido.ReferenciaEntrega) ? DBNull.Value : pedido.ReferenciaEntrega.Trim();
        cmd.Parameters.Add("@Observaciones", SqlDbType.NVarChar, 1000).Value =
            string.IsNullOrWhiteSpace(pedido.Observaciones) ? DBNull.Value : pedido.Observaciones.Trim();
        cn.Open();
        cmd.ExecuteNonQuery();
    }

    public List<Pedido> ListarPorCliente(
    int clienteId)
    {
        var lista = new List<Pedido>();
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Pedido_ListarPorCliente", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@ClienteId",SqlDbType.Int).Value = clienteId;
        conexion.Open();
        using SqlDataReader lector = comando.ExecuteReader();
        while (lector.Read())
        {
            lista.Add(MapearListado(lector));
        }
        return lista;
    }
    public void ActualizarEstado(int pedidoId, int estadoPedidoId)
    {
        using SqlConnection conexion = _conexionBD.CrearConexion();
        using SqlCommand comando = new("dbo.sp_Pedido_ActualizarEstado", conexion);
        comando.CommandType = CommandType.StoredProcedure;
        comando.Parameters.Add("@PedidoId", SqlDbType.Int).Value = pedidoId;
        comando.Parameters.Add("@EstadoPedidoId", SqlDbType.Int).Value = estadoPedidoId;
        conexion.Open();
        comando.ExecuteNonQuery();
    }

    private static Pedido MapearListado(SqlDataReader lector)
    {
        return new Pedido
        {
            PedidoId = Convert.ToInt32(lector["PedidoId"]),
            UsuarioId = Convert.ToInt32(lector["UsuarioId"]),
            CotizacionId = Convert.ToInt32(lector["CotizacionId"]),
            EstadoPedidoId = Convert.ToInt32(lector["EstadoPedidoId"]),
            Codigo = lector["Codigo"]?.ToString() ?? string.Empty,
            FechaPedido = Convert.ToDateTime(lector["FechaPedido"]),
            FechaEntregaEstimada = lector["FechaEntregaEstimada"] == DBNull.Value
                ? null : Convert.ToDateTime(lector["FechaEntregaEstimada"]),
            Destinatario = lector["Destinatario"] == DBNull.Value ? null : lector["Destinatario"].ToString(),
            TelefonoEntrega = lector["TelefonoEntrega"] == DBNull.Value ? null : lector["TelefonoEntrega"].ToString(),
            DireccionEntrega = lector["DireccionEntrega"] == DBNull.Value ? null : lector["DireccionEntrega"].ToString(),
            DistritoEntrega = lector["DistritoEntrega"] == DBNull.Value ? null : lector["DistritoEntrega"].ToString(),
            ReferenciaEntrega = lector["ReferenciaEntrega"] == DBNull.Value ? null : lector["ReferenciaEntrega"].ToString(),
            Subtotal = Convert.ToDecimal(lector["Subtotal"]),
            Igv = Convert.ToDecimal(lector["Igv"]),
            Total = Convert.ToDecimal(lector["Total"]),
            Observaciones = lector["Observaciones"] == DBNull.Value ? null : lector["Observaciones"].ToString(),
            Estado = lector["Estado"]?.ToString() ?? string.Empty,
            NombreEstado = lector["NombreEstado"]?.ToString() ?? string.Empty,
            CodigoCotizacion = lector["CodigoCotizacion"]?.ToString() ?? string.Empty,
            NombreCliente = lector["NombreCliente"]?.ToString() ?? string.Empty,
            NombreProducto = lector["NombreProducto"]?.ToString() ?? string.Empty,
            Cantidad = Convert.ToInt32(lector["Cantidad"])
        };
    }

    private static Pedido MapearDetalle(SqlDataReader lector)
    {
        Pedido pedido = MapearListado(lector);
        pedido.Documento = lector["Documento"] == DBNull.Value ? null : lector["Documento"].ToString();
        pedido.TelefonoCliente = lector["TelefonoCliente"] == DBNull.Value ? null : lector["TelefonoCliente"].ToString();
        pedido.Correo = lector["Correo"] == DBNull.Value ? null : lector["Correo"].ToString();
        pedido.Talla = lector["Talla"] == DBNull.Value ? null : lector["Talla"].ToString();
        pedido.Color = lector["Color"] == DBNull.Value ? null : lector["Color"].ToString();
        pedido.Material = lector["Material"] == DBNull.Value ? null : lector["Material"].ToString();
        pedido.TipoEstampado = lector["TipoEstampado"] == DBNull.Value ? null : lector["TipoEstampado"].ToString();
        return pedido;
    }
}
