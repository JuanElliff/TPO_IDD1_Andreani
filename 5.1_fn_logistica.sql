--Tiempo de Entrega 
CREATE OR ALTER FUNCTION fn_TiempoEntrega (@id_entrega INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @horas DECIMAL(10,2);

    SELECT @horas = DATEDIFF(HOUR, MIN(t.fecha), MAX(t.fecha))
    FROM TrazabilidadEvento t
    WHERE t.entidad_afectada = 'Entrega'
      AND t.id_registro_afectado = @id_entrega;

    RETURN @horas;
END;
GO

--Capacidad Ocupada
CREATE OR ALTER FUNCTION fn_CapacidadOcupada (@id_vehiculo INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @porcentaje DECIMAL(5,2);

    SELECT @porcentaje = 
        (SUM(c.capacidad_maxima) / v.capacidad) * 100
    FROM Entrega e
    INNER JOIN EntregaCaja ec ON e.id_entrega = ec.id_entrega
    INNER JOIN Caja c ON ec.id_caja = c.id_caja
    INNER JOIN DimVehiculo v ON e.id_vehiculo = v.id_vehiculo
    WHERE e.id_vehiculo = @id_vehiculo
    GROUP BY v.capacidad;

    RETURN @porcentaje;
END;
GO

--Tiempo promedio Entrega
CREATE OR ALTER FUNCTION fn_TiempoPromedioEntrega()
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @promedio DECIMAL(10,2);

    ;WITH tiempos AS (
        SELECT 
            t.id_registro_afectado,
            DATEDIFF(HOUR, MIN(t.fecha), MAX(t.fecha)) AS horas_dif
        FROM TrazabilidadEvento t
        WHERE t.entidad_afectada = 'Entrega'
        GROUP BY t.id_registro_afectado
    )
    SELECT @promedio = AVG(CAST(horas_dif AS DECIMAL(10,2)))
    FROM tiempos;

    RETURN @promedio;
END;
GO
SELECT dbo.fn_TiempoPromedioEntrega();
