# Pruebas finales - Venta directa SportWear

## 1. Base de datos existente

Ejecutar:

`SQL/03_VentaDirecta_Carrito_Favoritos.sql`

Verificar que existen:

- `Producto.Stock`
- `Venta`
- `VentaDetalle`
- `Favorito`

## 2. Producto de venta directa

En Administración -> Productos:

- Crear producto con `Personalizable` desmarcado.
- Asignar Stock mayor que 0.
- Confirmar que aparece en `/Catalogo`.
- Confirmar que NO aparece en `/Catalogo/Personalizados`.

## 3. Producto personalizado

- Crear o editar producto con `Personalizable` marcado.
- Stock debe quedar en 0.
- Debe aparecer en `/Catalogo/Personalizados`.
- Debe mantener `Solicitar cotización`.

## 4. Carrito

- Abrir producto de venta directa.
- Elegir cantidad y `Agregar al carrito`.
- Ver contador en menú.
- Actualizar cantidad.
- Intentar una cantidad mayor al stock: debe bloquearse.
- Eliminar producto.

## 5. Checkout

- Agregar productos al carrito.
- Si no hay sesión cliente, `Confirmar compra` debe solicitar login.
- Después del login debe regresar al checkout.
- Ingresar dirección y confirmar.
- Ver página de confirmación con código `VEN-...`.
- Verificar que el stock disminuyó.

## 6. Mi cuenta

Como cliente:

- Mi cuenta -> `Mis compras de tienda`.
- Debe aparecer la venta creada.
- Deben seguir apareciendo solicitudes, cotizaciones y pedidos personalizados.

## 7. Favoritos

- Iniciar sesión como cliente.
- Abrir un producto.
- `Guardar favorito`.
- Menú -> Favoritos.
- Eliminar favorito.

## 8. Administración de venta directa

Como ADMINISTRADOR o VENTAS:

- Menú -> Ventas directas.
- Abrir una venta.
- Cambiar estado:
  - REGISTRADA
  - PREPARANDO
  - LISTA
  - ENTREGADA
- Revisar que el estado también cambie en Mi cuenta del cliente.

## 9. Regresión del proceso personalizado

Confirmar que continúan funcionando:

- Solicitud de confección.
- Desplegables de talla, color, material y estampado.
- Generar cotización.
- PDF.
- Generar pedido.
- Avance APROBADO -> DISEÑO -> CONFECCION -> LISTO -> ENTREGADO.
