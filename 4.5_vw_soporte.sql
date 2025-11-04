--Soporte?
-- Qué productos hay en cada caja
CREATE OR ALTER VIEW vw_CajasConContenido AS
SELECT 
    c.id_caja,
    c.tipo,
    cd.id_lote,
    p.nombre AS producto,
    cd.cantidad
FROM CajaDetalle cd
INNER JOIN Caja c ON cd.id_caja = c.id_caja
INNER JOIN Lote l ON cd.id_lote = l.id_lote
INNER JOIN DimProducto p ON l.id_producto = p.id_producto;
