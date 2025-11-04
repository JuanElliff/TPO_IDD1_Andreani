/* ===============================================================
   KPI 1 – Nivel de cumplimiento en entregas
   ---------------------------------------------------------------
% de entregas realizadas en la fecha comprometida (On Time Delivery Rate)
   =============================================================== */
SELECT 
    CAST(100.0 * SUM(CASE WHEN e.fecha_entrega <= p.fecha_comprometida THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2)) AS CumplimientoEntregaPct
FROM Entrega e
JOIN Pedido p ON e.id_entrega = p.id_pedido;


/* ===============================================================
    KPI 2 – Trazabilidad completa por lote
   ---------------------------------------------------------------
    Registro del recorrido de un lote desde su preparación hasta la entrega
   =============================================================== */

SELECT 
    l.id_lote,
    p.id_pedido,
    c.id_caja,
    e.id_entrega,
    v.patente AS vehiculo,
    r.descripcion AS ruta,
    e.fecha_entrega,
    e.temperatura_registrada
FROM Lote l
JOIN DetallePedidoLote dl ON l.id_lote = dl.id_lote
JOIN DetallePedido dp ON dl.id_detalle_pedido = dp.id_detalle_pedido
JOIN Pedido p ON dp.id_pedido = p.id_pedido
JOIN CajaDetalle cd ON l.id_lote = cd.id_lote
JOIN Caja c ON cd.id_caja = c.id_caja
JOIN EntregaCaja ec ON c.id_caja = ec.id_caja
JOIN Entrega e ON ec.id_entrega = e.id_entrega
JOIN DimVehiculo v ON e.id_vehiculo = v.id_vehiculo
JOIN DimRuta r ON e.id_ruta = r.id_ruta
ORDER BY l.id_lote, e.fecha_entrega;

/* ===============================================================
    KPI 3 – Índice de consolidación de pedidos   
    ---------------------------------------------------------------
    Cantidad promedio de productos distintos por caja enviada.
   =============================================================== */
SELECT 
    AVG(ProductosPorCaja) AS PromedioConsolidacion
FROM (
    SELECT c.id_caja, COUNT(DISTINCT l.id_producto) AS ProductosPorCaja
    FROM Caja c
    JOIN CajaDetalle cd ON c.id_caja = cd.id_caja
    JOIN Lote l ON cd.id_lote = l.id_lote
    GROUP BY c.id_caja
) t;


   /* ===============================================================
    KPI 4 – Utilización de flota
   ---------------------------------------------------------------
    % de ocupación promedio de los vehículos por zona y tipo.
   =============================================================== */
SELECT 
    r.zona,
	v.refrigerado,
    CAST(100.0 * SUM(c.capacidad_maxima) / SUM(v.capacidad) AS DECIMAL(5,2)) AS UtilizacionFlotaPct
FROM Entrega e
JOIN EntregaCaja ec ON e.id_entrega = ec.id_entrega
JOIN Caja c ON ec.id_caja = c.id_caja
JOIN DimVehiculo v ON e.id_vehiculo = v.id_vehiculo
JOIN DimRuta r ON e.id_ruta = r.id_ruta
GROUP BY r.zona, v.refrigerado;


   /* ===============================================================
    KPI 5 – Incidencias por error de lote
   ---------------------------------------------------------------
   Cantidad de incidencias registradas por error de lote.
   =============================================================== */

SELECT 
    COUNT(*) AS TotalIncidenciasLote
FROM Incidencia i
WHERE i.tipo LIKE '%lote%';


