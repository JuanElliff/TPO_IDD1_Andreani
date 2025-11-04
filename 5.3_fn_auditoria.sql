--Auditoria

CREATE OR ALTER FUNCTION fn_TrazabilidadUltimoEstado (
    @entidad VARCHAR(50),
    @id_registro INT
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @accion VARCHAR(100);

    SELECT TOP 1 @accion = accion
    FROM TrazabilidadEvento
    WHERE entidad_afectada = @entidad
      AND id_registro_afectado = @id_registro
    ORDER BY fecha DESC;

    RETURN @accion;
END;
GO

select dbo.fn_TrazabilidadUltimoEstado('Caja', 3) AS UltimoEStado