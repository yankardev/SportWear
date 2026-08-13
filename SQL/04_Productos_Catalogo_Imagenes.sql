USE [SportWearDB];
GO

SET NOCOUNT ON;
GO

IF COL_LENGTH('dbo.Producto', 'Stock') IS NULL
BEGIN
    THROW 51001,
          'Primero ejecute 03_VentaDirecta_Carrito_Favoritos.sql para crear Producto.Stock.',
          1;
END;
GO

UPDATE dbo.Producto
SET Activo = 0
WHERE Nombre IN
(
    N'Polo Running Store',
    N'Short Training Store',
    N'Legging Active Store',
    N'Casaca Urban Sport'
);
GO

DECLARE @CatPolos INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Polos' AND Activo = 1);
DECLARE @CatShorts INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Shorts' AND Activo = 1);
DECLARE @CatBuzos INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Buzos' AND Activo = 1);
DECLARE @CatLeggings INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Leggings' AND Activo = 1);
DECLARE @CatCasacas INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Casacas' AND Activo = 1);
DECLARE @CatConjuntos INT = (SELECT TOP 1 CategoriaId FROM dbo.Categoria WHERE Nombre = N'Conjuntos' AND Activo = 1);

IF @CatPolos IS NULL OR @CatShorts IS NULL OR @CatBuzos IS NULL
   OR @CatLeggings IS NULL OR @CatCasacas IS NULL OR @CatConjuntos IS NULL
BEGIN
    THROW 51002, 'Faltan categorías base necesarias para los productos de catálogo.', 1;
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Polo Performance Black')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatPolos,N'Polo Performance Black',N'Polo deportivo negro de secado rápido, ligero y cómodo para entrenamiento diario.',69.90,N'/img/catalogo/catalogo-polo-performance-negro.png',0,28,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatPolos,Descripcion=N'Polo deportivo negro de secado rápido, ligero y cómodo para entrenamiento diario.',PrecioBase=69.90,ImagenUrl=N'/img/catalogo/catalogo-polo-performance-negro.png',Personalizable=0,Stock=28,Activo=1 WHERE Nombre=N'Polo Performance Black';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Legging Active Fit')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatLeggings,N'Legging Active Fit',N'Legging deportivo de cintura alta y tejido flexible para gimnasio, fitness y entrenamiento.',79.90,N'/img/catalogo/catalogo-legging-active.png',0,22,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatLeggings,Descripcion=N'Legging deportivo de cintura alta y tejido flexible para gimnasio, fitness y entrenamiento.',PrecioBase=79.90,ImagenUrl=N'/img/catalogo/catalogo-legging-active.png',Personalizable=0,Stock=22,Activo=1 WHERE Nombre=N'Legging Active Fit';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Cortaviento Navy Run')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatCasacas,N'Cortaviento Navy Run',N'Casaca cortaviento azul marino con acabado ligero para running y entrenamiento al aire libre.',129.90,N'/img/catalogo/catalogo-cortaviento-navy.png',0,16,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatCasacas,Descripcion=N'Casaca cortaviento azul marino con acabado ligero para running y entrenamiento al aire libre.',PrecioBase=129.90,ImagenUrl=N'/img/catalogo/catalogo-cortaviento-navy.png',Personalizable=0,Stock=16,Activo=1 WHERE Nombre=N'Cortaviento Navy Run';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Short Training Graphite')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatShorts,N'Short Training Graphite',N'Short deportivo gris de corte cómodo para entrenamiento, running y actividades de gimnasio.',49.90,N'/img/catalogo/catalogo-short-training-gris.png',0,30,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatShorts,Descripcion=N'Short deportivo gris de corte cómodo para entrenamiento, running y actividades de gimnasio.',PrecioBase=49.90,ImagenUrl=N'/img/catalogo/catalogo-short-training-gris.png',Personalizable=0,Stock=30,Activo=1 WHERE Nombre=N'Short Training Graphite';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Top Fitness Emerald')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatPolos,N'Top Fitness Emerald',N'Top deportivo de soporte medio y tejido elástico, pensado para fitness y entrenamiento funcional.',59.90,N'/img/catalogo/catalogo-top-fitness-verde.png',0,20,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatPolos,Descripcion=N'Top deportivo de soporte medio y tejido elástico, pensado para fitness y entrenamiento funcional.',PrecioBase=59.90,ImagenUrl=N'/img/catalogo/catalogo-top-fitness-verde.png',Personalizable=0,Stock=20,Activo=1 WHERE Nombre=N'Top Fitness Emerald';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Polo Motion White')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatPolos,N'Polo Motion White',N'Polo deportivo blanco de tela transpirable y diseño ligero para entrenamiento y uso diario.',64.90,N'/img/catalogo/catalogo-polo-motion-blanco.png',0,25,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatPolos,Descripcion=N'Polo deportivo blanco de tela transpirable y diseño ligero para entrenamiento y uso diario.',PrecioBase=64.90,ImagenUrl=N'/img/catalogo/catalogo-polo-motion-blanco.png',Personalizable=0,Stock=25,Activo=1 WHERE Nombre=N'Polo Motion White';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Jogger Training Black')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatBuzos,N'Jogger Training Black',N'Pantalón jogger deportivo negro con ajuste cómodo para entrenamiento, calentamiento y uso urbano.',89.90,N'/img/catalogo/catalogo-jogger-black.png',0,18,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatBuzos,Descripcion=N'Pantalón jogger deportivo negro con ajuste cómodo para entrenamiento, calentamiento y uso urbano.',PrecioBase=89.90,ImagenUrl=N'/img/catalogo/catalogo-jogger-black.png',Personalizable=0,Stock=18,Activo=1 WHERE Nombre=N'Jogger Training Black';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Tank Running Coral')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatPolos,N'Tank Running Coral',N'Camiseta sin mangas de tejido ligero para running, cardio y entrenamiento de alta intensidad.',54.90,N'/img/catalogo/catalogo-tank-running-coral.png',0,24,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatPolos,Descripcion=N'Camiseta sin mangas de tejido ligero para running, cardio y entrenamiento de alta intensidad.',PrecioBase=54.90,ImagenUrl=N'/img/catalogo/catalogo-tank-running-coral.png',Personalizable=0,Stock=24,Activo=1 WHERE Nombre=N'Tank Running Coral';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Conjunto Track Burgundy')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatConjuntos,N'Conjunto Track Burgundy',N'Conjunto deportivo de casaca y pantalón en color borgoña para calentamiento, viaje y entrenamiento.',159.90,N'/img/catalogo/catalogo-conjunto-track-borgona.png',0,14,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatConjuntos,Descripcion=N'Conjunto deportivo de casaca y pantalón en color borgoña para calentamiento, viaje y entrenamiento.',PrecioBase=159.90,ImagenUrl=N'/img/catalogo/catalogo-conjunto-track-borgona.png',Personalizable=0,Stock=14,Activo=1 WHERE Nombre=N'Conjunto Track Burgundy';

IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE Nombre = N'Polo Sport Cobalt')
    INSERT dbo.Producto (CategoriaId,Nombre,Descripcion,PrecioBase,ImagenUrl,Personalizable,Stock,Activo)
    VALUES (@CatPolos,N'Polo Sport Cobalt',N'Polo deportivo azul cobalto de corte clásico y tejido técnico para gimnasio y entrenamiento.',69.90,N'/img/catalogo/catalogo-polo-cobalt.png',0,26,1);
ELSE
    UPDATE dbo.Producto SET CategoriaId=@CatPolos,Descripcion=N'Polo deportivo azul cobalto de corte clásico y tejido técnico para gimnasio y entrenamiento.',PrecioBase=69.90,ImagenUrl=N'/img/catalogo/catalogo-polo-cobalt.png',Personalizable=0,Stock=26,Activo=1 WHERE Nombre=N'Polo Sport Cobalt';

GO

SELECT ProductoId, Nombre, PrecioBase, Stock, ImagenUrl, Personalizable, Activo
FROM dbo.Producto
WHERE ImagenUrl LIKE N'/img/catalogo/%'
ORDER BY ProductoId;
GO
