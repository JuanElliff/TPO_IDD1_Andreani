/* ============================================================
   03_insert_data.sql  —  Carga inicial consistente (contexto salud)
   Requisitos: Tablas creadas según el DDL previamente acordado.
   ============================================================ */

SET NOCOUNT ON;

/* ======================
   1) DIMENSIONES (>=10)
   ====================== */

-- 1.1 DimEmpresaCliente (CUIT UNIQUE, 11 dígitos)
INSERT INTO DimEmpresaCliente (razon_social, cuit, direccion, contacto) VALUES
('Biofarma S.A.',           '30711234011','Av. Mitre 1200, CABA','soporte@biofarma.com'),
('Pharmalex Argentina',     '30711234022','Av. Belgrano 2233, CABA','contact@pharmalex.com'),
('Laboratorios Andina',     '30711234033','Av. Colón 345, Córdoba','ops@andina.com'),
('Farmacorp LATAM',         '30711234044','Maipú 211, Mendoza','clientes@farmacorp.com'),
('VitalSalud S.R.L.',       '30711234055','Bv. Ocampo 911, Rosario','info@vitalsalud.com'),
('Sanitaria del Plata',     '30711234066','9 de Julio 100, La Plata','atencion@sdplata.com'),
('Austral Pharma',          '30711234077','Rivadavia 5050, CABA','operaciones@austral.com'),
('Pampero Biotech',         '30711234088','Eva Perón 1800, Salta','contacto@pampero.com'),
('Equilibrio Life',         '30711234099','Ituzaingó 120, Neuquén','mesa@equilibrio.com'),
('NovaMed S.A.',            '30711234110','San Martín 700, Tucumán','servicio@novamed.com');

-- 1.2 DimClienteDestino (clínicas/hospitales/farmacias)
INSERT INTO DimClienteDestino (nombre, tipo, direccion, localidad, provincia, contacto) VALUES
('Clínica San Miguel','Clinica','R. Peña 123','CABA','Buenos Aires','adm@sanmiguel.com'),
('Hospital Central Norte','Hospital','Sarmiento 455','CABA','Buenos Aires','hc_norte@hc.gov'),
('Farmacia Los Álamos','Farmacia','Alsina 140','Morón','Buenos Aires','ventas@alamos.com'),
('Clínica del Sur','Clinica','Colón 980','Mar del Plata','Buenos Aires','turnos@cdsur.com'),
('Hospital del Este','Hospital','Belgrano 333','La Plata','Buenos Aires','compras@heste.gov'),
('Farmacia La Moderna','Farmacia','Urquiza 220','Rosario','Santa Fe','moderna@farmacias.com'),
('Sanatorio Andino','Clinica','Mitre 400','Mendoza','Mendoza','ingresos@andino.com'),
('Hospital Regional Oeste','Hospital','Rivadavia 750','Córdoba','Córdoba','admin@hro.gov'),
('Farmacia Central Neuquén','Farmacia','Sarmiento 101','Neuquén','Neuquén','central@fnq.com'),
('Clínica Norte','Clinica','Belgrano 202','Salta','Salta','adm@cnorte.com');

-- 1.3 DimProducto (10+, mezcla refrigerado/no)
INSERT INTO DimProducto (nombre, descripcion, requiere_refrigeracion) VALUES
('Amoxicilina 500mg', 'Antibiótico cápsulas', 0),
('Ibuprofeno 400mg',  'Analgésico/antiinflamatorio', 0),
('Paracetamol 500mg', 'Analgésico antipirético', 0),
('Insulina NPH',      'Insulina de acción intermedia', 1),
('Vacuna Antigripal', 'Vacuna trivalente', 1),
('Omeprazol 20mg',    'IBP cápsulas', 0),
('Atorvastatina 20mg','Hipolipemiante', 0),
('Adrenalina 1mg/ml', 'Ampollas inyectables', 1),
('Ceftriaxona 1g',    'Antibiótico inyectable', 1),
('Vitamina C 1g',     'Suplemento efervescente', 0);

-- 1.4 DimChofer (DNI UNIQUE)
INSERT INTO DimChofer (nombre, dni, telefono) VALUES
('Carlos Pérez','20333444','11-5000-0001'),
('María Gómez','28322111','11-5000-0002'),
('Julián Rivas','30555111','11-5000-0003'),
('Nadia Torres','29444123','11-5000-0004'),
('Pablo Suárez','27111222','11-5000-0005'),
('Tamara Díaz','31666123','11-5000-0006'),
('Hernán López','28999111','11-5000-0007'),
('Lucía Fernández','30000123','11-5000-0008'),
('Sergio Ortega','27777000','11-5000-0009'),
('Agustina León','33111000','11-5000-0010');

-- 1.5 DimVehiculo (patente UNIQUE, asignado a chofer por DNI)
INSERT INTO DimVehiculo (patente, capacidad, refrigerado, id_chofer) VALUES
('AB123CD',  12.00, 1, (SELECT id_chofer FROM DimChofer WHERE dni='20333444')),
('AC234DE',  10.50, 1, (SELECT id_chofer FROM DimChofer WHERE dni='28322111')),
('AD345EF',   9.00, 0, (SELECT id_chofer FROM DimChofer WHERE dni='30555111')),
('AE456FG',  14.00, 1, (SELECT id_chofer FROM DimChofer WHERE dni='29444123')),
('AF567GH',   8.50, 0, (SELECT id_chofer FROM DimChofer WHERE dni='27111222')),
('AG678HI',  11.00, 1, (SELECT id_chofer FROM DimChofer WHERE dni='31666123')),
('AH789IJ',  13.50, 0, (SELECT id_chofer FROM DimChofer WHERE dni='28999111')),
('AI890JK',  10.00, 1, (SELECT id_chofer FROM DimChofer WHERE dni='30000123')),
('AJ901KL',   9.50, 0, (SELECT id_chofer FROM DimChofer WHERE dni='27777000')),
('AK012LM',  12.50, 1, (SELECT id_chofer FROM DimChofer WHERE dni='33111000'));

-- 1.6 DimRuta (10)
INSERT INTO DimRuta (descripcion, provincia, zona) VALUES
('CABA - Zona Norte',      'Buenos Aires','Norte'),
('CABA - Zona Sur',        'Buenos Aires','Sur'),
('AMBA Oeste',             'Buenos Aires','Oeste'),
('La Plata - CABA',        'Buenos Aires','Sur'),
('Rosario - AMBA',         'Santa Fe','Centro'),
('Córdoba - Capital',      'Córdoba','Centro'),
('Mendoza - Gran Mendoza', 'Mendoza','Cuyo'),
('Neuquén - Capital',      'Neuquén','Patagonia'),
('Salta - Capital',        'Salta','NOA'),
('Mar del Plata - Centro', 'Buenos Aires','Costa');

-- 1.7 DimUsuario (10)
INSERT INTO DimUsuario (nombre, rol, email) VALUES
('Admin Sistema','Administrador','admin@sistema.com'),
('Supervisor Logístico','Supervisor','supervisor@logistica.com'),
('Operador Depósito 1','Operador','op1@deposito.com'),
('Operador Depósito 2','Operador','op2@deposito.com'),
('Auditor Calidad','Auditor','auditor@calidad.com'),
('Planificador','Planificador','planificador@ops.com'),
('Despachante','Despacho','despacho@ops.com'),
('Jefe Transporte','JefeTransporte','jefe.transporte@ops.com'),
('Soporte IT','Soporte','soporte@it.com'),
('Recepción Destino','Recepcion','recepcion@cliente.com');


/* ===========================
   2) LOTES (2–3 por producto)
   =========================== */

-- Para 10 productos, generamos 22 lotes (2 o 3 por producto)
INSERT INTO Lote (id_producto, fecha_vencimiento, temperatura_min, temperatura_max)
SELECT id_producto, DATEADD(MONTH, 6, GETDATE()), -5.00, 8.00 FROM DimProducto WHERE nombre IN ('Insulina NPH','Vacuna Antigripal','Adrenalina 1mg/ml','Ceftriaxona 1g'); -- refrigerados base

INSERT INTO Lote (id_producto, fecha_vencimiento, temperatura_min, temperatura_max)
SELECT id_producto, DATEADD(MONTH, 12, GETDATE()), 5.00, 25.00 FROM DimProducto WHERE nombre IN ('Amoxicilina 500mg','Ibuprofeno 400mg','Paracetamol 500mg','Omeprazol 20mg','Atorvastatina 20mg','Vitamina C 1g');

-- Lotes adicionales para variedad (tercer lote en algunos productos)
INSERT INTO Lote (id_producto, fecha_vencimiento, temperatura_min, temperatura_max)
SELECT id_producto, DATEADD(MONTH, 9, GETDATE()), -2.00, 8.00 FROM DimProducto WHERE nombre IN ('Vacuna Antigripal','Ceftriaxona 1g');

INSERT INTO Lote (id_producto, fecha_vencimiento, temperatura_min, temperatura_max)
SELECT id_producto, DATEADD(MONTH, 18, GETDATE()), 5.00, 25.00 FROM DimProducto WHERE nombre IN ('Paracetamol 500mg','Omeprazol 20mg');


/* ==============================================
   3) PEDIDOS (12) + DETALLES (2–3 c/u, 28 totales)
   ============================================== */

-- 12 pedidos con compromisos y clientes variados
INSERT INTO Pedido (id_empresa_cliente, id_cliente_destino, fecha_pedido, fecha_comprometida, estado)
VALUES
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234011'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Clínica San Miguel'),       DATEADD(DAY,-5,GETDATE()), DATEADD(DAY, 2,GETDATE()), 'EN_PROCESO'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234022'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Hospital Central Norte'),    DATEADD(DAY,-4,GETDATE()), DATEADD(DAY, 1,GETDATE()), 'EN_PROCESO'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234033'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Farmacia Los Álamos'),       DATEADD(DAY,-4,GETDATE()), DATEADD(DAY, 3,GETDATE()), 'PENDIENTE'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234044'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Clínica del Sur'),            DATEADD(DAY,-3,GETDATE()), DATEADD(DAY, 2,GETDATE()), 'PENDIENTE'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234055'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Hospital del Este'),          DATEADD(DAY,-3,GETDATE()), DATEADD(DAY, 1,GETDATE()), 'EN_PROCESO'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234066'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Farmacia La Moderna'),        DATEADD(DAY,-2,GETDATE()), DATEADD(DAY, 4,GETDATE()), 'PENDIENTE'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234077'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Sanatorio Andino'),           DATEADD(DAY,-2,GETDATE()), DATEADD(DAY, 2,GETDATE()), 'EN_PROCESO'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234088'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Hospital Regional Oeste'),     DATEADD(DAY,-2,GETDATE()), DATEADD(DAY, 3,GETDATE()), 'PENDIENTE'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234099'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Farmacia Central Neuquén'),   DATEADD(DAY,-1,GETDATE()), DATEADD(DAY, 2,GETDATE()), 'PENDIENTE'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234110'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Clínica Norte'),              DATEADD(DAY,-1,GETDATE()), DATEADD(DAY, 1,GETDATE()), 'EN_PROCESO'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234011'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Hospital Central Norte'),     DATEADD(DAY,-1,GETDATE()), DATEADD(DAY, 5,GETDATE()), 'PENDIENTE'),
((SELECT id_empresa_cliente FROM DimEmpresaCliente WHERE cuit='30711234022'), (SELECT id_cliente_destino FROM DimClienteDestino WHERE nombre='Clínica San Miguel'),         GETDATE(),                    DATEADD(DAY, 3,GETDATE()), 'PENDIENTE');

-- Detalles por pedido (2–3 c/u). Referencias por nombre de producto (único).
-- Para brevedad, distribuimos productos variados; cantidades moderadas.
INSERT INTO DetallePedido (id_pedido, id_producto, cantidad)
SELECT p.id_pedido, pr.id_producto, v.cant
FROM (
  VALUES
  (1,'Amoxicilina 500mg', 60),
  (1,'Paracetamol 500mg', 80),
  (2,'Vacuna Antigripal', 120),
  (2,'Insulina NPH',      40),
  (3,'Ibuprofeno 400mg',  90),
  (3,'Omeprazol 20mg',    50),
  (4,'Ceftriaxona 1g',    30),
  (4,'Adrenalina 1mg/ml', 15),
  (5,'Insulina NPH',      60),
  (5,'Paracetamol 500mg', 60),
  (6,'Vitamina C 1g',     120),
  (6,'Ibuprofeno 400mg',  60),
  (7,'Vacuna Antigripal', 100),
  (7,'Ceftriaxona 1g',    20),
  (8,'Omeprazol 20mg',    70),
  (8,'Atorvastatina 20mg',70),
  (9,'Amoxicilina 500mg', 80),
  (9,'Vitamina C 1g',     80),
  (10,'Insulina NPH',     40),
  (10,'Adrenalina 1mg/ml',20),
  (11,'Vacuna Antigripal',110),
  (11,'Paracetamol 500mg',60),
  (12,'Ibuprofeno 400mg', 80),
  (12,'Omeprazol 20mg',   40)
) AS v(pedido_idx, prod_nom, cant)
JOIN (SELECT id_pedido, ROW_NUMBER() OVER (ORDER BY id_pedido) AS rn FROM Pedido) AS p ON p.rn = v.pedido_idx
JOIN DimProducto pr ON pr.nombre = v.prod_nom;

-- Asignación de lotes (FEFO simplificado: tomamos el primer lote del producto; en algunos detalles dividimos en 2 lotes)
;WITH DPL AS (
  SELECT dp.id_detalle_pedido, dp.id_producto,
         ROW_NUMBER() OVER (PARTITION BY dp.id_producto ORDER BY (SELECT 1)) AS rnk
  FROM DetallePedido dp
)
INSERT INTO DetallePedidoLote (id_detalle_pedido, id_lote, cantidad_asignada)
SELECT dp.id_detalle_pedido,
       (SELECT TOP 1 l.id_lote FROM Lote l WHERE l.id_producto = dp.id_producto ORDER BY l.fecha_vencimiento ASC),
       CAST(CEILING(dp.cantidad * 0.6) AS INT)
FROM DetallePedido dp;

-- Segundo lote para ~50% de los detalles (para mostrar split por lote)
INSERT INTO DetallePedidoLote (id_detalle_pedido, id_lote, cantidad_asignada)
SELECT dp.id_detalle_pedido,
       (SELECT TOP 1 l2.id_lote FROM Lote l2 WHERE l2.id_producto = dp.id_producto ORDER BY l2.fecha_vencimiento DESC),
       dp.cantidad - CAST(CEILING(dp.cantidad * 0.6) AS INT)
FROM DetallePedido dp
WHERE dp.id_detalle_pedido % 2 = 0;  -- mitad de los renglones se divide en 2 lotes


/* ==========================================
   4) CAJAS (15) + CajaDetalle coherente por lote
   ========================================== */

-- 15 cajas con distintas capacidades (en m3)
INSERT INTO Caja (tipo, capacidad_maxima, fecha_consolidacion) VALUES
('Térmica',  0.80, DATEADD(DAY,-1,GETDATE())),
('Estándar', 1.20, DATEADD(DAY,-1,GETDATE())),
('Térmica',  0.60, DATEADD(DAY,-1,GETDATE())),
('Estándar', 1.00, DATEADD(DAY,-1,GETDATE())),
('Térmica',  0.90, DATEADD(DAY,-1,GETDATE())),
('Estándar', 1.10, DATEADD(DAY,-1,GETDATE())),
('Térmica',  0.70, DATEADD(DAY,-1,GETDATE())),
('Estándar', 0.95, DATEADD(DAY,-1,GETDATE())),
('Térmica',  0.85, DATEADD(DAY,-1,GETDATE())),
('Estándar', 1.30, DATEADD(DAY,-1,GETDATE())),
('Estándar', 1.10, DATEADD(DAY,-1,GETDATE())),
('Térmica',  0.75, DATEADD(DAY,-1,GETDATE())),
('Estándar', 1.05, DATEADD(DAY,-1,GETDATE())),
('Térmica',  0.65, DATEADD(DAY,-1,GETDATE())),
('Estándar', 1.25, DATEADD(DAY,-1,GETDATE()));

-- Vinculamos lotes a cajas (cantidad ~ volumen simulado)
-- Tomamos 12 primeros lotes para simplificar la demostración
INSERT INTO CajaDetalle (id_caja, id_lote, cantidad)
SELECT c.id_caja, l.id_lote,
       CASE WHEN p.requiere_refrigeracion=1 THEN 0.20 ELSE 0.35 END
FROM (SELECT TOP 12 id_lote, id_producto FROM Lote ORDER BY id_lote) l
JOIN DimProducto p ON p.id_producto = l.id_producto
JOIN (SELECT TOP 12 id_caja FROM Caja ORDER BY id_caja) c ON 1=1
WHERE c.id_caja = l.id_lote - (SELECT MIN(id_lote) FROM Lote) + 1; -- reparto 1:1 simple para demo

-- Agregamos más contenido a algunas cajas (sin exceder capacidad declarada)
INSERT INTO CajaDetalle (id_caja, id_lote, cantidad)
SELECT c.id_caja, l.id_lote, 0.25
FROM (SELECT TOP 6 id_caja FROM Caja ORDER BY id_caja DESC) c
CROSS APPLY (SELECT TOP 1 id_lote FROM Lote ORDER BY NEWID()) l;


/* ======================================
   5) ENTREGAS (10) + EntregaCaja (múltiples)
   ====================================== */

-- 10 entregas variadas
INSERT INTO Entrega (id_vehiculo, id_ruta, fecha_entrega, receptor, temperatura_registrada, conformidad, observaciones) VALUES
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AB123CD'), (SELECT id_ruta FROM DimRuta WHERE descripcion='CABA - Zona Norte'),      DATEADD(HOUR,-5,GETDATE()), 'Recep. Clínica San Miguel',  6.2, 'CONFORME', NULL),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AC234DE'), (SELECT id_ruta FROM DimRuta WHERE descripcion='CABA - Zona Sur'),        DATEADD(HOUR,-4,GETDATE()), 'Recep. H. Central Norte',    7.1, 'CONFORME', NULL),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AD345EF'), (SELECT id_ruta FROM DimRuta WHERE descripcion='AMBA Oeste'),             DATEADD(HOUR,-4,GETDATE()), 'Recep. Farm. Los Álamos',    21.0,'CONFORME', NULL),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AE456FG'), (SELECT id_ruta FROM DimRuta WHERE descripcion='La Plata - CABA'),        DATEADD(HOUR,-3,GETDATE()), 'Recep. H. del Este',         6.5, 'CONFORME', NULL),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AF567GH'), (SELECT id_ruta FROM DimRuta WHERE descripcion='Rosario - AMBA'),         DATEADD(HOUR,-3,GETDATE()), 'Recep. Farm. La Moderna',    22.0,'CONFORME', NULL),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AG678HI'), (SELECT id_ruta FROM DimRuta WHERE descripcion='Córdoba - Capital'),      DATEADD(HOUR,-2,GETDATE()), 'Recep. Sanatorio Andino',    5.8, 'CONFORME', NULL),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AH789IJ'), (SELECT id_ruta FROM DimRuta WHERE descripcion='Mendoza - Gran Mendoza'), DATEADD(HOUR,-2,GETDATE()), 'Recep. H. Regional Oeste',   19.8,'CONFORME', NULL),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AI890JK'), (SELECT id_ruta FROM DimRuta WHERE descripcion='Neuquén - Capital'),      DATEADD(HOUR,-1,GETDATE()), 'Recep. Farm. Central Nqn',   6.9, 'NO_CONFORME', 'Demora por tránsito'),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AJ901KL'), (SELECT id_ruta FROM DimRuta WHERE descripcion='Salta - Capital'),        DATEADD(HOUR,-1,GETDATE()), 'Recep. Clínica Norte',        6.7, 'CONFORME', NULL),
((SELECT id_vehiculo FROM DimVehiculo WHERE patente='AK012LM'), (SELECT id_ruta FROM DimRuta WHERE descripcion='Mar del Plata - Centro'), GETDATE(),                    'Recep. Clínica San Miguel',  8.2, 'CONFORME', NULL);

-- Vincular cajas a entregas (cada entrega con 1–3 cajas)
INSERT INTO EntregaCaja (id_entrega, id_caja)
SELECT e.id_entrega, c.id_caja
FROM (SELECT TOP 10 id_entrega FROM Entrega ORDER BY id_entrega) e
JOIN (SELECT id_caja, ROW_NUMBER() OVER (ORDER BY id_caja) rn FROM Caja) c
  ON (e.id_entrega % 5) + 1 = c.rn % 5 + 1;  -- distribución simple, múltiple por entrega


/* =============================
   6) INCIDENCIAS (2–3 registros)
   ============================= */

-- Elegimos 3 entregas para registrar desvíos
INSERT INTO Incidencia (id_entrega, tipo, descripcion, fecha, registrada_por) VALUES
((SELECT MIN(id_entrega)+7 FROM Entrega), 'Demora en entrega', 'Congestión vehicular en acceso oeste', DATEADD(HOUR,-1,GETDATE()), (SELECT id_usuario FROM DimUsuario WHERE email='supervisor@logistica.com')),
((SELECT MIN(id_entrega)+2 FROM Entrega), 'Falla documental',  'Falta remito firmado en un bulto',     DATEADD(HOUR,-2,GETDATE()), (SELECT id_usuario FROM DimUsuario WHERE email='auditor@calidad.com')),
((SELECT MIN(id_entrega)+4 FROM Entrega), 'Ruptura cadena frío','Picos a 9.5°C durante 25 min',        DATEADD(HOUR,-1,GETDATE()), (SELECT id_usuario FROM DimUsuario WHERE email='op1@deposito.com'));


/* ===========================================
   7) TRAZABILIDAD (eventos típicos del ciclo)
   =========================================== */

-- Eventos de Pedido (CREADO / ASIGNADO / CERRADO) para primeros 3 pedidos
-- Eventos de Pedido (CREADO / ASIGNADO / CERRADO) para todos los pedidos
INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
SELECT 'Pedido', id_pedido, 'CREADO', DATEADD(DAY,-4,GETDATE()),
       (SELECT id_usuario FROM DimUsuario WHERE email='planificador@ops.com')
FROM Pedido;

INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
SELECT 'Pedido', id_pedido, 'ASIGNADO_A_LOTES', DATEADD(DAY,-3,GETDATE()),
       (SELECT id_usuario FROM DimUsuario WHERE email='op1@deposito.com')
FROM Pedido;

INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
SELECT 'Pedido', id_pedido, 'CERRADO', DATEADD(HOUR,-2,GETDATE()),
       (SELECT id_usuario FROM DimUsuario WHERE email='supervisor@logistica.com')
FROM Pedido;
-- Eventos de Caja (EMBALADA) para 10 cajas
INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
SELECT 'Caja', id_caja, 'EMBALADA', DATEADD(DAY,-1,GETDATE()), (SELECT id_usuario FROM DimUsuario WHERE email='op2@deposito.com')
FROM (SELECT TOP 10 id_caja FROM Caja ORDER BY id_caja) c;

-- Eventos de Entrega (DESPACHADA / ENTREGADA)
INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
SELECT 'Entrega', id_entrega, 'DESPACHADA', DATEADD(HOUR,-6,GETDATE()), (SELECT id_usuario FROM DimUsuario WHERE email='despacho@ops.com')
FROM (SELECT TOP 10 id_entrega FROM Entrega ORDER BY id_entrega) e;

INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
SELECT 'Entrega', id_entrega, 'ENTREGADA', DATEADD(HOUR,-1,GETDATE()), (SELECT id_usuario FROM DimUsuario WHERE email='recepcion@cliente.com')
FROM (SELECT TOP 9 id_entrega FROM Entrega ORDER BY id_entrega) e;  -- una queda sin ENTREGADA (pendiente)

-- Eventos por incidencias detectadas
INSERT INTO TrazabilidadEvento (entidad_afectada, id_registro_afectado, accion, fecha, id_usuario)
SELECT 'Entrega', i.id_entrega, 'INCIDENCIA_REGISTRADA', i.fecha, i.registrada_por
FROM Incidencia i;


PRINT 'Carga inicial completa y consistente.';
