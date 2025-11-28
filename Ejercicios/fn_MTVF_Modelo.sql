CREATE FUNCTION fn_ReporteComplejo (@IdCliente INT)
RETURNS @TablaResultado TABLE (
    Nombre VARCHAR(50),
    Total DECIMAL(10,2),
    Categoria VARCHAR(20)
)
AS
BEGIN
    -- 1. Lógica, Variables y Cálculos
    DECLARE @TotalGastado DECIMAL(10,2);

    SELECT @TotalGastado = SUM(Monto) 
    FROM Facturas 
    WHERE IdCliente = @IdCliente;

    -- 2. Insertar en la tabla variable según lógica
    IF @TotalGastado > 10000
    BEGIN
        INSERT INTO @TablaResultado (Nombre, Total, Categoria)
        SELECT Nombre, @TotalGastado, 'VIP' 
        FROM Clientes WHERE IdCliente = @IdCliente;
    END
    ELSE
    BEGIN
        INSERT INTO @TablaResultado (Nombre, Total, Categoria)
        SELECT Nombre, @TotalGastado, 'Regular' 
        FROM Clientes WHERE IdCliente = @IdCliente;
    END

    -- 3. Retorno final
    RETURN;
END;