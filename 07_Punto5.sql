/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 07 - PUNTO 5: VISTAS
   5.1 Dos vistas con mínimo 3 INNER JOIN, agrupamiento y WHERE
   5.2 Dos vistas con mínimo 3 INNER JOIN, agrupamiento y HAVING
===================================================================== */
USE BolsaValores;
GO

/* =====================================================================
   5.1 VISTAS CON INNER JOIN, AGRUPAMIENTO Y WHERE
===================================================================== */
-- Vista 5.1.1
-- Enunciado: Crear una vista con el número de transacciones y el valor negociado por
-- país de la empresa emisora, solo para empresas activas
CREATE OR ALTER VIEW vw_NegociacionPorPais
AS
SELECT p.nombre           AS Pais,
       COUNT(*)           AS NumTransacciones,
       SUM(t.cantidad)    AS AccionesNegociadas,
       SUM(t.valorTotal)  AS ValorNegociado
FROM TransaccionBolsa t
INNER JOIN Accion  a ON a.idAccion  = t.idAccion
INNER JOIN Empresa e ON e.idEmpresa = a.idEmpresa
INNER JOIN Pais    p ON p.idPais    = e.idPais
WHERE e.estado = 'Activa'
GROUP BY p.nombre;
GO

-- Consulta de la vista
SELECT * FROM vw_NegociacionPorPais
ORDER BY ValorNegociado DESC;
GO

-- Comprobación: valor negociado de las acciones de empresas colombianas
SELECT SUM(t.valorTotal) AS TotalColombia
FROM TransaccionBolsa t
WHERE t.idAccion IN (
        SELECT a.idAccion
        FROM Accion a
        INNER JOIN Empresa e ON e.idEmpresa = a.idEmpresa
        INNER JOIN Pais p    ON p.idPais    = e.idPais
        WHERE p.nombre = 'Colombia'
      );
GO

-- Vista 5.1.2
-- Enunciado: Crear una vista con el número de órdenes de compra ejecutadas, las acciones
-- compradas y el monto total por sector económico
CREATE OR ALTER VIEW vw_ComprasEjecutadasPorSector
AS
SELECT e.sector                          AS Sector,
       COUNT(*)                          AS NumOrdenes,
       COUNT(DISTINCT i.idInversionista) AS NumInversionistas,
       SUM(oc.cantidad)                  AS AccionesCompradas,
       SUM(oc.montoTotal)                AS MontoTotal
FROM OrdenCompra oc
INNER JOIN Inversionista i ON i.idInversionista = oc.idInversionista
INNER JOIN Accion        a ON a.idAccion        = oc.idAccion
INNER JOIN Empresa       e ON e.idEmpresa       = a.idEmpresa
WHERE oc.estado = 'Ejecutada'
GROUP BY e.sector;
GO

-- Consulta de la vista
SELECT * FROM vw_ComprasEjecutadasPorSector
ORDER BY MontoTotal DESC;
GO

-- Comprobación: la suma de la vista es igual al total de órdenes ejecutadas
SELECT (SELECT SUM(MontoTotal) FROM vw_ComprasEjecutadasPorSector)          AS TotalVista,
       (SELECT SUM(montoTotal) FROM OrdenCompra WHERE estado = 'Ejecutada') AS TotalTabla;
GO

/* =====================================================================
   5.2 VISTAS CON INNER JOIN, AGRUPAMIENTO Y HAVING
===================================================================== */
-- Vista 5.2.1
-- Enunciado: Crear una vista con las acciones cuyo valor total negociado supera los 5.000,
-- mostrando la empresa y el país
CREATE OR ALTER VIEW vw_AccionesAltoVolumen
AS
SELECT a.simbolo          AS Simbolo,
       e.nombre           AS Empresa,
       p.nombre           AS Pais,
       COUNT(*)           AS NumTransacciones,
       SUM(t.valorTotal)  AS ValorNegociado
FROM TransaccionBolsa t
INNER JOIN Accion  a ON a.idAccion  = t.idAccion
INNER JOIN Empresa e ON e.idEmpresa = a.idEmpresa
INNER JOIN Pais    p ON p.idPais    = e.idPais
GROUP BY a.simbolo, e.nombre, p.nombre
HAVING SUM(t.valorTotal) > 5000;
GO

-- Consulta de la vista
SELECT * FROM vw_AccionesAltoVolumen
ORDER BY ValorNegociado DESC;
GO

-- Comprobación: valor negociado de todas las acciones, sin HAVING
SELECT a.simbolo, SUM(t.valorTotal) AS ValorNegociado
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
GROUP BY a.simbolo
ORDER BY ValorNegociado DESC;
GO

-- Vista 5.2.2
-- Enunciado: Crear una vista con los inversionistas cuyo monto total en órdenes de compra
-- supera los 5.000, mostrando su saldo disponible
CREATE OR ALTER VIEW vw_InversionistasMayorCompra
AS
SELECT i.idInversionista,
       i.nombres + ' ' + i.apellidos AS Inversionista,
       i.saldoDisponible             AS SaldoDisponible,
       COUNT(*)                      AS NumOrdenes,
       COUNT(DISTINCT e.sector)      AS SectoresDistintos,
       SUM(oc.montoTotal)            AS MontoComprado
FROM Inversionista i
INNER JOIN OrdenCompra oc ON oc.idInversionista = i.idInversionista
INNER JOIN Accion      a  ON a.idAccion         = oc.idAccion
INNER JOIN Empresa     e  ON e.idEmpresa        = a.idEmpresa
GROUP BY i.idInversionista, i.nombres, i.apellidos, i.saldoDisponible
HAVING SUM(oc.montoTotal) > 5000;
GO

-- Consulta de la vista
SELECT * FROM vw_InversionistasMayorCompra
ORDER BY MontoComprado DESC;
GO

-- Comprobación: monto comprado por todos los inversionistas, sin HAVING
SELECT idInversionista, SUM(montoTotal) AS MontoComprado
FROM OrdenCompra
GROUP BY idInversionista
ORDER BY MontoComprado DESC;
GO

-- Comprobación: vistas creadas en la base de datos
SELECT name AS Vista, create_date AS FechaCreacion
FROM sys.views;
GO