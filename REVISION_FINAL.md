# Revisión final de SportWear

## Alcance incorporado

Se mantuvo el proceso existente de confección personalizada:

`Solicitud -> Cotización -> PDF -> Pedido -> APROBADO -> DISEÑO -> CONFECCION -> LISTO -> ENTREGADO`

Y se agregó una segunda línea de negocio para productos de venta directa:

`Catálogo -> Carrito -> Login cliente -> Confirmar compra -> Venta -> Seguimiento`

### Venta directa
- `Producto.Personalizable = false` identifica prendas de precio fijo.
- Stock por producto.
- Carrito almacenado en Session.
- Actualización y eliminación de cantidades.
- Validación de stock.
- Checkout para clientes autenticados.
- Registro transaccional de Venta y VentaDetalle.
- Descuento automático de stock.
- Historial de compras en Mi Cuenta.
- Gestión de ventas directas para ADMINISTRADOR y VENTAS.

### Personalizados
- `Producto.Personalizable = true`.
- Se conserva la solicitud de cotización.
- Talla, color, material y tipo de estampado mediante desplegables.
- Cotización y PDF.
- Pedido y avance de estados.
- Opción para registrar otra solicitud del mismo cliente.

### Portal cliente
- Catálogo.
- Personalizados.
- Carrito con contador.
- Mis pedidos / Mi Cuenta.
- Favoritos.
- Proformas.
- Login y registro.
- Retorno al checkout después de iniciar sesión.

### Administración
- ADMINISTRADOR mantiene acceso completo.
- VENTAS accede a los módulos comerciales y a Ventas directas.
- PRODUCCION mantiene Confección y Pedidos.
- CLIENTE continúa usando ClientePortal y no puede crearse desde Usuarios.

## Base de datos

Para una base `SportWearDB` YA existente ejecutar solamente:

`SQL/03_VentaDirecta_Carrito_Favoritos.sql`

Para instalar desde cero en otra PC:

`SQL/01_SportWearDB_Completa.sql`

La migración agrega:
- `Producto.Stock`
- `Venta`
- `VentaDetalle`
- `Favorito`
- tipo tabla `dbo.VentaDetalleTipo`
- procedimientos almacenados de venta directa, stock y favoritos.

## Verificaciones estáticas realizadas

- El archivo `.csproj` tiene XML válido.
- Los 57 procedimientos almacenados referenciados por el código C# se encuentran en el SQL completo.
- Las 12 rutas de imágenes de productos referenciadas por el SQL existen en `wwwroot`.
- No se dejaron carpetas `bin`, `obj`, `.vs` ni `.git` dentro del paquete.
- Se revisó balance básico de llaves de los archivos C#.
- Se validó sintaxis JavaScript de los scripts principales del catálogo y formularios de Producto con Node.

## Verificación pendiente en la PC del alumno

Este entorno no dispone del SDK de .NET, por lo que la compilación real debe realizarse en Visual Studio:

`Ctrl + Shift + B`

Después seguir `PRUEBAS_VENTA_DIRECTA.md`.

## Nota sobre pagos

El checkout registra la compra y el pedido de tienda. No integra una pasarela de pago real; esto evita incorporar credenciales o servicios externos innecesarios para la demostración académica.
