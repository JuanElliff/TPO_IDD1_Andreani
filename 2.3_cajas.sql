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
