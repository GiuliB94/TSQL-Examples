--Actividad Integradora n1

--Listado con Apellido y nombres de los técnicos que, en promedio, hayan demorado más de 225 minutos en la prestación de servicios.

select t.apellido, t.nombre, avg(s.duracion) promedioServicios from tecnicos T
inner join servicios s on s.idtecnico=t.ID
group by t.id, t.apellido, t.Nombre
having avg(s.duracion)>225

--Listado con Descripción del tipo de servicio, el texto 'Particular' y la cantidad de clientes de tipo Particular. Luego añadirle un listado con descripción del tipo de servicio, el texto 'Empresa' y la cantidad de clientes de tipo Empresa.
select t1.descripcion, t1.tipocliente, t1.cantidad, t2.tipocliente, t2.cantidad FROM
(select ts.descripcion, 'Particular' as TipoCliente, count(distinct c.id) as cantidad from TiposServicio ts
inner join servicios s on s.idTipo=ts.ID
inner join clientes c on c.id=s.IDCliente
where c.Tipo='P'
GROUP BY ts.id, TS.DESCRIPCION
) t1
inner JOIN
(select ts.descripcion, 'Empresa' as TipoCliente, count(distinct c.id) as cantidad from TiposServicio ts
inner join servicios s on s.idTipo=ts.ID
inner join clientes c on c.id=s.IDCliente
where c.Tipo='E'
GROUP BY ts.id, TS.DESCRIPCION) t2 on t1.Descripcion=t2.Descripcion



--Listado con Apellidos y nombres de los clientes que hayan abonado con las cuatro formas de pago.

select c.apellido, c.nombre from clientes C
inner join servicios s on s.IDCliente=c.ID
group by c.id, c.apellido, c.nombre
having count(distinct s.FormaPago)=4

--La descripción del tipo de servicio que en promedio haya brindado mayor cantidad de días de garantía.

select top 1 ts.descripcion, avg(diasGarantia) as GarantiaPromedio from tiposservicio TS
inner join servicios s on s.idtipo=ts.id
group by ts.Descripcion
order by GarantiaPromedio desc

--Agregar las tablas y/o restricciones que considere necesario para permitir a un cliente que contrate a un técnico por un período determinado.
-- Dicha contratación debe poder registrar la fecha de inicio y fin del trabajo, el costo total, el domicilio al que debe el técnico asistir y la periodicidad del trabajo (1 - Diario, 2 - Semanal, 3 - Quincenal).

create table Contrataciones(
    ID int IDENTITY(1,1) primary key,
    IDTecnico int foreign key references tecnicos(id) not null,
    IDCliente int foreign key references clientes(id) not null,
    FechaInicio smalldatetime DEFAULT(GETDATE()) NOT NULL,
    FechaFin smalldatetime not null,
    DomicilioContratacion varchar(150) not null,
    CostoTotal money not null,
    periodicidad char not null check(periodicidad='1' or periodicidad='2' or periodicidad='3')
)

alter table Contrataciones
add constraint c_fechafin check(fechainicio<fechafin)
