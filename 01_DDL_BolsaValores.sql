
USE master;
GO

IF DB_ID('BolsaValores') IS NOT NULL
BEGIN
    ALTER DATABASE BolsaValores SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BolsaValores;
END
GO

CREATE DATABASE BolsaValores;
GO

USE BolsaValores;
GO

/* =========================================
   TABLA: Inversionista
========================================= */
CREATE TABLE Inversionista(
    idInversionista INT IDENTITY(1,1) PRIMARY KEY,
    nombres         VARCHAR(60)  NOT NULL,
    apellidos       VARCHAR(60)  NOT NULL,
    documento       VARCHAR(20)  NOT NULL UNIQUE,
    correo          VARCHAR(100) NOT NULL UNIQUE,
    telefono        VARCHAR(20)  NOT NULL,
    saldoDisponible DECIMAL(18,2) NOT NULL
        CONSTRAINT CK_Inversionista_Saldo CHECK (saldoDisponible >= 0),
    estado          VARCHAR(15)  NOT NULL
        CONSTRAINT CK_Inversionista_Estado CHECK (estado IN ('Activo', 'Inactivo'))
);
GO

/* =========================================
   TABLA: Empresa
========================================= */
CREATE TABLE Empresa(
    idEmpresa INT IDENTITY(1,1) PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL UNIQUE,
    sector    VARCHAR(50)  NOT NULL,
    pais      VARCHAR(50)  NOT NULL,
    estado    VARCHAR(15)  NOT NULL
        CONSTRAINT CK_Empresa_Estado CHECK (estado IN ('Activa', 'Suspendida'))
);
GO

/* =========================================
   TABLA: Accion
========================================= */
CREATE TABLE Accion(
    idAccion           INT IDENTITY(1,1) PRIMARY KEY,
    idEmpresa          INT NOT NULL,
    simbolo            VARCHAR(10) NOT NULL UNIQUE,
    precioActual       DECIMAL(18,2) NOT NULL
        CONSTRAINT CK_Accion_Precio CHECK (precioActual > 0),
    cantidadDisponible INT NOT NULL
        CONSTRAINT CK_Accion_Cantidad CHECK (cantidadDisponible >= 0),
    CONSTRAINT FK_Accion_Empresa
        FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa)
);
GO

/* =========================================
   TABLA: OrdenCompra
========================================= */
CREATE TABLE OrdenCompra(
    idOrdenCompra   INT IDENTITY(1,1) PRIMARY KEY,
    idInversionista INT NOT NULL,
    idAccion        INT NOT NULL,
    fechaOrden      DATETIME NOT NULL DEFAULT GETDATE(),
    cantidad        INT NOT NULL
        CONSTRAINT CK_OrdenCompra_Cantidad CHECK (cantidad > 0),
    precioUnitario  DECIMAL(18,2) NOT NULL
        CONSTRAINT CK_OrdenCompra_Precio CHECK (precioUnitario > 0),
    montoTotal AS (cantidad * precioUnitario),   -- columna calculada
    estado          VARCHAR(15) NOT NULL
        CONSTRAINT CK_OrdenCompra_Estado CHECK (estado IN ('Registrada', 'Ejecutada', 'Cancelada')),
    CONSTRAINT FK_OrdenCompra_Inversionista
        FOREIGN KEY (idInversionista) REFERENCES Inversionista(idInversionista),
    CONSTRAINT FK_OrdenCompra_Accion
        FOREIGN KEY (idAccion) REFERENCES Accion(idAccion)
);
GO

/* =========================================
   TABLA: OrdenVenta
========================================= */
CREATE TABLE OrdenVenta(
    idOrdenVenta    INT IDENTITY(1,1) PRIMARY KEY,
    idInversionista INT NOT NULL,
    idAccion        INT NOT NULL,
    fechaOrden      DATETIME NOT NULL DEFAULT GETDATE(),
    cantidad        INT NOT NULL
        CONSTRAINT CK_OrdenVenta_Cantidad CHECK (cantidad > 0),
    precioUnitario  DECIMAL(18,2) NOT NULL
        CONSTRAINT CK_OrdenVenta_Precio CHECK (precioUnitario > 0),
    montoTotal AS (cantidad * precioUnitario),   -- columna calculada
    estado          VARCHAR(15) NOT NULL
        CONSTRAINT CK_OrdenVenta_Estado CHECK (estado IN ('Registrada', 'Ejecutada', 'Cancelada')),
    CONSTRAINT FK_OrdenVenta_Inversionista
        FOREIGN KEY (idInversionista) REFERENCES Inversionista(idInversionista),
    CONSTRAINT FK_OrdenVenta_Accion
        FOREIGN KEY (idAccion) REFERENCES Accion(idAccion)
);
GO

/* =========================================
   TABLA: TransaccionBolsa
========================================= */
CREATE TABLE TransaccionBolsa(
    idTransaccion    INT IDENTITY(1,1) PRIMARY KEY,
    tipoTransaccion  VARCHAR(10) NOT NULL
        CONSTRAINT CK_TransaccionBolsa_Tipo CHECK (tipoTransaccion IN ('Compra', 'Venta')),
    idInversionista  INT NOT NULL,
    idAccion         INT NOT NULL,
    idOrdenCompra    INT NULL,
    idOrdenVenta     INT NULL,
    fechaTransaccion DATETIME NOT NULL DEFAULT GETDATE(),
    cantidad         INT NOT NULL
        CONSTRAINT CK_TransaccionBolsa_Cantidad CHECK (cantidad > 0),
    precioUnitario   DECIMAL(18,2) NOT NULL
        CONSTRAINT CK_TransaccionBolsa_Precio CHECK (precioUnitario > 0),
    valorTotal AS (cantidad * precioUnitario),   -- columna calculada
    CONSTRAINT FK_TransaccionBolsa_Inversionista
        FOREIGN KEY (idInversionista) REFERENCES Inversionista(idInversionista),
    CONSTRAINT FK_TransaccionBolsa_Accion
        FOREIGN KEY (idAccion) REFERENCES Accion(idAccion),
    CONSTRAINT FK_TransaccionBolsa_OrdenCompra
        FOREIGN KEY (idOrdenCompra) REFERENCES OrdenCompra(idOrdenCompra),
    CONSTRAINT FK_TransaccionBolsa_OrdenVenta
        FOREIGN KEY (idOrdenVenta) REFERENCES OrdenVenta(idOrdenVenta)
);
GO

-- Comprobación: deben aparecer 6 tablas y 9 claves foráneas
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

SELECT name AS ClaveForanea,
       OBJECT_NAME(parent_object_id)     AS TablaHija,
       OBJECT_NAME(referenced_object_id) AS TablaPadre
FROM sys.foreign_keys
ORDER BY TablaHija;
GO