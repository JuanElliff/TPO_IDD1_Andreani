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
