# SportWear

Aplicación web desarrollada en **ASP.NET Core MVC (.NET 8)** para la venta de ropa deportiva y la gestión de confecciones personalizadas.

## Tecnologías

- ASP.NET Core MVC (.NET 8)
- ADO.NET
- SQL Server
- Procedimientos almacenados
- Web API REST
- JavaScript, AJAX y JSON
- Session
- QuestPDF
- CSS y Bootstrap Icons

## Funcionalidades principales

### Portal del cliente

- Catálogo de productos de venta directa.
- Catálogo de productos personalizables.
- Carrito de compras y validación de stock.
- Favoritos.
- Registro e inicio de sesión mediante `Cliente` + `ClienteAcceso`.
- Compras y seguimiento de pedidos.
- Solicitudes de confección personalizada.
- Cotizaciones y proformas PDF.
- Cambio de contraseña desde Mi Cuenta.

### Administración

- Dashboard y reportes.
- CRUD de categorías, productos y clientes.
- Gestión de stock.
- Gestión de solicitudes de confección.
- Cotizaciones y generación de PDF.
- Pedidos personalizados por etapas.
- Ventas directas y actualización de estado.
- Usuarios internos y perfiles.

## Perfiles internos

- **ADMINISTRADOR:** acceso completo.
- **VENTAS:** productos, clientes, solicitudes, cotizaciones, pedidos y ventas.
- **PRODUCCION:** solicitudes de confección y pedidos personalizados.

Los clientes utilizan un acceso independiente mediante `ClientePortal`.

## Flujos principales

### Venta directa

```text
Producto no personalizable
-> Catálogo
-> Carrito
-> Login cliente
-> Confirmar compra
-> Validar stock
-> Venta + VentaDetalle
-> Descontar stock
-> REGISTRADA -> PREPARANDO -> LISTA -> ENTREGADA
```

### Confección personalizada

```text
Producto personalizable
-> Solicitud
-> Cotización
-> PDF / Proforma
-> Pedido
-> APROBADO -> DISEÑO -> CONFECCION -> LISTO -> ENTREGADO
```

## Base de datos

Los scripts se encuentran en la carpeta `SQL`.

Para una instalación nueva ejecutar, en este orden:

1. `SQL/01_SportWearDB_Completa.sql`
2. `SQL/04_Productos_Catalogo_Imagenes.sql`
3. `SQL/05_Tallas_VentaDirecta_Final.sql`
4. `SQL/06_Cierre_Clientes_Seguridad.sql`
5. `SQL/07_Cierre_Clientes_Definitivo.sql`

Consulta `SQL/README_SQL.txt` para más detalles.

## Configuración de conexión

En desarrollo local la aplicación utiliza la cadena `SportWearDB` definida en `appsettings.json`.

```text
Server=localhost;Database=SportWearDB;Trusted_Connection=True;TrustServerCertificate=True;
```

En producción la cadena debe configurarse como variable/cadena de conexión del proveedor de hosting. No se deben guardar contraseñas de producción en el repositorio.

## Ejecución local

```bash
dotnet restore
dotnet run --project SportWear.Web.csproj
```

## Despliegue

El repositorio incluye un workflow de GitHub Actions en `.github/workflows` para publicar la aplicación ASP.NET Core.

## Seguridad

Las contraseñas se almacenan como hash y las credenciales reales de acceso no se publican en este repositorio.
