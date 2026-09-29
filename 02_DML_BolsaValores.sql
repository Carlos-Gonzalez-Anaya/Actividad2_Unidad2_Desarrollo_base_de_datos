/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 02 - DML: carga de datos de prueba
===================================================================== */
USE BolsaValores;
GO

INSERT INTO Inversionista (nombres, apellidos, documento, correo, telefono, saldoDisponible, estado)
VALUES
('Carlos',    'Ramirez',   '9001', 'carlos.ramirez@correo.com',   '3001111111', 15000000, 'Activo'),
('Luisa',     'Fernandez', '9002', 'luisa.fernandez@correo.com',  '3002222222', 12000000, 'Activo'),
('Andres',    'Gomez',     '9003', 'andres.gomez@correo.com',     '3003333333', 18000000, 'Activo'),
('Maria',     'Lopez',     '9004', 'maria.lopez@correo.com',      '3004444444', 20000000, 'Activo'),
('Jorge',     'Martinez',  '9005', 'jorge.martinez@correo.com',   '3005555555',  9000000, 'Activo'),
('Paula',     'Diaz',      '9006', 'paula.diaz@correo.com',       '3006666666', 11000000, 'Activo'),
('Felipe',    'Torres',    '9007', 'felipe.torres@correo.com',    '3007777777', 25000000, 'Activo'),
('Sandra',    'Moreno',    '9008', 'sandra.moreno@correo.com',    '3008888888', 13000000, 'Activo'),
('Diego',     'Castro',    '9009', 'diego.castro@correo.com',     '3009999999', 16000000, 'Activo'),
('Valentina', 'Rojas',     '9010', 'valentina.rojas@correo.com',  '3010000000',  8000000, 'Inactivo');
GO

INSERT INTO Empresa (nombre, sector, pais, estado)
VALUES
('TechGlobal S.A.',        'Tecnologia',        'Estados Unidos', 'Activa'),
('Energia Andina S.A.',    'Energia',           'Colombia',       'Activa'),
('Finanzas Europa PLC',    'Financiero',        'Reino Unido',    'Activa'),
('Salud Viva Inc.',        'Salud',             'Canada',         'Activa'),
('AgroMundo Ltda.',        'Agricola',          'Brasil',         'Activa'),
('Telecom Iberia S.A.',    'Telecomunicaciones','España',         'Activa'),
('Minerales del Sur S.A.', 'Mineria',           'Chile',          'Activa'),
('Movilidad Urbana Corp.', 'Transporte',        'Mexico',         'Activa'),
('Alimentos Premium S.A.', 'Consumo',           'Argentina',      'Activa'),
('BioFuture Labs',         'Biotecnologia',     'Alemania',       'Suspendida');
GO

INSERT INTO Accion (idEmpresa, simbolo, precioActual, cantidadDisponible)
VALUES
(1,  'TGS', 125.50, 10000),
(2,  'EAN',  89.30,  8500),
(3,  'FEP', 140.75,  7200),
(4,  'SVI',  98.20,  9000),
(5,  'AGM',  76.40, 15000),
(6,  'TIB', 110.60,  6100),
(7,  'MDS',  67.90, 13000),
(8,  'MUC',  54.25, 20000),
(9,  'APS',  92.10,  9800),
(10, 'BFL', 160.80,  5000);
GO

INSERT INTO OrdenCompra (idInversionista, idAccion, fechaOrden, cantidad, precioUnitario, estado)
VALUES
(1,  1,  '2026-03-20 09:00:00',  50, 125.50, 'Ejecutada'),
(2,  2,  '2026-03-20 09:15:00',  40,  89.30, 'Ejecutada'),
(3,  3,  '2026-03-20 09:30:00',  25, 140.75, 'Ejecutada'),
(4,  4,  '2026-03-20 10:00:00',  60,  98.20, 'Ejecutada'),
(5,  5,  '2026-03-20 10:15:00', 100,  76.40, 'Ejecutada'),
(6,  6,  '2026-03-20 10:30:00',  35, 110.60, 'Ejecutada'),
(7,  7,  '2026-03-20 11:00:00',  80,  67.90, 'Ejecutada'),
(8,  8,  '2026-03-20 11:15:00', 120,  54.25, 'Ejecutada'),
(9,  9,  '2026-03-20 11:30:00',  55,  92.10, 'Ejecutada'),
(10, 10, '2026-03-20 12:00:00',  20, 160.80, 'Cancelada');
GO

INSERT INTO OrdenVenta (idInversionista, idAccion, fechaOrden, cantidad, precioUnitario, estado)
VALUES
(1,  2, '2026-03-21 09:10:00', 10,  89.30, 'Ejecutada'),
(2,  3, '2026-03-21 09:20:00',  8, 140.75, 'Ejecutada'),
(3,  4, '2026-03-21 09:40:00', 15,  98.20, 'Ejecutada'),
(4,  5, '2026-03-21 10:05:00', 20,  76.40, 'Ejecutada'),
(5,  6, '2026-03-21 10:20:00', 12, 110.60, 'Ejecutada'),
(6,  7, '2026-03-21 10:35:00', 18,  67.90, 'Ejecutada'),
(7,  8, '2026-03-21 11:05:00', 25,  54.25, 'Ejecutada'),
(8,  9, '2026-03-21 11:20:00', 14,  92.10, 'Ejecutada'),
(9,  1, '2026-03-21 11:40:00',  9, 125.50, 'Ejecutada'),
(10, 2, '2026-03-21 12:05:00',  7,  89.30, 'Cancelada');
GO

INSERT INTO TransaccionBolsa
    (tipoTransaccion, idInversionista, idAccion, idOrdenCompra, idOrdenVenta, fechaTransaccion, cantidad, precioUnitario)
VALUES
('Compra', 1, 1, 1,    NULL, '2026-03-20 09:01:00',  50, 125.50),
('Compra', 2, 2, 2,    NULL, '2026-03-20 09:16:00',  40,  89.30),
('Compra', 3, 3, 3,    NULL, '2026-03-20 09:31:00',  25, 140.75),
('Compra', 4, 4, 4,    NULL, '2026-03-20 10:01:00',  60,  98.20),
('Compra', 5, 5, 5,    NULL, '2026-03-20 10:16:00', 100,  76.40),
('Venta',  1, 2, NULL, 1,    '2026-03-21 09:11:00',  10,  89.30),
('Venta',  2, 3, NULL, 2,    '2026-03-21 09:21:00',   8, 140.75),
('Venta',  3, 4, NULL, 3,    '2026-03-21 09:41:00',  15,  98.20),
('Venta',  4, 5, NULL, 4,    '2026-03-21 10:06:00',  20,  76.40),
('Venta',  5, 6, NULL, 5,    '2026-03-21 10:21:00',  12, 110.60);
GO

-- Comprobación: número de registros por tabla
SELECT 'Inversionista'    AS Tabla, COUNT(*) AS Total FROM Inversionista
UNION ALL
SELECT 'Empresa',          COUNT(*) FROM Empresa
UNION ALL
SELECT 'Accion',           COUNT(*) FROM Accion
UNION ALL
SELECT 'OrdenCompra',      COUNT(*) FROM OrdenCompra
UNION ALL
SELECT 'OrdenVenta',       COUNT(*) FROM OrdenVenta
UNION ALL
SELECT 'TransaccionBolsa', COUNT(*) FROM TransaccionBolsa;
GO