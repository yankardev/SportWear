USE [SportWearDB];
GO

/* ============================================================
   SPORTWEAR - VENTA DIRECTA, STOCK, CARRITO Y FAVORITOS
   Ejecutar después de 01_SportWearDB_Completa.sql
   ============================================================ */

/* 1. STOCK EN PRODUCTO */
IF COL_LENGTH('dbo.Producto', 'Stock') IS NULL
BEGIN
    ALTER TABLE dbo.Producto
    ADD Stock INT NOT NULL CONSTRAINT DF_Producto_Stock DEFAULT (0);
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_Producto_Stock'
)
BEGIN
    ALTER TABLE dbo.Producto
    ADD CONSTRAINT CK_Producto_Stock CHECK (Stock >= 0);
END;
GO

UPDATE dbo.Producto SET Stock = 0 WHERE Personalizable = 1;
UPDATE dbo.Producto SET Stock = 20 WHERE Personalizable = 0 AND Stock = 0;
GO

/* 2. TABLAS DE VENTA DIRECTA */
IF OBJECT_ID('dbo.Venta', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Venta
    (
        VentaId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ClienteId INT NOT NULL,
        Codigo VARCHAR(20) NOT NULL UNIQUE,
        FechaVenta DATETIME NOT NULL CONSTRAINT DF_Venta_FechaVenta DEFAULT (GETDATE()),
        Destinatario NVARCHAR(150) NOT NULL,
        Telefono NVARCHAR(20) NOT NULL,
        Direccion NVARCHAR(250) NOT NULL,
        Subtotal DECIMAL(12,2) NOT NULL,
        Igv DECIMAL(12,2) NOT NULL,
        Total DECIMAL(12,2) NOT NULL,
        Estado NVARCHAR(30) NOT NULL CONSTRAINT DF_Venta_Estado DEFAULT (N'REGISTRADA'),
        CONSTRAINT FK_Venta_Cliente FOREIGN KEY (ClienteId) REFERENCES dbo.Cliente(ClienteId),
        CONSTRAINT CK_Venta_Subtotal CHECK (Subtotal >= 0),
        CONSTRAINT CK_Venta_Igv CHECK (Igv >= 0),
        CONSTRAINT CK_Venta_Total CHECK (Total >= 0)
    );
END;
GO

IF OBJECT_ID('dbo.VentaDetalle', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.VentaDetalle
    (
        VentaDetalleId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        VentaId INT NOT NULL,
        ProductoId INT NOT NULL,
        Cantidad INT NOT NULL,
        PrecioUnitario DECIMAL(10,2) NOT NULL,
        Subtotal DECIMAL(12,2) NOT NULL,
        CONSTRAINT FK_VentaDetalle_Venta FOREIGN KEY (VentaId) REFERENCES dbo.Venta(VentaId),
        CONSTRAINT FK_VentaDetalle_Producto FOREIGN KEY (ProductoId) REFERENCES dbo.Producto(ProductoId),
        CONSTRAINT CK_VentaDetalle_Cantidad CHECK (Cantidad > 0),
        CONSTRAINT CK_VentaDetalle_Precio CHECK (PrecioUnitario > 0),
        CONSTRAINT CK_VentaDetalle_Subtotal CHECK (Subtotal > 0)
    );
END;
GO

IF OBJECT_ID('dbo.Favorito', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Favorito
    (
        FavoritoId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ClienteId INT NOT NULL,
        ProductoId INT NOT NULL,
        FechaRegistro DATETIME NOT NULL CONSTRAINT DF_Favorito_FechaRegistro DEFAULT (GETDATE()),
        CONSTRAINT FK_Favorito_Cliente FOREIGN KEY (ClienteId) REFERENCES dbo.Cliente(ClienteId),
        CONSTRAINT FK_Favorito_Producto FOREIGN KEY (ProductoId) REFERENCES dbo.Producto(ProductoId),
        CONSTRAINT UQ_Favorito_ClienteProducto UNIQUE (ClienteId, ProductoId)
    );
END;
GO

IF TYPE_ID(N'dbo.VentaDetalleTipo') IS NULL
BEGIN
    EXEC(N'CREATE TYPE dbo.VentaDetalleTipo AS TABLE
    (
        ProductoId INT NOT NULL PRIMARY KEY,
        Cantidad INT NOT NULL
    );');
END;
GO

/* 3. PROCEDIMIENTOS DE PRODUCTO ACTUALIZADOS CON STOCK */
CREATE OR ALTER PROCEDURE dbo.sp_Producto_Listar
    @Buscar NVARCHAR(120) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.ProductoId,
        P.CategoriaId,
        C.Nombre AS NombreCategoria,
        P.Nombre,
        P.Descripcion,
        P.PrecioBase,
        P.ImagenUrl,
        P.Personalizable,
        P.Stock,
        P.Activo,
        P.FechaRegistro
    FROM dbo.Producto P
    INNER JOIN dbo.Categoria C ON P.CategoriaId = C.CategoriaId
    WHERE @Buscar IS NULL
       OR LTRIM(RTRIM(@Buscar)) = ''
       OR P.Nombre LIKE '%' + @Buscar + '%'
       OR C.Nombre LIKE '%' + @Buscar + '%'
    ORDER BY P.ProductoId DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Producto_ListarPaginado
    @Pagina INT,
    @Tamano INT,
    @Total INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @Pagina < 1 SET @Pagina = 1;
    IF @Tamano < 1 SET @Tamano = 5;

    SELECT @Total = COUNT(*) FROM dbo.Producto;

    SELECT
        P.ProductoId,
        P.CategoriaId,
        C.Nombre AS NombreCategoria,
        P.Nombre,
        P.Descripcion,
        P.PrecioBase,
        P.ImagenUrl,
        P.Personalizable,
        P.Stock,
        P.Activo,
        P.FechaRegistro
    FROM dbo.Producto P
    INNER JOIN dbo.Categoria C ON P.CategoriaId = C.CategoriaId
    ORDER BY P.ProductoId DESC
    OFFSET (@Pagina - 1) * @Tamano ROWS
    FETCH NEXT @Tamano ROWS ONLY;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Producto_ListarPersonalizables
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.ProductoId,
        P.CategoriaId,
        C.Nombre AS NombreCategoria,
        P.Nombre,
        P.Descripcion,
        P.PrecioBase,
        P.ImagenUrl,
        P.Personalizable,
        P.Stock,
        P.Activo,
        P.FechaRegistro
    FROM dbo.Producto P
    INNER JOIN dbo.Categoria C ON P.CategoriaId = C.CategoriaId
    WHERE P.Activo = 1 AND P.Personalizable = 1
    ORDER BY P.Nombre;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Producto_ObtenerPorId
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.ProductoId,
        P.CategoriaId,
        C.Nombre AS NombreCategoria,
        P.Nombre,
        P.Descripcion,
        P.PrecioBase,
        P.ImagenUrl,
        P.Personalizable,
        P.Stock,
        P.Activo,
        P.FechaRegistro
    FROM dbo.Producto P
    INNER JOIN dbo.Categoria C ON P.CategoriaId = C.CategoriaId
    WHERE P.ProductoId = @ProductoId;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Producto_Insertar
    @CategoriaId INT,
    @Nombre NVARCHAR(120),
    @Descripcion NVARCHAR(500) = NULL,
    @PrecioBase DECIMAL(10,2),
    @ImagenUrl NVARCHAR(500) = NULL,
    @Personalizable BIT,
    @Stock INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @PrecioBase <= 0
        THROW 50002, 'El precio debe ser mayor que cero.', 1;

    IF @Stock < 0
        THROW 50008, 'El stock no puede ser negativo.', 1;

    IF @Personalizable = 1 SET @Stock = 0;

    INSERT INTO dbo.Producto
    (
        CategoriaId, Nombre, Descripcion, PrecioBase,
        ImagenUrl, Personalizable, Stock, Activo
    )
    VALUES
    (
        @CategoriaId, LTRIM(RTRIM(@Nombre)), @Descripcion, @PrecioBase,
        @ImagenUrl, @Personalizable, @Stock, 1
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Producto_Actualizar
    @ProductoId INT,
    @CategoriaId INT,
    @Nombre NVARCHAR(120),
    @Descripcion NVARCHAR(500) = NULL,
    @PrecioBase DECIMAL(10,2),
    @ImagenUrl NVARCHAR(500) = NULL,
    @Personalizable BIT,
    @Stock INT,
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PrecioBase <= 0
        THROW 50006, 'El precio debe ser mayor que cero.', 1;

    IF @Stock < 0
        THROW 50008, 'El stock no puede ser negativo.', 1;

    IF @Personalizable = 1 SET @Stock = 0;

    UPDATE dbo.Producto
    SET CategoriaId = @CategoriaId,
        Nombre = LTRIM(RTRIM(@Nombre)),
        Descripcion = @Descripcion,
        PrecioBase = @PrecioBase,
        ImagenUrl = @ImagenUrl,
        Personalizable = @Personalizable,
        Stock = @Stock,
        Activo = @Activo
    WHERE ProductoId = @ProductoId;
END;
GO

/* 4. FAVORITOS */
CREATE OR ALTER PROCEDURE dbo.sp_Favorito_ListarPorCliente
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.ProductoId,
        P.CategoriaId,
        C.Nombre AS NombreCategoria,
        P.Nombre,
        P.Descripcion,
        P.PrecioBase,
        P.ImagenUrl,
        P.Personalizable,
        P.Stock,
        P.Activo,
        P.FechaRegistro
    FROM dbo.Favorito F
    INNER JOIN dbo.Producto P ON F.ProductoId = P.ProductoId
    INNER JOIN dbo.Categoria C ON P.CategoriaId = C.CategoriaId
    WHERE F.ClienteId = @ClienteId
      AND P.Activo = 1
    ORDER BY F.FechaRegistro DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Favorito_Agregar
    @ClienteId INT,
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Cliente WHERE ClienteId = @ClienteId AND Activo = 1)
        THROW 50100, 'El cliente no existe o está inactivo.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE ProductoId = @ProductoId AND Activo = 1)
        THROW 50101, 'El producto no está disponible.', 1;

    IF NOT EXISTS (
        SELECT 1 FROM dbo.Favorito
        WHERE ClienteId = @ClienteId AND ProductoId = @ProductoId
    )
    BEGIN
        INSERT dbo.Favorito (ClienteId, ProductoId)
        VALUES (@ClienteId, @ProductoId);
    END;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Favorito_Eliminar
    @ClienteId INT,
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Favorito
    WHERE ClienteId = @ClienteId AND ProductoId = @ProductoId;
END;
GO

/* 5. VENTA DIRECTA */
CREATE OR ALTER PROCEDURE dbo.sp_Venta_Registrar
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

    IF NOT EXISTS (SELECT 1 FROM dbo.Cliente WHERE ClienteId = @ClienteId AND Activo = 1)
        THROW 50200, 'El cliente no existe o está inactivo.', 1;

    IF NOT EXISTS (SELECT 1 FROM @Detalle)
        THROW 50201, 'La compra no contiene productos.', 1;

    IF EXISTS (SELECT 1 FROM @Detalle WHERE Cantidad <= 0)
        THROW 50202, 'La cantidad debe ser mayor que cero.', 1;

    DECLARE @Subtotal DECIMAL(12,2), @Igv DECIMAL(12,2), @Total DECIMAL(12,2);

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

        IF EXISTS
        (
            SELECT 1
            FROM @Detalle D
            INNER JOIN dbo.Producto P WITH (UPDLOCK, HOLDLOCK)
                ON D.ProductoId = P.ProductoId
            WHERE P.Stock < D.Cantidad
        )
            THROW 50204, 'No existe stock suficiente para uno de los productos.', 1;

        SELECT @Total = SUM(P.PrecioBase * D.Cantidad)
        FROM @Detalle D
        INNER JOIN dbo.Producto P ON D.ProductoId = P.ProductoId;

        -- PrecioBase es el precio final mostrado en la tienda (IGV incluido).
        SET @Total = ISNULL(@Total, 0);
        SET @Subtotal = ROUND(@Total / 1.18, 2);
        SET @Igv = @Total - @Subtotal;

        DECLARE @CodigoTemporal VARCHAR(20) = 'TMP-' + RIGHT(REPLACE(CONVERT(VARCHAR(36), NEWID()), '-', ''), 16);

        INSERT dbo.Venta
        (
            ClienteId, Codigo, Destinatario, Telefono, Direccion,
            Subtotal, Igv, Total, Estado
        )
        VALUES
        (
            @ClienteId, @CodigoTemporal, LTRIM(RTRIM(@Destinatario)),
            LTRIM(RTRIM(@Telefono)), LTRIM(RTRIM(@Direccion)),
            @Subtotal, @Igv, @Total, N'REGISTRADA'
        );

        SET @VentaId = CONVERT(INT, SCOPE_IDENTITY());

        UPDATE dbo.Venta
        SET Codigo = 'VEN-' + RIGHT('00000000' + CAST(@VentaId AS VARCHAR(8)), 8)
        WHERE VentaId = @VentaId;

        INSERT dbo.VentaDetalle
        (
            VentaId, ProductoId, Cantidad, PrecioUnitario, Subtotal
        )
        SELECT
            @VentaId,
            D.ProductoId,
            D.Cantidad,
            P.PrecioBase,
            P.PrecioBase * D.Cantidad
        FROM @Detalle D
        INNER JOIN dbo.Producto P ON D.ProductoId = P.ProductoId;

        UPDATE P
        SET P.Stock = P.Stock - D.Cantidad
        FROM dbo.Producto P
        INNER JOIN @Detalle D ON P.ProductoId = D.ProductoId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Venta_Listar
    @Buscar NVARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        V.VentaId,
        V.ClienteId,
        V.Codigo,
        V.FechaVenta,
        V.Destinatario,
        V.Telefono,
        V.Direccion,
        V.Subtotal,
        V.Igv,
        V.Total,
        V.Estado,
        CONCAT(C.Nombres, ' ', C.Apellidos) AS NombreCliente
    FROM dbo.Venta V
    INNER JOIN dbo.Cliente C ON V.ClienteId = C.ClienteId
    WHERE @Buscar IS NULL
       OR LTRIM(RTRIM(@Buscar)) = ''
       OR V.Codigo LIKE '%' + @Buscar + '%'
       OR C.Nombres LIKE '%' + @Buscar + '%'
       OR C.Apellidos LIKE '%' + @Buscar + '%'
    ORDER BY V.VentaId DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Venta_ListarPorCliente
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        V.VentaId,
        V.ClienteId,
        V.Codigo,
        V.FechaVenta,
        V.Destinatario,
        V.Telefono,
        V.Direccion,
        V.Subtotal,
        V.Igv,
        V.Total,
        V.Estado,
        CONCAT(C.Nombres, ' ', C.Apellidos) AS NombreCliente
    FROM dbo.Venta V
    INNER JOIN dbo.Cliente C ON V.ClienteId = C.ClienteId
    WHERE V.ClienteId = @ClienteId
    ORDER BY V.VentaId DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Venta_ObtenerPorId
    @VentaId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        V.VentaId,
        V.ClienteId,
        V.Codigo,
        V.FechaVenta,
        V.Destinatario,
        V.Telefono,
        V.Direccion,
        V.Subtotal,
        V.Igv,
        V.Total,
        V.Estado,
        CONCAT(C.Nombres, ' ', C.Apellidos) AS NombreCliente
    FROM dbo.Venta V
    INNER JOIN dbo.Cliente C ON V.ClienteId = C.ClienteId
    WHERE V.VentaId = @VentaId;
END;
GO

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
        VD.Cantidad,
        VD.PrecioUnitario,
        VD.Subtotal
    FROM dbo.VentaDetalle VD
    INNER JOIN dbo.Producto P ON VD.ProductoId = P.ProductoId
    WHERE VD.VentaId = @VentaId
    ORDER BY VD.VentaDetalleId;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Venta_ActualizarEstado
    @VentaId INT,
    @Estado NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    SET @Estado = UPPER(LTRIM(RTRIM(@Estado)));

    IF @Estado NOT IN (N'REGISTRADA', N'PREPARANDO', N'LISTA', N'ENTREGADA')
        THROW 50210, 'El estado de venta no es válido.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.Venta WHERE VentaId = @VentaId)
        THROW 50211, 'La venta no existe.', 1;

    UPDATE dbo.Venta
    SET Estado = @Estado
    WHERE VentaId = @VentaId;
END;
GO

/* 6. PRODUCTOS DEMO DE VENTA DIRECTA SI EL CATÁLOGO ESTÁ VACÍO */
IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Activo = 1 AND Personalizable = 0)
BEGIN
    DECLARE @CatPolos INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Polos');
    DECLARE @CatShorts INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Shorts');
    DECLARE @CatLeggings INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Leggings');
    DECLARE @CatCasacas INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Casacas');

    INSERT dbo.Producto (CategoriaId, Nombre, Descripcion, PrecioBase, ImagenUrl, Personalizable, Stock, Activo)
    VALUES
    (@CatPolos, N'Polo Running Store', N'Polo deportivo listo para entrega, ligero y transpirable.', 69.90, N'/img/productos/polo-running.svg', 0, 24, 1),
    (@CatShorts, N'Short Training Store', N'Short deportivo de entrenamiento para venta directa.', 49.90, N'/img/productos/short-deportivo.svg', 0, 18, 1),
    (@CatLeggings, N'Legging Active Store', N'Legging fitness flexible y cómodo, disponible para compra inmediata.', 79.90, N'/img/productos/legging-fitness.png', 0, 16, 1),
    (@CatCasacas, N'Casaca Urban Sport', N'Casaca deportiva ligera para uso diario y entrenamiento.', 119.90, N'/img/productos/casaca-cortaviento.svg', 0, 12, 1);
END;
GO

PRINT 'Venta directa, stock, carrito y favoritos preparados correctamente.';
GO

/* 7. DASHBOARD: INCLUIR VENTA DIRECTA EN EL TOTAL VENDIDO */
CREATE OR ALTER PROCEDURE dbo.sp_Reporte_ResumenGeneral
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        (SELECT COUNT(*) FROM dbo.Producto WHERE Activo = 1) AS TotalProductos,
        (SELECT COUNT(*) FROM dbo.Cliente WHERE Activo = 1) AS TotalClientes,
        (SELECT COUNT(*) FROM dbo.SolicitudConfeccion) AS TotalSolicitudes,
        (SELECT COUNT(*) FROM dbo.Cotizacion) AS TotalCotizaciones,
        (SELECT COUNT(*) FROM dbo.Pedido) AS TotalPedidos,
        (
            SELECT COUNT(*)
            FROM dbo.Pedido P
            INNER JOIN dbo.EstadoPedido EP ON P.EstadoPedidoId = EP.EstadoPedidoId
            WHERE EP.Nombre NOT IN ('ENTREGADO', 'CANCELADO')
        ) AS PedidosPendientes,
        (
            (SELECT ISNULL(SUM(Total), 0) FROM dbo.Pedido WHERE Estado <> 'CANCELADO')
            +
            (SELECT ISNULL(SUM(Total), 0) FROM dbo.Venta)
        ) AS TotalVentas;

    SELECT
        EP.Nombre AS Estado,
        COUNT(P.PedidoId) AS Cantidad,
        ISNULL(SUM(P.Total), 0) AS Total
    FROM dbo.EstadoPedido EP
    LEFT JOIN dbo.Pedido P ON EP.EstadoPedidoId = P.EstadoPedidoId
    WHERE EP.Activo = 1
    GROUP BY EP.EstadoPedidoId, EP.Nombre, EP.Orden
    ORDER BY EP.Orden;

    SELECT TOP (5)
        PR.ProductoId,
        PR.Nombre AS Producto,
        COUNT(S.SolicitudId) AS TotalSolicitudes,
        ISNULL(SUM(S.Cantidad), 0) AS TotalUnidades
    FROM dbo.Producto PR
    LEFT JOIN dbo.SolicitudConfeccion S ON PR.ProductoId = S.ProductoId
    WHERE PR.Activo = 1
    GROUP BY PR.ProductoId, PR.Nombre
    ORDER BY TotalSolicitudes DESC, TotalUnidades DESC, PR.Nombre;

    SELECT TOP (5)
        C.ClienteId,
        CONCAT(C.Nombres, ' ', C.Apellidos) AS Cliente,
        COUNT(S.SolicitudId) AS TotalSolicitudes,
        ISNULL(SUM(CO.Total), 0) AS TotalCotizado
    FROM dbo.Cliente C
    LEFT JOIN dbo.SolicitudConfeccion S ON C.ClienteId = S.ClienteId
    LEFT JOIN dbo.Cotizacion CO ON S.SolicitudId = CO.SolicitudId
    WHERE C.Activo = 1
    GROUP BY C.ClienteId, C.Nombres, C.Apellidos
    ORDER BY TotalSolicitudes DESC, TotalCotizado DESC, Cliente;
END;
GO
