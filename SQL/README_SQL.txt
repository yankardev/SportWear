SPORTWEAR - BASE DE DATOS
=========================

ARCHIVOS
--------
01_SportWearDB_Completa.sql
  Instalación completa desde cero. Incluye el proyecto original y al final
  aplica la ampliación de venta directa, stock, favoritos y ventas.

02_Limpieza_UsuarioCliente_Antiguo.sql
  Opcional. Elimina usuarios internos de prueba con rol CLIENTE cuando no
  estén referenciados por cotizaciones o pedidos.

03_VentaDirecta_Carrito_Favoritos.sql
  MIGRACIÓN para una base SportWearDB que YA existe.
  Agrega:
  - Stock a Producto.
  - Venta y VentaDetalle.
  - Favorito.
  - Tipo dbo.VentaDetalleTipo.
  - Procedimientos de stock, favoritos y venta directa.
  - Productos demo de venta directa si el catálogo está vacío.
  - Dashboard actualizado para sumar venta directa al total vendido.

QUÉ ARCHIVO EJECUTAR
--------------------
A) Si YA tienes SportWearDB funcionando:
   Ejecuta SOLAMENTE 03_VentaDirecta_Carrito_Favoritos.sql.

B) Si crearás la base desde cero en otra PC:
   Ejecuta 01_SportWearDB_Completa.sql.

NO vuelvas a ejecutar 01 sobre una base ya creada porque la primera parte del
script contiene CREATE TABLE del proyecto original.

REGLA DE NEGOCIO DE PRODUCTO
----------------------------
Personalizable = 1
  - Se usa para confección personalizada.
  - Stock se mantiene en 0.
  - Flujo: Solicitud -> Cotización -> Pedido.

Personalizable = 0
  - Se usa para venta directa.
  - Maneja Stock.
  - Flujo: Catálogo -> Carrito -> Venta -> Seguimiento.

PRECIOS DE TIENDA
-----------------
PrecioBase se interpreta como precio final mostrado al cliente (IGV incluido).
Al confirmar la compra, el sistema separa internamente Subtotal e IGV sin
incrementar el precio visto en el catálogo.

## Acceso de demostración

El sistema incluye perfiles de Administrador, Ventas, Producción y Cliente.

Por seguridad, las credenciales de acceso no se almacenan
públicamente en este repositorio.
