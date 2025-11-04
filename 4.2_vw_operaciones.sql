-- Entregas por chofer
CREATE OR ALTER VIEW vw_EntregasPorChofer AS
SELECT 
    ch.nombre AS chofer,
    COUNT(e.id_entrega) AS total_entregas,
    SUM(CASE WHEN e.conformidad = 'Conforme' THEN 1 ELSE 0 END) AS entregas_conformes,
    AVG(e.temperatura_registrada) AS temp_promedio
FROM Entrega e
LEFT JOIN DimVehiculo v ON e.id_vehiculo = v.id_vehiculo
LEFT JOIN DimChofer ch ON v.id_chofer = ch.id_chofer
GROUP BY ch.nombre;

-- Capacidad usada por vehículo (%)
CREATE OR ALTER VIEW vw_CapacidadUsadaPorVehiculo AS
SELECT 
    v.patente,
    v.capacidad AS capacidad_total,
    SUM(c.capacidad_maxima) AS capacidad_usada,
    ROUND(SUM(c.capacidad_maxima) / v.capacidad * 100, 2) AS porcentaje_uso
FROM Entrega e
INNER JOIN EntregaCaja ec ON e.id_entrega = ec.id_entrega
INNER JOIN Caja c ON ec.id_caja = c.id_caja
INNER JOIN DimVehiculo v ON e.id_vehiculo = v.id_vehiculo
GROUP BY v.patente, v.capacidad;