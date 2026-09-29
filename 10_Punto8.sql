/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 10 - PUNTO 8: CONSULTAS CON CASE
===================================================================== */
USE BolsaValores;
GO

-- Consulta 8.1 (CASE simple)
-- Enunciado: Mostrar una descripción del estado de cada orden de compra
SELECT oc.idOrdenCompra,
       i.nombres + ' ' + i.apellidos AS Inversionista,
       oc.estado,
       CASE oc.estado
           WHEN 'Registrada' THEN 'En espera de ejecución'
           WHEN 'Ejecutada'  THEN 'Compra completada'
           WHEN 'Cancelada'  THEN 'Compra anulada'
           ELSE 'Desconocido'
       END AS EstadoDescripcion
FROM OrdenCompra oc
INNER JOIN Inversionista i ON i.idInversionista = oc.idInversionista;
GO

-- Consulta 8.2 (CASE con condiciones)
-- Enunciado: Clasificar cada acción por su precio: 'Económica' si es menor a 70,
-- 'Media' si es menor a 100 y 'Premium' si es de 100 o más
SELECT simbolo,
       precioActual,
       CASE
           WHEN precioActual < 70  THEN 'Económica'
           WHEN precioActual < 100 THEN 'Media'
           ELSE 'Premium'
       END AS CategoriaPrecio
FROM Accion
ORDER BY precioActual;
GO

-- Comprobación: cantidad de acciones por categoría de precio
SELECT CASE
           WHEN precioActual < 70  THEN 'Económica'
           WHEN precioActual < 100 THEN 'Media'
           ELSE 'Premium'
       END      AS CategoriaPrecio,
       COUNT(*) AS NumAcciones
FROM Accion
GROUP BY CASE
             WHEN precioActual < 70  THEN 'Económica'
             WHEN precioActual < 100 THEN 'Media'
             ELSE 'Premium'
         END;
GO