--COMERCIAL

-- Pedidos por cliente
CREATE OR ALTER VIEW vw_PedidosPorCliente AS
SELECT 
    ec.razon_social AS cliente,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(CASE WHEN p.estado = 'Pendiente' THEN 1 ELSE 0 END) AS pedidos_pendientes,
    SUM(CASE WHEN p.estado = 'Cerrado' THEN 1 ELSE 0 END) AS pedidos_cerrados
FROM Pedido p
LEFT JOIN DimEmpresaCliente ec ON p.id_empresa_cliente = ec.id_empresa_cliente
GROUP BY ec.razon_social;

-- Productos que requieren refrigeración
CREATE OR ALTER VIEW vw_ProductosConRefrigeracion AS
SELECT 
    nombre AS producto,
    descripcion,
    requiere_refrigeracion
FROM DimProducto
WHERE requiere_refrigeracion = 1;
