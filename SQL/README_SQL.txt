SPORTWEAR - BASE DE DATOS
=========================

ARCHIVOS
--------
01_SportWearDB_Completa.sql
  Instalación principal desde cero. Incluye tablas, relaciones, procedimientos
  y la ampliación de venta directa, stock, favoritos y ventas.

02_Limpieza_UsuarioCliente_Antiguo.sql
  Script opcional de limpieza de usuarios antiguos con rol CLIENTE.

03_VentaDirecta_Carrito_Favoritos.sql
  Migración histórica para una base anterior a la venta directa.

04_Productos_Catalogo_Imagenes.sql
  Carga/actualiza el catálogo final y sus rutas de imágenes.

05_Tallas_VentaDirecta_Final.sql
  Agrega el manejo de talla en VentaDetalle y actualiza los procedimientos
  relacionados con la venta directa.

06_Cierre_Clientes_Seguridad.sql
  Ajustes finales:
  - Cambio/restablecimiento de contraseña de clientes.
  - Sincronización del estado Cliente / ClienteAcceso.
  - Procedimientos finales de acceso del portal cliente.

QUÉ ARCHIVOS EJECUTAR
---------------------
A) Base nueva:
   1. 01_SportWearDB_Completa.sql
   2. 04_Productos_Catalogo_Imagenes.sql
   3. 05_Tallas_VentaDirecta_Final.sql
   4. 06_Cierre_Clientes_Seguridad.sql

B) Base actual del proyecto, que ya tiene venta directa y tallas:
   Ejecutar solamente 06_Cierre_Clientes_Seguridad.sql para aplicar los
   ajustes finales de clientes y seguridad.

REGLA DE NEGOCIO DE PRODUCTO
----------------------------
Personalizable = 1
  - Confección personalizada.
  - Flujo: Solicitud -> Cotización -> Pedido.

Personalizable = 0
  - Venta directa.
  - Maneja Stock.
  - Flujo: Catálogo -> Carrito -> Venta -> Seguimiento.

SEGURIDAD
---------
Las credenciales de acceso no se documentan en este repositorio.
Las contraseñas se almacenan como hash y deben administrarse desde el sistema.

============================================================
CIERRE DEFINITIVO CLIENTES
============================================================
Para la version final de la aplicacion ejecutar tambien:
07_Cierre_Clientes_Definitivo.sql

Este script permite al administrador crear/restablecer el acceso de clientes
y garantiza que un cliente inactivo no pueda iniciar sesion.
