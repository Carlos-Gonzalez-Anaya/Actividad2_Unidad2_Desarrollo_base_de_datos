/* =====================================================================
   ACTIVIDAD 2 - UNIDAD 2 | BASE DE DATOS: BolsaValores
   ARCHIVO 04 - PUNTO 2: MODIFICACIÓN DE TABLAS CON ALTER TABLE
===================================================================== */
USE BolsaValores;
GO

/* =====================================================================
   2a. ADICIONAR UN NUEVO CAMPO Y ELIMINARLO
===================================================================== */
-- Enunciado: Agregar el campo fechaNacimiento a la tabla Inversionista
ALTER TABLE Inversionista ADD fechaNacimiento DATE NULL;
GO

-- Comprobación
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Inversionista';
GO

-- Enunciado: Eliminar el campo fechaNacimiento de la tabla Inversionista
ALTER TABLE Inversionista DROP COLUMN fechaNacimiento;
GO

-- Comprobación
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Inversionista';
GO

/* =====================================================================
   2b. MODIFICAR UN CAMPO
===================================================================== */
-- Enunciado: Ampliar el campo sector de la tabla Empresa a VARCHAR(80)
ALTER TABLE Empresa ALTER COLUMN sector VARCHAR(80) NOT NULL;
GO

-- Comprobación
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Empresa' AND COLUMN_NAME = 'sector';
GO

/* =====================================================================
   2c. ADICIONAR UNA CLAVE FORÁNEA
===================================================================== */
-- Enunciado: Crear la tabla Pais
CREATE TABLE Pais(
    idPais INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);
GO

-- Enunciado: Llenar la tabla Pais con los países registrados en Empresa, sin repetir
INSERT INTO Pais(nombre)
SELECT DISTINCT pais FROM Empresa;
GO

-- Enunciado: Agregar el campo idPais a la tabla Empresa
ALTER TABLE Empresa ADD idPais INT NULL;
GO

-- Enunciado: Asignar a cada empresa el idPais correspondiente
UPDATE e
SET e.idPais = p.idPais
FROM Empresa e
INNER JOIN Pais p ON p.nombre = e.pais;
GO

-- Enunciado: Volver obligatorio el campo idPais
ALTER TABLE Empresa ALTER COLUMN idPais INT NOT NULL;
GO

-- Enunciado: Crear la clave foránea entre Empresa y Pais
ALTER TABLE Empresa
ADD CONSTRAINT FK_Empresa_Pais FOREIGN KEY (idPais) REFERENCES Pais(idPais);
GO

-- Enunciado: Eliminar el campo pais de la tabla Empresa
ALTER TABLE Empresa DROP COLUMN pais;
GO

-- Comprobación: país de cada empresa a través de la relación
SELECT e.idEmpresa, e.nombre, p.nombre AS pais
FROM Empresa e
INNER JOIN Pais p ON p.idPais = e.idPais;
GO

-- Comprobación: insertar una empresa con un país inexistente (debe generar error)
INSERT INTO Empresa (nombre, sector, estado, idPais)
VALUES ('Prueba S.A.', 'Tecnologia', 'Activa', 999);
GO

/* =====================================================================
   2d. ADICIONAR UN CONSTRAINT CHECK
===================================================================== */
-- Enunciado: El teléfono del inversionista debe tener exactamente 10 caracteres
ALTER TABLE Inversionista
ADD CONSTRAINT CK_Inversionista_Telefono CHECK (LEN(telefono) = 10);
GO

-- Comprobación: actualizar un teléfono de 7 dígitos (debe generar error)
UPDATE Inversionista SET telefono = '3001111' WHERE idInversionista = 1;
GO

-- Enunciado: Una transacción de Compra solo puede tener orden de compra
-- y una transacción de Venta solo puede tener orden de venta
ALTER TABLE TransaccionBolsa
ADD CONSTRAINT CK_TransaccionBolsa_Orden CHECK (
       (tipoTransaccion = 'Compra' AND idOrdenCompra IS NOT NULL AND idOrdenVenta IS NULL)
    OR (tipoTransaccion = 'Venta'  AND idOrdenVenta  IS NOT NULL AND idOrdenCompra IS NULL)
);
GO

-- Comprobación: insertar una Compra con orden de venta (debe generar error)
INSERT INTO TransaccionBolsa
    (tipoTransaccion, idInversionista, idAccion, idOrdenCompra, idOrdenVenta, cantidad, precioUnitario)
VALUES ('Compra', 1, 1, NULL, 1, 10, 125.50);
GO

-- Comprobación: restricciones CHECK de la base de datos
SELECT name AS Restriccion, OBJECT_NAME(parent_object_id) AS Tabla, definition
FROM sys.check_constraints
ORDER BY Tabla;
GO

/* =====================================================================
   2e. SP_RENAME
===================================================================== */
-- Enunciado: Cambiar el nombre de la tabla TransaccionBolsa a Transaccion
EXEC sp_rename 'TransaccionBolsa', 'Transaccion';
GO

-- Comprobación
SELECT TOP 3 * FROM Transaccion;
GO

-- Enunciado: Restaurar el nombre original de la tabla
EXEC sp_rename 'Transaccion', 'TransaccionBolsa';
GO

-- Comprobación
SELECT TOP 3 * FROM TransaccionBolsa;
GO

/* =====================================================================
   2f. CREAR UN ÍNDICE
===================================================================== */
-- Enunciado: Crear un índice no agrupado sobre idInversionista en la tabla OrdenCompra
CREATE NONCLUSTERED INDEX IX_OrdenCompra_Inversionista
ON OrdenCompra(idInversionista);
GO

-- Comprobación: índices de la tabla OrdenCompra
EXEC sp_helpindex 'OrdenCompra';
GO

-- Comprobación: claves foráneas del modelo final
SELECT name AS ClaveForanea,
       OBJECT_NAME(parent_object_id)     AS TablaHija,
       OBJECT_NAME(referenced_object_id) AS TablaPadre
FROM sys.foreign_keys
ORDER BY TablaHija;
GO