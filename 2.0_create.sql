-- =====================================================
-- MODELO RELACIONAL - CASO ANDREANI
-- Fase 2: Creación de tablas y restricciones
-- Compatible con Azure SQL Database
-- =====================================================

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

--------------------------------------------------------
-- ENTIDADES PRINCIPALES
--------------------------------------------------------

CREATE TABLE Lote (
    id_lote            INT IDENTITY(1,1) PRIMARY KEY,
    id_producto        INT NOT NULL FOREIGN KEY REFERENCES DimProducto(id_producto),
    fecha_vencimiento  DATE NOT NULL,
    temperatura_min    DECIMAL(5,2),
    temperatura_max    DECIMAL(5,2)
);

CREATE TABLE Pedido (
    id_pedido           INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa_cliente  INT NOT NULL FOREIGN KEY REFERENCES DimEmpresaCliente(id_empresa_cliente),
    id_cliente_destino  INT NOT NULL FOREIGN KEY REFERENCES DimClienteDestino(id_cliente_destino),
    fecha_pedido        DATETIME2 NOT NULL,
    fecha_comprometida  DATETIME2,
    estado              VARCHAR(20) CHECK (estado IN ('PENDIENTE','EN_PROCESO','ENTREGADO','CANCELADO'))
);

CREATE TABLE DetallePedido (
    id_detalle_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido         INT NOT NULL FOREIGN KEY REFERENCES Pedido(id_pedido),
    id_producto       INT NOT NULL FOREIGN KEY REFERENCES DimProducto(id_producto),
    cantidad          INT NOT NULL CHECK (cantidad > 0)
);

CREATE TABLE DetallePedidoLote (
    id_detalle_pedido INT NOT NULL,
    id_lote           INT NOT NULL,
    cantidad_asignada INT NOT NULL CHECK (cantidad_asignada > 0),
    CONSTRAINT PK_DetallePedidoLote PRIMARY KEY (id_detalle_pedido, id_lote),
    CONSTRAINT FK_DPL_Detalle FOREIGN KEY (id_detalle_pedido) REFERENCES DetallePedido(id_detalle_pedido),
    CONSTRAINT FK_DPL_Lote FOREIGN KEY (id_lote) REFERENCES Lote(id_lote)
);

--------------------------------------------------------
-- CAJAS Y CONSOLIDACIÓN
--------------------------------------------------------

CREATE TABLE Caja (
    id_caja             INT IDENTITY(1,1) PRIMARY KEY,
    tipo                VARCHAR(50),
    capacidad_maxima    DECIMAL(10,2) CHECK (capacidad_maxima > 0),
    fecha_consolidacion DATETIME2
);

CREATE TABLE CajaDetalle (
    id_caja_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_caja         INT NOT NULL FOREIGN KEY REFERENCES Caja(id_caja),
    id_lote         INT NOT NULL FOREIGN KEY REFERENCES Lote(id_lote),
    cantidad        DECIMAL(10,2) NOT NULL CHECK (cantidad > 0)
);

--------------------------------------------------------
-- LOGÍSTICA Y ENTREGA
--------------------------------------------------------

CREATE TABLE Entrega (
    id_entrega             INT IDENTITY(1,1) PRIMARY KEY,
    id_vehiculo            INT NOT NULL FOREIGN KEY REFERENCES DimVehiculo(id_vehiculo),
    id_ruta                INT NOT NULL FOREIGN KEY REFERENCES DimRuta(id_ruta),
    fecha_entrega          DATETIME2 NOT NULL,
    receptor               VARCHAR(100),
    temperatura_registrada DECIMAL(5,2),
    conformidad            VARCHAR(20) CHECK (conformidad IN ('CONFORME','NO_CONFORME','PENDIENTE')),
    observaciones           VARCHAR(MAX)
);

CREATE TABLE EntregaCaja (
    id_entrega INT NOT NULL FOREIGN KEY REFERENCES Entrega(id_entrega),
    id_caja    INT NOT NULL FOREIGN KEY REFERENCES Caja(id_caja),
    CONSTRAINT PK_EntregaCaja PRIMARY KEY (id_entrega, id_caja)
);

--------------------------------------------------------
-- INCIDENTES Y TRAZABILIDAD
--------------------------------------------------------

CREATE TABLE Incidencia (
    id_incidencia  INT IDENTITY(1,1) PRIMARY KEY,
    id_entrega     INT NOT NULL FOREIGN KEY REFERENCES Entrega(id_entrega),
    tipo           VARCHAR(50),
    descripcion    VARCHAR(MAX),
    fecha          DATETIME2,
    registrada_por INT FOREIGN KEY REFERENCES DimUsuario(id_usuario)
);

CREATE TABLE TrazabilidadEvento (
    id_evento            INT IDENTITY(1,1) PRIMARY KEY,
    entidad_afectada     VARCHAR(30) NOT NULL,
    id_registro_afectado INT NOT NULL,
    accion               VARCHAR(30),
    fecha                DATETIME2,
    id_usuario           INT FOREIGN KEY REFERENCES DimUsuario(id_usuario)
);
