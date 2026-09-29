/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 03 - PUNTO 1
   1.1 Modelo relacional (diagrama en SQL Server con los cambios realizados)
   1.2 Consulta con LEFT JOIN desde cero y diferencia con INNER JOIN
   1.3 Consulta de agrupamiento desde cero
===================================================================== */
USE BolsaValores;
GO

/* =====================================================================
   1.1 MODELO RELACIONAL
===================================================================== */
-- Enunciado: Mostrar las claves foráneas del modelo (tabla hija y tabla padre)
SELECT name AS ClaveForanea,
       OBJECT_NAME(parent_object_id)     AS TablaHija,
       OBJECT_NAME(referenced_object_id) AS TablaPadre
FROM sys.foreign_keys
ORDER BY TablaHija;
GO

-- Enunciado: Mostrar las órdenes de compra ejecutadas que no tienen transacción registrada
SELECT oc.idOrdenCompra, oc.estado, t.idTransaccion
FROM OrdenCompra oc
LEFT JOIN TransaccionBolsa t ON t.idOrdenCompra = oc.idOrdenCompra
WHERE oc.estado = 'Ejecutada'
  AND t.idTransaccion IS NULL;
GO

/* =====================================================================
   1.2 LEFT JOIN DESDE CERO Y DIFERENCIA CON INNER JOIN
   Enunciado: Listar todos los inversionistas con sus transacciones,
   incluyendo a los que no han realizado ninguna transacción
===================================================================== */
-- Paso 1: tabla izquierda
SELECT idInversionista, nombres, apellidos
FROM Inversionista;
GO

-- Paso 2: tabla derecha
SELECT idTransaccion, idInversionista, tipoTransaccion, valorTotal
FROM TransaccionBolsa;
GO

-- Paso 3: INNER JOIN
SELECT i.idInversionista, i.nombres, i.apellidos,
       t.idTransaccion, t.tipoTransaccion, t.valorTotal
FROM Inversionista i
INNER JOIN TransaccionBolsa t ON t.idInversionista = i.idInversionista
ORDER BY i.idInversionista;
GO

-- Paso 4: LEFT JOIN
SELECT i.idInversionista, i.nombres, i.apellidos,
       t.idTransaccion, t.tipoTransaccion, t.valorTotal
FROM Inversionista i
LEFT JOIN TransaccionBolsa t ON t.idInversionista = i.idInversionista
ORDER BY i.idInversionista;
GO

-- Paso 5: Inversionistas que nunca han realizado una transacción
SELECT i.idInversionista, i.nombres, i.apellidos
FROM Inversionista i
LEFT JOIN TransaccionBolsa t ON t.idInversionista = i.idInversionista
WHERE t.idTransaccion IS NULL;
GO

-- Comprobación: cantidad de inversionistas sin transacciones
SELECT COUNT(*) AS InversionistasSinTransaccion
FROM Inversionista
WHERE idInversionista NOT IN (SELECT idInversionista FROM TransaccionBolsa);
GO

/* =====================================================================
   1.3 AGRUPAMIENTO DESDE CERO
   Enunciado: Mostrar, por tipo de transacción, la cantidad de transacciones,
   el valor total, el promedio, el mínimo y el máximo
===================================================================== */
-- Paso 1: detalle de las transacciones
SELECT idTransaccion, tipoTransaccion, cantidad, precioUnitario, valorTotal
FROM TransaccionBolsa
ORDER BY tipoTransaccion;
GO

-- Paso 2: agrupar por tipo de transacción
SELECT tipoTransaccion
FROM TransaccionBolsa
GROUP BY tipoTransaccion;
GO

-- Paso 3: funciones de agregación
SELECT tipoTransaccion,
       COUNT(*)        AS CantidadTransacciones,
       SUM(valorTotal) AS ValorTotal,
       AVG(valorTotal) AS ValorPromedio,
       MIN(valorTotal) AS ValorMinimo,
       MAX(valorTotal) AS ValorMaximo
FROM TransaccionBolsa
GROUP BY tipoTransaccion;
GO

-- Comprobación: total por tipo sin GROUP BY
SELECT SUM(valorTotal) AS TotalCompras
FROM TransaccionBolsa
WHERE tipoTransaccion = 'Compra';

SELECT SUM(valorTotal) AS TotalVentas
FROM TransaccionBolsa
WHERE tipoTransaccion = 'Venta';
GO