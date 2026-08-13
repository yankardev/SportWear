USE [SportWearDB];
GO

/*
   OPCIONAL - LIMPIEZA DE PRUEBAS ANTIGUAS

   El proyecto actual NO utiliza dbo.Usuario para clientes.
   Los clientes usan dbo.Cliente + dbo.ClienteAcceso.

   Este script elimina únicamente usuarios con rol CLIENTE que no tengan
   cotizaciones ni pedidos relacionados. Puede usarse para limpiar registros
   de prueba creados antes de separar el portal cliente.
*/

DELETE U
FROM dbo.Usuario AS U
INNER JOIN dbo.Rol AS R
    ON U.RolId = R.RolId
WHERE R.Nombre = N'CLIENTE'
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.Cotizacion AS C
      WHERE C.UsuarioId = U.UsuarioId
  )
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.Pedido AS P
      WHERE P.UsuarioId = U.UsuarioId
  );
GO

SELECT
    U.UsuarioId,
    U.Nombres,
    U.Apellidos,
    U.Correo,
    R.Nombre AS Rol,
    U.Activo
FROM dbo.Usuario AS U
INNER JOIN dbo.Rol AS R
    ON U.RolId = R.RolId
ORDER BY U.UsuarioId;
GO
