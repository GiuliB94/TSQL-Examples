
-- Listado con todos los datos de todas las películas
Select * From Peliculas

-- Listado con todas las películas ordenadas por título ascendentemente
Select * From Peliculas Order By Nombre asc
Select * From Peliculas Order By 3 desc -- Por Fecha de Estreno DESC

-- Listado con título de la película y año de estreno 
Select Nombre as Titulo, Year(FechaEstrenoMundial) as AñoEstreno From Peliculas

Select Nombre as Titulo, DatePart(Year, FechaEstrenoMundial) as AñoEstreno From Peliculas
order by AñoEstreno desc

-- Listado con título de la película, año de estreno y cuánto tiempo pasó (en días) entre el estreno y la fecha actual
Select 
    Nombre as Titulo, 
    Year(FechaEstrenoMundial) as AñoEstreno,
    DateDiff(day, FechaEstrenoMundial, GETDATE()) as DiasTranscurridos,
    cast(getdate() as date) as FechaActual
From Peliculas

Select 
    Nombre as Titulo, 
    Year(FechaEstrenoMundial) as AñoEstreno,
    DateDiff(year, FechaEstrenoMundial, GETDATE()) as AniosTranscurridos,
    cast(getdate() as date) as FechaActual
From Peliculas
order by AniosTranscurridos desc, Titulo asc

-- Listado con título de la película y año de estreno ordenado por año de mayor a menor y luego por título de menor a mayor
Select Nombre as Titulo, Year(FechaEstrenoMundial) as AñoEstreno 
From Peliculas
Order by AñoEstreno desc, Nombre asc

-- Listado con título y fecha de estreno de la película más antigua
Select Top 1 Nombre as Titulo, FechaEstrenoMundial from Peliculas
Order by FechaEstrenoMundial asc

-- Listado con título y duración de la película más extensa. Si existen varias películas que cumplan esta condición, incluirlas a todas.

Select Top 1 with ties Nombre, Duracion from Peliculas
Order by Duracion desc

-- Listado de todos los datos de las películas que tengan una duración mayor a 150 minutos
Select * From Peliculas where Duracion > 150

-- Listado de todos los datos de las películas que tengan una duración entre 60 y 120 minutos
Select * From Peliculas where Duracion >= 60 And Duracion <= 120

Select * From Peliculas where Duracion Between 60 and 120

-- Listado de todos los datos de las películas que pertenezcan a las categorías 1, 3 y  5
Select * From Peliculas Where IDCategoria = 1 Or IDCategoria = 3 Or IDCategoria = 5

Select * From Peliculas Where IDCategoria In (1, 3, 5)

-- Listado de todos los datos de las películas que no pertenezcan a las categorías 1, 3 y  5
Select * From Peliculas Where Not (IDCategoria = 1 Or IDCategoria = 3 Or IDCategoria = 5)

Select * From Peliculas Where IDCategoria <> 1 And IDCategoria <> 3 And IDCategoria <> 5

Select * from Peliculas where IDCATEGORIA not in (1,3,5)

-- Listado con título de la película, duración y tipo de duración siendo:
    -- Cortometraje - Hasta 30 minutos
    -- Mediometraje - Hasta 75 minutos
    -- Largometraje - Mayor a 75 minutos
Select 
    Nombre as Titulo,
    Duracion,
    Case  
        When Duracion <= 30 Then 'Cortometraje'
        When Duracion <= 75 Then 'Mediometraje'
        Else 'Largometraje'
    End as TipoDuracion
From Peliculas
order by duracion asc

-- Listado de todos los datos de todos los clientes que no indicaron un celular
Select * From Clientes where Celular is null

-- Listado de todos los datos de todos los clientes que indicaron un mail pero no un celular
Select * From Clientes where Email is not null and Celular is null

-- Listado de apellidos y nombres de los clientes y su información de contacto. La información de contacto debe ser el mail en primer lugar, si no tiene mail el celular y si no tiene celular el domicilio.

Select 
Apellidos, 
Nombres,
IsNull(Email, Isnull(Celular, Direccion)) as Contacto
From Clientes

Select 
Apellidos, 
Nombres,
Coalesce(Email, Celular, Direccion) as Contacto
From Clientes
order by Apellidos asc

-- Listado de todos los clientes cuyo apellido es Smith
Select * from Clientes Where Apellidos = 'Smith'
Select * from Clientes Where Apellidos like 'Smith'

-- Listado de todos los datos de todos los clientes cuyo apellido finalice con 'Son'.
Select * from Clientes Where Apellidos like '%son'

-- Listado de todos los datos de todos los clientes cuyo apellido comience con vocal y finalice con vocal.
Select * from Clientes Where Apellidos like '[AEIOU]%[AEIOU]'

-- Listado de todos los datos de todos los clientes cuyo apellido contenga 5 carácteres.
Select * from Clientes Where Apellidos like '_____'

Select * From Clientes Where Len(Trim(Apellidos)) = 5

-- Listado de clientes con apellidos, nombres y mail de aquellos clientes que tengan un mail con dominio .jp

Select Apellidos, nombres, email from clientes where email like '%.jp'

-- Listado de clientes con apellidos, nombres y mail de aquellos clientes que tengan un mail cuya organización comience con vocal.

Select Apellidos, nombres, email from clientes where email like '%@[AEIOU]%'

-- Listado de clientes con apellidos, nombre y mail de aquellos clientes que tengan un mail cuyo nombre de usuario comience con E y tenga 9 carácteres en total pero no sea de tipo '.COM'

Select Apellidos, Nombres, Email
From Clientes
Where Email like 'E________@%' and Email not like '%.com'


-- Listado con todos los apellidos sin repetir
Select distinct Apellidos from Clientes

--Ejemplo union
SELECT
    nombre as Titulo,
    duracion,
    'Cortometrajes' as TipoDuracion
from Peliculas where duracion<=30
Union
SELECT
    nombre as Titulo,
    duracion,
    'Mediometrajes' as TipoDuracion
from Peliculas where duracion between 31 and 75
UNION
SELECT
    nombre as Titulo,
    duracion,
    'Largometraje' as TipoDuracion
from Peliculas where duracion>75
order by duracion asc

-- Listar para cada cliente apellido, nombre, direccion, nombre de la localidad y nombre de provincia de aquellos clientes que tengan domicilio

select 
    c.nombres, c.apellidos, c.direccion, l.nombre as localidad, p.nombre as provincia
from clientes as c
inner join Localidades as l on c.idLocalidad=L.ID
inner join Provincias as p on l.IDProvincia=p.ID
order by p.nombre desc

-- Listar para cada cliente apellido, nombre, direccion, nombre de la localidad y nombre de provincia. si no tiene registrada localidad debe figurar null

select 
    c.nombres, c.apellidos, c.direccion, l.nombre as localidad, p.nombre as provincia
from clientes as c
left join Localidades as l on c.idLocalidad=L.ID
left join Provincias as p on l.IDProvincia=p.ID
order by p.nombre desc

-- listar localidades sin clientes

select l.nombre as localidad
from localidades as l left join clientes as c on l.id=c.idlocalidad
where c.ID is null

-- Listar todos los géneros, sin repetir, de aquellas peliculas con categoría R

select DISTINCT g.Nombre
from Generos as G
inner join generos_x_pelicula as gp on g.id=gp.IDGenero
inner join peliculas as p on P.ID=GP.IDPelicula
inner join categorias as c on c.id=p.IDCategoria
where c.codigo='R'

-- Listar los nombres de las peliculas cuyo género sea Ciencia ficción o Comedia

select p.nombre as titulo
from peliculas as P
inner join generos_x_pelicula as gp on p.Id=gp.IDPelicula
inner join generos as g on gp.IDGenero=g.ID
where g.nombre in('Ciencia ficción', 'Comedia')

-- Listar los nombres de las peliculas que se hayan proyectado en alguna sala 4d. La sala debe contener el texto "4D"

select DISTINCT p.nombre as titulo
from peliculas as p 
inner join funciones as f on p.ID=f.IDPelicula
inner join salas as s on f.IDSala=s.ID
inner join TiposSalas as ts on s.IDTipo=ts.ID
where ts.nombre like '%4D%'

--Listar para cada sala, el nombre, la capacidad y el tipo de sala
select s.nombre, s.capacidad, ts.nombre as tipo
from salas as s 
inner join TiposSalas as ts on s.IDTipo=ts.ID

-- Listar para cada película, el nombre de la película, su duración y su categoría

select p.nombre, cast(p.duracion as float)/60 as duracion, c.nombre as categoria
from peliculas as P 
inner join categorias as c on p.IDCategoria=c.ID
 
-- Listar para cada película, el nombre de la película y sus géneros

select p.Nombre, g.nombre as genero
from peliculas as p 
inner join Generos_x_Pelicula as gp on p.ID=gp.IDPelicula
inner join generos as g on gp.IDGenero=g.ID

 
-- Listar para cada película, el nombre de la película, el nombre de la categoría, el nombre y tipo de la sala donde se proyecta, el horario y costo de cada función
 
select p.nombre, c.nombre as categoria, s.nombre as sala, ts.nombre as TipoSala, cast(f.horario as date) as dia, cast(F.horario as time) as horario, f.costo 
from peliculas P 
inner join categorias c on p.IDCategoria=c.ID
inner join funciones f on f.IDPelicula=p.ID
inner join salas s on s.ID=f.IDSala
inner join tipossalas as ts on s.IDTipo=ts.ID

-- Listar para cada película el nombre de la película y de cada función el horario y el nombre del idioma hablado y de subtítulo
 
select p.nombre, f.horario, i.nombre as idioma, ii.nombre as subtitulos
from peliculas as  p
inner join funciones as f on p.ID=f.IDPelicula
inner join idiomas as i on f.IDIdioma=i.id
inner join idiomas as ii on f.IDidiomaSubtitulos=ii.ID



-- Listar los nombres de las películas cuyo género sea Ciencia Ficción o Comedia.

select distinct p.nombre
from peliculas P
inner join Generos_x_Pelicula as gp on gp.IDPelicula=p.ID
inner join Generos as g on g.ID=gp.IDGenero
where g.Nombre in ('Ciencia ficción')

--Cantidad de clientes

select count(*) from clientes

--Cantidad de clientes con teléfono

select count(*) from clientes where celular is not null

select count(celular) from clientes

--capacidad total entre todas las salas

select sum(capacidad) from salas

--capacidad total de las salas tipo 3d del cine

select sum(capacidad) from salas s 
inner join TiposSalas ts on s.IDTipo=ts.ID
where ts.Nombre like '%3D%'

--por cada pelicula el nombre y cuantas funciones tuvieron

select count(f.IDpelicula) as funciones, p.Nombre  from funciones f
inner join peliculas p on f.IDPelicula=p.ID
group by p.Nombre


--por cada pelicula el nombre y cuantas funciones tuvieron. Si no tuvo funciones que figure contabilizando 0

select count(f.IDpelicula) as funciones, p.Nombre  from funciones f
right join peliculas p on f.IDPelicula=p.ID
group by p.Nombre
having count(f.IDpelicula)=0

select count(f.IDpelicula) as funciones, p.Nombre from funciones f
right join peliculas p on f.IDPelicula=p.ID
group by p.Nombre, p.ID
order by P.NOMBRE asc

--por cada pelicula el nombre y la cantidad de salas distintas en las que se proyectó

select p.nombre, count(distinct s.nombre) as salas from Peliculas P
inner join funciones f on p.ID=f.IDPelicula
inner join salas s on f.IDSala=s.ID
group by p.id, p.Nombre

-- por cada pelicula, el nombre y el costo promedio de las funciones. Solo listar aquellas peliculas cuyo costo promedio por funcion sea menor a $300

select p.nombre, avg(f.costo) from peliculas P 
inner join funciones f on f.IDPelicula=p.ID
group by p.ID, p.Nombre
having avg(f.costo)<300

--subconsultas

-- peliculas que tengsn duracion mayor al promedio

select avg(cast(duracion as float)) from peliculas

select * from peliculas p where p.duracion>(
    select avg(cast(duracion as float)) from peliculas
)

--las peliculas que tengan una duracion mayor a la de la pelicula de comedia más extensa

select * from peliculas p where p.duracion>(
    select max(cast(p.duracion as float)) from peliculas p
    inner join generos_x_pelicula gp on gp.IDPelicula=p.ID
    inner join generos g on g.id=gp.IDGenero
    where g.Nombre='comedia'
)

-- las peliculas que no hayan sido proyectadas en el 2022

select p.id from peliculas p 
inner join funciones f on f.IDpelicula=p.id
where year(f.horario)=2022

select * from peliculas where id not in(
    select distinct f.idpelicula from funciones f
    where year(f.horario)=2022
)

-- Por cada cliente, la cantidad de peliculas en idioma español vistas y la cantidad vistas en otro idioma

select c.id, count(f.id) as Español from clientes C
inner join ventas v on v.IDCliente=c.ID
inner join funciones f on f.id=v.IDFuncion
inner join idiomas i on f.IDIdioma=i.ID
where i.Nombre<>'Castellano'
group by c.id

select c.id, t1.español, t2.otros from clientes C
left join (
    select c.id, count(f.id) as otros from clientes C
    inner join ventas v on v.IDCliente=c.ID
    inner join funciones f on f.id=v.IDFuncion
    inner join idiomas i on f.IDIdioma=i.ID
    where i.Nombre<>'Castellano'
    group by c.id
) t2 on t2.id=c.id
left join (
    select c.id, count(f.id) as Español from clientes C
    inner join ventas v on v.IDCliente=c.ID
    inner join funciones f on f.id=v.IDFuncion
    inner join idiomas i on f.IDIdioma=i.ID
    where i.Nombre='Castellano'
    group by c.id
) t1 on t1.id=c.id

--alt

select c.id, c.apellidos, c.nombres,
(   select count(f.id) from funciones f
    inner join ventas v on f.id=v.IDFuncion
    inner join idiomas i on f.IDIdioma=i.ID
    where i.Nombre='Castellano' and v.IDCliente=c.id) as Español,
(   select count(f.id) from funciones f
    inner join ventas v on f.id=v.IDFuncion
    inner join idiomas i on f.IDIdioma=i.ID
    where i.Nombre<>'Castellano' and v.IDCliente=c.id) as Otros
from clientes c

-- por cada pelicula el nombre de la pelicula y sus generos separados por coma

select p.nombre,
(select string_agg(g.nombre, ',') from generos G
inner join generos_x_pelicula gp on gp.IDGenero=g.ID
where gp.IDPelicula=p.id) as generos 
from peliculas p

-- los clientes que vieron más peliculas en idioma castellano que en otro idioma

select c.id, c.apellidos, c.nombres from clientes c
where(select count(f.id) from funciones f
    inner join ventas v on f.id=v.IDFuncion
    inner join idiomas i on f.IDIdioma=i.ID
    where i.Nombre='Castellano' and v.IDCliente=c.id) >
(   select count(f.id) from funciones f
    inner join ventas v on f.id=v.IDFuncion
    inner join idiomas i on f.IDIdioma=i.ID
    where i.Nombre<>'Castellano' and v.IDCliente=c.id)


--alt

select * from (
    select c.id, c.apellidos, c.nombres,
(   select count(f.id) from funciones f
    inner join ventas v on f.id=v.IDFuncion
    inner join idiomas i on f.IDIdioma=i.ID
    where i.Nombre='Castellano' and v.IDCliente=c.id) as Español,
(   select count(f.id) from funciones f
    inner join ventas v on f.id=v.IDFuncion
    inner join idiomas i on f.IDIdioma=i.ID
    where i.Nombre<>'Castellano' and v.IDCliente=c.id) as Otros
from clientes c
) as t1
where t1.español>t1.otros