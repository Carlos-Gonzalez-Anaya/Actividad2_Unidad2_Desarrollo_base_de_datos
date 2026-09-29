/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 09 - PUNTO 7: CONSULTAS CON IIF
===================================================================== */
USE BolsaValores;
GO

-- Consulta 7.1
-- Enunciado: Clasificar a cada inversionista según su saldo disponible:
-- 'Alto' si es de 15.000.000 o más, 'Normal' en caso contrario
SELECT nombres,
       apellidos,
       saldoDisponible,
       IIF(saldoDisponible >= 15000000, 'Alto', 'Normal') AS NivelSaldo
FROM Inversionista;
GO

-- Consulta 7.2
-- Enunciado: Indicar para cada acción si tiene baja disponibilidad (menos de 8.000
-- acciones) o disponibilidad suficiente, junto con el estado de su empresa
SELECT a.simbolo,
       e.nombre AS Empresa,
       a.cantidadDisponible,
       IIF(a.cantidadDisponible < 8000, 'Baja disponibilidad', 'Suficiente') AS Disponibilidad,
       IIF(e.estado = 'Activa', 'Se puede negociar', 'No se puede negociar') AS Negociacion
FROM Accion a
INNER JOIN Empresa e ON e.idEmpresa = a.idEmpresa;
GO

-- Consulta 7.3 (IIF anidado)
-- Enunciado: Clasificar cada orden de compra por su monto: 'Grande' si es de 6.000 o más,
-- 'Mediana' si es de 4.000 o más y 'Pequeña' en otro caso
SELECT idOrdenCompra,
       montoTotal,
       IIF(montoTotal >= 6000, 'Grande',
           IIF(montoTotal >= 4000, 'Mediana', 'Pequeña')) AS TamanoOrden
FROM OrdenCompra
ORDER BY montoTotal DESC;
GO

-- Comprobación: cantidad de órdenes por tamaño
SELECT IIF(montoTotal >= 6000, 'Grande',
           IIF(montoTotal >= 4000, 'Mediana', 'Pequeña')) AS TamanoOrden,
       COUNT(*) AS NumOrdenes
FROM OrdenCompra
GROUP BY IIF(montoTotal >= 6000, 'Grande',
             IIF(montoTotal >= 4000, 'Mediana', 'Pequeña'));
GO