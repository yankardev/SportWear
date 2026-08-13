# Revisión técnica de SportWear

Fecha de revisión: 11/08/2026

## Cambios aplicados en esta revisión

- Se mantuvo el catálogo público como página inicial.
- Se mantuvo el consumo de Web API desde MVC y el buscador AJAX/JSON del catálogo.
- Se corrigió la navegación por perfiles internos:
  - ADMINISTRADOR: acceso completo.
  - VENTAS: productos, clientes, solicitudes, cotizaciones y pedidos.
  - PRODUCCION: solicitudes de confección y pedidos.
- Se ocultaron en el menú las áreas que no corresponden al perfil.
- Se ajustaron las acciones rápidas del Dashboard según el perfil.
- Se evitó el bucle de redirección si existiera un usuario interno antiguo con rol CLIENTE.
- El acceso CLIENTE permanece separado mediante ClientePortal/ClienteAcceso.
- Se restringió la creación de solicitudes a ADMINISTRADOR/VENTAS.
- Se restringió la generación de pedidos a ADMINISTRADOR/VENTAS.
- Se restringió el avance de estados de producción a ADMINISTRADOR/PRODUCCION.
- Se agregó al módulo Reportes un filtro por estado y rango de fechas.
- Se agregó paginación al reporte detallado de pedidos.
- Se agregó la carpeta SQL con una base completa y portable para GitHub.
- Se eliminó del paquete la carpeta .git y los artefactos obj/bin para dejar una entrega limpia.

## Verificaciones estáticas realizadas

- Los 48 procedimientos almacenados invocados por los repositorios existen en el script SQL incluido.
- Las 12 rutas de imágenes usadas por los productos existen en `wwwroot/img/productos`.
- La base incluida contiene las 10 tablas utilizadas por el proyecto actual.
- No se encontró código `TODO`, `FIXME` o `NotImplemented` propio del proyecto.
- Los formularios MVC POST revisados utilizan antiforgery token; los endpoints Web API quedan fuera de este mecanismo.

## Pruebas manuales recomendadas antes de entregar

1. ADMINISTRADOR: ingresar y comprobar todos los módulos.
2. VENTAS: comprobar que no aparezcan Categorías, Reportes ni Usuarios.
3. PRODUCCION: comprobar que solo vea Dashboard, Confección y Pedidos.
4. PRODUCCION: intentar escribir `/Usuario` manualmente; debe ser bloqueado.
5. CLIENTE: registrarse desde ClientePortal, iniciar sesión y revisar Mi Cuenta.
6. Catálogo: usar el buscador AJAX y verificar que no se recargue la página.
7. Cotización: generar una cotización y descargar el PDF.
8. Pedido: crear un pedido con VENTAS y avanzar sus estados con PRODUCCION.
9. Reportes: filtrar por estado, fechas y navegar por la paginación.
10. Ejecutar el script SQL desde una base limpia en otro equipo si es posible.

## Mejoras futuras recomendadas

- Para producción real, reemplazar SHA-256 directo por un algoritmo de contraseñas con salt como PBKDF2/BCrypt/Argon2.
- Restringir los endpoints POST/PUT/DELETE de la Web API con autorización específica de API.
- Reemplazar la política CORS `PermitirTodo` por orígenes conocidos al publicar.
- Configurar la cadena de conexión mediante variables de entorno/App Service al desplegar en Azure.
- Verificar si el docente exige uso explícito de componentes Bootstrap además de Bootstrap Icons.

## Nota de compilación

En el entorno usado para esta revisión no estaba instalado el SDK de .NET, por lo que no se pudo ejecutar `dotnet build`. La revisión realizada fue estática y de consistencia entre código, vistas, repositorios, imágenes y script SQL. Antes de subir el proyecto, compilar en Visual Studio con `Ctrl + Shift + B`.
