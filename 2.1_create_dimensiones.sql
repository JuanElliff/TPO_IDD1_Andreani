
--------------------------------------------------------
-- DIMENSIONES
--------------------------------------------------------

CREATE TABLE DimEmpresaCliente (
    id_empresa_cliente INT IDENTITY(1,1) PRIMARY KEY,
    razon_social        VARCHAR(100) NOT NULL,
    cuit                VARCHAR(11)  NOT NULL UNIQUE CHECK (LEN(cuit)=11),
    direccion           VARCHAR(150),
    contacto            VARCHAR(100)
);

CREATE TABLE DimClienteDestino (
    id_cliente_destino  INT IDENTITY(1,1) PRIMARY KEY,
    nombre              VARCHAR(100) NOT NULL,
    tipo                VARCHAR(50),
    direccion           VARCHAR(150),
    localidad           VARCHAR(100),
    provincia           VARCHAR(100),
    contacto            VARCHAR(100)
);

CREATE TABLE DimProducto (
    id_producto             INT IDENTITY(1,1) PRIMARY KEY,
    nombre                  VARCHAR(100) NOT NULL,
    descripcion             VARCHAR(250),
    requiere_refrigeracion  BIT NOT NULL CHECK (requiere_refrigeracion IN (0,1))
);

CREATE TABLE DimChofer (
    id_chofer INT IDENTITY(1,1) PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    dni       VARCHAR(15) NOT NULL UNIQUE,
    telefono  VARCHAR(30)
);

CREATE TABLE DimVehiculo (
    id_vehiculo INT IDENTITY(1,1) PRIMARY KEY,
    patente     VARCHAR(20) NOT NULL UNIQUE,
    capacidad   DECIMAL(10,2) NOT NULL CHECK (capacidad > 0),
    refrigerado BIT NOT NULL CHECK (refrigerado IN (0,1)),
    id_chofer   INT NOT NULL FOREIGN KEY REFERENCES DimChofer(id_chofer)
);

CREATE TABLE DimRuta (
    id_ruta     INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(150),
    provincia   VARCHAR(100) CHECK (LEN(provincia)>0),
    zona        VARCHAR(100) CHECK (LEN(zona)>0)
);

CREATE TABLE DimUsuario (
    id_usuario  INT IDENTITY(1,1) PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    rol         VARCHAR(30),
    email       VARCHAR(100) UNIQUE
);