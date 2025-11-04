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
