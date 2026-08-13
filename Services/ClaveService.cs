using System.Security.Cryptography;
using System.Text;

namespace SportWear.Web.Services;

public static class ClaveService
{
    public static string GenerarHash(string clave)
    {
        byte[] datos = Encoding.UTF8.GetBytes(clave);
        byte[] hash = SHA256.HashData(datos);

        return Convert.ToHexString(hash);
    }

    public static bool Verificar(string claveIngresada, string hashGuardado)
    {
        string hashIngresado = GenerarHash(claveIngresada);

        return string.Equals(hashIngresado,hashGuardado,StringComparison.OrdinalIgnoreCase
        );
    }
}