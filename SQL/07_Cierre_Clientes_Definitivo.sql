USE [SportWearDB];
GO

/*
    SPORTWEAR - CIERRE DEFINITIVO DE CLIENTES

    Corrige dos comportamientos:
    1) El administrador puede crear/restablecer el acceso de cualquier cliente
       que tenga correo registrado.
    2) Un cliente inactivo no puede iniciar sesión, aunque ClienteAcceso haya
       quedado activo por datos antiguos.
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

    BEGIN TRY
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
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Cliente_Eliminar
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE dbo.Cliente
        SET Activo = 0
        WHERE ClienteId = @ClienteId;

        UPDATE dbo.ClienteAcceso
        SET Activo = 0
        WHERE ClienteId = @ClienteId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ClienteAcceso_ObtenerPorCorreo
    @Correo VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        A.ClienteAccesoId,
        A.ClienteId,
        A.Correo,
        A.ClaveHash,
        CAST(
            CASE
                WHEN A.Activo = 1 AND C.Activo = 1 THEN 1
                ELSE 0
            END
            AS BIT
        ) AS Activo,
        A.FechaRegistro,
        C.Nombres,
        C.Apellidos
    FROM dbo.ClienteAcceso AS A
    INNER JOIN dbo.Cliente AS C
        ON A.ClienteId = C.ClienteId
    WHERE A.Correo = @Correo;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ClienteAcceso_ObtenerPorClienteId
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        A.ClienteAccesoId,
        A.ClienteId,
        A.Correo,
        A.ClaveHash,
        CAST(
            CASE
                WHEN A.Activo = 1 AND C.Activo = 1 THEN 1
                ELSE 0
            END
            AS BIT
        ) AS Activo,
        A.FechaRegistro,
        C.Nombres,
        C.Apellidos
    FROM dbo.ClienteAcceso AS A
    INNER JOIN dbo.Cliente AS C
        ON A.ClienteId = C.ClienteId
    WHERE A.ClienteId = @ClienteId;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ClienteAcceso_CambiarClave
    @ClienteId INT,
    @ClaveHash VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    IF LEN(@ClaveHash) <> 64
        THROW 51021, 'El formato de la contraseña no es válido.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.ClienteAcceso A
        INNER JOIN dbo.Cliente C
            ON C.ClienteId = A.ClienteId
        WHERE A.ClienteId = @ClienteId
          AND A.Activo = 1
          AND C.Activo = 1
    )
        THROW 51020, 'No se encontró una cuenta activa para el cliente.', 1;

    UPDATE dbo.ClienteAcceso
    SET ClaveHash = @ClaveHash
    WHERE ClienteId = @ClienteId;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ClienteAcceso_RestablecerClaveAdmin
    @ClienteId INT,
    @Correo VARCHAR(150),
    @ClaveHash VARCHAR(64),
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @Correo = LTRIM(RTRIM(@Correo));

    IF LEN(@ClaveHash) <> 64
        THROW 51031, 'El formato de la contraseña no es válido.', 1;

    IF NULLIF(@Correo, '') IS NULL
        THROW 51032, 'El cliente necesita un correo para crear su acceso.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Cliente
        WHERE ClienteId = @ClienteId
    )
        THROW 51033, 'No se encontró el cliente.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.ClienteAcceso
        WHERE Correo = @Correo
          AND ClienteId <> @ClienteId
    )
        THROW 51034, 'El correo ya pertenece al acceso de otro cliente.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.ClienteAcceso
        WHERE ClienteId = @ClienteId
    )
    BEGIN
        UPDATE dbo.ClienteAcceso
        SET Correo = @Correo,
            ClaveHash = @ClaveHash,
            Activo = @Activo
        WHERE ClienteId = @ClienteId;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.ClienteAcceso
        (
            ClienteId,
            Correo,
            ClaveHash,
            Activo
        )
        VALUES
        (
            @ClienteId,
            @Correo,
            @ClaveHash,
            @Activo
        );
    END;
END;
GO

/* Sincroniza datos antiguos existentes. */
UPDATE A
SET A.Activo = C.Activo
FROM dbo.ClienteAcceso A
INNER JOIN dbo.Cliente C
    ON C.ClienteId = A.ClienteId
WHERE A.Activo <> C.Activo;
GO

PRINT 'Cierre definitivo de clientes aplicado correctamente.';
GO
