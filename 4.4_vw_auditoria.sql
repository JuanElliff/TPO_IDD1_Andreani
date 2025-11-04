--AUDITORIA Y CONTROL


-- Incidencias por tipo
CREATE OR ALTER VIEW vw_IncidenciasPorTipo AS
SELECT 
    tipo,
    COUNT(*) AS cantidad,
    COUNT(DISTINCT id_entrega) AS entregas_afectadas
FROM Incidencia
GROUP BY tipo;

-- Pedidos con productos vencidos
CREATE OR ALTER VIEW vw_PedidosVencidos AS
SELECT DISTINCT
    p.id_pedido,
    ec.razon_social AS cliente,
    l.fecha_vencimiento,
    dp.id_producto
FROM Pedido p
INNER JOIN DetallePedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN Lote l ON dp.id_producto = l.id_producto
INNER JOIN DimEmpresaCliente ec ON p.id_empresa_cliente = ec.id_empresa_cliente
WHERE l.fecha_vencimiento < p.fecha_pedido;

-- Trazabilidad: últimos eventos por entidad
CREATE OR ALTER VIEW vw_TrazabilidadUltimosEventos AS
SELECT 
    t.entidad_afectada,
    t.id_registro_afectado,
    MAX(t.fecha) AS ultima_fecha,
    MAX(t.accion) AS ultima_accion
FROM TrazabilidadEvento t
GROUP BY t.entidad_afectada, t.id_registro_afectado;
