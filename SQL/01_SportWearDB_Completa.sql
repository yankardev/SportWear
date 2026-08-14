/*
    SPORTWEAR - BASE DE DATOS COMPLETA
    Proyecto: Desarrollo de Servicios Web I
    Motor: Microsoft SQL Server

    Este script fue preparado para el repositorio GitHub.
    - Crea SportWearDB si todavía no existe.
    - Incluye tablas, relaciones, datos de demostración y procedimientos almacenados.
    - El perfil CLIENTE permanece en dbo.Rol, pero los clientes se autentican
      mediante dbo.ClienteAcceso y NO mediante dbo.Usuario.
*/

USE [master];
GO

IF DB_ID(N'SportWearDB') IS NULL
BEGIN
    CREATE DATABASE [SportWearDB];
END;
GO

USE [SportWearDB]
GO
/****** Objeto: Table [dbo].[Categoria] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categoria](
	[CategoriaId] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](300) NULL,
	[Activo] [bit] NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoriaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cliente] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cliente](
	[ClienteId] [int] IDENTITY(1,1) NOT NULL,
	[Nombres] [nvarchar](100) NOT NULL,
	[Apellidos] [nvarchar](100) NOT NULL,
	[Documento] [nvarchar](15) NOT NULL,
	[Telefono] [nvarchar](20) NULL,
	[Correo] [nvarchar](120) NULL,
	[Direccion] [nvarchar](200) NULL,
	[Activo] [bit] NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ClienteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[ClienteAcceso] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClienteAcceso](
	[ClienteAccesoId] [int] IDENTITY(1,1) NOT NULL,
	[ClienteId] [int] NOT NULL,
	[Correo] [varchar](150) NOT NULL,
	[ClaveHash] [varchar](64) NOT NULL,
	[Activo] [bit] NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ClienteAccesoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cotizacion] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cotizacion](
	[CotizacionId] [int] IDENTITY(1,1) NOT NULL,
	[SolicitudId] [int] NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[Codigo] [varchar](20) NOT NULL,
	[Estado] [nvarchar](20) NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaVencimiento] [datetime] NULL,
	[PrecioUnitario] [decimal](10, 2) NOT NULL,
	[DescuentoPorcentaje] [decimal](5, 2) NOT NULL,
	[Subtotal] [decimal](12, 2) NOT NULL,
	[Igv] [decimal](12, 2) NOT NULL,
	[Total] [decimal](12, 2) NOT NULL,
	[Observaciones] [nvarchar](1000) NULL,
	[PdfUrl] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[CotizacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[EstadoPedido] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoPedido](
	[EstadoPedidoId] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Orden] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EstadoPedidoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Pedido] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pedido](
	[PedidoId] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[CotizacionId] [int] NOT NULL,
	[EstadoPedidoId] [int] NOT NULL,
	[Codigo] [varchar](20) NOT NULL,
	[FechaPedido] [datetime] NOT NULL,
	[FechaEntregaEstimada] [date] NULL,
	[Destinatario] [nvarchar](150) NULL,
	[TelefonoEntrega] [nvarchar](20) NULL,
	[DireccionEntrega] [nvarchar](250) NULL,
	[DistritoEntrega] [nvarchar](100) NULL,
	[ReferenciaEntrega] [nvarchar](250) NULL,
	[Subtotal] [decimal](12, 2) NOT NULL,
	[Igv] [decimal](12, 2) NOT NULL,
	[Total] [decimal](12, 2) NOT NULL,
	[Observaciones] [nvarchar](1000) NULL,
	[Estado] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PedidoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Producto] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[ProductoId] [int] IDENTITY(1,1) NOT NULL,
	[CategoriaId] [int] NOT NULL,
	[Nombre] [nvarchar](120) NOT NULL,
	[Descripcion] [nvarchar](500) NULL,
	[PrecioBase] [decimal](10, 2) NOT NULL,
	[ImagenUrl] [nvarchar](500) NULL,
	[Personalizable] [bit] NOT NULL,
	[Activo] [bit] NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Rol] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rol](
	[RolId] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](200) NULL,
	[Activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RolId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[SolicitudConfeccion] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolicitudConfeccion](
	[SolicitudId] [int] IDENTITY(1,1) NOT NULL,
	[ClienteId] [int] NOT NULL,
	[ProductoId] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Talla] [nvarchar](20) NOT NULL,
	[Color] [nvarchar](50) NOT NULL,
	[Material] [nvarchar](100) NOT NULL,
	[TipoEstampado] [nvarchar](100) NULL,
	[TextoPersonalizado] [nvarchar](150) NULL,
	[ArchivoDisenoUrl] [nvarchar](500) NULL,
	[Observaciones] [nvarchar](500) NULL,
	[Estado] [nvarchar](20) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SolicitudId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Usuario] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[UsuarioId] [int] IDENTITY(1,1) NOT NULL,
	[RolId] [int] NOT NULL,
	[Nombres] [nvarchar](100) NOT NULL,
	[Apellidos] [nvarchar](100) NOT NULL,
	[Correo] [varchar](150) NOT NULL,
	[ClaveHash] [varchar](64) NOT NULL,
	[Telefono] [nvarchar](20) NULL,
	[Activo] [bit] NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UsuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Categoria] ON 

INSERT [dbo].[Categoria] ([CategoriaId], [Nombre], [Descripcion], [Activo], [FechaRegistro]) VALUES (1, N'Polos', N'Polos deportivos personalizables para entrenamiento, running y gimnasio.', 1, CAST(N'2026-08-09T06:25:45.803' AS DateTime))
INSERT [dbo].[Categoria] ([CategoriaId], [Nombre], [Descripcion], [Activo], [FechaRegistro]) VALUES (2, N'Shorts', N'Shorts deportivos para entrenamiento, running y competencia.', 1, CAST(N'2026-08-09T06:25:45.803' AS DateTime))
INSERT [dbo].[Categoria] ([CategoriaId], [Nombre], [Descripcion], [Activo], [FechaRegistro]) VALUES (3, N'Buzos', N'Buzos y conjuntos abrigadores para equipos y delegaciones.', 1, CAST(N'2026-08-09T06:25:45.803' AS DateTime))
INSERT [dbo].[Categoria] ([CategoriaId], [Nombre], [Descripcion], [Activo], [FechaRegistro]) VALUES (4, N'Leggings', N'Leggings deportivos para entrenamiento y fitness.', 1, CAST(N'2026-08-09T06:25:45.803' AS DateTime))
INSERT [dbo].[Categoria] ([CategoriaId], [Nombre], [Descripcion], [Activo], [FechaRegistro]) VALUES (5, N'Camisetas', N'Camisetas para fútbol, vóley y equipos deportivos.', 1, CAST(N'2026-08-10T06:21:10.877' AS DateTime))
INSERT [dbo].[Categoria] ([CategoriaId], [Nombre], [Descripcion], [Activo], [FechaRegistro]) VALUES (6, N'Casacas', N'Casacas deportivas, cortavientos y prendas para entrenamiento.', 1, CAST(N'2026-08-10T06:21:10.877' AS DateTime))
INSERT [dbo].[Categoria] ([CategoriaId], [Nombre], [Descripcion], [Activo], [FechaRegistro]) VALUES (7, N'Uniformes', N'Uniformes completos para clubes, academias y empresas.', 1, CAST(N'2026-08-10T06:21:10.877' AS DateTime))
INSERT [dbo].[Categoria] ([CategoriaId], [Nombre], [Descripcion], [Activo], [FechaRegistro]) VALUES (8, N'Conjuntos', N'Conjuntos deportivos personalizados para entrenamiento.', 1, CAST(N'2026-08-10T06:21:10.880' AS DateTime))
SET IDENTITY_INSERT [dbo].[Categoria] OFF
GO
SET IDENTITY_INSERT [dbo].[Cliente] ON 

INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (1, N'Carlos', N'Ramírez', N'74235689', N'987654321', N'carlos@gmail.com', N'Trujillo', 1, CAST(N'2026-08-09T06:25:45.817' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (2, N'Ana', N'Sánchez', N'71325698', N'999111222', N'ana@gmail.com', N'Víctor Larco', 1, CAST(N'2026-08-09T06:25:45.817' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (3, N'Luis', N'Castillo', N'70445566', N'988777555', N'luis@gmail.com', N'La Esperanza', 1, CAST(N'2026-08-09T06:25:45.817' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (4, N'PAMELA', N'ASCOY', N'46214483', N'916284243', N'Pamelaag@ironpulse.com', NULL, 1, CAST(N'2026-08-09T22:04:17.100' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (5, N'YAMILA', N'CALDERON', N'79858485', N'952785458', N'YAMILA-CALDERON@sportwear.com', NULL, 1, CAST(N'2026-08-09T23:26:40.203' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (6, N'Diego', N'Vargas Salazar', N'70000011', N'987410011', N'diego.vargas@sportwear.com', N'El Golf - Trujillo', 1, CAST(N'2026-08-10T06:21:10.933' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (7, N'Andrea', N'Ruiz Mendoza', N'70000012', N'987410012', N'andrea.ruiz@sportwear.com', N'Víctor Larco - Trujillo', 1, CAST(N'2026-08-10T06:21:10.937' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (8, N'Miguel', N'Torres Díaz', N'70000013', N'987410013', N'miguel.torres@sportwear.com', N'California - Trujillo', 1, CAST(N'2026-08-10T06:21:10.937' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (9, N'Fiorella', N'Castro León', N'70000014', N'987410014', N'fiorella.castro@sportwear.com', N'La Merced - Trujillo', 1, CAST(N'2026-08-10T06:21:10.937' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (10, N'Renzo', N'Morales Vega', N'70000015', N'987410015', N'renzo.morales@sportwear.com', N'San Andrés - Trujillo', 1, CAST(N'2026-08-10T06:21:10.937' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (11, N'Camila', N'Mendoza Flores', N'70000016', N'987410016', N'camila.mendoza@sportwear.com', N'Los Cedros - Trujillo', 1, CAST(N'2026-08-10T06:21:10.940' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (12, N'Sebastián', N'León Rojas', N'70000017', N'987410017', N'sebastian.leon@sportwear.com', N'Las Quintanas - Trujillo', 1, CAST(N'2026-08-10T06:21:10.940' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (13, N'Luciana', N'Vega Torres', N'70000018', N'987410018', N'luciana.vega@sportwear.com', N'Primavera - Trujillo', 1, CAST(N'2026-08-10T06:21:10.940' AS DateTime))
INSERT [dbo].[Cliente] ([ClienteId], [Nombres], [Apellidos], [Documento], [Telefono], [Correo], [Direccion], [Activo], [FechaRegistro]) VALUES (14, N'DANIEL', N'LOPEZ VEGA', N'47854285', N'916284241', N'DANIEL.LOPEZ@GMAIL.COM', NULL, 1, CAST(N'2026-08-11T23:04:45.340' AS DateTime))
SET IDENTITY_INSERT [dbo].[Cliente] OFF
GO
SET IDENTITY_INSERT [dbo].[ClienteAcceso] ON 

INSERT [dbo].[ClienteAcceso] ([ClienteAccesoId], [ClienteId], [Correo], [ClaveHash], [Activo], [FechaRegistro]) VALUES (1, 5, N'YAMILA-CALDERON@sportwear.com', N'8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 1, CAST(N'2026-08-09T23:26:40.217' AS DateTime))
INSERT [dbo].[ClienteAcceso] ([ClienteAccesoId], [ClienteId], [Correo], [ClaveHash], [Activo], [FechaRegistro]) VALUES (2, 10, N'renzo.morales@sportwear.com', N'FF3317ED92AF000942897760A1CDAD0920E8F3FDB42F7D29A4E0C4843598A30C', 1, CAST(N'2026-08-10T06:21:10.947' AS DateTime))
SET IDENTITY_INSERT [dbo].[ClienteAcceso] OFF
GO
SET IDENTITY_INSERT [dbo].[Cotizacion] ON 

INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (1, 1, 2, N'COT-000001', N'APROBADA', CAST(N'2026-08-09T22:05:55.073' AS DateTime), CAST(N'2026-08-24T22:05:55.073' AS DateTime), CAST(134.90 AS Decimal(10, 2)), CAST(10.00 AS Decimal(5, 2)), CAST(6070.50 AS Decimal(12, 2)), CAST(1092.69 AS Decimal(12, 2)), CAST(7163.19 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (2, 3, 3, N'COT-000003', N'EMITIDA', CAST(N'2026-07-27T06:23:04.463' AS DateTime), CAST(N'2026-08-11T06:23:04.463' AS DateTime), CAST(99.90 AS Decimal(10, 2)), CAST(0.00 AS Decimal(5, 2)), CAST(1798.20 AS Decimal(12, 2)), CAST(323.68 AS Decimal(12, 2)), CAST(2121.88 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (3, 4, 3, N'COT-000004', N'APROBADA', CAST(N'2026-07-29T06:23:04.463' AS DateTime), CAST(N'2026-08-13T06:23:04.463' AS DateTime), CAST(129.90 AS Decimal(10, 2)), CAST(5.00 AS Decimal(5, 2)), CAST(3702.15 AS Decimal(12, 2)), CAST(666.39 AS Decimal(12, 2)), CAST(4368.54 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (4, 5, 3, N'COT-000005', N'APROBADA', CAST(N'2026-07-31T06:23:04.463' AS DateTime), CAST(N'2026-08-15T06:23:04.463' AS DateTime), CAST(157.90 AS Decimal(10, 2)), CAST(5.00 AS Decimal(5, 2)), CAST(3300.11 AS Decimal(12, 2)), CAST(594.02 AS Decimal(12, 2)), CAST(3894.13 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (5, 6, 3, N'COT-000006', N'APROBADA', CAST(N'2026-08-02T06:23:04.463' AS DateTime), CAST(N'2026-08-17T06:23:04.463' AS DateTime), CAST(69.90 AS Decimal(10, 2)), CAST(5.00 AS Decimal(5, 2)), CAST(2656.20 AS Decimal(12, 2)), CAST(478.12 AS Decimal(12, 2)), CAST(3134.32 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (6, 7, 3, N'COT-000007', N'APROBADA', CAST(N'2026-08-04T06:23:04.467' AS DateTime), CAST(N'2026-08-19T06:23:04.467' AS DateTime), CAST(139.90 AS Decimal(10, 2)), CAST(0.00 AS Decimal(5, 2)), CAST(2098.50 AS Decimal(12, 2)), CAST(377.73 AS Decimal(12, 2)), CAST(2476.23 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (7, 8, 3, N'COT-000008', N'APROBADA', CAST(N'2026-07-21T06:23:04.467' AS DateTime), CAST(N'2026-08-05T06:23:04.467' AS DateTime), CAST(107.90 AS Decimal(10, 2)), CAST(10.00 AS Decimal(5, 2)), CAST(4855.50 AS Decimal(12, 2)), CAST(873.99 AS Decimal(12, 2)), CAST(5729.49 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (8, 9, 3, N'COT-000009', N'EMITIDA', CAST(N'2026-08-07T06:23:04.467' AS DateTime), CAST(N'2026-08-22T06:23:04.467' AS DateTime), CAST(63.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(5, 2)), CAST(2094.75 AS Decimal(12, 2)), CAST(377.06 AS Decimal(12, 2)), CAST(2471.81 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
INSERT [dbo].[Cotizacion] ([CotizacionId], [SolicitudId], [UsuarioId], [Codigo], [Estado], [FechaEmision], [FechaVencimiento], [PrecioUnitario], [DescuentoPorcentaje], [Subtotal], [Igv], [Total], [Observaciones], [PdfUrl]) VALUES (9, 10, 1, N'COT-000010', N'APROBADA', CAST(N'2026-08-11T23:06:40.363' AS DateTime), CAST(N'2026-08-26T23:06:40.363' AS DateTime), CAST(94.90 AS Decimal(10, 2)), CAST(5.00 AS Decimal(5, 2)), CAST(1803.10 AS Decimal(12, 2)), CAST(324.56 AS Decimal(12, 2)), CAST(2127.66 AS Decimal(12, 2)), N'Cotización generada automáticamente.', NULL)
SET IDENTITY_INSERT [dbo].[Cotizacion] OFF
GO
SET IDENTITY_INSERT [dbo].[EstadoPedido] ON 

INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (1, N'PENDIENTE', 1, 0)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (2, N'APROBADO', 1, 1)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (3, N'DISEÑO', 2, 1)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (4, N'CORTE', 4, 0)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (5, N'CONFECCION', 3, 1)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (6, N'CONTROL_CALIDAD', 6, 0)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (7, N'LISTO', 4, 1)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (8, N'ENVIADO', 8, 0)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (9, N'ENTREGADO', 5, 1)
INSERT [dbo].[EstadoPedido] ([EstadoPedidoId], [Nombre], [Orden], [Activo]) VALUES (10, N'CANCELADO', 10, 0)
SET IDENTITY_INSERT [dbo].[EstadoPedido] OFF
GO
SET IDENTITY_INSERT [dbo].[Pedido] ON 

INSERT [dbo].[Pedido] ([PedidoId], [UsuarioId], [CotizacionId], [EstadoPedidoId], [Codigo], [FechaPedido], [FechaEntregaEstimada], [Destinatario], [TelefonoEntrega], [DireccionEntrega], [DistritoEntrega], [ReferenciaEntrega], [Subtotal], [Igv], [Total], [Observaciones], [Estado]) VALUES (1, 1, 1, 9, N'PED-000001', CAST(N'2026-08-10T03:33:22.873' AS DateTime), CAST(N'2026-08-25' AS Date), N'PAMELA ASCOY', N'916284243', N'SAN ANDRES 134', N'TRUJILLO', N'FRENTE A PARQUE', CAST(6070.50 AS Decimal(12, 2)), CAST(1092.69 AS Decimal(12, 2)), CAST(7163.19 AS Decimal(12, 2)), NULL, N'ENTREGADO')
INSERT [dbo].[Pedido] ([PedidoId], [UsuarioId], [CotizacionId], [EstadoPedidoId], [Codigo], [FechaPedido], [FechaEntregaEstimada], [Destinatario], [TelefonoEntrega], [DireccionEntrega], [DistritoEntrega], [ReferenciaEntrega], [Subtotal], [Igv], [Total], [Observaciones], [Estado]) VALUES (2, 3, 3, 2, N'PED-000003', CAST(N'2026-07-30T06:30:43.700' AS DateTime), CAST(N'2026-08-20' AS Date), N'Miguel Torres Díaz', N'987410013', N'California 340', N'Trujillo', N'Cerca al parque principal', CAST(3702.15 AS Decimal(12, 2)), CAST(666.39 AS Decimal(12, 2)), CAST(4368.54 AS Decimal(12, 2)), N'Pedido demo - etapa aprobada', N'APROBADO')
INSERT [dbo].[Pedido] ([PedidoId], [UsuarioId], [CotizacionId], [EstadoPedidoId], [Codigo], [FechaPedido], [FechaEntregaEstimada], [Destinatario], [TelefonoEntrega], [DireccionEntrega], [DistritoEntrega], [ReferenciaEntrega], [Subtotal], [Igv], [Total], [Observaciones], [Estado]) VALUES (3, 3, 4, 3, N'PED-000004', CAST(N'2026-08-01T06:30:43.703' AS DateTime), CAST(N'2026-08-18' AS Date), N'Fiorella Castro León', N'987410014', N'La Merced 225', N'Trujillo', N'Frente a losa deportiva', CAST(3300.11 AS Decimal(12, 2)), CAST(594.02 AS Decimal(12, 2)), CAST(3894.13 AS Decimal(12, 2)), N'Pedido demo - etapa diseño', N'DISEÑO')
INSERT [dbo].[Pedido] ([PedidoId], [UsuarioId], [CotizacionId], [EstadoPedidoId], [Codigo], [FechaPedido], [FechaEntregaEstimada], [Destinatario], [TelefonoEntrega], [DireccionEntrega], [DistritoEntrega], [ReferenciaEntrega], [Subtotal], [Igv], [Total], [Observaciones], [Estado]) VALUES (4, 3, 5, 5, N'PED-000005', CAST(N'2026-08-03T06:30:43.703' AS DateTime), CAST(N'2026-08-16' AS Date), N'Renzo Morales Vega', N'987410015', N'San Andrés 550', N'Trujillo', N'Local Iron Box', CAST(2656.20 AS Decimal(12, 2)), CAST(478.12 AS Decimal(12, 2)), CAST(3134.32 AS Decimal(12, 2)), N'Pedido demo - etapa confección', N'CONFECCION')
INSERT [dbo].[Pedido] ([PedidoId], [UsuarioId], [CotizacionId], [EstadoPedidoId], [Codigo], [FechaPedido], [FechaEntregaEstimada], [Destinatario], [TelefonoEntrega], [DireccionEntrega], [DistritoEntrega], [ReferenciaEntrega], [Subtotal], [Igv], [Total], [Observaciones], [Estado]) VALUES (5, 3, 6, 7, N'PED-000006', CAST(N'2026-08-05T06:30:43.707' AS DateTime), CAST(N'2026-08-12' AS Date), N'Camila Mendoza Flores', N'987410016', N'Los Cedros 410', N'Trujillo', N'Puerta principal', CAST(2098.50 AS Decimal(12, 2)), CAST(377.73 AS Decimal(12, 2)), CAST(2476.23 AS Decimal(12, 2)), N'Pedido demo - listo para entrega', N'LISTO')
INSERT [dbo].[Pedido] ([PedidoId], [UsuarioId], [CotizacionId], [EstadoPedidoId], [Codigo], [FechaPedido], [FechaEntregaEstimada], [Destinatario], [TelefonoEntrega], [DireccionEntrega], [DistritoEntrega], [ReferenciaEntrega], [Subtotal], [Igv], [Total], [Observaciones], [Estado]) VALUES (6, 3, 7, 9, N'PED-000007', CAST(N'2026-07-22T06:30:43.707' AS DateTime), CAST(N'2026-08-08' AS Date), N'Sebastián León Rojas', N'987410017', N'Las Quintanas 180', N'Trujillo', N'Club Deportivo Libertad', CAST(4855.50 AS Decimal(12, 2)), CAST(873.99 AS Decimal(12, 2)), CAST(5729.49 AS Decimal(12, 2)), N'Pedido demo - entregado', N'ENTREGADO')
INSERT [dbo].[Pedido] ([PedidoId], [UsuarioId], [CotizacionId], [EstadoPedidoId], [Codigo], [FechaPedido], [FechaEntregaEstimada], [Destinatario], [TelefonoEntrega], [DireccionEntrega], [DistritoEntrega], [ReferenciaEntrega], [Subtotal], [Igv], [Total], [Observaciones], [Estado]) VALUES (7, 1, 9, 9, N'PED-000009', CAST(N'2026-08-11T23:08:21.017' AS DateTime), CAST(N'2026-08-26' AS Date), N'DANIEL LOPEZ VEGA', N'916284241', N'LOS PORTALES', N'TRUJILLO', N'FRENTE A FARMACIA', CAST(1803.10 AS Decimal(12, 2)), CAST(324.56 AS Decimal(12, 2)), CAST(2127.66 AS Decimal(12, 2)), NULL, N'ENTREGADO')
SET IDENTITY_INSERT [dbo].[Pedido] OFF
GO
SET IDENTITY_INSERT [dbo].[Producto] ON 

INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (1, 1, N'Polo Dry Fit', N'Polo técnico de secado rápido, ligero y transpirable. Ideal para equipos, gimnasios y eventos deportivos.', CAST(45.00 AS Decimal(10, 2)), N'/img/productos/polo-dry-fit.svg', 1, 1, CAST(N'2026-08-09T06:25:45.813' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (2, 1, N'Polo Running', N'Polo liviano para running con tela respirable y acabado deportivo. Disponible para personalización por equipo.', CAST(55.00 AS Decimal(10, 2)), N'/img/productos/polo-running.svg', 1, 1, CAST(N'2026-08-09T06:25:45.813' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (3, 2, N'Short Deportivo', N'Short cómodo y resistente para entrenamiento. Puede personalizarse con colores, número y logotipo.', CAST(39.90 AS Decimal(10, 2)), N'/img/productos/short-deportivo.svg', 1, 1, CAST(N'2026-08-09T06:25:45.813' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (4, 3, N'Buzo Deportivo', N'Conjunto deportivo de casaca y pantalón para academias, empresas y delegaciones.', CAST(129.90 AS Decimal(10, 2)), N'/img/productos/buzo-deportivo.svg', 1, 1, CAST(N'2026-08-09T06:25:45.813' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (5, 4, N'Legging Fitness', N'Legging de alto ajuste para entrenamiento y fitness, confeccionado en tejido flexible y cómodo.', CAST(69.90 AS Decimal(10, 2)), N'/img/productos/legging-fitness.png', 1, 1, CAST(N'2026-08-09T06:25:45.813' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (6, 5, N'Camiseta Fútbol Pro', N'Camiseta para fútbol en tejido Dry Fit. Personalizable con escudo, dorsal, nombres y auspiciadores.', CAST(59.90 AS Decimal(10, 2)), N'/img/productos/camiseta-futbol-pro.svg', 1, 1, CAST(N'2026-08-10T06:21:10.920' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (7, 5, N'Camiseta Vóley Team', N'Camiseta ligera para vóley con corte deportivo. Permite sublimación completa y numeración personalizada.', CAST(54.90 AS Decimal(10, 2)), N'/img/productos/camiseta-voley-team.svg', 1, 1, CAST(N'2026-08-10T06:21:10.920' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (8, 6, N'Casaca Cortaviento', N'Casaca ligera para exterior, resistente al viento y adecuada para clubes, running y delegaciones.', CAST(59.90 AS Decimal(10, 2)), N'/img/productos/casaca-cortaviento.svg', 1, 1, CAST(N'2026-08-10T06:21:10.920' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (9, 7, N'Uniforme Fútbol Completo', N'Kit de camiseta y short para fútbol. Incluye opciones de sublimación, escudo, dorsal y nombre.', CAST(99.90 AS Decimal(10, 2)), N'/img/productos/uniforme-futbol-completo.svg', 1, 1, CAST(N'2026-08-10T06:21:10.920' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (10, 7, N'Uniforme Vóley Completo', N'Uniforme para vóley compuesto por camiseta y short, pensado para academias y equipos competitivos.', CAST(94.90 AS Decimal(10, 2)), N'/img/productos/uniforme-voley-completo.svg', 1, 1, CAST(N'2026-08-10T06:21:10.923' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (11, 8, N'Conjunto Entrenamiento', N'Conjunto para entrenamiento compuesto por casaca y pantalón deportivo, con bordado o estampado institucional.', CAST(89.90 AS Decimal(10, 2)), N'/img/productos/conjunto-entrenamiento.png', 1, 1, CAST(N'2026-08-10T06:21:10.923' AS DateTime))
INSERT [dbo].[Producto] ([ProductoId], [CategoriaId], [Nombre], [Descripcion], [PrecioBase], [ImagenUrl], [Personalizable], [Activo], [FechaRegistro]) VALUES (12, 1, N'Polo Gym Performance', N'Polo de entrenamiento para gimnasio, de corte moderno y tela respirable. Ideal para boxes y centros fitness.', CAST(64.90 AS Decimal(10, 2)), N'/img/productos/polo-gym-performance.svg', 1, 1, CAST(N'2026-08-10T06:21:10.923' AS DateTime))
SET IDENTITY_INSERT [dbo].[Producto] OFF
GO
SET IDENTITY_INSERT [dbo].[Rol] ON 

INSERT [dbo].[Rol] ([RolId], [Nombre], [Descripcion], [Activo]) VALUES (1, N'ADMINISTRADOR', N'Gestiona todos los módulos del sistema', 1)
INSERT [dbo].[Rol] ([RolId], [Nombre], [Descripcion], [Activo]) VALUES (2, N'CLIENTE', N'Usuario cliente del sistema', 1)
INSERT [dbo].[Rol] ([RolId], [Nombre], [Descripcion], [Activo]) VALUES (3, N'VENTAS', N'Gestiona clientes, solicitudes, cotizaciones y pedidos.', 1)
INSERT [dbo].[Rol] ([RolId], [Nombre], [Descripcion], [Activo]) VALUES (4, N'PRODUCCION', N'Gestiona la producción y estados de los pedidos.', 1)
SET IDENTITY_INSERT [dbo].[Rol] OFF
GO
SET IDENTITY_INSERT [dbo].[SolicitudConfeccion] ON 

INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (1, 4, 4, 50, N'S', N'MORADO', N'Poliéster', N'Serigrafía', N'EMMPRESA ASCOY', NULL, NULL, N'APROBADA', CAST(N'2026-08-09T22:04:17.110' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (2, 6, 6, 24, N'M', N'Azul marino', N'Dry Fit', N'Sublimación', N'DEMO-DIEGO', NULL, N'Uniforme para torneo empresarial. Incluir escudo y dorsal.', N'PENDIENTE', CAST(N'2026-08-10T06:21:10.983' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (3, 7, 10, 18, N'M', N'Vino', N'Poliéster', N'Serigrafía', N'DEMO-ANDREA', NULL, N'Academia de vóley. Logo frontal y numeración posterior.', N'COTIZADA', CAST(N'2026-08-10T06:21:10.987' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (4, 8, 8, 30, N'L', N'Negro', N'Taslan', N'Bordado', N'DEMO-MIGUEL', NULL, N'Casacas para club de running. Logo bordado en pecho.', N'APROBADA', CAST(N'2026-08-10T06:21:10.987' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (5, 9, 11, 22, N'S', N'Morado', N'Poliéster', N'Sublimación', N'DEMO-FIORELLA', NULL, N'Conjuntos para equipo femenino de entrenamiento.', N'APROBADA', CAST(N'2026-08-10T06:21:10.987' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (6, 10, 12, 40, N'M', N'Negro', N'Dry Fit', N'Serigrafía', N'DEMO-RENZO', NULL, N'Polos para gimnasio Iron Box. Logo delantero y frase posterior.', N'APROBADA', CAST(N'2026-08-10T06:21:10.987' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (7, 11, 4, 15, N'M', N'Gris', N'Algodón perchado', N'Bordado', N'DEMO-CAMILA', NULL, N'Buzos para delegación deportiva universitaria.', N'APROBADA', CAST(N'2026-08-10T06:21:10.990' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (8, 12, 9, 50, N'L', N'Rojo', N'Poliéster', N'Sublimación', N'DEMO-SEBASTIAN', NULL, N'Uniformes para Deportivo Libertad. Escudo, dorsal y nombres.', N'APROBADA', CAST(N'2026-08-10T06:21:10.990' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (9, 13, 2, 35, N'S', N'Coral', N'Dry Fit', N'Sublimación', N'DEMO-LUCIANA', NULL, N'Polos para grupo Runners Norte, edición carrera 10K.', N'COTIZADA', CAST(N'2026-08-10T06:21:10.990' AS DateTime))
INSERT [dbo].[SolicitudConfeccion] ([SolicitudId], [ClienteId], [ProductoId], [Cantidad], [Talla], [Color], [Material], [TipoEstampado], [TextoPersonalizado], [ArchivoDisenoUrl], [Observaciones], [Estado], [FechaRegistro]) VALUES (10, 14, 11, 20, N'S', N'AZUL', N'Algodón', N'Serigrafía', N'EMMPRESA R', NULL, NULL, N'APROBADA', CAST(N'2026-08-11T23:04:45.353' AS DateTime))
SET IDENTITY_INSERT [dbo].[SolicitudConfeccion] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuario] ON 

INSERT [dbo].[Usuario] ([UsuarioId], [RolId], [Nombres], [Apellidos], [Correo], [ClaveHash], [Telefono], [Activo], [FechaRegistro]) VALUES (1, 1, N'Administrador', N'SportWear', N'admin@sportwear.com', N'0A5BC3E342432F1BAD92FFD51B785343EC72906CDBA6A26131060B008E786656', N'999999999', 1, CAST(N'2026-08-09T06:25:45.797' AS DateTime))
INSERT [dbo].[Usuario] ([UsuarioId], [RolId], [Nombres], [Apellidos], [Correo], [ClaveHash], [Telefono], [Activo], [FechaRegistro]) VALUES (2, 1, N'YANCARLOS', N'CALDERON ESPINOLA', N'YANCARLOS.CALDERON@SPORTWEAR.COM', N'8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', N'916284243', 1, CAST(N'2026-08-09T06:53:56.020' AS DateTime))
INSERT [dbo].[Usuario] ([UsuarioId], [RolId], [Nombres], [Apellidos], [Correo], [ClaveHash], [Telefono], [Activo], [FechaRegistro]) VALUES (3, 4, N'FABIO', N'CADENAS', N'FABIO.CADENAS@SPORTWEAR.COM', N'8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', N'985236854', 1, CAST(N'2026-08-10T03:01:44.613' AS DateTime))
INSERT [dbo].[Usuario] ([UsuarioId], [RolId], [Nombres], [Apellidos], [Correo], [ClaveHash], [Telefono], [Activo], [FechaRegistro]) VALUES (4, 3, N'JENNYFER', N'CHAVEZ TELLO', N'JENNYFER.CHAVEZ@SPORTWEAR.COM', N'8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', N'987654990', 1, CAST(N'2026-08-10T06:21:10.953' AS DateTime))
SET IDENTITY_INSERT [dbo].[Usuario] OFF
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UX_Categoria_Nombre_Activo] Fecha de script: 11/08/2026 23:20:30 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Categoria_Nombre_Activo] ON [dbo].[Categoria]
(
	[Nombre] ASC
)
WHERE ([Activo]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UX_Cliente_Documento_Activo] Fecha de script: 11/08/2026 23:20:30 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Cliente_Documento_Activo] ON [dbo].[Cliente]
(
	[Documento] ASC
)
WHERE ([Activo]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__ClienteA__60695A1931C4634F] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[ClienteAcceso] ADD UNIQUE NONCLUSTERED 
(
	[Correo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [UQ__ClienteA__71ABD0865A250F58] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[ClienteAcceso] ADD UNIQUE NONCLUSTERED 
(
	[ClienteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__Cotizaci__06370DAC736808C5] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[Cotizacion] ADD UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [UQ_Cotizacion_Solicitud] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[Cotizacion] ADD  CONSTRAINT [UQ_Cotizacion_Solicitud] UNIQUE NONCLUSTERED 
(
	[SolicitudId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_Cotizacion_UsuarioId] Fecha de script: 11/08/2026 23:20:30 ******/
CREATE NONCLUSTERED INDEX [IX_Cotizacion_UsuarioId] ON [dbo].[Cotizacion]
(
	[UsuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__EstadoPe__75E3EFCF5BA5DB1C] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[EstadoPedido] ADD UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__Pedido__06370DACD28FA5E5] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[Pedido] ADD UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [UQ_Pedido_Cotizacion] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[Pedido] ADD  CONSTRAINT [UQ_Pedido_Cotizacion] UNIQUE NONCLUSTERED 
(
	[CotizacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_Producto_CategoriaId] Fecha de script: 11/08/2026 23:20:30 ******/
CREATE NONCLUSTERED INDEX [IX_Producto_CategoriaId] ON [dbo].[Producto]
(
	[CategoriaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__Rol__75E3EFCF375020FC] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[Rol] ADD UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_Solicitud_ClienteId] Fecha de script: 11/08/2026 23:20:30 ******/
CREATE NONCLUSTERED INDEX [IX_Solicitud_ClienteId] ON [dbo].[SolicitudConfeccion]
(
	[ClienteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_Solicitud_ProductoId] Fecha de script: 11/08/2026 23:20:30 ******/
CREATE NONCLUSTERED INDEX [IX_Solicitud_ProductoId] ON [dbo].[SolicitudConfeccion]
(
	[ProductoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [UQ__Usuario__60695A19BAFDDDC3] Fecha de script: 11/08/2026 23:20:30 ******/
ALTER TABLE [dbo].[Usuario] ADD UNIQUE NONCLUSTERED 
(
	[Correo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categoria] ADD  CONSTRAINT [DF_Categoria_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Categoria] ADD  CONSTRAINT [DF_Categoria_FechaRegistro]  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_FechaRegistro]  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[ClienteAcceso] ADD  CONSTRAINT [DF_ClienteAcceso_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[ClienteAcceso] ADD  CONSTRAINT [DF_ClienteAcceso_FechaRegistro]  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Cotizacion] ADD  CONSTRAINT [DF_Cotizacion_Estado]  DEFAULT ('EMITIDA') FOR [Estado]
GO
ALTER TABLE [dbo].[Cotizacion] ADD  CONSTRAINT [DF_Cotizacion_FechaEmision]  DEFAULT (getdate()) FOR [FechaEmision]
GO
ALTER TABLE [dbo].[Cotizacion] ADD  CONSTRAINT [DF_Cotizacion_Descuento]  DEFAULT ((0)) FOR [DescuentoPorcentaje]
GO
ALTER TABLE [dbo].[EstadoPedido] ADD  CONSTRAINT [DF_EstadoPedido_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Pedido] ADD  CONSTRAINT [DF_Pedido_FechaPedido]  DEFAULT (getdate()) FOR [FechaPedido]
GO
ALTER TABLE [dbo].[Pedido] ADD  CONSTRAINT [DF_Pedido_Estado]  DEFAULT ('PENDIENTE') FOR [Estado]
GO
ALTER TABLE [dbo].[Producto] ADD  CONSTRAINT [DF_Producto_Personalizable]  DEFAULT ((0)) FOR [Personalizable]
GO
ALTER TABLE [dbo].[Producto] ADD  CONSTRAINT [DF_Producto_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Producto] ADD  CONSTRAINT [DF_Producto_FechaRegistro]  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Rol] ADD  CONSTRAINT [DF_Rol_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[SolicitudConfeccion] ADD  CONSTRAINT [DF_Solicitud_Estado]  DEFAULT ('PENDIENTE') FOR [Estado]
GO
ALTER TABLE [dbo].[SolicitudConfeccion] ADD  CONSTRAINT [DF_Solicitud_FechaRegistro]  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_FechaRegistro]  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[ClienteAcceso]  WITH CHECK ADD  CONSTRAINT [FK_ClienteAcceso_Cliente] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Cliente] ([ClienteId])
GO
ALTER TABLE [dbo].[ClienteAcceso] CHECK CONSTRAINT [FK_ClienteAcceso_Cliente]
GO
ALTER TABLE [dbo].[Cotizacion]  WITH CHECK ADD  CONSTRAINT [FK_Cotizacion_Solicitud] FOREIGN KEY([SolicitudId])
REFERENCES [dbo].[SolicitudConfeccion] ([SolicitudId])
GO
ALTER TABLE [dbo].[Cotizacion] CHECK CONSTRAINT [FK_Cotizacion_Solicitud]
GO
ALTER TABLE [dbo].[Cotizacion]  WITH CHECK ADD  CONSTRAINT [FK_Cotizacion_Usuario] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuario] ([UsuarioId])
GO
ALTER TABLE [dbo].[Cotizacion] CHECK CONSTRAINT [FK_Cotizacion_Usuario]
GO
ALTER TABLE [dbo].[Pedido]  WITH CHECK ADD  CONSTRAINT [FK_Pedido_Cotizacion] FOREIGN KEY([CotizacionId])
REFERENCES [dbo].[Cotizacion] ([CotizacionId])
GO
ALTER TABLE [dbo].[Pedido] CHECK CONSTRAINT [FK_Pedido_Cotizacion]
GO
ALTER TABLE [dbo].[Pedido]  WITH CHECK ADD  CONSTRAINT [FK_Pedido_EstadoPedido] FOREIGN KEY([EstadoPedidoId])
REFERENCES [dbo].[EstadoPedido] ([EstadoPedidoId])
GO
ALTER TABLE [dbo].[Pedido] CHECK CONSTRAINT [FK_Pedido_EstadoPedido]
GO
ALTER TABLE [dbo].[Pedido]  WITH CHECK ADD  CONSTRAINT [FK_Pedido_Usuario] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuario] ([UsuarioId])
GO
ALTER TABLE [dbo].[Pedido] CHECK CONSTRAINT [FK_Pedido_Usuario]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [FK_Producto_Categoria] FOREIGN KEY([CategoriaId])
REFERENCES [dbo].[Categoria] ([CategoriaId])
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [FK_Producto_Categoria]
GO
ALTER TABLE [dbo].[SolicitudConfeccion]  WITH CHECK ADD  CONSTRAINT [FK_Solicitud_Cliente] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Cliente] ([ClienteId])
GO
ALTER TABLE [dbo].[SolicitudConfeccion] CHECK CONSTRAINT [FK_Solicitud_Cliente]
GO
ALTER TABLE [dbo].[SolicitudConfeccion]  WITH CHECK ADD  CONSTRAINT [FK_Solicitud_Producto] FOREIGN KEY([ProductoId])
REFERENCES [dbo].[Producto] ([ProductoId])
GO
ALTER TABLE [dbo].[SolicitudConfeccion] CHECK CONSTRAINT [FK_Solicitud_Producto]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Rol] FOREIGN KEY([RolId])
REFERENCES [dbo].[Rol] ([RolId])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Rol]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [CK_Producto_PrecioBase] CHECK  (([PrecioBase]>(0)))
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [CK_Producto_PrecioBase]
GO
ALTER TABLE [dbo].[SolicitudConfeccion]  WITH CHECK ADD  CONSTRAINT [CK_Solicitud_Cantidad] CHECK  (([Cantidad]>(0)))
GO
ALTER TABLE [dbo].[SolicitudConfeccion] CHECK CONSTRAINT [CK_Solicitud_Cantidad]
GO
/****** Objeto: StoredProcedure [dbo].[sp_Categoria_Actualizar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Categoria_Actualizar]
    @CategoriaId INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(300) = NULL,
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Categoria
    SET Nombre = @Nombre,
        Descripcion = @Descripcion,
        Activo = @Activo
    WHERE CategoriaId = @CategoriaId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Categoria_Eliminar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Categoria_Eliminar]
    @CategoriaId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Categoria
    SET Activo = 0
    WHERE CategoriaId = @CategoriaId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Categoria_Insertar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Categoria_Insertar]
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Categoria (Nombre, Descripcion, Activo)
    VALUES (@Nombre, @Descripcion, 1);
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Categoria_Listar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Categoria_Listar]
    @Buscar NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CategoriaId, Nombre, Descripcion, Activo, FechaRegistro
    FROM dbo.Categoria
    WHERE @Buscar IS NULL
       OR LTRIM(RTRIM(@Buscar)) = ''
       OR Nombre LIKE '%' + @Buscar + '%'
       OR Descripcion LIKE '%' + @Buscar + '%'
    ORDER BY CategoriaId DESC;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Categoria_ListarActivas] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Categoria_ListarActivas]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CategoriaId, Nombre, Descripcion, Activo, FechaRegistro
    FROM dbo.Categoria
    WHERE Activo = 1
    ORDER BY Nombre;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Categoria_ListarPaginado] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Categoria_ListarPaginado]
    @Pagina INT,
    @Tamano INT,
    @Total INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Pagina < 1 SET @Pagina = 1;
    IF @Tamano < 1 SET @Tamano = 5;

    SELECT @Total = COUNT(*) FROM dbo.Categoria;

    SELECT CategoriaId, Nombre, Descripcion, Activo, FechaRegistro
    FROM dbo.Categoria
    ORDER BY CategoriaId DESC
    OFFSET (@Pagina - 1) * @Tamano ROWS
    FETCH NEXT @Tamano ROWS ONLY;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Categoria_ObtenerPorId] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Categoria_ObtenerPorId]
    @CategoriaId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CategoriaId, Nombre, Descripcion, Activo, FechaRegistro
    FROM dbo.Categoria
    WHERE CategoriaId = @CategoriaId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Cliente_Actualizar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cliente_Actualizar]
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

    UPDATE dbo.Cliente
    SET Nombres = @Nombres,
        Apellidos = @Apellidos,
        Documento = @Documento,
        Telefono = @Telefono,
        Correo = @Correo,
        Direccion = @Direccion,
        Activo = @Activo
    WHERE ClienteId = @ClienteId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Cliente_Eliminar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cliente_Eliminar]
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Cliente
    SET Activo = 0
    WHERE ClienteId = @ClienteId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Cliente_Insertar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Cliente_Insertar]
    @Nombres NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Documento NVARCHAR(15),
    @Telefono NVARCHAR(20) = NULL,
    @Correo NVARCHAR(120) = NULL,
    @Direccion NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Cliente
    (
        Nombres,
        Apellidos,
        Documento,
        Telefono,
        Correo,
        Direccion,
        Activo
    )
    VALUES
    (
        @Nombres,
        @Apellidos,
        @Documento,
        @Telefono,
        @Correo,
        @Direccion,
        1
    );

    SELECT CAST(
        SCOPE_IDENTITY() AS INT
    ) AS ClienteId;
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_Cliente_Listar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cliente_Listar]
    @Buscar NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ClienteId, Nombres, Apellidos, Documento,
        Telefono, Correo, Direccion, Activo, FechaRegistro
    FROM dbo.Cliente
    WHERE @Buscar IS NULL
       OR LTRIM(RTRIM(@Buscar)) = ''
       OR Nombres LIKE '%' + @Buscar + '%'
       OR Apellidos LIKE '%' + @Buscar + '%'
       OR Documento LIKE '%' + @Buscar + '%'
       OR Correo LIKE '%' + @Buscar + '%'
    ORDER BY ClienteId DESC;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Cliente_ListarActivos] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cliente_ListarActivos]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ClienteId, Nombres, Apellidos, Documento,
        Telefono, Correo, Direccion, Activo, FechaRegistro
    FROM dbo.Cliente
    WHERE Activo = 1
    ORDER BY Nombres, Apellidos;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Cliente_ListarPaginado] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cliente_ListarPaginado]
    @Pagina INT,
    @Tamano INT,
    @Total INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Pagina < 1 SET @Pagina = 1;
    IF @Tamano < 1 SET @Tamano = 5;

    SELECT @Total = COUNT(*) FROM dbo.Cliente;

    SELECT
        ClienteId, Nombres, Apellidos, Documento,
        Telefono, Correo, Direccion, Activo, FechaRegistro
    FROM dbo.Cliente
    ORDER BY ClienteId DESC
    OFFSET (@Pagina - 1) * @Tamano ROWS
    FETCH NEXT @Tamano ROWS ONLY;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Cliente_ObtenerPorDocumento] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Cliente_ObtenerPorDocumento]
    @Documento NVARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ClienteId,
        Nombres,
        Apellidos,
        Documento,
        Telefono,
        Correo,
        Direccion,
        Activo,
        FechaRegistro
    FROM dbo.Cliente
    WHERE Documento = @Documento;
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_Cliente_ObtenerPorId] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cliente_ObtenerPorId]
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ClienteId, Nombres, Apellidos, Documento,
        Telefono, Correo, Direccion, Activo, FechaRegistro
    FROM dbo.Cliente
    WHERE ClienteId = @ClienteId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_ClienteAcceso_Insertar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_ClienteAcceso_Insertar]
    @ClienteId INT,
    @Correo VARCHAR(150),
    @ClaveHash VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.ClienteAcceso
        WHERE ClienteId = @ClienteId
    )
    BEGIN
        THROW 50100,
              'El cliente ya tiene una cuenta registrada.',
              1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.ClienteAcceso
        WHERE Correo = @Correo
    )
    BEGIN
        THROW 50101,
              'El correo ya está registrado.',
              1;
    END;

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
        1
    );
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_ClienteAcceso_ObtenerPorCorreo] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_ClienteAcceso_ObtenerPorCorreo]
    @Correo VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        A.ClienteAccesoId,
        A.ClienteId,
        A.Correo,
        A.ClaveHash,
        A.Activo,
        A.FechaRegistro,

        C.Nombres,
        C.Apellidos

    FROM dbo.ClienteAcceso AS A

    INNER JOIN dbo.Cliente AS C
        ON A.ClienteId = C.ClienteId

    WHERE A.Correo = @Correo;
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_Cotizacion_Generar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cotizacion_Generar]
    @SolicitudId INT,
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @Cantidad INT,
        @PrecioBase DECIMAL(10,2),
        @TipoEstampado NVARCHAR(100),
        @CostoAdicional DECIMAL(10,2),
        @PrecioUnitario DECIMAL(10,2),
        @DescuentoPorcentaje DECIMAL(5,2),
        @SubtotalBruto DECIMAL(12,2),
        @Subtotal DECIMAL(12,2),
        @Igv DECIMAL(12,2),
        @Total DECIMAL(12,2),
        @Codigo VARCHAR(20);

    SELECT
        @Cantidad = S.Cantidad,
        @PrecioBase = P.PrecioBase,
        @TipoEstampado = S.TipoEstampado
    FROM dbo.SolicitudConfeccion AS S
    INNER JOIN dbo.Producto AS P
        ON S.ProductoId = P.ProductoId
    WHERE S.SolicitudId = @SolicitudId;

    IF @Cantidad IS NULL
        THROW 50020, 'La solicitud no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Cotizacion
        WHERE SolicitudId = @SolicitudId
    )
        THROW 50021, 'La solicitud ya tiene una cotización.', 1;

    SET @CostoAdicional =
        CASE
            WHEN @TipoEstampado = N'Sublimación' THEN 8.00
            WHEN @TipoEstampado = N'Serigrafía' THEN 5.00
            WHEN @TipoEstampado = N'Bordado' THEN 10.00
            ELSE 0.00
        END;

    SET @DescuentoPorcentaje =
        CASE
            WHEN @Cantidad >= 50 THEN 10.00
            WHEN @Cantidad >= 20 THEN 5.00
            ELSE 0.00
        END;

    SET @PrecioUnitario = @PrecioBase + @CostoAdicional;
    SET @SubtotalBruto = @Cantidad * @PrecioUnitario;
    SET @Subtotal = ROUND(
        @SubtotalBruto - (@SubtotalBruto * @DescuentoPorcentaje / 100),
        2
    );
    SET @Igv = ROUND(@Subtotal * 0.18, 2);
    SET @Total = @Subtotal + @Igv;
    SET @Codigo = 'COT-' + RIGHT('000000' + CAST(@SolicitudId AS VARCHAR(10)), 6);

    BEGIN TRANSACTION;

    INSERT INTO dbo.Cotizacion
    (
        SolicitudId, UsuarioId, Codigo, Estado,
        FechaEmision, FechaVencimiento,
        PrecioUnitario, DescuentoPorcentaje,
        Subtotal, Igv, Total, Observaciones
    )
    VALUES
    (
        @SolicitudId, @UsuarioId, @Codigo, 'EMITIDA',
        GETDATE(), DATEADD(DAY, 15, GETDATE()),
        @PrecioUnitario, @DescuentoPorcentaje,
        @Subtotal, @Igv, @Total,
        N'Cotización generada automáticamente.'
    );

    UPDATE dbo.SolicitudConfeccion
    SET Estado = 'COTIZADA'
    WHERE SolicitudId = @SolicitudId;

    COMMIT TRANSACTION;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Cotizacion_Listar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cotizacion_Listar]
    @Buscar NVARCHAR(120) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.CotizacionId,
        C.SolicitudId,
        C.UsuarioId,
        C.Codigo,
        C.Estado,
        C.FechaEmision,
        C.FechaVencimiento,
        C.PrecioUnitario,
        C.DescuentoPorcentaje,
        C.Subtotal,
        C.Igv,
        C.Total,
        C.Observaciones,
        C.PdfUrl,
        CONCAT(CL.Nombres, ' ', CL.Apellidos) AS NombreCliente,
        P.Nombre AS NombreProducto,
        S.Cantidad
    FROM dbo.Cotizacion AS C
    INNER JOIN dbo.SolicitudConfeccion AS S
        ON C.SolicitudId = S.SolicitudId
    INNER JOIN dbo.Cliente AS CL
        ON S.ClienteId = CL.ClienteId
    INNER JOIN dbo.Producto AS P
        ON S.ProductoId = P.ProductoId
    WHERE @Buscar IS NULL
       OR LTRIM(RTRIM(@Buscar)) = ''
       OR C.Codigo LIKE '%' + @Buscar + '%'
       OR CL.Nombres LIKE '%' + @Buscar + '%'
       OR CL.Apellidos LIKE '%' + @Buscar + '%'
       OR P.Nombre LIKE '%' + @Buscar + '%'
       OR C.Estado LIKE '%' + @Buscar + '%'
    ORDER BY C.CotizacionId DESC;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Cotizacion_ListarPorCliente] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Cotizacion_ListarPorCliente]
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.CotizacionId,
        C.SolicitudId,
        C.UsuarioId,
        C.Codigo,
        C.Estado,
        C.FechaEmision,
        C.FechaVencimiento,
        C.PrecioUnitario,
        C.DescuentoPorcentaje,
        C.Subtotal,
        C.Igv,
        C.Total,
        C.Observaciones,
        C.PdfUrl,

        CONCAT(CL.Nombres, ' ', CL.Apellidos)
            AS NombreCliente,

        P.Nombre AS NombreProducto,

        S.Cantidad

    FROM dbo.Cotizacion AS C

    INNER JOIN dbo.SolicitudConfeccion AS S
        ON C.SolicitudId = S.SolicitudId

    INNER JOIN dbo.Cliente AS CL
        ON S.ClienteId = CL.ClienteId

    INNER JOIN dbo.Producto AS P
        ON S.ProductoId = P.ProductoId

    WHERE S.ClienteId = @ClienteId

    ORDER BY C.CotizacionId DESC;
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_Cotizacion_ObtenerPorId] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Cotizacion_ObtenerPorId]
    @CotizacionId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.CotizacionId,
        C.SolicitudId,
        C.UsuarioId,
        C.Codigo,
        C.Estado,
        C.FechaEmision,
        C.FechaVencimiento,
        C.PrecioUnitario,
        C.DescuentoPorcentaje,
        C.Subtotal,
        C.Igv,
        C.Total,
        C.Observaciones,
        C.PdfUrl,
        CONCAT(CL.Nombres, ' ', CL.Apellidos) AS NombreCliente,
        P.Nombre AS NombreProducto,
        S.Cantidad,
        CL.Documento,
        CL.Telefono,
        CL.Correo,
        S.Talla,
        S.Color,
        S.Material,
        S.TipoEstampado,
        S.TextoPersonalizado
    FROM dbo.Cotizacion AS C
    INNER JOIN dbo.SolicitudConfeccion AS S
        ON C.SolicitudId = S.SolicitudId
    INNER JOIN dbo.Cliente AS CL
        ON S.ClienteId = CL.ClienteId
    INNER JOIN dbo.Producto AS P
        ON S.ProductoId = P.ProductoId
    WHERE C.CotizacionId = @CotizacionId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_EstadoPedido_Listar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_EstadoPedido_Listar]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT EstadoPedidoId, Nombre, Orden, Activo
    FROM dbo.EstadoPedido
    WHERE Activo = 1
    ORDER BY Orden;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Pedido_ActualizarEstado] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Pedido_ActualizarEstado]
    @PedidoId INT,
    @EstadoPedidoId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NombreEstado NVARCHAR(50);

    IF NOT EXISTS (SELECT 1 FROM dbo.Pedido WHERE PedidoId = @PedidoId)
        THROW 50044, 'El pedido no existe.', 1;

    SELECT @NombreEstado = Nombre
    FROM dbo.EstadoPedido
    WHERE EstadoPedidoId = @EstadoPedidoId AND Activo = 1;

    IF @NombreEstado IS NULL
        THROW 50045, 'El estado seleccionado no existe o está inactivo.', 1;

    UPDATE dbo.Pedido
    SET EstadoPedidoId = @EstadoPedidoId,
        Estado = @NombreEstado
    WHERE PedidoId = @PedidoId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Pedido_Generar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Pedido_Generar]
    @CotizacionId INT,
    @UsuarioId INT,
    @FechaEntregaEstimada DATE = NULL,
    @Destinatario NVARCHAR(150) = NULL,
    @TelefonoEntrega NVARCHAR(20) = NULL,
    @DireccionEntrega NVARCHAR(250) = NULL,
    @DistritoEntrega NVARCHAR(100) = NULL,
    @ReferenciaEntrega NVARCHAR(250) = NULL,
    @Observaciones NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @EstadoPedidoId INT,
        @Subtotal DECIMAL(12,2),
        @Igv DECIMAL(12,2),
        @Total DECIMAL(12,2),
        @Codigo VARCHAR(20);

    IF NOT EXISTS (SELECT 1 FROM dbo.Usuario WHERE UsuarioId = @UsuarioId AND Activo = 1)
        THROW 50040, 'El usuario no existe o está inactivo.', 1;

    IF EXISTS (SELECT 1 FROM dbo.Pedido WHERE CotizacionId = @CotizacionId)
        THROW 50041, 'La cotización ya tiene un pedido registrado.', 1;

    SELECT @Subtotal = Subtotal, @Igv = Igv, @Total = Total
    FROM dbo.Cotizacion
    WHERE CotizacionId = @CotizacionId;

    IF @Total IS NULL
        THROW 50042, 'La cotización indicada no existe.', 1;

    SELECT TOP (1) @EstadoPedidoId = EstadoPedidoId
    FROM dbo.EstadoPedido
    WHERE Nombre = N'APROBADO' AND Activo = 1
    ORDER BY Orden;

    IF @EstadoPedidoId IS NULL
        THROW 50043, 'No existe el estado inicial APROBADO.', 1;

    SET @Codigo = 'PED-' + RIGHT('000000' + CAST(@CotizacionId AS VARCHAR(10)), 6);

    BEGIN TRANSACTION;

    INSERT INTO dbo.Pedido
    (
        UsuarioId, CotizacionId, EstadoPedidoId, Codigo,
        FechaEntregaEstimada, Destinatario, TelefonoEntrega,
        DireccionEntrega, DistritoEntrega, ReferenciaEntrega,
        Subtotal, Igv, Total, Observaciones, Estado
    )
    VALUES
    (
        @UsuarioId, @CotizacionId, @EstadoPedidoId, @Codigo,
        @FechaEntregaEstimada, NULLIF(LTRIM(RTRIM(@Destinatario)), ''),
        NULLIF(LTRIM(RTRIM(@TelefonoEntrega)), ''),
        NULLIF(LTRIM(RTRIM(@DireccionEntrega)), ''),
        NULLIF(LTRIM(RTRIM(@DistritoEntrega)), ''),
        NULLIF(LTRIM(RTRIM(@ReferenciaEntrega)), ''),
        @Subtotal, @Igv, @Total,
        NULLIF(LTRIM(RTRIM(@Observaciones)), ''), N'APROBADO'
    );

    UPDATE dbo.Cotizacion
    SET Estado = N'APROBADA'
    WHERE CotizacionId = @CotizacionId;

    UPDATE S
    SET S.Estado = N'APROBADA'
    FROM dbo.SolicitudConfeccion AS S
    INNER JOIN dbo.Cotizacion AS C ON S.SolicitudId = C.SolicitudId
    WHERE C.CotizacionId = @CotizacionId;

    COMMIT TRANSACTION;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Pedido_Listar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Pedido_Listar]
    @Buscar NVARCHAR(120) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        PE.PedidoId, PE.UsuarioId, PE.CotizacionId, PE.EstadoPedidoId,
        PE.Codigo, PE.FechaPedido, PE.FechaEntregaEstimada,
        PE.Destinatario, PE.TelefonoEntrega, PE.DireccionEntrega,
        PE.DistritoEntrega, PE.ReferenciaEntrega,
        PE.Subtotal, PE.Igv, PE.Total, PE.Observaciones, PE.Estado,
        EP.Nombre AS NombreEstado,
        C.Codigo AS CodigoCotizacion,
        CONCAT(CL.Nombres, ' ', CL.Apellidos) AS NombreCliente,
        P.Nombre AS NombreProducto,
        S.Cantidad
    FROM dbo.Pedido AS PE
    INNER JOIN dbo.EstadoPedido AS EP ON PE.EstadoPedidoId = EP.EstadoPedidoId
    INNER JOIN dbo.Cotizacion AS C ON PE.CotizacionId = C.CotizacionId
    INNER JOIN dbo.SolicitudConfeccion AS S ON C.SolicitudId = S.SolicitudId
    INNER JOIN dbo.Cliente AS CL ON S.ClienteId = CL.ClienteId
    INNER JOIN dbo.Producto AS P ON S.ProductoId = P.ProductoId
    WHERE @Buscar IS NULL OR LTRIM(RTRIM(@Buscar)) = ''
       OR PE.Codigo LIKE '%' + @Buscar + '%'
       OR C.Codigo LIKE '%' + @Buscar + '%'
       OR CL.Nombres LIKE '%' + @Buscar + '%'
       OR CL.Apellidos LIKE '%' + @Buscar + '%'
       OR P.Nombre LIKE '%' + @Buscar + '%'
       OR EP.Nombre LIKE '%' + @Buscar + '%'
    ORDER BY PE.PedidoId DESC;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Pedido_ListarPorCliente] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Pedido_ListarPorCliente]
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        PE.PedidoId,
        PE.UsuarioId,
        PE.CotizacionId,
        PE.EstadoPedidoId,
        PE.Codigo,
        PE.FechaPedido,
        PE.FechaEntregaEstimada,
        PE.Destinatario,
        PE.TelefonoEntrega,
        PE.DireccionEntrega,
        PE.DistritoEntrega,
        PE.ReferenciaEntrega,
        PE.Subtotal,
        PE.Igv,
        PE.Total,
        PE.Observaciones,
        PE.Estado,

        EP.Nombre AS NombreEstado,

        C.Codigo AS CodigoCotizacion,

        CONCAT(CL.Nombres, ' ', CL.Apellidos)
            AS NombreCliente,

        P.Nombre AS NombreProducto,

        S.Cantidad

    FROM dbo.Pedido AS PE

    INNER JOIN dbo.EstadoPedido AS EP
        ON PE.EstadoPedidoId =
           EP.EstadoPedidoId

    INNER JOIN dbo.Cotizacion AS C
        ON PE.CotizacionId =
           C.CotizacionId

    INNER JOIN dbo.SolicitudConfeccion AS S
        ON C.SolicitudId =
           S.SolicitudId

    INNER JOIN dbo.Cliente AS CL
        ON S.ClienteId =
           CL.ClienteId

    INNER JOIN dbo.Producto AS P
        ON S.ProductoId =
           P.ProductoId

    WHERE S.ClienteId = @ClienteId

    ORDER BY PE.PedidoId DESC;
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_Pedido_ObtenerPorId] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Pedido_ObtenerPorId]
    @PedidoId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        PE.PedidoId, PE.UsuarioId, PE.CotizacionId, PE.EstadoPedidoId,
        PE.Codigo, PE.FechaPedido, PE.FechaEntregaEstimada,
        PE.Destinatario, PE.TelefonoEntrega, PE.DireccionEntrega,
        PE.DistritoEntrega, PE.ReferenciaEntrega,
        PE.Subtotal, PE.Igv, PE.Total, PE.Observaciones, PE.Estado,
        EP.Nombre AS NombreEstado,
        C.Codigo AS CodigoCotizacion,
        CONCAT(CL.Nombres, ' ', CL.Apellidos) AS NombreCliente,
        P.Nombre AS NombreProducto,
        S.Cantidad, CL.Documento,
        CL.Telefono AS TelefonoCliente, CL.Correo,
        S.Talla, S.Color, S.Material, S.TipoEstampado
    FROM dbo.Pedido AS PE
    INNER JOIN dbo.EstadoPedido AS EP ON PE.EstadoPedidoId = EP.EstadoPedidoId
    INNER JOIN dbo.Cotizacion AS C ON PE.CotizacionId = C.CotizacionId
    INNER JOIN dbo.SolicitudConfeccion AS S ON C.SolicitudId = S.SolicitudId
    INNER JOIN dbo.Cliente AS CL ON S.ClienteId = CL.ClienteId
    INNER JOIN dbo.Producto AS P ON S.ProductoId = P.ProductoId
    WHERE PE.PedidoId = @PedidoId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Producto_Actualizar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Producto_Actualizar]
    @ProductoId INT,
    @CategoriaId INT,
    @Nombre NVARCHAR(120),
    @Descripcion NVARCHAR(500) = NULL,
    @PrecioBase DECIMAL(10,2),
    @ImagenUrl NVARCHAR(500) = NULL,
    @Personalizable BIT,
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Producto
    SET CategoriaId = @CategoriaId,
        Nombre = @Nombre,
        Descripcion = @Descripcion,
        PrecioBase = @PrecioBase,
        ImagenUrl = @ImagenUrl,
        Personalizable = @Personalizable,
        Activo = @Activo
    WHERE ProductoId = @ProductoId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Producto_Eliminar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Producto_Eliminar]
    @ProductoId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Producto
    SET Activo = 0
    WHERE ProductoId = @ProductoId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Producto_Insertar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Producto_Insertar]
    @CategoriaId INT,
    @Nombre NVARCHAR(120),
    @Descripcion NVARCHAR(500) = NULL,
    @PrecioBase DECIMAL(10,2),
    @ImagenUrl NVARCHAR(500) = NULL,
    @Personalizable BIT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Producto
    (
        CategoriaId, Nombre, Descripcion, PrecioBase,
        ImagenUrl, Personalizable, Activo
    )
    VALUES
    (
        @CategoriaId, @Nombre, @Descripcion, @PrecioBase,
        @ImagenUrl, @Personalizable, 1
    );
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Producto_Listar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Producto_Listar]
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
        P.Activo,
        P.FechaRegistro
    FROM dbo.Producto AS P
    INNER JOIN dbo.Categoria AS C
        ON P.CategoriaId = C.CategoriaId
    WHERE @Buscar IS NULL
       OR LTRIM(RTRIM(@Buscar)) = ''
       OR P.Nombre LIKE '%' + @Buscar + '%'
       OR C.Nombre LIKE '%' + @Buscar + '%'
    ORDER BY P.ProductoId DESC;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Producto_ListarPaginado] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Producto_ListarPaginado]
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
        P.Activo,
        P.FechaRegistro
    FROM dbo.Producto AS P
    INNER JOIN dbo.Categoria AS C
        ON P.CategoriaId = C.CategoriaId
    ORDER BY P.ProductoId DESC
    OFFSET (@Pagina - 1) * @Tamano ROWS
    FETCH NEXT @Tamano ROWS ONLY;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Producto_ListarPersonalizables] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Producto_ListarPersonalizables]
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
        P.Activo,
        P.FechaRegistro
    FROM dbo.Producto AS P
    INNER JOIN dbo.Categoria AS C
        ON P.CategoriaId = C.CategoriaId
    WHERE P.Activo = 1
      AND P.Personalizable = 1
    ORDER BY P.Nombre;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Producto_ObtenerPorId] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Producto_ObtenerPorId]
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
        P.Activo,
        P.FechaRegistro
    FROM dbo.Producto AS P
    INNER JOIN dbo.Categoria AS C
        ON P.CategoriaId = C.CategoriaId
    WHERE P.ProductoId = @ProductoId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Reporte_ResumenGeneral] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Reporte_ResumenGeneral]
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
            FROM dbo.Pedido AS P
            INNER JOIN dbo.EstadoPedido AS EP
                ON P.EstadoPedidoId = EP.EstadoPedidoId
            WHERE EP.Nombre NOT IN ('ENTREGADO', 'CANCELADO')
        ) AS PedidosPendientes,
        (SELECT ISNULL(SUM(Total), 0) FROM dbo.Pedido WHERE Estado <> 'CANCELADO') AS TotalVentas;

    SELECT
        EP.Nombre AS Estado,
        COUNT(P.PedidoId) AS Cantidad,
        ISNULL(SUM(P.Total), 0) AS Total
    FROM dbo.EstadoPedido AS EP
    LEFT JOIN dbo.Pedido AS P
        ON EP.EstadoPedidoId = P.EstadoPedidoId
    WHERE EP.Activo = 1
    GROUP BY EP.EstadoPedidoId, EP.Nombre, EP.Orden
    ORDER BY EP.Orden;

    SELECT TOP (5)
        PR.ProductoId,
        PR.Nombre AS Producto,
        COUNT(S.SolicitudId) AS TotalSolicitudes,
        ISNULL(SUM(S.Cantidad), 0) AS TotalUnidades
    FROM dbo.Producto AS PR
    LEFT JOIN dbo.SolicitudConfeccion AS S
        ON PR.ProductoId = S.ProductoId
    WHERE PR.Activo = 1
    GROUP BY PR.ProductoId, PR.Nombre
    ORDER BY TotalSolicitudes DESC, TotalUnidades DESC, PR.Nombre;

    SELECT TOP (5)
        C.ClienteId,
        CONCAT(C.Nombres, ' ', C.Apellidos) AS Cliente,
        COUNT(S.SolicitudId) AS TotalSolicitudes,
        ISNULL(SUM(CO.Total), 0) AS TotalCotizado
    FROM dbo.Cliente AS C
    LEFT JOIN dbo.SolicitudConfeccion AS S
        ON C.ClienteId = S.ClienteId
    LEFT JOIN dbo.Cotizacion AS CO
        ON S.SolicitudId = CO.SolicitudId
    WHERE C.Activo = 1
    GROUP BY C.ClienteId, C.Nombres, C.Apellidos
    ORDER BY TotalSolicitudes DESC, TotalCotizado DESC, Cliente;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Rol_ListarActivos] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Rol_ListarActivos]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT RolId, Nombre, Descripcion, Activo
    FROM dbo.Rol
    WHERE Activo = 1
    ORDER BY Nombre;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_SolicitudConfeccion_ActualizarEstado] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SolicitudConfeccion_ActualizarEstado]
    @SolicitudId INT,
    @Estado NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.SolicitudConfeccion
    SET Estado = @Estado
    WHERE SolicitudId = @SolicitudId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_SolicitudConfeccion_Insertar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SolicitudConfeccion_Insertar]
    @ClienteId INT,
    @ProductoId INT,
    @Cantidad INT,
    @Talla NVARCHAR(20),
    @Color NVARCHAR(50),
    @Material NVARCHAR(100),
    @TipoEstampado NVARCHAR(100) = NULL,
    @TextoPersonalizado NVARCHAR(150) = NULL,
    @ArchivoDisenoUrl NVARCHAR(500) = NULL,
    @Observaciones NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SolicitudConfeccion
    (
        ClienteId, ProductoId, Cantidad, Talla, Color,
        Material, TipoEstampado, TextoPersonalizado,
        ArchivoDisenoUrl, Observaciones, Estado
    )
    VALUES
    (
        @ClienteId, @ProductoId, @Cantidad, @Talla, @Color,
        @Material, @TipoEstampado, @TextoPersonalizado,
        @ArchivoDisenoUrl, @Observaciones, 'PENDIENTE'
    );
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_SolicitudConfeccion_Listar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SolicitudConfeccion_Listar]
    @Buscar NVARCHAR(120) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        S.SolicitudId,
        S.ClienteId,
        CONCAT(C.Nombres, ' ', C.Apellidos) AS NombreCliente,
        S.ProductoId,
        P.Nombre AS NombreProducto,
        S.Cantidad,
        S.Talla,
        S.Color,
        S.Material,
        S.TipoEstampado,
        S.TextoPersonalizado,
        S.ArchivoDisenoUrl,
        S.Observaciones,
        S.Estado,
        S.FechaRegistro
    FROM dbo.SolicitudConfeccion AS S
    INNER JOIN dbo.Cliente AS C
        ON S.ClienteId = C.ClienteId
    INNER JOIN dbo.Producto AS P
        ON S.ProductoId = P.ProductoId
    WHERE @Buscar IS NULL
       OR LTRIM(RTRIM(@Buscar)) = ''
       OR C.Nombres LIKE '%' + @Buscar + '%'
       OR C.Apellidos LIKE '%' + @Buscar + '%'
       OR P.Nombre LIKE '%' + @Buscar + '%'
       OR S.Estado LIKE '%' + @Buscar + '%'
    ORDER BY S.SolicitudId DESC;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_SolicitudConfeccion_ListarPorCliente] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_SolicitudConfeccion_ListarPorCliente]
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        S.SolicitudId,
        S.ClienteId,
        CONCAT(C.Nombres, ' ', C.Apellidos) AS NombreCliente,
        S.ProductoId,
        P.Nombre AS NombreProducto,
        S.Cantidad,
        S.Talla,
        S.Color,
        S.Material,
        S.TipoEstampado,
        S.TextoPersonalizado,
        S.ArchivoDisenoUrl,
        S.Observaciones,
        S.Estado,
        S.FechaRegistro
    FROM dbo.SolicitudConfeccion AS S
    INNER JOIN dbo.Cliente AS C
        ON S.ClienteId = C.ClienteId
    INNER JOIN dbo.Producto AS P
        ON S.ProductoId = P.ProductoId
    WHERE S.ClienteId = @ClienteId
    ORDER BY S.SolicitudId DESC;
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_SolicitudConfeccion_ObtenerPorId] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SolicitudConfeccion_ObtenerPorId]
    @SolicitudId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        S.SolicitudId,
        S.ClienteId,
        CONCAT(C.Nombres, ' ', C.Apellidos) AS NombreCliente,
        S.ProductoId,
        P.Nombre AS NombreProducto,
        S.Cantidad,
        S.Talla,
        S.Color,
        S.Material,
        S.TipoEstampado,
        S.TextoPersonalizado,
        S.ArchivoDisenoUrl,
        S.Observaciones,
        S.Estado,
        S.FechaRegistro
    FROM dbo.SolicitudConfeccion AS S
    INNER JOIN dbo.Cliente AS C
        ON S.ClienteId = C.ClienteId
    INNER JOIN dbo.Producto AS P
        ON S.ProductoId = P.ProductoId
    WHERE S.SolicitudId = @SolicitudId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Usuario_Actualizar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Usuario_Actualizar]
    @UsuarioId INT,
    @RolId INT,
    @Nombres NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Correo VARCHAR(150),
    @Telefono NVARCHAR(20) = NULL,
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.Usuario WHERE Correo = @Correo AND UsuarioId <> @UsuarioId)
        THROW 50102, 'Ya existe otro usuario con ese correo.', 1;
    UPDATE dbo.Usuario
    SET RolId = @RolId, Nombres = @Nombres, Apellidos = @Apellidos,
        Correo = @Correo, Telefono = @Telefono, Activo = @Activo
    WHERE UsuarioId = @UsuarioId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Usuario_CambiarClave] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Usuario_CambiarClave]
    @UsuarioId INT,
    @ClaveHash VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Usuario SET ClaveHash = @ClaveHash WHERE UsuarioId = @UsuarioId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Usuario_Eliminar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Usuario_Eliminar]
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Usuario SET Activo = 0 WHERE UsuarioId = @UsuarioId;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Usuario_Insertar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Usuario_Insertar]
    @RolId INT,
    @Nombres NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Correo VARCHAR(150),
    @ClaveHash VARCHAR(64),
    @Telefono NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.Usuario WHERE Correo = @Correo)
        THROW 50100, 'Ya existe un usuario con ese correo.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE RolId = @RolId AND Activo = 1)
        THROW 50101, 'El rol seleccionado no existe o está inactivo.', 1;
    INSERT INTO dbo.Usuario (RolId, Nombres, Apellidos, Correo, ClaveHash, Telefono, Activo)
    VALUES (@RolId, @Nombres, @Apellidos, @Correo, @ClaveHash, @Telefono, 1);
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Usuario_Listar] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Usuario_Listar]
    @Buscar NVARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT U.UsuarioId, U.RolId, R.Nombre AS NombreRol,
           U.Nombres, U.Apellidos, U.Correo, U.ClaveHash,
           U.Telefono, U.Activo, U.FechaRegistro
    FROM dbo.Usuario U
    INNER JOIN dbo.Rol R ON U.RolId = R.RolId
    WHERE @Buscar IS NULL OR LTRIM(RTRIM(@Buscar)) = ''
       OR U.Nombres LIKE '%' + @Buscar + '%'
       OR U.Apellidos LIKE '%' + @Buscar + '%'
       OR U.Correo LIKE '%' + @Buscar + '%'
       OR R.Nombre LIKE '%' + @Buscar + '%'
    ORDER BY U.UsuarioId DESC;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Usuario_ObtenerPorCorreo] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Usuario_ObtenerPorCorreo]
    @Correo VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT U.UsuarioId, U.RolId, R.Nombre AS NombreRol,
           U.Nombres, U.Apellidos, U.Correo, U.ClaveHash,
           U.Telefono, U.Activo, U.FechaRegistro
    FROM dbo.Usuario U
    INNER JOIN dbo.Rol R ON U.RolId = R.RolId
    WHERE U.Correo = @Correo AND U.Activo = 1;
END;

GO
/****** Objeto: StoredProcedure [dbo].[sp_Usuario_ObtenerPorId] Fecha de script: 11/08/2026 23:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Usuario_ObtenerPorId]
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT U.UsuarioId, U.RolId, R.Nombre AS NombreRol,
           U.Nombres, U.Apellidos, U.Correo, U.ClaveHash,
           U.Telefono, U.Activo, U.FechaRegistro
    FROM dbo.Usuario U
    INNER JOIN dbo.Rol R ON U.RolId = R.RolId
    WHERE U.UsuarioId = @UsuarioId;
END;

GO
USE [master]
GO
ALTER DATABASE [SportWearDB] SET  READ_WRITE 
GO


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


/* CIERRE FINAL CLIENTES Y SEGURIDAD */

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
