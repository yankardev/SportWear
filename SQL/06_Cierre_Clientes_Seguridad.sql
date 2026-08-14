USE [SportWearDB];
GO

/*
    SPORTWEAR - CIERRE FINAL CLIENTES Y SEGURIDAD
    - Sincroniza el estado de Cliente con ClienteAcceso.
    - Mantiene el cambio/restablecimiento de contraseña mediante SP.
    - No elimina datos ni modifica pedidos, ventas o solicitudes.
*/

CREATE OR ALTER PROCEDURE dbo.sp_Cliente_Actualizar
    @ClienteId INT,
    @Nombres NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Documento NVARCHAR(15),
    @Telefono NVARCHAR(20) = NULL,
    @Correo NVARCHAR(120) = NULL,
    @Direccion NVARCHAR(200) = NULL,
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    UPDATE dbo.Cliente
    SET Nombres = @Nombres,
        Apellidos = @Apellidos,
        Documento = @Documento,
        Telefono = @Telefono,
        Correo = @Correo,
        Direccion = @Direccion,
        Activo = @Activo
    WHERE ClienteId = @ClienteId;

    UPDATE dbo.ClienteAcceso
    SET Activo = @Activo
    WHERE ClienteId = @ClienteId;

    COMMIT TRANSACTION;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Cliente_Eliminar
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    UPDATE dbo.Cliente
    SET Activo = 0
    WHERE ClienteId = @ClienteId;

    UPDATE dbo.ClienteAcceso
    SET Activo = 0
    WHERE ClienteId = @ClienteId;

    COMMIT TRANSACTION;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ClienteAcceso_ObtenerPorClienteId
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CA.ClienteAccesoId,
        CA.ClienteId,
        CA.Correo,
        CA.ClaveHash,
        CA.Activo,
        CA.FechaRegistro,
        C.Nombres,
        C.Apellidos
    FROM dbo.ClienteAcceso CA
    INNER JOIN dbo.Cliente C
        ON C.ClienteId = CA.ClienteId
    WHERE CA.ClienteId = @ClienteId;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ClienteAcceso_CambiarClave
    @ClienteId INT,
    @ClaveHash VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.ClienteAcceso
        WHERE ClienteId = @ClienteId
          AND Activo = 1
    )
    BEGIN
        THROW 51020,
              'No se encontró una cuenta activa para el cliente.',
              1;
    END;

    IF LEN(@ClaveHash) <> 64
    BEGIN
        THROW 51021,
              'El formato de la contraseña no es válido.',
              1;
    END;

    UPDATE dbo.ClienteAcceso
    SET ClaveHash = @ClaveHash
    WHERE ClienteId = @ClienteId;
END;
GO

PRINT 'Ajustes finales de clientes y seguridad aplicados correctamente.';
GO
