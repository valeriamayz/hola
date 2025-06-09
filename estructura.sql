CREATE DATABASE pizzeria;

use pizzeria;

-- CREACIÓN DE TABLAS
CREATE TABLE localidades (
codigo char (3) NOT NULL ,
nombre char(50) NOT NULL,
codigopostal char(5),	
PRIMARY KEY (codigo)
);

create table Clientes (
codigo integer NOT NULL ,
nif char(12) NOT NULL,
nombre char(50) not null,
apellido1 char(50) not null,
apellido2 char(50) ,
telefono char(12) not null,
calle char(100) not null,
numero char(4) not null,
letra char(1),
piso char (3),
puerta char (2),
observaciones varchar(200),
localidad char(3) not null,
PRIMARY KEY (codigo),
FOREIGN KEY (localidad) references
Localidades (codigo) /* on update cascade 
on delete no action */
);

create table Personal (
codigo integer NOT NULL ,
nif char(12) NOT NULL,
nombre char(50) not null,
apellido1 char(50) not null,
apellido2 char(50) ,
telefono char(12),
email char(50), /*check (email like '%@%'),*/
calle char(100) not null,
numero char(4) not null,
piso char (3),
puerta char (2),
localidad char(3) not null,
fechaAlta date, /*not null default getdate()*/
fechaBaja date,
PRIMARY KEY (codigo),
FOREIGN KEY (localidad) references
Localidades (codigo) /*on update cascade on delete no action,
CONSTRAINT fechaBaja check(fechaAlta<=fechaBaja or fechaBaja=null)*/
);
create table Estados (
	codigo char (3) not null,
	descripcion char (20) not null,
	PRIMARY KEY (codigo)
);
create table MediosPago(
	codigo char (3) not null,
	descripcion char(20) not null,
	PRIMARY KEY (codigo)
);
create table Bases (
	codigo char (3) not null,
	descripcion char (20) not null,
	importe numeric (4,2), /*default 0*/
	PRIMARY KEY (codigo)
);
create table Ingredientes (
	codigo char (3) not null,
	descripcion char (20) not null,
	importe numeric(5,2) default 0,
	PRIMARY KEY (codigo)
);
create table Pedidos (
	codigo integer not null,
	iva integer not null, /*check (iva >=0 and iva<=100)*/
	FechaHoraPedido datetime not null,
	FechaHoraServicio datetime null,
	importe numeric(6,2) not null, 
	observaciones varchar (100) null,
	estado char(3) not null,
	cliente integer not null,
	personal integer not null,
	pago char(3) not null,
	PRIMARY KEY (codigo),	
	foreign key (estado) references Estados (codigo),	
	foreign key (cliente) references
	Clientes (codigo),
	foreign key (personal) references Personal (codigo),
	foreign key (pago) references MediosPago (codigo)
);
create table Pizzas (
	codigo integer not null,
	pedido integer not null,
	base char (3) not null,
	importeBase numeric(5,2) not null,
	primary key(codigo),
	foreign key (base) references Bases (codigo), /*on update cascade on delete no action*/
    foreign key (pedido) references Pedidos (codigo) /*on update cascade on delete cascade*/
);
create table IngredienteDePizza (
	pizza integer not null,
	ingrediente char (3) not null,
	importe numeric(5,2) not null,
	foreign key (ingrediente) references Ingredientes (codigo),
	foreign key (pizza) references Pizzas (codigo)
);
