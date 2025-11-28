CREATE TRIGGER trg_BloqueoBorrado
ON TablaCritica -- (Ej: Trazabilidad)
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Detectar qué intentaron borrar
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- 2. (Opcional) Guardar el intento en log de auditoría
        INSERT INTO LogSeguridad (Usuario, Fecha, Accion)
        VALUES (SYSTEM_USER, GETDATE(), 'Intento de Borrado Ilegal');

        -- 3. Lanzar el error bloqueante
        ;THROW 51000, 'SEGURIDAD: No está permitido borrar registros de esta tabla.', 1;
    END
END;