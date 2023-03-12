Create database Cine

GO

USE Cine

-- Listado con título de la pelicula, duración y tipo de duración, siendo corto menor
-- o igual a 30 y largo msyor o igual a 75

Select 
    Nombre as Titulo,
    Duracion,
    'cortometrajes' AS TipoDuracion
From Peliculas
where Duracion <=30
UNION
Select
    Nombre as Titulo,
    Duracion,
    'mediometrajes' as TipoDuracion
From Peliculas
where Duracion between 31 and 75
UNION
Select
    Nombre as Titulo,
    Duracion,
    'mediometrajes' as TipoDuracion
From Peliculas
where Duracion > 75

--union: uniones de consultas (como un and anidado), deben tener el mismo nro de columnas
--pueden tener nombres diferentes asignados o tomarse de tablas diferentes, siempre y cuando las tablas tengan
--el mismo tipo de dato en sus columnas
-- es costoso para el procesador
