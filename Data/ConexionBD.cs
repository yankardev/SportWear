using Microsoft.Data.SqlClient;

namespace SportWear.Web.Data;

public class ConexionBD
{
    private readonly string _cadenaConexion;

    public ConexionBD(IConfiguration configuration)
    {
        _cadenaConexion = configuration.GetConnectionString("SportWearDB")
            ?? throw new InvalidOperationException(
                "No se encontró la cadena de conexión SportWearDB.");
    }

    public SqlConnection CrearConexion()
    {
        return new SqlConnection(_cadenaConexion);
    }
}