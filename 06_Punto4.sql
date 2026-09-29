/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 06 - PUNTO 4: INVESTIGAR Y APLICAR INSTRUCCIONES
   4.1 Operadores de conjuntos: UNION, INTERSECT, EXCEPT
   4.2 Funciones de texto: LOWER, UPPER, SUBSTRING, CONCAT
   4.3 Funciones de fecha: GETDATE, DAY, MONTH, YEAR, DATEDIFF
   4.4 Funciones matemáticas: ABS, RAND, SQRT, POWER
   4.5 Conversión: CAST
   4.6 TOP y DISTINCT
===================================================================== */
USE BolsaValores;
GO

/* =====================================================================
   4.1 OPERADORES DE CONJUNTOS
===================================================================== */
-- Paso previo: acciones compradas
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Compra';
GO

-- Paso previo: acciones vendidas
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Venta';
GO

-- Consulta 4.1.1 (UNION)
-- Enunciado: Listar todas las acciones que se han comprado o vendido, sin repetir
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Compra'
UNION
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Venta';
GO

-- Consulta 4.1.2 (UNION ALL)
-- Enunciado: Listar todas las acciones compradas y vendidas, incluyendo repetidas
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Compra'
UNION ALL
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Venta';
GO

-- Consulta 4.1.3 (INTERSECT)
-- Enunciado: Listar las acciones que se han comprado y también vendido
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Compra'
INTERSECT
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Venta';
GO

-- Consulta 4.1.4 (EXCEPT)
-- Enunciado: Listar las acciones que se han comprado pero nunca vendido
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Compra'
EXCEPT
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Venta';
GO

-- Consulta 4.1.5 (EXCEPT en sentido contrario)
-- Enunciado: Listar las acciones que se han vendido pero nunca comprado
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Venta'
EXCEPT
SELECT a.simbolo
FROM TransaccionBolsa t
INNER JOIN Accion a ON a.idAccion = t.idAccion
WHERE t.tipoTransaccion = 'Compra';
GO

/* =====================================================================
   4.2 FUNCIONES DE TEXTO
===================================================================== */
-- Consulta 4.2.1 (UPPER y LOWER)
-- Enunciado: Mostrar el nombre de cada empresa en mayúsculas y su sector en minúsculas
SELECT nombre,
       UPPER(nombre) AS NombreMayusculas,
       sector,
       LOWER(sector) AS SectorMinusculas
FROM Empresa;
GO

-- Consulta 4.2.2 (SUBSTRING)
-- Enunciado: Mostrar las iniciales de cada inversionista y el usuario de su correo
SELECT nombres,
       apellidos,
       SUBSTRING(nombres, 1, 1) + SUBSTRING(apellidos, 1, 1) AS Iniciales,
       correo,
       SUBSTRING(correo, 1, CHARINDEX('@', correo) - 1)       AS UsuarioCorreo
FROM Inversionista;
GO

-- Consulta 4.2.3 (CONCAT)
-- Enunciado: Mostrar el nombre completo y el documento de cada inversionista en una sola columna
SELECT CONCAT(nombres, ' ', apellidos, ' - Doc. ', documento) AS Inversionista
FROM Inversionista;
GO

-- Comprobación: diferencia entre CONCAT y el operador + cuando hay valores NULL
SELECT idTransaccion,
       idOrdenCompra,
       CONCAT('Orden de compra: ', idOrdenCompra)                  AS ConCONCAT,
       'Orden de compra: ' + CAST(idOrdenCompra AS VARCHAR(10))    AS ConSuma
FROM TransaccionBolsa;
GO

/* =====================================================================
   4.3 FUNCIONES DE FECHA
===================================================================== */
-- Consulta 4.3.1 (GETDATE)
-- Enunciado: Mostrar la fecha y hora actual del servidor
SELECT GETDATE() AS FechaHoraActual;
GO

-- Consulta 4.3.2 (DAY, MONTH, YEAR)
-- Enunciado: Mostrar el día, mes y año de cada orden de compra
SELECT idOrdenCompra,
       fechaOrden,
       DAY(fechaOrden)   AS Dia,
       MONTH(fechaOrden) AS Mes,
       YEAR(fechaOrden)  AS Anio
FROM OrdenCompra;
GO

-- Consulta 4.3.3 (DATEDIFF)
-- Enunciado: Mostrar cuántos días han pasado desde cada orden de compra y cuántos
-- minutos tardó en ejecutarse cada una
SELECT oc.idOrdenCompra,
       oc.fechaOrden,
       t.fechaTransaccion,
       DATEDIFF(DAY, oc.fechaOrden, GETDATE())               AS DiasDesdeLaOrden,
       DATEDIFF(MINUTE, oc.fechaOrden, t.fechaTransaccion)   AS MinutosEnEjecutarse
FROM OrdenCompra oc
INNER JOIN TransaccionBolsa t ON t.idOrdenCompra = oc.idOrdenCompra;
GO

/* =====================================================================
   4.4 FUNCIONES MATEMÁTICAS
===================================================================== */
-- Consulta 4.4.1 (ABS)
-- Enunciado: Mostrar la diferencia entre el monto vendido y el monto comprado por
-- cada inversionista, y su valor absoluto
SELECT oc.idInversionista,
       oc.montoTotal                       AS MontoComprado,
       ov.montoTotal                       AS MontoVendido,
       ov.montoTotal - oc.montoTotal       AS Diferencia,
       ABS(ov.montoTotal - oc.montoTotal)  AS DiferenciaAbsoluta
FROM OrdenCompra oc
INNER JOIN OrdenVenta ov ON ov.idInversionista = oc.idInversionista
WHERE oc.estado = 'Ejecutada' AND ov.estado = 'Ejecutada';
GO

-- Consulta 4.4.2 (RAND)
-- Enunciado: Generar un número aleatorio entre 0 y 1 y un número entero aleatorio entre 1 y 100
SELECT RAND()                        AS Aleatorio,
       CAST(RAND() * 100 AS INT) + 1 AS AleatorioEntre1y100;
GO

-- Consulta 4.4.3 (SQRT y POWER)
-- Enunciado: Mostrar la raíz cuadrada y el cuadrado del precio de cada acción, y el
-- precio proyectado a 3 años con un crecimiento del 5% anual
SELECT simbolo,
       precioActual,
       SQRT(precioActual)                              AS RaizCuadrada,
       POWER(precioActual, 2)                          AS PrecioAlCuadrado,
       CAST(precioActual * POWER(CAST(1.05 AS FLOAT), 3) AS DECIMAL(18,2)) AS PrecioProyectado3Anios
FROM Accion;
GO

/* =====================================================================
   4.5 CAST
===================================================================== */
-- Consulta 4.5.1
-- Enunciado: Mostrar el saldo de cada inversionista como número entero y como texto,
-- y la fecha de sus órdenes sin la hora
SELECT i.nombres,
       i.saldoDisponible,
       CAST(i.saldoDisponible AS INT)                      AS SaldoEntero,
       'Saldo: ' + CAST(i.saldoDisponible AS VARCHAR(20))  AS SaldoTexto,
       oc.fechaOrden,
       CAST(oc.fechaOrden AS DATE)                         AS SoloFecha
FROM Inversionista i
INNER JOIN OrdenCompra oc ON oc.idInversionista = i.idInversionista;
GO

/* =====================================================================
   4.6 TOP Y DISTINCT
===================================================================== */
-- Consulta 4.6.1 (TOP)
-- Enunciado: Mostrar los 3 inversionistas con mayor saldo disponible
SELECT TOP 3 nombres, apellidos, saldoDisponible
FROM Inversionista
ORDER BY saldoDisponible DESC;
GO

-- Consulta 4.6.2 (DISTINCT)
-- Enunciado: Mostrar los distintos estados que tienen las órdenes de compra
SELECT DISTINCT estado
FROM OrdenCompra;
GO

-- Consulta 4.6.3 (DISTINCT)
-- Enunciado: Mostrar los inversionistas distintos que tienen transacciones registradas
SELECT DISTINCT t.idInversionista, i.nombres, i.apellidos
FROM TransaccionBolsa t
INNER JOIN Inversionista i ON i.idInversionista = t.idInversionista;
GO

-- Comprobación: sin DISTINCT cada inversionista aparece una vez por transacción
SELECT t.idInversionista, i.nombres, i.apellidos
FROM TransaccionBolsa t
INNER JOIN Inversionista i ON i.idInversionista = t.idInversionista
ORDER BY t.idInversionista;
GO