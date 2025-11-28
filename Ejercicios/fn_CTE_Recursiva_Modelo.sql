-- Función que devuelve una tabla con fechas
CREATE FUNCTION fn_GenerarRangoFechas (@FechaDesde DATE, @FechaHasta DATE)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Calendario AS (
        -- Caso Base: El primer día
        SELECT @FechaDesde AS Fecha
        
        UNION ALL
        
        -- Parte Recursiva: Sumar 1 día hasta llegar al final
        SELECT DATEADD(DAY, 1, Fecha)
        FROM CTE_Calendario
        WHERE DATEADD(DAY, 1, Fecha) < @FechaHasta -- Ojo con el < o <=
    )
    SELECT Fecha FROM CTE_Calendario
);
-- Nota: Si el rango es mayor a 100 días, al llamarla usar OPTION (MAXRECURSION 0)