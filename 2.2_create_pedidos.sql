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