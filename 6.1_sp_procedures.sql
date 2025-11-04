
--sp_RegistrarEventoTrazabilidad - Auditoria
CREATE OR ALTER PROCEDURE sp_RegistrarEventoTrazabilidad
    @entidad VARCHAR(50),
    @id_registro INT,
    @accion VARCHAR(100),
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
    VALUES (@entidad, @id_registro, @accion, GETDATE(), @id_usuario);
END;
GO

--sp_CrearPedido - Operaciones
CREATE OR ALTER PROCEDURE sp_CrearPedido
    @id_empresa_cliente INT,
    @estado VARCHAR(50),
    @id_usuario INT,
    @id_pedido_out INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Pedido (id_empresa_cliente, fecha_pedido, estado)
    VALUES (@id_empresa_cliente, GETDATE(), @estado);

    SET @id_pedido_out = SCOPE_IDENTITY();

    EXEC sp_RegistrarEventoTrazabilidad 'Pedido', @id_pedido_out, 'CREADO', @id_usuario;
END;
GO

--sp_CerrarPedido - Operaciones
CREATE OR ALTER PROCEDURE sp_CerrarPedido
    @id_pedido INT,
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Pedido
    SET estado = 'Cerrado'
    WHERE id_pedido = @id_pedido;

    EXEC sp_RegistrarEventoTrazabilidad 'Pedido', @id_pedido, 'CERRADO', @id_usuario;
END;
GO

--sp_GenerarEntrega - logistica
CREATE OR ALTER PROCEDURE sp_GenerarEntrega
    @id_vehiculo INT,
    @id_ruta INT,
    @receptor VARCHAR(100),
    @id_usuario INT,
    @id_entrega_out INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Entrega (id_vehiculo, id_ruta, fecha_entrega, receptor, conformidad)
    VALUES (@id_vehiculo, @id_ruta, GETDATE(), @receptor, 'Pendiente');

    SET @id_entrega_out = SCOPE_IDENTITY();

    EXEC sp_RegistrarEventoTrazabilidad 'Entrega', @id_entrega_out, 'PROGRAMADA', @id_usuario;
END;
GO

--sp_ActualizarConformidadEntrega - Control/Chofer
CREATE OR ALTER PROCEDURE sp_ActualizarConformidadEntrega
    @id_entrega INT,
    @conformidad VARCHAR(50),
    @temperatura FLOAT,
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Entrega
    SET conformidad = @conformidad,
        temperatura_registrada = @temperatura
    WHERE id_entrega = @id_entrega;

    DECLARE @accion VARCHAR(100);
    SET @accion = CASE WHEN @conformidad = 'Conforme' THEN 'ENTREGADA' ELSE 'NO_CONFORME' END;

    EXEC sp_RegistrarEventoTrazabilidad 'Entrega', @id_entrega, @accion, @id_usuario;
END;
GO

--sp_RegistrarIncidencia - auditoria
CREATE OR ALTER PROCEDURE sp_RegistrarIncidencia
    @id_entrega INT,
    @tipo VARCHAR(100),
    @descripcion TEXT,
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Incidencia (id_entrega, tipo, descripcion, fecha, registrada_por)
    VALUES (@id_entrega, @tipo, @descripcion, GETDATE(), @id_usuario);

    EXEC sp_RegistrarEventoTrazabilidad 'Entrega', @id_entrega, 'INCIDENCIA_REGISTRADA', @id_usuario;
END;
GO

--sp_ConsolidarCaja - Operaciones
CREATE OR ALTER PROCEDURE sp_ConsolidarCaja
    @id_caja INT,
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Caja
    SET fecha_consolidacion = GETDATE()
    WHERE id_caja = @id_caja;

    EXEC sp_RegistrarEventoTrazabilidad 'Caja', @id_caja, 'CONSOLIDADA', @id_usuario;
END;
GO
