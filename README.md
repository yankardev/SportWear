# SportWear

Aplicación web en **ASP.NET Core MVC (.NET 8)** para dos líneas de negocio:

1. **Venta directa de ropa deportiva** con precio fijo, stock, carrito, favoritos y seguimiento de compras.
2. **Confección personalizada** con solicitud, cotización, PDF y pedido por etapas.

## Tecnologías

- ASP.NET Core MVC
- ADO.NET
- SQL Server
- Procedimientos almacenados
- Web API REST
- JavaScript, AJAX y JSON
- Session para carrito temporal
- QuestPDF
- CSS y Bootstrap Icons

## Portal cliente

- Inicio y catálogo de venta directa (`Personalizable = 0`).
- Catálogo de productos personalizados (`Personalizable = 1`).
- Carrito de compras con actualización de cantidades.
- Validación de stock.
- Confirmación de compra y descuento transaccional de stock.
- Favoritos.
- Mi cuenta con compras de tienda, solicitudes, proformas y pedidos personalizados.
- Registro e inicio de sesión mediante `Cliente` + `ClienteAcceso`.
- Cambio de contraseña desde Mi Cuenta con validación de la contraseña actual.

## Administración

- Productos con stock para venta directa.
- Categorías.
- Clientes.
- Solicitudes de confección.
- Cotizaciones + PDF.
- Pedidos personalizados por etapas.
- Ventas directas y actualización de su estado.
- Usuarios internos por perfil.
- Dashboard y reportes.

## Perfiles internos

- **ADMINISTRADOR:** acceso completo.
- **VENTAS:** productos, clientes, solicitudes, cotizaciones, pedidos y ventas directas.
- **PRODUCCION:** solicitudes de confección y pedidos personalizados.

Los clientes no se crean desde el mantenimiento de Usuario. Utilizan `ClientePortal`.

## Flujos

### Venta directa

```text
Producto no personalizable
-> Catálogo
-> Carrito
-> Login cliente (si aún no inició sesión)
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

Consulta `SQL/README_SQL.txt`.

- Base nueva: ejecutar `SQL/01_SportWearDB_Completa.sql`, luego `SQL/04_Productos_Catalogo_Imagenes.sql`, `SQL/05_Tallas_VentaDirecta_Final.sql` y `SQL/06_Cierre_Clientes_Seguridad.sql`.
- Base existente que ya tiene venta directa: ejecutar `SQL/06_Cierre_Clientes_Seguridad.sql` para aplicar los ajustes finales de clientes y seguridad.

## Cadena local incluida

```text
Server=localhost;Database=SportWearDB;Trusted_Connection=True;TrustServerCertificate=True;
```

Adáptala en `appsettings.json` si tu instancia de SQL Server tiene otro nombre.

## Acceso de demostración

El sistema incluye perfiles de Administrador, Ventas, Producción y Cliente.

Por seguridad, las credenciales de acceso no se almacenan públicamente en este repositorio.
