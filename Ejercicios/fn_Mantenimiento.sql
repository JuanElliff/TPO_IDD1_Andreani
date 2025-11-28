CREATE OR ALTER FUNCTION dbo.fn_DisponibilidadVehiculo(
	@id_vehiculo INT,
	@fecha_desde DATE,
	@fecha_hasta DATE
	)

	RETURNS TABLE
	AS
	RETURN
	(
		WITH CTE_RangoFechas AS(
			SELECT @fecha_desde AS Fecha

			UNION ALL

			SELECT DATEADD(DAY, 1, Fecha)
			FROM CTE_RangoFechas
			WHERE Fecha  < @fecha_hasta
			)

		SELECT 
			rf.Fecha,
			Estado= 
				CASE 
					WHEN EXISTS(
						SELECT 1 FROM Mantenimientos m
						WHERE m.id_vehiculo = @id_vehiculo
						AND rf.Fecha >= m.fecha_inicio 
						AND rf.Fecha <= m.fecha_fin
					)THEN 'En Mantenimiento'
					WHEN EXISTS (
						SELECT 1 FROM Viajes v
						WHERE v.id_vehiculo = @id_vehiculo
						AND  rf.Fecha >= v.fecha_salida
						AND  rf.Fecha <= v.fecha_llegada
					)THEN 'En Viaje'
					ELSE 'Disponible'
				END AS Estado
		FROM CTE_RangoFechas rf
);