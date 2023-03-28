-- tp N 1A

create table articulos(
    codigo varchar(6) primary key,
    descripcion varchar(50) not null,
    marca smallint not null,
    precio_compra SMALLMONEY not null,
    precio_venta SMALLMONEY not null,
    tipo_articulo smallint not null,
    stock_actual int not null,
    stock_min int not null,
    estado bit not null
)

create table marcas(
    id smallint primary key,
    nombre varchar(50) not null
)

create table tipo_productos(
    id smallint primary key,
    nombre varchar(50) not null
)

create table vendedores(
    legajo int primary key,
    dni varchar(7) not null unique,
    apellidos varchar(20) not null,
    nombres varchar(20) not null,
    sexo bit check (sexo='F' or sexo='M'),
    fecha_nacimiento smalldatetime check (fecha_nacimiento<getdate()),
    direccion varchar(100) not null,
    cp varchar(5) not null,
    localidad int not null,
    telefono varchar(15) not null,
    sueldo smallmoney
)

create table provincias(
    Id int primary key,
    nombre varchar(20) not null
)

create table localidades(
    id int not null primary key,
    nombre varchar(50) not null,
    provincia int not null
    unique(nombre,provincia)
)

create table clientes(
    dni varchar(7) not null,
    apellidos varchar(20) not null,
    nombres varchar(20) not null,
    sexo bit check (sexo='F' or sexo='M'),
    telefono varchar(15) not null,
    mail varchar(15) not null,
    fecha_alta smalldatetime not null default(getdate()),
    fecha_nacimiento smalldatetime not null check (fecha_nacimiento<getdate()),
    direccion varchar(100) not null,
    cp varchar(5) not null,
    localidad int not null foreign key references localidades(id)
)

alter table articulos
add constraint fk_tipoart foreign key (tipo_articulo) references tipo_productos(id)

alter table articulos
add constraint fk_marca foreign key (marca) references marcas(id)

alter table vendedores
add constraint fk_localidad foreign key (localidad) references localidades(id)

alter table localidades
add constraint fk_provincia foreign key (provincia) references provincias(id)

alter table clientes
add constraint pk_clientes primary key(dni)

create table ventas(
    codigo int identity(1,1) primary key,
    fecha smalldatetime default(getdate()),
    cliente varchar(7) foreign key references clientes(dni),
    vendedor int foreign key references vendedores(legajo),
    forma_pago bit not null check(forma_pago='E' or forma_pago='T'),
    importe money not null
)

create table venta_x_articulo(
    venta int foreign key references ventas(codigo),
    codigo_art varchar(6) foreign key references articulos(codigo),
    precio_unitario smallmoney not null,
    cantidad smallint not NULL,
    primary key (venta, codigo_art)
)


-- tp N 1C

create table carreras2(
    codigo int primary key,
    nombre varchar(50) not null
)

create table materias2(
    codigo int primary key,
    nombre varchar(20) not null
)

create table cargos(
    id int primary key,
    descripcion varchar(50) not null unique
)

create table docentes(
    legajo int primary key,
    dni varchar(7) unique not null,
    fecha_nacimiento smalldatetime not null,
    nombres varchar(20) not null,
    apellidos varchar(20) not null
)

create table materias_x_carrera(
    carrera int foreign key references carreras2(codigo) not NULL,
    materia int foreign key references materias2(codigo) not null,
    docente int foreign key references docentes(legajo),
    cargo_docente int foreign key references cargos(id),
    primary key (carrera, materia, docente)
)

