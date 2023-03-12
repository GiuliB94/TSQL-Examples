--Apellido, nombres y fecha de ingreso de todos los colaboradores

select apellidos, nombres, añoingreso from colaboradores

--Apellido, nombres y antigüedad de todos los colaboradores

select apellidos, nombres, year(getdate())-añoingreso as antiguedad from colaboradores

--Apellido y nombres de aquellos colaboradores que trabajen part-time.

select apellidos, nombres from colaboradores where ModalidadTrabajo='P'

--Apellido y nombres, antigüedad y modalidad de trabajo de aquellos colaboradores cuyo sueldo sea entre 50000 y 100000.

select apellidos, nombres from colaboradores where sueldo between 50000 and 100000

--Apellidos y nombres y edad de los colaboradores con legajos 4, 6, 12 y 25.

select legajo, apellidos, nombres from colaboradores where legajo in (4,6,12,25)

--Todos los datos de todos los productos ordenados por precio de venta. Del más caro al más barato
select * from productos order by precio asc

--El nombre del producto más costoso.

select top 1 with ties descripcion, precio from Productos
order by precio desc

--Todos los datos de todos los pedidos que hayan superado el monto de $20000.

select * from pedidos where costo>20000

--Apellido y nombres de los clientes que no hayan registrado teléfono.

select apellidos, nombres from clientes where telefono is null

--Apellido y nombres de los clientes que hayan registrado mail pero no teléfono.

select apellidos, nombres from clientes where mail is not null and telefono is null

--Apellidos, nombres y datos de contacto de todos los clientes.
--Nota: En datos de contacto debe figurar el número de celular, si no tiene celular el número de teléfono fijo y si no tiene este último el mail. En caso de no tener ninguno de los tres debe figurar 'Incontactable'.

select apellidos, nombres, coalesce(celular, telefono, mail, 'Incontactable') from clientes

--Apellidos, nombres y medio de contacto de todos los clientes. Si tiene celular debe figurar 'Celular'. Si no tiene celular pero tiene teléfono fijo debe figurar 'Teléfono fijo' de lo contrario y si tiene Mail debe figurar 'Email'. Si no posee ninguno de los tres debe figurar NULL.

select apellidos, nombres,
CASE
    when celular is not null then 'Celular'
    when telefono is not null then'Telefono fijo'
    when mail is not null then 'mail'
end as metodoContacto
from clientes

--Todos los datos de los colaboradores que hayan nacido luego del año 2000

select * from colaboradores where year(FechaNacimiento)>2000

--Todos los datos de los colaboradores que hayan nacido entre los meses de Enero y Julio (inclusive)

select * from colaboradores where month(FechaNacimiento) between 1 and 7

--Todos los datos de los clientes cuyo apellido finalice con vocal

select * from clientes where apellidos like '%[AEIOU]'

--Todos los datos de los clientes cuyo nombre comience con 'A' y contenga al menos otra 'A'. Por ejemplo, Ana, Anatasia, Aaron, etc

select * from clientes where nombres like 'a%a%'

--Todos los colaboradores que tengan más de 10 años de antigüedad

select * from colaboradores where (year(GETDATE())-añoingreso)>10

--Los códigos de producto, sin repetir, que hayan registrado al menos un pedido

select distinct p.idProducto, pr.descripcion from pedidos p
inner join productos pr on p.idProducto=pr.id

--Todos los datos de todos los productos con su precio aumentado en un 20%

select *, cast(precio*1.2 as money) as NuevoPrecio from productos

--Todos los datos de todos los colaboradores ordenados por apellido ascendentemente en primera instancia y por nombre descendentemente en segunda instancia.

select * from colaboradores
order by apellidos asc, nombres desc

--Por cada producto listar la descripción del producto, el precio y el nombre de la categoría a la que pertenece.

select p.descripcion, p.precio, c.nombre as categoria from productos p
inner join categorias c on p.idcategoria=c.id

--Listar las categorías de producto de las cuales no se registren productos.

select c.nombre as categoria from categorias c 
left join productos p on p.idcategoria=c.Id 
where p.descripcion is null

--Listar el nombre de la categoría de producto de aquel o aquellos productos que más tiempo lleven en construir.

select top 1 with ties  c.nombre from categorias c
inner join productos p  on p.idcategoria=c.ID 
order by p.diasconstruccion desc

--Listar apellidos y nombres y dirección de mail de aquellos clientes que no hayan registrado pedidos.

select c.apellidos, c.nombres, c.mail from clientes c 
left join pedidos p on p.idcliente=c.ID 
where p.id is null

--Listar apellidos y nombres, mail, teléfono y celular de aquellos clientes que hayan realizado algún pedido cuyo costo supere $1000000

select c.apellidos, c.nombres, c.mail, c.celular from clientes c 
inner join pedidos p on p.idcliente=c.ID 
where p.costo>1000000

--Listar IDPedido, Costo, Fecha de solicitud y fecha de finalización, descripción del producto, costo y apellido y nombre del cliente. Sólo listar aquellos registros de pedidos que hayan sido pagados.

select p.id, p.costo, p.fechasolicitud, p.fechafinalizacion, pr.descripcion, pr.costo, c.apellidos, c.nombres from pedidos p
inner join productos pr on pr.id=p.idproducto
inner join clientes c on p.idcliente=c.id
where p.pagado=1

-- Listar IDPedido, Fecha de solicitud, fecha de finalización, días de construcción del producto, días de construcción del pedido (fecha de finalización - fecha de solicitud) y una columna llamada Tiempo de construcción con la siguiente información:
--'Con anterioridad' → Cuando la cantidad de días de construcción del pedido sea menor a los días de construcción del producto.
--'Exacto'' → Si la cantidad de días de construcción del pedido y el producto son iguales
--'Con demora' → Cuando la cantidad de días de construcción del pedido sea mayor a los días de construcción del producto.

select p.id, p.fechasolicitud, p.fechafinalizacion, pr.diasconstruccion, datediff(day, p.fechasolicitud, p.fechafinalizacion) as diaspedido,
CASE
    when datediff(day, p.fechasolicitud, p.fechafinalizacion)<pr.diasconstruccion then 'Con anterioridad'
    when datediff(day, p.fechasolicitud, p.fechafinalizacion)=pr.diasconstruccion then 'Exacto'
    when datediff(day, p.fechasolicitud, p.fechafinalizacion)>pr.diasconstruccion then 'Con demora'
end as TiempoConstruccion   
from pedidos P  
inner join productos pr on pr.id=p.idproducto

--Listar por cada cliente el apellido y nombres y los nombres de las categorías de aquellos productos de los cuales hayan realizado pedidos. No deben figurar registros duplicados.

select distinct c.apellidos, c.nombres, p.descripcion from clientes c
inner join pedidos pe on pe.idcliente=c.ID
inner join productos p on p.id=pe.idProducto

--Listar apellidos y nombres de aquellos clientes que hayan realizado algún pedido cuya cantidad sea exactamente igual a la cantidad considerada mayorista del producto.

select c.apellidos, c.nombres, pe.cantidad, p.cantidadmayorista from clientes c
inner join pedidos pe on pe.idcliente=c.ID
inner join productos p on p.id=pe.idProducto
where pe.cantidad=p.cantidadmayorista

--Listar por cada producto el nombre del producto, el nombre de la categoría, el precio de venta minorista, el precio de venta mayorista y el porcentaje de ahorro que se obtiene por la compra mayorista a valor mayorista en relación al valor minorista.

select p.descripcion, c.nombre, p.precio, p.precioventamayorista, (1-(p.precioventamayorista/p.precio))*100 as porcentajeAhorro from Productos p
inner join categorias c on c.id=p.idcategoria

--Actividad 2.3

--La cantidad de colaboradores que nacieron luego del año 1995.

select count(legajo) from colaboradores
where year(fechanacimiento)>1995

--El costo total de todos los pedidos que figuren como Pagado.

select sum(costo) as CantidadPagados from pedidos
where Pagado=1

--La cantidad total de unidades pedidas del producto con ID igual a 30.

select sum(cantidad) from pedidos
where idproducto=30

--La cantidad de clientes distintos que hicieron pedidos en el año 2020.

select count(distinct idcliente) from pedidos
where year(fechasolicitud)=2020

--Por cada material, la cantidad de productos que lo utilizan.

select m.nombre, count(mp.idproducto) as productos from materiales M 
inner join materiales_x_producto mp on mp.idmaterial=m.id
group by m.nombre

select m.nombre, mp.idproducto as productos from materiales M 
inner join materiales_x_producto mp on mp.idmaterial=m.id
order by m.nombre asc

--Para cada producto, listar el nombre y la cantidad de pedidos pagados.

select p.descripcion, count(pe.id) as PedidosPagados from productos P 
inner join pedidos pe on pe.idproducto=p.ID
where pe.pagado=1
group by descripcion

--Por cada cliente, listar apellidos y nombres de los clientes y la cantidad de productos distintos que haya pedido.

select c.apellidos, c.nombres, count(distinct p.idproducto) as prodictospedidos from clientes c 
inner join pedidos p on p.idcliente=c.id
group by apellidos, nombres

select c.apellidos, c.nombres, count(distinct p.idproducto) as prodictospedidos, p.fechasolicitud from clientes c 
inner join pedidos p on p.idcliente=c.id
where month(p.fechasolicitud)=4 and year(p.fechasolicitud)=2022
group by apellidos, nombres, p.fechasolicitud

select idproducto, avg(datediff(day,fechafinalizacion, fechasolicitud)) as promediodias from pedidos
group by idproducto

select idproducto, datediff(day,fechafinalizacion, fechasolicitud) as promediodias from pedidos
where idproducto=47

--Por cada colaborador y tarea que haya realizado, listar apellidos y nombres, nombre de la tarea y la cantidad de veces que haya realizado esa tarea.

select c.apellidos, c.nombres, t.nombre, count(p.idtarea) cantidadTareas from colaboradores c
inner join tareas_x_pedido p on p.legajo=c.legajo
inner join tareas t on t.id=p.idtarea
group by c.apellidos, c.nombres, t.nombre



--Por cada cliente, listar los apellidos y nombres y el importe individual más caro que hayan abonado en concepto de pago.

select c.apellidos, c.nombres, max(pg.importe) as MayorPago from clientes C
inner join pedidos p on p.idcliente=c.ID
inner join pagos pg on pg.idpedido=p.id
group by c.apellidos, c.nombres

--Por cada colaborador, apellidos y nombres y la menor cantidad de unidades solicitadas en un pedido individual en el que haya trabajado.

select c.apellidos, c.nombres, min(p.cantidad) MinimoCantidades from colaboradores C
inner join tareas_x_pedido tp on tp.legajo=c.legajo
inner join pedidos p on p.id=tp.idpedido
group by c.apellidos, c.nombres
order by MinimoCantidades asc

--Listar apellidos y nombres de aquellos clientes que no hayan realizado ningún pedido. Es decir, que contabilicen 0 pedidos.

select c.apellidos, c.nombres, count(p.id) from clientes C
left join pedidos p on p.idcliente=c.ID
group by c.apellidos, c.nombres
having count(p.id)=0

--Obtener un listado de productos indicando descripción y precio de aquellos productos que hayan registrado más de 15 pedidos.

select p.descripcion, p.precio, count(pd.id) as pedidos from productos P
inner join pedidos pd on pd.idproducto=p.id
group by p.descripcion, p.precio
having count(pd.id)>15

--Obtener un listado de productos indicando descripción y nombre de categoría de los productos que tienen un precio promedio de pedidos mayor a $25000.

select p.descripcion, c.nombre as categoria, avg(pd.costo) as promedio from productos P
inner join pedidos pd on pd.idproducto=p.ID
inner join categorias c on c.id=p.idcategoria
group by p.descripcion, c.nombre
having avg(pd.costo)>25000
order by promedio asc

--Apellidos y nombres de los clientes que hayan registrado más de 15 pedidos que superen los $15000.

select c.apellidos, c.nombres, count(p.id) as pedidos from clientes c
inner join pedidos p on p.idcliente=c.ID
where p.costo>15000
group by c.apellidos, c.nombres
having count(p.id)>15

--Para cada producto, listar el nombre, el texto 'Pagados'  y la cantidad de pedidos pagados. Anexar otro listado con nombre, el texto 'No pagados' y cantidad de pedidos no pagados.

select * FROM
(select p.descripcion, 'Pagados' as status, count(pe.id) cantidad from productos p
inner join pedidos pe on pe.idproducto=p.id
where pe.pagado=1
group by descripcion) t1
full outer join
(select p.descripcion, 'No Pagados' as status, count(pe.id) cantidad from productos p
inner join pedidos pe on pe.idproducto=p.id
where pe.pagado=0
group by descripcion) t2 on t1.descripcion=t2.descripcion
order by t1.descripcion, t2.descripcion


SELECT idproducto,  
AVG(CONVERT(decimal(7,2), DATEDIFF(DAY,dia_anterior,fechasolicitud))) AS avg_dias  
FROM  
(  
SELECT idproducto,  
fechasolicitud,  
LAG(fechasolicitud,1) OVER (PARTITION BY idproducto ORDER BY fechasolicitud) AS dia_anterior FROM pedidos 
) AS TempTable  
GROUP BY idproducto
ORDER BY idproducto 
