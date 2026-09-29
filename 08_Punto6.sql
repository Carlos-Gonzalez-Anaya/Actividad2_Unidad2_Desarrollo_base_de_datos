/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 08 - PUNTO 6: INSERCIÓN EN UNA TABLA TEMPORAL A PARTIR DE
   UNA CONSULTA CON INNER JOIN
===================================================================== */
USE BolsaValores;
GO

/* =====================================================================
   6.1 FORMA 1: SELECT ... INTO (crea la tabla temporal y la llena)
===================================================================== */
DROP TABLE IF EXISTS #ComprasEjecutadas;
GO

-- Enunciado: Crear la tabla temporal #ComprasEjecutadas con el inversionista, la acción
-- y el monto de cada orden de compra ejecutada
SELECT oc.idOrdenCompra,
       i.nombres + ' ' + i.apellidos AS Inversionista,
       a.simbolo                     AS Simbolo,
       oc.cantidad                   AS Cantidad,
       oc.montoTotal                 AS MontoTotal
INTO #ComprasEjecutadas
FROM OrdenCompra oc
INNER JOIN Inversionista i ON i.idInversionista = oc.idInversionista
INNER JOIN Accion        a ON a.idAccion        = oc.idAccion
WHERE oc.estado = 'Ejecutada';
GO

-- Consulta de la tabla temporal
SELECT * FROM #ComprasEjecutadas;
GO

/* =====================================================================
   6.2 FORMA 2: CREATE TABLE + INSERT INTO ... SELECT
===================================================================== */
DROP TABLE IF EXISTS #ResumenVentas;
GO

-- Enunciado: Crear la tabla temporal #ResumenVentas
CREATE TABLE #ResumenVentas(
    idOrdenVenta  INT,
    Inversionista VARCHAR(121),
    Simbolo       VARCHAR(10),
    Empresa       VARCHAR(100),
    MontoTotal    DECIMAL(18,2)
);
GO

-- Enunciado: Insertar en #ResumenVentas las órdenes de venta ejecutadas con el
-- inversionista, la acción y la empresa
INSERT INTO #ResumenVentas (idOrdenVenta, Inversionista, Simbolo, Empresa, MontoTotal)
SELECT ov.idOrdenVenta,
       i.nombres + ' ' + i.apellidos,
       a.simbolo,
       e.nombre,
       ov.montoTotal
FROM OrdenVenta ov
INNER JOIN Inversionista i ON i.idInversionista = ov.idInversionista
INNER JOIN Accion        a ON a.idAccion        = ov.idAccion
INNER JOIN Empresa       e ON e.idEmpresa       = a.idEmpresa
WHERE ov.estado = 'Ejecutada';
GO

-- Consulta de la tabla temporal
SELECT * FROM #ResumenVentas;
GO

/* =====================================================================
   COMPROBACIÓN
===================================================================== */
-- Comprobación: registros y montos de las tablas temporales frente a las tablas originales
SELECT (SELECT COUNT(*)        FROM #ComprasEjecutadas)                       AS FilasTemporalCompras,
       (SELECT COUNT(*)        FROM OrdenCompra WHERE estado = 'Ejecutada')   AS FilasOrdenCompra,
       (SELECT SUM(MontoTotal) FROM #ResumenVentas)                           AS MontoTemporalVentas,
       (SELECT SUM(montoTotal) FROM OrdenVenta  WHERE estado = 'Ejecutada')   AS MontoOrdenVenta;
GO

-- Comprobación: las tablas temporales se guardan en tempdb
SELECT name AS TablaTemporal, create_date
FROM tempdb.sys.tables
WHERE name LIKE '#ComprasEjecutadas%' OR name LIKE '#ResumenVentas%';
GO

-- Eliminar las tablas temporales
DROP TABLE IF EXISTS #ComprasEjecutadas;
DROP TABLE IF EXISTS #ResumenVentas;
GO