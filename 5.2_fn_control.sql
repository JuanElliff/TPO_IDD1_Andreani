--Incidencia por Entrega
CREATE OR ALTER FUNCTION fn_IncidenciasPorEntrega (@id_entrega INT)
RETURNS INT
AS
BEGIN
    DECLARE @cantidad INT;

    SELECT @cantidad = COUNT(*)
    FROM Incidencia
    WHERE id_entrega = @id_entrega;

    RETURN @cantidad;
END;
GO

--Entregas Conformes
CREATE OR ALTER FUNCTION fn_EntregasConformidad()
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @porcentaje DECIMAL(5,2);

    SELECT @porcentaje = 
        (SUM(CASE WHEN conformidad = 'Conforme' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)
    FROM Entrega;

    RETURN @porcentaje;
END;
GO

--Lotes Vencidos
CREATE OR ALTER FUNCTION fn_LotesVencidos()
RETURNS INT
AS
BEGIN
    DECLARE @vencidos INT;

    SELECT @vencidos = COUNT(DISTINCT l.id_lote)
    FROM Lote l
    INNER JOIN DetallePedidoLote dpl ON l.id_lote = dpl.id_lote
    INNER JOIN DetallePedido dp ON dpl.id_detalle_pedido = dp.id_detalle_pedido
    INNER JOIN Pedido p ON dp.id_pedido = p.id_pedido
    WHERE l.fecha_vencimiento < p.fecha_pedido;

    RETURN @vencidos;
END;
GO