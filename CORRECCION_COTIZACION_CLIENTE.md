# Corrección: cotización asociada al cliente autenticado

## Problema corregido

Antes, `CatalogoController.Cotizar` buscaba o creaba un cliente usando el documento enviado por el formulario. Eso podía generar una solicitud con un `ClienteId` distinto al `ClienteId` de la sesión, por lo que `Mi Cuenta` mostraba 0 solicitudes/cotizaciones/pedidos.

## Comportamiento nuevo

1. Para cotizar un producto personalizado el cliente debe iniciar sesión.
2. Si no tiene sesión, se guarda la URL de retorno y se envía a `ClientePortal/Login`.
3. Después del login regresa automáticamente al producto que estaba cotizando.
4. Los datos de identidad se cargan desde la cuenta y se muestran en modo solo lectura.
5. Al registrar la solicitud se usa siempre `HttpContext.Session.GetInt32("ClienteId")`.
6. Al finalizar aparece un botón `Ver en Mi Cuenta`.

## Prueba

- Iniciar sesión como cliente.
- Ir a `Personalizados`.
- Abrir un producto y pulsar `Solicitar cotización`.
- Registrar la solicitud.
- Pulsar `Ver en Mi Cuenta`.
- El contador de Solicitudes debe aumentar a 1 y la solicitud debe aparecer en la sección `Mis solicitudes`.
- Cuando Ventas genere la cotización, el contador de Cotizaciones debe aumentar.
- Cuando se genere el pedido personalizado, el contador de Pedidos debe aumentar.

No se requiere ejecutar un SQL adicional para esta corrección.
