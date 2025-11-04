-- ===========================================================
-- Script: description.sql
-- Propósito:
--   Asigna descripciones (propiedades extendidas) a columnas
--   y tablas del modelo relacional "Caso Andreani".
--   Estas descripciones se almacenan en sys.extended_properties
--   para documentación y herramientas como Power BI o Fabric.
--
-- Notas:
--   - Las propiedades se crean bajo el nombre 'Column_Description'
--     o 'Table_Description'.
--   - No alteran datos ni estructuras; solo agregan metadatos.
--   - Para visualizar en SSMS, duplicar con 'MS_Description'.
--
-- Autor: Juan Cruz Elliff
-- Fecha: Octubre 2025
-- ===========================================================

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = '11 dígitos',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DimEmpresaCliente',
@level2type = N'Column', @level2name = 'cuit';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = '0 = no, 1 = sí',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DimProducto',
@level2type = N'Column', @level2name = 'requiere_refrigeracion';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Volumen en m³',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DimVehiculo',
@level2type = N'Column', @level2name = 'capacidad';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'PENDIENTE / EN_PROCESO / ENTREGADO / CANCELADO',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Pedido',
@level2type = N'Column', @level2name = 'estado';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Tabla intermedia para asignar múltiples lotes a un mismo detalle de pedido',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'DetallePedidoLote';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Volumen máximo en m³',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Caja',
@level2type = N'Column', @level2name = 'capacidad_maxima';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Productos o lotes contenidos dentro de cada caja',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'CajaDetalle';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'CONFORME / NO_CONFORME / PENDIENTE',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Entrega',
@level2type = N'Column', @level2name = 'conformidad';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Relación N:N entre Entrega y Caja',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'EntregaCaja';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Registra acciones sobre distintas entidades (pedido, caja, entrega, etc.)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TrazabilidadEvento';
GO

