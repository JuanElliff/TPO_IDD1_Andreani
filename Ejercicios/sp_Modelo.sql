CREATE OR ALTER PROCEDURE sp_NombreDelProceso
    @Parametro1 INT,
    @Parametro2 VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON; -- 1. Buena práctica siempre

    BEGIN TRY
        -- 2. Configuración de Aislamiento (Solo si piden evitar lecturas fantasma/sucias)
        -- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 

        BEGIN TRANSACTION;

        -- 3. Validaciones de Negocio (Bloqueantes)
        IF NOT EXISTS (SELECT 1 FROM TablaMaestra WHERE ID = @Parametro1)
        BEGIN
            -- El punto y coma antes del THROW es obligatorio
            ;THROW 51000, 'ERROR: El ID ingresado no existe.', 1;
        END

        -- 4. La Acción Principal
        INSERT INTO TablaDestino (Columna1, Columna2)
        VALUES (@Parametro1, @Parametro2);

        -- 5. Confirmación
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- 6. Rollback Seguro (Solo si hay transacción viva)
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- 7. Relanzar el error exacto
        ;THROW;
    END CATCH
END;