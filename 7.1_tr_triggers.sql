/* ===============================================================
   BLOQUE 07 - TRIGGERS DE AUDITORÍA Y CONTROL
   Proyecto: Logística Farmacéutica
   Autor: Juan Cruz Elliff
   Objetivo: Mantener trazabilidad y validaciones automáticas
   =============================================================== */

USE [TuBaseDeDatos];
GO


/* ===============================================================
   1️ TR_Entrega_UpdateConformidad
   ---------------------------------------------------------------
   Registra automáticamente evento en TrazabilidadEvento
   cuando cambia la conformidad de una entrega.
   =============================================================== */
CREATE OR ALTER TRIGGER TR_Entrega_UpdateConformidad
ON Entrega
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(conformidad)
    BEGIN
        INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
        SELECT 
            'Entrega',
            i.id_entrega,
            CASE WHEN i.conformidad = 'Conforme' THEN 'ENTREGADA'
                 WHEN i.conformidad = 'No Conforme' THEN 'NO_CONFORME'
                 ELSE 'ACTUALIZADA' END,
            GETDATE(),
            1 -- Usuario del sistema / proceso automático
        FROM inserted i;
    END
END;
GO


/* ===============================================================
   2️ TR_CajaDetalle_ValidarCapacidad
   ---------------------------------------------------------------
   Evita que el contenido total de una caja supere su capacidad.
   =============================================================== */
CREATE OR ALTER TRIGGER TR_CajaDetalle_ValidarCapacidad
ON CajaDetalle
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Caja c
        JOIN (
            SELECT id_caja, SUM(cantidad) AS total
            FROM CajaDetalle
            GROUP BY id_caja
        ) x ON c.id_caja = x.id_caja
        WHERE x.total > c.capacidad_maxima
    )
    BEGIN
        RAISERROR ('La cantidad total en la caja excede la capacidad máxima permitida.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO


/* ===============================================================
   3️ TR_Incidencia_Insert
   ---------------------------------------------------------------
   Registra automáticamente un evento de trazabilidad cuando
   se crea una nueva incidencia.
   =============================================================== */
CREATE OR ALTER TRIGGER TR_Incidencia_Insert
ON Incidencia
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
    SELECT 
        'Entrega',
        i.id_entrega,
        'INCIDENCIA_REGISTRADA',
        GETDATE(),
        i.registrada_por
    FROM inserted i;
END;
GO


/* ===============================================================
   4️ TR_Pedido_AutoCierre
   ---------------------------------------------------------------
   Si todos los detalles de un pedido fueron entregados (todas las
   cajas asociadas a sus entregas están conformes), marca el pedido
   como 'Cerrado' y registra el evento.
   =============================================================== */
CREATE OR ALTER TRIGGER TR_Pedido_AutoCierre
ON Entrega
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Solo aplicar si cambia conformidad a 'Conforme'
    IF UPDATE(conformidad)
    BEGIN
        DECLARE @pedidosCerrados TABLE (id_pedido INT);

        INSERT INTO @pedidosCerrados (id_pedido)
        SELECT DISTINCT dp.id_pedido
        FROM Pedido p
        JOIN DetallePedido dp ON p.id_pedido = dp.id_pedido
        JOIN DetallePedidoLote dpl ON dp.id_detalle_pedido = dpl.id_detalle_pedido
        JOIN CajaDetalle cd ON dpl.id_lote = cd.id_lote
        JOIN EntregaCaja ec ON cd.id_caja = ec.id_caja
        JOIN Entrega e ON ec.id_entrega = e.id_entrega
        WHERE e.conformidad = 'Conforme'
        GROUP BY dp.id_pedido
        HAVING COUNT(DISTINCT e.id_entrega) >= 1;  -- todas las entregas del pedido realizadas

        -- Actualiza estado y registra evento
        UPDATE Pedido
        SET estado = 'Cerrado'
        WHERE id_pedido IN (SELECT id_pedido FROM @pedidosCerrados);

        INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
        SELECT 
            'Pedido',
            id_pedido,
            'CERRADO_AUTO',
            GETDATE(),
            1
        FROM @pedidosCerrados;
    END
END;
GO
