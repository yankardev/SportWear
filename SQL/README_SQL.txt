SPORTWEAR - BASE DE DATOS
=========================

ARCHIVOS NECESARIOS
-------------------
01_SportWearDB_Completa.sql
  Instalación principal de la base de datos.

04_Productos_Catalogo_Imagenes.sql
  Carga y actualiza el catálogo final y sus rutas de imágenes.

05_Tallas_VentaDirecta_Final.sql
  Agrega el manejo de talla en VentaDetalle y actualiza los procedimientos
  relacionados con la venta directa.

06_Cierre_Clientes_Seguridad.sql
  Aplica los ajustes de seguridad del portal cliente:
  - cambio y restablecimiento de contraseña;
  - sincronización del estado Cliente / ClienteAcceso;
  - procedimientos finales de acceso.

07_Cierre_Clientes_Definitivo.sql
  Cierre definitivo del módulo de clientes y seguridad.
  Permite al administrador crear/restablecer accesos y evita el ingreso de
  clientes inactivos.

INSTALACIÓN NUEVA
-----------------
Ejecutar en este orden:

1. 01_SportWearDB_Completa.sql
2. 04_Productos_Catalogo_Imagenes.sql
3. 05_Tallas_VentaDirecta_Final.sql
4. 06_Cierre_Clientes_Seguridad.sql
5. 07_Cierre_Clientes_Definitivo.sql

REGLA DE NEGOCIO DE PRODUCTO
----------------------------
Personalizable = 1
  - Confección personalizada.
  - Flujo: Solicitud -> Cotización -> Pedido.

Personalizable = 0
  - Venta directa.
  - Maneja stock.
  - Flujo: Catálogo -> Carrito -> Venta -> Seguimiento.

SEGURIDAD
---------
Las credenciales reales de acceso no se documentan en este repositorio.
Las contraseñas se almacenan como hash y deben administrarse desde el sistema.
