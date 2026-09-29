/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 05 - PUNTO 3: OPERACIONES
   3.1 Operadores relacionales y lógicos
   3.2 IS NULL
   3.3 LEFT JOIN y RIGHT JOIN
   3.4 GROUP BY y HAVING
   3.5 Subconsultas con IN, NOT IN, EXISTS y NOT EXISTS
===================================================================== */
USE BolsaValores;
GO

/* =====================================================================
   3.1 OPERADORES RELACIONALES Y LÓGICOS
===================================================================== */
-- Consulta 3.1.1
-- Enunciado: Listar los inversionistas activos cuyo saldo disponible sea mayor a 12.000.000
SELECT idInversionista, nombres, apellidos, saldoDisponible, estado
FROM Inversionista
WHERE estado = 'Activo'
  AND saldoDisponible > 12000000;
GO

-- Comprobación
SELECT idInversionista, saldoDisponible, estado
FROM Inversionista
ORDER BY saldoDisponible DESC;
GO

-- Consulta 3.1.2
-- Enunciado: Listar las acciones con precio mayor o igual a 100 o con 15.000 o más
-- acciones disponibles, excluyendo las de la empresa 10
SELECT idAccion, simbolo, precioActual, cantidadDisponible, idEmpresa
FROM Accion
WHERE (precioActual >= 100 OR cantidadDisponible >= 15000)
  AND NOT idEmpresa = 10;
GO

-- Comprobación: la misma consulta sin paréntesis
SELECT idAccion, simbolo, precioActual, cantidadDisponible, idEmpresa
FROM Accion
WHERE precioActual >= 100 OR cantidadDisponible >= 15000
  AND NOT idEmpresa = 10;
GO

/* =====================================================================
   3.2 IS NULL
===================================================================== */
-- Consulta 3.2.1
-- Enunciado: Listar las transacciones que no están asociadas a una orden de venta
SELECT idTransaccion, tipoTransaccion, idOrdenCompra, idOrdenVenta, valorTotal
FROM TransaccionBolsa
WHERE idOrdenVenta IS NULL;
GO

-- Comprobación: comparación incorrecta con = NULL
SELECT idTransaccion, tipoTransaccion, idOrdenVenta
FROM TransaccionBolsa
WHERE idOrdenVenta = NULL;
GO

-- Consulta 3.2.2
-- Enunciado: Listar las transacciones que tienen orden de venta, con el nombre del
-- inversionista y un texto en lugar de la orden de compra vacía
SELECT t.idTransaccion,
       i.nombres + ' ' + i.apellidos AS Inversionista,
       t.tipoTransaccion,
       ISNULL(CAST(t.idOrdenCompra AS VARCHAR(10)), 'Sin orden de compra') AS OrdenCompra,
       t.idOrdenVenta,
       t.valorTotal
FROM TransaccionBolsa t
INNER JOIN Inversionista i ON i.idInversionista = t.idInversionista
WHERE t.idOrdenVenta IS NOT NULL;
GO

-- Comprobación
SELECT
    (SELECT COUNT(*) FROM TransaccionBolsa WHERE idOrdenVenta IS NULL)     AS SinOrdenVenta,
    (SELECT COUNT(*) FROM TransaccionBolsa WHERE idOrdenVenta IS NOT NULL) AS ConOrdenVenta,
    (SELECT COUNT(*) FROM TransaccionBolsa)                                AS Total;
GO

/* =====================================================================
   3.3 LEFT JOIN Y RIGHT JOIN
===================================================================== */
-- Consulta 3.3.1 (LEFT JOIN)
-- Enunciado: Listar todas las acciones con sus transacciones, incluyendo las que
-- nunca se han negociado
SELECT a.idAccion, a.simbolo, t.idTransaccion, t.tipoTransaccion, t.valorTotal
FROM Accion a
LEFT JOIN TransaccionBolsa t ON t.idAccion = a.idAccion
ORDER BY a.idAccion;
GO

-- Comprobación: acciones que nunca se han negociado
SELECT a.idAccion, a.simbolo
FROM Accion a
LEFT JOIN TransaccionBolsa t ON t.idAccion = a.idAccion
WHERE t.idTransaccion IS NULL;
GO

-- Consulta 3.3.2 (RIGHT JOIN, desde cero)
-- Enunciado: Listar todas las órdenes de venta y, si existe, la transacción que las ejecutó

-- Paso 1: tabla derecha
SELECT idOrdenVenta, idInversionista, estado
FROM OrdenVenta;
GO

-- Paso 2: RIGHT JOIN
SELECT ov.idOrdenVenta, ov.estado, t.idTransaccion, t.fechaTransaccion, t.valorTotal
FROM TransaccionBolsa t
RIGHT JOIN OrdenVenta ov ON ov.idOrdenVenta = t.idOrdenVenta
ORDER BY ov.idOrdenVenta;
GO

-- Paso 3: equivalente con LEFT JOIN
SELECT ov.idOrdenVenta, ov.estado, t.idTransaccion, t.fechaTransaccion, t.valorTotal
FROM OrdenVenta ov
LEFT JOIN TransaccionBolsa t ON t.idOrdenVenta = ov.idOrdenVenta
ORDER BY ov.idOrdenVenta;
GO

-- Comprobación
SELECT
    (SELECT COUNT(*) FROM OrdenVenta)                                      AS TotalOrdenes,
    (SELECT COUNT(*) FROM TransaccionBolsa WHERE idOrdenVenta IS NOT NULL) AS ConTransaccion;
GO

/* =====================================================================
   3.4 GROUP BY Y HAVING
===================================================================== */
-- Consulta 3.4.1 (desde cero)
-- Enunciado: Mostrar las acciones negociadas 2 o más veces, con su número de
-- transacciones y el valor total negociado

-- Paso 1: detalle de transacciones por acción
SELECT t.idAccion, a.simbolo, t.tipoTransaccion, t.valorTotal
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
ORDER BY t.idAccion;
GO

-- Paso 2: agrupar por acción
SELECT a.simbolo,
       COUNT(*)          AS NumTransacciones,
       SUM(t.valorTotal) AS ValorNegociado
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
GROUP BY a.simbolo;
GO

-- Paso 3: filtrar los grupos con HAVING
SELECT a.simbolo,
       COUNT(*)          AS NumTransacciones,
       SUM(t.valorTotal) AS ValorNegociado
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
GROUP BY a.simbolo
HAVING COUNT(*) >= 2
ORDER BY ValorNegociado DESC;
GO

-- Comprobación: valor negociado de la acción AGM
SELECT SUM(valorTotal) AS TotalAGM
FROM TransaccionBolsa
WHERE idAccion = 5;
GO

-- Consulta 3.4.2
-- Enunciado: Mostrar los inversionistas cuyo volumen total negociado supere los 7.000
SELECT i.nombres + ' ' + i.apellidos AS Inversionista,
       COUNT(*)                      AS NumTransacciones,
       SUM(t.valorTotal)             AS VolumenNegociado
FROM Inversionista i
INNER JOIN TransaccionBolsa t ON t.idInversionista = i.idInversionista
GROUP BY i.nombres, i.apellidos
HAVING SUM(t.valorTotal) > 7000
ORDER BY VolumenNegociado DESC;
GO

-- Comprobación: volumen negociado de todos los inversionistas
SELECT i.nombres + ' ' + i.apellidos AS Inversionista,
       SUM(t.valorTotal)             AS VolumenNegociado
FROM Inversionista i
INNER JOIN TransaccionBolsa t ON t.idInversionista = i.idInversionista
GROUP BY i.nombres, i.apellidos
ORDER BY VolumenNegociado DESC;
GO

/* =====================================================================
   3.5 SUBCONSULTAS
===================================================================== */
-- Subconsulta 3.5.1 (IN)
-- Enunciado: Listar los inversionistas que han realizado al menos una venta
SELECT idInversionista, nombres, apellidos
FROM Inversionista
WHERE idInversionista IN (
        SELECT idInversionista
        FROM TransaccionBolsa
        WHERE tipoTransaccion = 'Venta'
      );
GO

-- Subconsulta 3.5.2 (NOT IN)
-- Enunciado: Listar las acciones que nunca se han negociado
SELECT idAccion, simbolo, precioActual
FROM Accion
WHERE idAccion NOT IN (
        SELECT idAccion
        FROM TransaccionBolsa
      );
GO

-- Subconsulta 3.5.3 (EXISTS)
-- Enunciado: Listar las empresas que tienen al menos una acción con una orden de
-- compra ejecutada
SELECT e.idEmpresa, e.nombre, e.estado
FROM Empresa e
WHERE EXISTS (
        SELECT 1
        FROM Accion a
        INNER JOIN OrdenCompra oc ON oc.idAccion = a.idAccion
        WHERE a.idEmpresa = e.idEmpresa
          AND oc.estado = 'Ejecutada'
      );
GO

-- Subconsulta 3.5.4 (NOT EXISTS)
-- Enunciado: Listar los inversionistas que no tienen ninguna orden de venta ejecutada
SELECT i.idInversionista, i.nombres, i.apellidos, i.estado
FROM Inversionista i
WHERE NOT EXISTS (
        SELECT 1
        FROM OrdenVenta ov
        WHERE ov.idInversionista = i.idInversionista
          AND ov.estado = 'Ejecutada'
      );
GO

-- Comprobación: estado de las órdenes de venta por inversionista
SELECT idInversionista, idOrdenVenta, estado
FROM OrdenVenta
ORDER BY idInversionista;
GO