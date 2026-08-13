USE [SportWearDB];
GO

/* ============================================================
   SPORTWEAR - AJUSTE FINAL DE VENTA DIRECTA
   - Guarda la talla elegida en cada detalle de venta.
   - Permite el mismo producto en distintas tallas dentro del carrito.
   - Mantiene el stock general por producto.
   - Tallas permitidas: S, M, L, XL.
   ============================================================ */

SET NOCOUNT ON;
GO

/* 1. Agregar talla al detalle de venta */
IF COL_LENGTH('dbo.VentaDetalle', 'Talla') IS NULL
BEGIN
    ALTER TABLE dbo.VentaDetalle
    ADD Talla NVARCHAR(10) NULL;
END;
GO

/* Restricción compatible con ventas antiguas (Talla NULL) */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_VentaDetalle_Talla'
)
BEGIN
    ALTER TABLE dbo.VentaDetalle
    ADD CONSTRAINT CK_VentaDetalle_Talla
        CHECK
        (
            Talla IS NULL
            OR UPPER(LTRIM(RTRIM(Talla))) IN (N'S', N'M', N'L', N'XL')
        );
END;
GO

/* 2. Recrear el tipo tabla porque SQL Server no permite ALTER TYPE */
DROP PROCEDURE IF EXISTS dbo.sp_Venta_Registrar;
GO

DROP TYPE IF EXISTS dbo.VentaDetalleTipo;
GO

CREATE TYPE dbo.VentaDetalleTipo AS TABLE
(
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL,
    Talla NVARCHAR(10) NOT NULL,
    PRIMARY KEY (ProductoId, Talla)
);
GO

/* 3. Registrar venta incluyendo talla */
CREATE PROCEDURE dbo.sp_Venta_Registrar
    @ClienteId INT,
    @Destinatario NVARCHAR(150),
    @Telefono NVARCHAR(20),
    @Direccion NVARCHAR(250),
    @Detalle dbo.VentaDetalleTipo READONLY,
    @VentaId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Cliente
        WHERE ClienteId = @ClienteId
          AND Activo = 1
    )
        THROW 50200, 'El cliente no existe o está inactivo.', 1;

    IF NOT EXISTS (SELECT 1 FROM @Detalle)
        THROW 50201, 'La compra no contiene productos.', 1;

    IF EXISTS (SELECT 1 FROM @Detalle WHERE Cantidad <= 0)
        THROW 50202, 'La cantidad debe ser mayor que cero.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM @Detalle
        WHERE UPPER(LTRIM(RTRIM(Talla))) NOT IN (N'S', N'M', N'L', N'XL')
    )
        THROW 50205, 'Una de las tallas seleccionadas no es válida.', 1;

    DECLARE
        @Subtotal DECIMAL(12,2),
        @Igv DECIMAL(12,2),
        @Total DECIMAL(12,2);

    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS
        (
            SELECT 1
            FROM @Detalle D
            LEFT JOIN dbo.Producto P WITH (UPDLOCK, HOLDLOCK)
                ON D.ProductoId = P.ProductoId
            WHERE P.ProductoId IS NULL
               OR P.Activo = 0
               OR P.Personalizable = 1
        )
            THROW 50203, 'Uno de los productos no está disponible para venta directa.', 1;

        /* El stock sigue siendo general por producto.
           Si el mismo producto se compra en varias tallas,
           se valida la suma de todas ellas. */
        IF EXISTS
        (
            SELECT D.ProductoId
            FROM @Detalle D
            INNER JOIN dbo.Producto P WITH (UPDLOCK, HOLDLOCK)
                ON D.ProductoId = P.ProductoId
            GROUP BY D.ProductoId, P.Stock
            HAVING P.Stock < SUM(D.Cantidad)
        )
            THROW 50204, 'No existe stock suficiente para uno de los productos.', 1;

        SELECT @Total = SUM(P.PrecioBase * D.Cantidad)
        FROM @Detalle D
        INNER JOIN dbo.Producto P
            ON D.ProductoId = P.ProductoId;

        /* PrecioBase es el precio final mostrado en tienda (IGV incluido). */
        SET @Total = ISNULL(@Total, 0);
        SET @Subtotal = ROUND(@Total / 1.18, 2);
        SET @Igv = @Total - @Subtotal;

        DECLARE @CodigoTemporal VARCHAR(20) =
            'TMP-' + RIGHT(REPLACE(CONVERT(VARCHAR(36), NEWID()), '-', ''), 16);

        INSERT dbo.Venta
        (
            ClienteId,
            Codigo,
            Destinatario,
            Telefono,
            Direccion,
            Subtotal,
            Igv,
            Total,
            Estado
        )
        VALUES
        (
            @ClienteId,
            @CodigoTemporal,
            LTRIM(RTRIM(@Destinatario)),
            LTRIM(RTRIM(@Telefono)),
            LTRIM(RTRIM(@Direccion)),
            @Subtotal,
            @Igv,
            @Total,
            N'REGISTRADA'
        );

        SET @VentaId = CONVERT(INT, SCOPE_IDENTITY());

        UPDATE dbo.Venta
        SET Codigo = 'VEN-' + RIGHT('00000000' + CAST(@VentaId AS VARCHAR(8)), 8)
        WHERE VentaId = @VentaId;

        INSERT dbo.VentaDetalle
        (
            VentaId,
            ProductoId,
            Talla,
            Cantidad,
            PrecioUnitario,
            Subtotal
        )
        SELECT
            @VentaId,
            D.ProductoId,
            UPPER(LTRIM(RTRIM(D.Talla))),
            D.Cantidad,
            P.PrecioBase,
            P.PrecioBase * D.Cantidad
        FROM @Detalle D
        INNER JOIN dbo.Producto P
            ON D.ProductoId = P.ProductoId;

        /* Descontar la suma de todas las tallas por producto. */
        UPDATE P
        SET P.Stock = P.Stock - X.CantidadTotal
        FROM dbo.Producto P
        INNER JOIN
        (
            SELECT ProductoId, SUM(Cantidad) AS CantidadTotal
            FROM @Detalle
            GROUP BY ProductoId
        ) X
            ON P.ProductoId = X.ProductoId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

/* 4. Mostrar talla en el detalle de venta */
CREATE OR ALTER PROCEDURE dbo.sp_VentaDetalle_ListarPorVenta
    @VentaId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        VD.VentaDetalleId,
        VD.VentaId,
        VD.ProductoId,
        P.Nombre AS NombreProducto,
        P.ImagenUrl,
        VD.Talla,
        VD.Cantidad,
        VD.PrecioUnitario,
        VD.Subtotal
    FROM dbo.VentaDetalle VD
    INNER JOIN dbo.Producto P
        ON VD.ProductoId = P.ProductoId
    WHERE VD.VentaId = @VentaId
    ORDER BY VD.VentaDetalleId;
END;
GO

PRINT 'Tallas de venta directa habilitadas correctamente.';
GO
