--EJERCICIO 1

CREATE TABLE CARRERAS(
    ID VARCHAR(4) PRIMARY KEY,
    NOMBRE VARCHAR(50) NOT NULL,
    FECHACREACION SMALLDATETIME CHECK(FECHACREACION<GETDATE()) NOT NULL,
    MAIL VARCHAR(100) NOT NULL,
    NIVEL VARCHAR(12) CHECK (NIVEL='Diplomatura' or NIVEL='Pregrado' or NIVEL='Grado' or NIVEL='Posgrado')
)


CREATE TABLE MATERIAS(
    ID INT IDENTITY (1,1),
    IDCARRERA VARCHAR(4) NOT NULL,
    NOMBRE VARCHAR(50) NOT NULL,
    CARGAHORARIA SMALLINT CHECK(CARGAHORARIA>0) NOT NULL,
    PRIMARY KEY (ID)
)

ALTER TABLE MATERIAS
ADD CONSTRAINT FK_IDCARRERA FOREIGN KEY (IDCARRERA) REFERENCES CARRERAS (ID)

CREATE TABLE ALUMNOS(
    ID INT IDENTITY(1000,1) PRIMARY KEY,
    IDCARRERA VARCHAR(4) NOT NULL FOREIGN KEY REFERENCES CARRERAS (ID),
    NOMBRE VARCHAR(50) NOT NULL,
    APELLIDOS VARCHAR(50) NOT NULL,
    FECHANACIMIENTO SMALLDATETIME CHECK(FECHANACIMIENTO<GETDATE()),
    MAIL VARCHAR(100) NOT NULL UNIQUE,
    TELEFONO VARCHAR(30)
)

--EJERCICIO 1.2

CREATE TABLE CATEGORIA(
    ID INT PRIMARY KEY,
    NOMBRE VARCHAR(50) NOT NULL
)

CREATE TABLE PRODUCTOS(
    ID INT PRIMARY KEY,
    NOMBRE VARCHAR(50) NOT NULL,
    PRECIOMINORISTA int NOT NULL,
    PRECIOMAYORISTA INT,
    UNIDADESMAYORISTA INT,
    DIASPRODUCCION INT NOT NULL,
    CATEGORIA INT NOT NULL,
    CONSTRAINT CK_MAYORISTA CHECK (PRECIOMAYORISTA<PRECIOMINORISTA AND UNIDADESMAYORISTA IS NOT NULL)
)

Alter table productos
add constraint  FK_category foreign key (categoria) references categoria(id)

CREATE TABLE CLIENTES(
    ID INT PRIMARY KEY,
    NOMBRE VARCHAR(50) NOT NULL,
    APELLIDO VARCHAR(50) NOT NULL,
    FECHANACIMIENTO SMALLDATETIME CHECK(FECHANACIMIENTO<GETDATE()),
    MAIL VARCHAR(100),
    REGISTRO VARCHAR(3) NULL CHECK(REGISTRO='WEB')
)

insert into Clientes 
VALUES
(9, 'Armando', 'Barreda', 10/11/1984, 'Armando.barreda@gmail.com', 'WEB'),
(10, 'Monica', 'Barros', 12/11/1984, 'Monica.barros@gmail.com', null),
(11, 'Pepe', 'Argento', 10/10/1984, 'Pepe.Argento@gmail.com', 'Web'),
(12, 'Karina', 'Ojeda', 11/11/1984, 'Karina.Ojeda@hotmail.com', null)

CREATE TABLE TELEFONO(
    IDCLIENTE INT FOREIGN KEY REFERENCES CLIENTES(ID),
    TELEFONO VARCHAR(30) NOT NULL,
    PRIMARY KEY (IDCLIENTE, TELEFONO)
)

CREATE TABLE COLABORADORES(
    LEGAJO INT PRIMARY KEY,
    APELLIDOS VARCHAR(50) NOT NULL,
    NOMBRES VARCHAR(50) NOT NULL,
    FECHANACIMIENTO SMALLDATETIME CHECK(FECHANACIMIENTO<GETDATE()) NOT NULL,
    ANIOINGRESO INT CHECK(ANIOINGRESO>1990 and ANIOINGRESO<=YEAR(GETDATE())),
    SUELDO MONEY NOT NULL,
    MODALIDAD CHAR CHECK (MODALIDAD='P' OR MODALIDAD='F')
)

CREATE TABLE PEDIDOS (
    ID INT PRIMARY KEY IDENTITY(0,1),
    IDPRODUCTO INT FOREIGN KEY REFERENCES PRODUCTOS(ID) NOT NULL,
    CANTIDAD INT NOT NULL,
    FECHASOLICITUD SMALLDATETIME DEFAULT(GETDATE()) NOT NULL,
    IDCLIENTE INT FOREIGN KEY REFERENCES CLIENTES(ID)

)

alter table pedidos
add FECHAFIN smalldatetime not null default(getdate()),
COSTO money not null default 0,
ESTADO bit not null default 0,
PAGADO bit not null default 0

 

select 
    P.ID,
    CLI.NOMBRE AS NOMBRECLIENTE,
    CLI.APELLIDO AS APELLIDOCLIENTE,
    PR.NOMBRE,
    P.CANTIDAD,
    CASE 
        WHEN P.CANTIDAD>=PR.UNIDADESMAYORISTA THEN P.CANTIDAD*PR.PRECIOMAYORISTA
        ELSE P.CANTIDAD*PRECIOMINORISTA
    END AS PRECIOFINAL,
    P.FECHASOLICITUD,
    P.FECHASOLICITUD+(PR.DIASPRODUCCION*P.CANTIDAD) AS FECHAFIN
from PEDIDOS As P
inner join CLIENTES as CLI on P.IDCLIENTE = CLI.ID
inner join PRODUCTOS as PR ON P.IDPRODUCTO = PR.ID

--Ejercicio 1.4

create table trabajos(
    ID int primary key identity (0,1),
    Idcolaborador int FOREIGN key references colaboradores(legajo) not null,
    IdTareas int not null,
    finalizado char check (finalizado='y') null,
    tiempo int
)

create table tareas (
    id int primary key identity (1,1),
    descripcion varchar(50) not null
)

alter table trabajos
add constraint fk_trabajos foreign key (idtareas) references tareas(id)

alter table trabajos
add constraint ch_tiempo check ((tiempo is not null and finalizado='y') or finalizado is null)

create table envios(
    id int primary key identity (1,1),
    idpedido int foreign key references pedidos(id) unique,
    idcliente int foreign key references clientes(id),
    direccion varchar(150) not null,
    localidad int not null,
    costo SMALLMONEY,
    bonificado char check (bonificado='y')

)

create table localidades(
    id int primary key,
    nombre varchar(100) not null
)

alter table Envios
add constraint fk_localidad foreign key (Localidad) references localidades(id)

create table materiales(
    id int primary key,
    descripcion varchar(100) not null unique
)

create table materiales_x_producto(
    idproducto int foreign key references productos(id),
    idmaterial int foreign key references materiales(id),
    primary key (idproducto, idmaterial)
)

alter table envios
add constraint ch_ids check (idpedido is not null and idcliente is not null)

create table pagos(
    recibo int primary key,
    idpedido int foreign key references pedidos(id) not null,
    idcliente int foreign key references clientes(id) not null,
    importe money not null,
    fechaPago datetime not null default(getdate()),
    
)

