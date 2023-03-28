
create table usuarios (
    dni varchar(9) primary key not null,
    Apellidos varchar(20) not null,
    Nombres varchar(50) not null,
    fechaNacimiento smalldatetime not null check (fechaNacimiento<getdate()),
    Domicilio varchar(100) not null,
    estado bit not null default (1)
)

create table tarjetas (
    numero varchar(20) primary key not null,
    dniUsuario varchar(9) foreign key references usuarios(dni),
    fechaAlta smalldatetime not null default (getdate()),
    saldo smallmoney not null,
    estado bit not null default (1)
 )


create table lineas(
    codigo int primary key not null IDENTITY (1,1),
    nombre varchar(20) not null,
    direccionLegal varchar(100) not null

)

create table colectivos(
    id int not null IDENTITY (1,1),
    linea int foreign key references lineas(codigo),
    primary key (id)
)

create table viajes (
    id int primary key not null IDENTITY (1,1),
    fechaViaje smalldatetime not null default(getdate()),
    colectivo int foreign key references colectivos(id) not null,
    nroTarjeta varchar(20) foreign key references tarjetas(numero) not null,
    dniUsuario varchar(9) foreign key references usuarios(dni),
    costo smallmoney not null

)

drop table movimientos 

create table movimientos (
    id int primary key identity (1,1),
    fechaHora smalldatetime not null default(getdate()),
    tarjeta varchar(20) foreign key references tarjetas(numero),
    importe smallmoney,
    movimiento char(1) check (movimiento = 'C' or movimiento='D')
)


-- Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.

create view datos_usuarios AS
select u.apellidos, u.nombres, t.numero as numero_tarjeta, t.estado, t.saldo from usuarios u
inner join tarjetas t on t.dniUsuario=u.dni
go

select * from datos_usuarios

-- Realizar una vista que permita conocer los datos de los usuarios y sus respectivos viajes. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, fecha del viaje, 
--importe del viaje, número de interno y nombre de la línea.

create view viajes_usuarios AS
select u.apellidos, u.nombres, t.numero, v.fechaviaje, v.costo, v.colectivo, l.nombre from usuarios U
inner join tarjetas t on t.dniUsuario=u.dni
inner join viajes v on v.dniUsuario=u.dni
inner join colectivos c on c.id=v.colectivo
inner join lineas l on l.codigo=c.linea
go
-- Realizar una vista que permita conocer los datos estadísticos de cada tarjeta. La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, cantidad de viajes realizados, 
--total de dinero acreditado (históricamente), cantidad de recargas, importe de recarga promedio (en pesos), estado de la tarjeta.

create view datos_estadisticos_tarjetas AS
select u.apellidos, u.nombres, t.numero, (select count(v.id) from viajes v where v.nroTarjeta=t.numero) as cantidad_viajes, 
(select sum(m.importe) from movimientos m where m.tarjeta=t.numero and m.movimiento='C') as creditos_totales,
(select count(m.id) from movimientos m where m.tarjeta=t.numero and m.movimiento='C') as cargas_totales,
(select avg(m.importe) from movimientos m where m.tarjeta=t.numero and m.movimiento='C') as carga_promedio, t.estado from usuarios u
inner join tarjetas t on t.dniUsuario=u.dni
go

select * from datos_estadisticos_tarjetas

