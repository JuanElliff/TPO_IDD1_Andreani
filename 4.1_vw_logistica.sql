USE tp_idd1_db;


/* ===============================================================
   1️ VISTAS DE LOGÍSTICA
   =============================================================== */

-- Entregas por estado (conformidad)
CREATE OR ALTER VIEW vw_EntregasPorEstado AS
SELECT 
    e.id_entrega,
    e.fecha_entrega,
    e.conformidad,
    e.temperatura_registrada,
    v.patente AS vehiculo,
    ch.nombre AS chofer,
    r.descripcion AS ruta,
    COUNT(DISTINCT ec.id_caja) AS cajas_entregadas
FROM Entrega e
LEFT JOIN DimVehiculo v ON e.id_vehiculo = v.id_vehiculo
LEFT JOIN DimChofer ch ON v.id_chofer = ch.id_chofer
LEFT JOIN DimRuta r ON e.id_ruta = r.id_ruta
LEFT JOIN EntregaCaja ec ON e.id_entrega = ec.id_entrega
GROUP BY e.id_entrega, e.fecha_entrega, e.conformidad, e.temperatura_registrada, 
         v.patente, ch.nombre, r.descripcion;

-- Entregas con incidencias
CREATE OR ALTER VIEW vw_EntregasConIncidencias AS
SELECT 
    e.id_entrega,
    e.fecha_entrega,
    e.conformidad,
    i.tipo AS tipo_incidencia,
    i.descripcion AS detalle_incidencia,
    u.nombre AS registrado_por
FROM Entrega e
INNER JOIN Incidencia i ON e.id_entrega = i.id_entrega
LEFT JOIN DimUsuario u ON i.registrada_por = u.id_usuario;


--select * from vw_EntregasConIncidencias
--select * from vw_EntregasPorEstado
--select * from Entrega