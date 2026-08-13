using Microsoft.AspNetCore.Http;
using System.Text.Json;

namespace SportWear.Web.Extensions;

public static class SessionExtensions
{
    private static readonly JsonSerializerOptions Opciones = new(JsonSerializerDefaults.Web);

    public static void SetObject<T>(this ISession session, string key, T value)
    {
        session.SetString(key, JsonSerializer.Serialize(value, Opciones));
    }

    public static T? GetObject<T>(this ISession session, string key)
    {
        string? json = session.GetString(key);
        return string.IsNullOrWhiteSpace(json)
            ? default
            : JsonSerializer.Deserialize<T>(json, Opciones);
    }
}
