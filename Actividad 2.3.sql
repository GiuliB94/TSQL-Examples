--Los pedidos que hayan sido finalizados en menor cantidad de días que la demora promedio

select * from Pedidos
where datediff(day,fechasolicitud,fechafinalizacion)<(select avg(datediff(day,fechasolicitud,fechafinalizacion)*1.0) from pedidos)


--Los productos cuyo costo sea mayor que el costo del producto de Roble más caro.

select * from Productos
where costo>(select max(p.costo) from Productos p
inner join materiales_x_producto mp on p.id=mp.IDProducto
inner join materiales m on mp.IDMaterial=m.id
where m.Nombre='Roble'
group by m.id)

--Los clientes que no hayan solicitado ningún producto de material Pino en el año 2022.

select * from clientes C
where c.id not in (
    select distinct IDCliente from pedidos P
    inner join clientes c on c.id=p.IDCliente
    inner join productos pr on pr.ID=p.IDProducto
    inner join materiales_x_producto mp on mp.IDProducto=pr.ID
    inner join materiales m on m.ID=mp.IDMaterial
    where m.Nombre='Pino' and year(FechaSolicitud)=2022
)

--Los colaboradores que no hayan realizado ninguna tarea de Lijado en pedidos que se solicitaron en el año 2021.

select * from colaboradores where legajo not in(
    select distinct c.legajo from Colaboradores C
    inner join Tareas_x_Pedido tp on tp.Legajo=c.Legajo
    inner join tareas t on t.ID=tp.IDTarea
    inner join pedidos p on tp.IDPedido=p.ID
    where t.Nombre='Lijado' and year(p.FechaSolicitud)=2021
)

--Los clientes a los que les hayan enviado (no necesariamente entregado) al menos un tercio de sus pedidos.



select * from clientes C 
where cast((select count(p.id) from pedidos p
inner join envios e on e.IDPedido=p.id
where e.FechaEnvio is not null and p.IDCliente=c.id group by p.IDCliente) as float)/cast((select count(p.id) from pedidos p
where p.IDCliente=c.id
group by p.IDCliente
having count(p.id)>0
) as FLOAT) >= 0.3333


select * from clientes C 
where ((select count(p.id) from pedidos p
inner join envios e on e.IDPedido=p.id
where e.FechaEnvio is not null and p.IDCliente=c.id group by p.IDCliente)*1.0)/((select count(p.id) from pedidos p
where p.IDCliente=c.id
group by p.IDCliente
having count(p.id)>0
)*1.0) >= 0.3


--Los colaboradores que hayan realizado todas las tareas (no necesariamente en un mismo pedido).

select distinct c.legajo, c.apellidos, c.nombres, t.ID, t.Nombre from colaboradores C
inner join tareas_x_pedido tp on tp.Legajo=c.Legajo
inner join tareas t on t.ID=tp.IDTarea
order by c.legajo

select * from Colaboradores c
where(select count(distinct t.ID) from tareas t
inner join tareas_x_pedido tp on t.ID=tp.IDTarea
where tp.Legajo=c.legajo)=(select count(id) from tareas)


--Por cada producto, la descripción y la cantidad de colaboradores fulltime que hayan trabajado en él y la cantidad de colaboradores parttime

select p.id, count (distinct c.Legajo) from Productos p
inner join pedidos pe on p.ID=pe.IDProducto
inner join Tareas_x_Pedido tp on tp.IDPedido=pe.ID
inner join Colaboradores c on c.Legajo=tp.Legajo
group by p.id

select p.id, count (distinct c.Legajo) from Productos p
inner join pedidos pe on p.ID=pe.IDProducto
inner join Tareas_x_Pedido tp on tp.IDPedido=pe.ID
inner join Colaboradores c on c.Legajo=tp.Legajo
where c.ModalidadTrabajo='P'
group by p.id

select p.id, p.descripcion, (select count (distinct c.Legajo) from colaboradores c
inner join Tareas_x_Pedido tp on c.Legajo=tp.Legajo
inner join pedidos pe on pe.ID=tp.IDPedido
where p.ID=pe.IDProducto and c.ModalidadTrabajo='P') as Part, (select count (distinct c.Legajo) from colaboradores c
inner join Tareas_x_Pedido tp on c.Legajo=tp.Legajo
inner join pedidos pe on pe.ID=tp.IDPedido
where p.ID=pe.IDProducto and c.ModalidadTrabajo='F') as Fulltime from productos p


--Por cada producto, la descripción y la cantidad de pedidos enviados y la cantidad de pedidos sin envío.

select * from productos P
inner join pedidos pe on pe.IDProducto=p.ID
inner join envios e on e.IDPedido=pe.ID
where e.FechaEnvio>=getdate()

select p.id, p.descripcion, (select count(e.IDPedido) from Envios e
inner join pedidos pe on pe.ID=e.IDPedido
where pe.IDProducto=p.id) as Enviados,(select count(pe.id) from pedidos pe
left join envios e on pe.ID=e.IDPedido
where pe.IDProducto=p.id and e.FechaEnvio is null) as NoEnviados from productos p

--Por cada cliente, apellidos y nombres y la cantidad de pedidos solicitados en los años 2020, 2021 y 2022. (Cada año debe mostrarse en una columna separada)

select c.apellidos, c.nombres, (select count(p.id) from pedidos p where p.IDCliente=c.id and year(p.FechaSolicitud)=2020) as Pedidos2020,
(select count(p.id) from pedidos p where p.IDCliente=c.id and year(p.FechaSolicitud)=2021) as Pedidos2021,
(select count(p.id) from pedidos p where p.IDCliente=c.id and year(p.FechaSolicitud)=2022) as Pedidos2022
from clientes c

--Por cada producto, listar la descripción del producto, el costo y los materiales de construcción (en una celda separados por coma)

select p.descripcion, p.Costo,(select string_agg(m.Nombre, ',') from Materiales m
inner join Materiales_x_Producto mt on mt.IDMaterial=m.id
where mt.IDProducto=p.id) as Materiales  from productos p

--Por cada pedido, listar el ID, la fecha de solicitud, el nombre del producto, los apellidos y nombres de los colaboradores que trabajaron en el pedido 
--y la/s tareas que el colaborador haya realizado (en una celda separados por coma)

select p.id, p.fechasolicitud, t1.* from pedidos P
inner join (select tp.IDPedido, c.apellidos, c.nombres, string_agg(t.Nombre, ',') as tareas from tareas t
inner join Tareas_x_Pedido tp on tp.IDTarea=t.ID
inner join Colaboradores c on c.Legajo=tp.Legajo
group by tp.IDPedido, c.legajo,c.apellidos, c.nombres) t1 on t1.IDPedido=p.id
order by p.id

--Las descripciones de los productos que hayan requerido el doble de colaboradores fulltime que colaboradores partime.


select pr.descripcion from productos pr
where (select count(distinct c.legajo) from colaboradores c 
inner join Tareas_x_Pedido tp on tp.legajo=c.Legajo
inner join pedidos p on p.ID=tp.IDPedido
where p.IDProducto=pr.id  and c.ModalidadTrabajo='f') >=(select count(distinct c.legajo) from colaboradores c 
inner join Tareas_x_Pedido tp on tp.legajo=c.Legajo
inner join pedidos p on p.ID=tp.IDPedido
where p.IDProducto=pr.id and c.ModalidadTrabajo='p')*2 and (select count(distinct c.legajo) from colaboradores c 
inner join Tareas_x_Pedido tp on tp.legajo=c.Legajo
inner join pedidos p on p.ID=tp.IDPedido
where p.IDProducto=pr.id and c.ModalidadTrabajo='p') !=0


--Las descripciones de los productos que tuvieron más pedidos sin envíos que con envíos pero que al menos tuvieron un pedido enviado.


select p.descripcion from productos p
where (select count(pe.id) from pedidos PE 
where pe.IDProducto=p.id and pe.id in (select idpedido from envios)
group by pe.IDProducto
) < (select count(pe.id) from pedidos PE 
left join envios e on e.IDPedido=pe.id
where pe.IDProducto=p.id and e.FechaEnvio is null
group by pe.IDProducto
) and (select count(pe.id) from pedidos PE 
where pe.IDProducto=p.id and pe.id in (select idpedido from envios)
group by pe.IDProducto
) is not null

--Los nombre y apellidos de los clientes que hayan realizado pedidos en los años 2020, 2021 y 2022 pero que la cantidad de pedidos haya decrecido en cada año. 
--Añadirle al listado aquellos clientes que hayan realizado exactamente la misma cantidad de pedidos en todos los años y que dicha cantidad no sea cero.

select c.apellidos, c.nombres, t1.* from clientes C
inner join (select c.id, (select count(pe.id) from pedidos pe where pe.IDCliente=c.id and year(pe.FechaSolicitud)=2020 group by pe.IDCliente) as pedidos2020,
(select count(pe.id) from pedidos pe where pe.IDCliente=c.id and year(pe.FechaSolicitud)=2021 group by  pe.IDCliente) as pedidos2021,
(select count(pe.id) from pedidos pe where pe.IDCliente=c.id and year(pe.FechaSolicitud)=2022 group by pe.IDCliente ) as pedidos2022
from clientes C) t1 on t1.ID=c.ID
where (t1.pedidos2020<t1.pedidos2021 and t1.pedidos2021<t1.pedidos2022) or (t1.pedidos2020=t1.pedidos2021 and t1.pedidos2022=t1.pedidos2021 and t1.pedidos2020 is not null)
