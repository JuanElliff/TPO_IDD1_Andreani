/* ===============================================================
   VALIDACIÓN DE INTEGRIDAD REFERENCIAL Y COHERENCIA DE DATOS
   Proyecto: Logística Farmacéutica - TP Ingeniería de Datos I
   Autor: Juan Cruz Elliff
   =============================================================== */

/*1️ Clientes- Pedidos */
PRINT '1️ Verificando Pedidos sin empresa cliente...';
SELECT p.id_pedido, p.fecha_pedido
FROM Pedido p
LEFT JOIN DimEmpresaCliente ec ON p.id_empresa_cliente = ec.id_empresa_cliente
WHERE ec.id_empresa_cliente IS NULL;

PRINT '1️ Verificando Pedidos sin cliente destino...';
SELECT p.id_pedido, p.fecha_pedido
FROM Pedido p
LEFT JOIN DimClienteDestino cd ON p.id_cliente_destino = cd.id_cliente_destino
WHERE cd.id_cliente_destino IS NULL;

/* 2️ Pedidos - DetallePedido */
PRINT '2️ Verificando Detalles sin pedido asociado...';
SELECT dp.id_detalle_pedido, dp.id_pedido, dp.id_producto
FROM DetallePedido dp
LEFT JOIN Pedido p ON dp.id_pedido = p.id_pedido
WHERE p.id_pedido IS NULL;

/* 3️ Productos - Lotes */
PRINT '3️ Verificando Lotes sin producto válido...';
SELECT l.id_lote, l.id_producto
FROM Lote l
LEFT JOIN DimProducto pr ON l.id_producto = pr.id_producto
WHERE pr.id_producto IS NULL;

/* 4️ DetallePedido- Lotes */
PRINT '4️ Verificando DetallePedidoLote con detalle inexistente o lote inexistente...';
SELECT dpl.id_detalle_pedido, dpl.id_lote
FROM DetallePedidoLote dpl
LEFT JOIN DetallePedido dp ON dpl.id_detalle_pedido = dp.id_detalle_pedido
LEFT JOIN Lote l ON dpl.id_lote = l.id_lote
WHERE dp.id_detalle_pedido IS NULL OR l.id_lote IS NULL;

/* 5️ Lotes - Cajas */
PRINT '5️ Verificando CajaDetalle con lote inexistente o caja inexistente...';
SELECT cd.id_caja_detalle, cd.id_caja, cd.id_lote
FROM CajaDetalle cd
LEFT JOIN Lote l ON cd.id_lote = l.id_lote
LEFT JOIN Caja c ON cd.id_caja = c.id_caja
WHERE l.id_lote IS NULL OR c.id_caja IS NULL;

/* 6️ Cajas - Entregas */
PRINT '6️ Verificando EntregaCaja con entrega o caja inexistente...';
SELECT ec.id_entrega, ec.id_caja
FROM EntregaCaja ec
LEFT JOIN Caja c ON ec.id_caja = c.id_caja
LEFT JOIN Entrega e ON ec.id_entrega = e.id_entrega
WHERE e.id_entrega IS NULL OR c.id_caja IS NULL;

/* 7️ Entregas - Vehículos / Rutas */
PRINT '7️ Verificando Entregas con vehículo o ruta inexistente...';
SELECT e.id_entrega, e.id_vehiculo, e.id_ruta
FROM Entrega e
LEFT JOIN DimVehiculo v ON e.id_vehiculo = v.id_vehiculo
LEFT JOIN DimRuta r ON e.id_ruta = r.id_ruta
WHERE v.id_vehiculo IS NULL OR r.id_ruta IS NULL;

/* 8️ Incidencias - Entregas y Usuarios */
PRINT '8️ Verificando Incidencias sin entrega o usuario...';
SELECT i.id_incidencia, i.id_entrega, i.registrada_por
FROM Incidencia i
LEFT JOIN Entrega e ON i.id_entrega = e.id_entrega
LEFT JOIN DimUsuario u ON i.registrada_por = u.id_usuario
WHERE e.id_entrega IS NULL OR u.id_usuario IS NULL;

/* 9️ TrazabilidadEvento - Usuario */
PRINT '9️ Verificando eventos de trazabilidad sin usuario válido...';
SELECT t.id_evento, t.entidad_afectada, t.id_usuario
FROM TrazabilidadEvento t
LEFT JOIN DimUsuario u ON t.id_usuario = u.id_usuario
WHERE u.id_usuario IS NULL;

/*  Resumen de conteos */
PRINT ' Conteo general de registros (esperado: consistencia 1:N)';
SELECT 
  (SELECT COUNT(*) FROM DimEmpresaCliente) AS EmpresaCliente,
  (SELECT COUNT(*) FROM DimClienteDestino) AS ClienteDestino,
  (SELECT COUNT(*) FROM Pedido) AS Pedidos,
  (SELECT COUNT(*) FROM DetallePedido) AS Detalles,
  (SELECT COUNT(*) FROM Lote) AS Lotes,
  (SELECT COUNT(*) FROM DetallePedidoLote) AS DetalleLote,
  (SELECT COUNT(*) FROM Caja) AS Cajas,
  (SELECT COUNT(*) FROM CajaDetalle) AS CajaDetalle,
  (SELECT COUNT(*) FROM Entrega) AS Entregas,
  (SELECT COUNT(*) FROM EntregaCaja) AS EntregaCaja,
  (SELECT COUNT(*) FROM Incidencia) AS Incidencias,
  (SELECT COUNT(*) FROM TrazabilidadEvento) AS Eventos,
  (SELECT COUNT(*) FROM DimUsuario) AS Usuarios;


SELECT *
FROM TrazabilidadEvento
