-- =============================================
-- Script: Creación de Base de Datos
-- Descripción: Sistema de Gestión de Beneficiarios
-- =============================================

USE master;
GO

-- Eliminar base de datos si existe
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SistemaBeneficiarios')
BEGIN
    ALTER DATABASE SistemaBeneficiarios SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SistemaBeneficiarios;
END
GO

-- Crear base de datos
CREATE DATABASE SistemaBeneficiarios;
GO

USE SistemaBeneficiarios;
GO

-- =============================================
-- Tabla: DocumentoIdentidad
-- =============================================
CREATE TABLE DocumentoIdentidad (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Abreviatura VARCHAR(10) NOT NULL,
    Pais VARCHAR(50) NOT NULL,
    Longitud INT NOT NULL,
    SoloNumeros BIT NOT NULL DEFAULT 1,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL
);
GO

-- =============================================
-- Tabla: Beneficiario
-- =============================================
CREATE TABLE Beneficiario (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    DocumentoIdentidadId INT NOT NULL,
    NumeroDocumento VARCHAR(20) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Sexo CHAR(1) NOT NULL CHECK (Sexo IN ('M', 'F')),
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL,
    CONSTRAINT FK_Beneficiario_DocumentoIdentidad FOREIGN KEY (DocumentoIdentidadId) 
        REFERENCES DocumentoIdentidad(Id),
    CONSTRAINT UQ_Beneficiario_Documento UNIQUE (DocumentoIdentidadId, NumeroDocumento)
);
GO

-- Crear índices para mejorar el rendimiento
CREATE INDEX IX_Beneficiario_DocumentoIdentidadId ON Beneficiario(DocumentoIdentidadId);
CREATE INDEX IX_Beneficiario_NumeroDocumento ON Beneficiario(NumeroDocumento);
CREATE INDEX IX_DocumentoIdentidad_Activo ON DocumentoIdentidad(Activo);
GO

PRINT 'Base de datos y tablas creadas exitosamente';
GO



-- =============================================
-- Script: Inserción de Datos Iniciales
-- Descripción: Tipos de documentos de identidad por país
-- =============================================

USE SistemaBeneficiarios;
GO

-- =============================================
-- Datos de DocumentoIdentidad
-- =============================================

-- Perú
INSERT INTO DocumentoIdentidad (Nombre, Abreviatura, Pais, Longitud, SoloNumeros, Activo)
VALUES 
    ('Documento Nacional de Identidad', 'DNI', 'Perú', 8, 1, 1),
    ('Carné de Extranjería', 'CE', 'Perú', 9, 1, 1),
    ('Pasaporte', 'PAS', 'Perú', 12, 0, 1);

-- Colombia
INSERT INTO DocumentoIdentidad (Nombre, Abreviatura, Pais, Longitud, SoloNumeros, Activo)
VALUES 
    ('Cédula de Ciudadanía', 'CC', 'Colombia', 10, 1, 1),
    ('Cédula de Extranjería', 'CE', 'Colombia', 7, 1, 1),
    ('Pasaporte', 'PAS', 'Colombia', 10, 0, 1);

-- Argentina
INSERT INTO DocumentoIdentidad (Nombre, Abreviatura, Pais, Longitud, SoloNumeros, Activo)
VALUES 
    ('Documento Nacional de Identidad', 'DNI', 'Argentina', 8, 1, 1),
    ('Libreta de Enrolamiento', 'LE', 'Argentina', 8, 1, 1),
    ('Libreta Cívica', 'LC', 'Argentina', 8, 1, 1),
    ('Pasaporte', 'PAS', 'Argentina', 9, 0, 1);

-- Chile
INSERT INTO DocumentoIdentidad (Nombre, Abreviatura, Pais, Longitud, SoloNumeros, Activo)
VALUES 
    ('Rol Único Nacional', 'RUN', 'Chile', 9, 0, 1),
    ('Pasaporte', 'PAS', 'Chile', 9, 0, 1);

-- México
INSERT INTO DocumentoIdentidad (Nombre, Abreviatura, Pais, Longitud, SoloNumeros, Activo)
VALUES 
    ('Clave Única de Registro de Población', 'CURP', 'México', 18, 0, 1),
    ('Pasaporte', 'PAS', 'México', 10, 0, 1);

-- Ecuador
INSERT INTO DocumentoIdentidad (Nombre, Abreviatura, Pais, Longitud, SoloNumeros, Activo)
VALUES 
    ('Cédula de Identidad', 'CI', 'Ecuador', 10, 1, 1),
    ('Pasaporte', 'PAS', 'Ecuador', 9, 0, 1);

GO

-- =============================================
-- Datos de ejemplo de Beneficiarios
-- =============================================

INSERT INTO Beneficiario (Nombres, Apellidos, DocumentoIdentidadId, NumeroDocumento, FechaNacimiento, Sexo)
VALUES 
    ('Juan Carlos', 'Pérez García', 1, '12345678', '1985-03-15', 'M'),
    ('María Elena', 'Rodríguez López', 1, '87654321', '1990-07-22', 'F'),
    ('Pedro José', 'Martínez Silva', 2, '001234567', '1988-11-10', 'M'),
    ('Ana Lucía', 'González Torres', 4, '1234567890', '1992-05-18', 'F'),
    ('Carlos Alberto', 'Fernández Ruiz', 7, '23456789', '1987-09-25', 'M');

GO






-- =============================================
-- Script: Stored Procedures
-- Descripción: Procedimientos almacenados para CRUD
-- =============================================

USE SistemaBeneficiarios;
GO

-- =============================================
-- SP: Listar Todos los Beneficiarios (Activos e Inactivos)
-- =============================================
CREATE OR ALTER PROCEDURE sp_ListarTodosBeneficiarios
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        b.Id,
        b.Nombres,
        b.Apellidos,
        b.DocumentoIdentidadId,
        d.Nombre AS TipoDocumento,
        d.Abreviatura AS AbreviaturaDocumento,
        d.Pais,
        b.NumeroDocumento,
        b.FechaNacimiento,
        b.Sexo,
        b.Activo,
        b.FechaCreacion,
        b.FechaModificacion
    FROM Beneficiario b
    INNER JOIN DocumentoIdentidad d ON b.DocumentoIdentidadId = d.Id
    ORDER BY b.Activo DESC, b.FechaCreacion DESC;
END
GO



-- =============================================
-- SP: Listar Solo Beneficiarios Activos
-- =============================================
CREATE OR ALTER PROCEDURE sp_ListarBeneficiariosActivos
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        b.Id,
        b.Nombres,
        b.Apellidos,
        b.DocumentoIdentidadId,
        d.Nombre AS TipoDocumento,
        d.Abreviatura AS AbreviaturaDocumento,
        d.Pais,
        b.NumeroDocumento,
        b.FechaNacimiento,
        b.Sexo,
        b.Activo,
        b.FechaCreacion,
        b.FechaModificacion
    FROM Beneficiario b
    INNER JOIN DocumentoIdentidad d ON b.DocumentoIdentidadId = d.Id
    WHERE b.Activo = 1
    ORDER BY b.FechaCreacion DESC;
END
GO


-- =============================================
-- SP: Listar Solo Beneficiarios Inactivos
-- =============================================
CREATE OR ALTER PROCEDURE sp_ListarBeneficiariosInactivos
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        b.Id,
        b.Nombres,
        b.Apellidos,
        b.DocumentoIdentidadId,
        d.Nombre AS TipoDocumento,
        d.Abreviatura AS AbreviaturaDocumento,
        d.Pais,
        b.NumeroDocumento,
        b.FechaNacimiento,
        b.Sexo,
        b.Activo,
        b.FechaCreacion,
        b.FechaModificacion
    FROM Beneficiario b
    INNER JOIN DocumentoIdentidad d ON b.DocumentoIdentidadId = d.Id
    WHERE b.Activo = 0
    ORDER BY b.FechaModificacion DESC;
END
GO

-- =============================================
-- SP: Obtener Beneficiario por ID
-- =============================================
CREATE OR ALTER PROCEDURE sp_ObtenerBeneficiario
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        b.Id,
        b.Nombres,
        b.Apellidos,
        b.DocumentoIdentidadId,
        d.Nombre AS TipoDocumento,
        d.Abreviatura AS AbreviaturaDocumento,
        d.Pais,
        b.NumeroDocumento,
        b.FechaNacimiento,
        b.Sexo,
        b.Activo,
        b.FechaCreacion,
        b.FechaModificacion
    FROM Beneficiario b
    INNER JOIN DocumentoIdentidad d ON b.DocumentoIdentidadId = d.Id
    WHERE b.Id = @Id;
END
GO


-- =============================================
-- SP: Crear Beneficiario
-- =============================================
CREATE OR ALTER PROCEDURE sp_CrearBeneficiario
    @Nombres VARCHAR(100),
    @Apellidos VARCHAR(100),
    @DocumentoIdentidadId INT,
    @NumeroDocumento VARCHAR(20),
    @FechaNacimiento DATE,
    @Sexo CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el tipo de documento existe y está activo
        IF NOT EXISTS (SELECT 1 FROM DocumentoIdentidad WHERE Id = @DocumentoIdentidadId AND Activo = 1)
        BEGIN
            RAISERROR('El tipo de documento no existe o no está activo', 16, 1);
            RETURN;
        END
        
        -- Validar que no exista el mismo documento
        IF EXISTS (SELECT 1 FROM Beneficiario 
                   WHERE DocumentoIdentidadId = @DocumentoIdentidadId 
                   AND NumeroDocumento = @NumeroDocumento 
                   AND Activo = 1)
        BEGIN
            RAISERROR('Ya existe un beneficiario con este número de documento', 16, 1);
            RETURN;
        END
        
        -- Insertar beneficiario
        INSERT INTO Beneficiario (Nombres, Apellidos, DocumentoIdentidadId, NumeroDocumento, FechaNacimiento, Sexo)
        VALUES (@Nombres, @Apellidos, @DocumentoIdentidadId, @NumeroDocumento, @FechaNacimiento, @Sexo);
        
        -- Obtener el ID del beneficiario creado
        DECLARE @NewId INT = SCOPE_IDENTITY();
        
        -- Retornar el beneficiario creado
        EXEC sp_ObtenerBeneficiario @NewId;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO


-- =============================================
-- SP: Actualizar Beneficiario
-- =============================================
CREATE OR ALTER PROCEDURE sp_ActualizarBeneficiario
    @Id INT,
    @Nombres VARCHAR(100),
    @Apellidos VARCHAR(100),
    @DocumentoIdentidadId INT,
    @NumeroDocumento VARCHAR(20),
    @FechaNacimiento DATE,
    @Sexo CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el beneficiario existe
        IF NOT EXISTS (SELECT 1 FROM Beneficiario WHERE Id = @Id)
        BEGIN
            RAISERROR('El beneficiario no existe', 16, 1);
            RETURN;
        END
        
        -- Validar que el tipo de documento existe y está activo
        IF NOT EXISTS (SELECT 1 FROM DocumentoIdentidad WHERE Id = @DocumentoIdentidadId AND Activo = 1)
        BEGIN
            RAISERROR('El tipo de documento no existe o no está activo', 16, 1);
            RETURN;
        END
        
        -- Validar que no exista otro beneficiario con el mismo documento
        IF EXISTS (SELECT 1 FROM Beneficiario 
                   WHERE DocumentoIdentidadId = @DocumentoIdentidadId 
                   AND NumeroDocumento = @NumeroDocumento 
                   AND Id != @Id 
                   AND Activo = 1)
        BEGIN
            RAISERROR('Ya existe otro beneficiario con este número de documento', 16, 1);
            RETURN;
        END
        
        -- Actualizar beneficiario
        UPDATE Beneficiario
        SET 
            Nombres = @Nombres,
            Apellidos = @Apellidos,
            DocumentoIdentidadId = @DocumentoIdentidadId,
            NumeroDocumento = @NumeroDocumento,
            FechaNacimiento = @FechaNacimiento,
            Sexo = @Sexo,
            FechaModificacion = GETDATE()
        WHERE Id = @Id;
        
        -- Retornar el beneficiario actualizado
        EXEC sp_ObtenerBeneficiario @Id;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO



-- =============================================
-- SP: Eliminar Beneficiario (Soft Delete)
-- =============================================
CREATE OR ALTER PROCEDURE sp_EliminarBeneficiario
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el beneficiario existe
        IF NOT EXISTS (SELECT 1 FROM Beneficiario WHERE Id = @Id)
        BEGIN
            RAISERROR('El beneficiario no existe', 16, 1);
            RETURN;
        END
        
        -- Realizar soft delete
        UPDATE Beneficiario
        SET 
            Activo = 0,
            FechaModificacion = GETDATE()
        WHERE Id = @Id;
        
        COMMIT TRANSACTION;
        
        SELECT 1 AS Success;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

PRINT 'Stored Procedures creados exitosamente';
GO



-- =============================================
-- SP: Restaurar Beneficiario (Reactivar)
-- =============================================
CREATE OR ALTER PROCEDURE sp_RestaurarBeneficiario
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el beneficiario existe
        IF NOT EXISTS (SELECT 1 FROM Beneficiario WHERE Id = @Id)
        BEGIN
            RAISERROR('El beneficiario no existe', 16, 1);
            RETURN;
        END
        
        -- Reactivar beneficiario
        UPDATE Beneficiario
        SET 
            Activo = 1,
            FechaModificacion = GETDATE()
        WHERE Id = @Id;
        
        COMMIT TRANSACTION;
        
        SELECT 1 AS Success;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO


-- =============================================
-- SP: Listar Documentos de Identidad Activos
-- =============================================
CREATE OR ALTER PROCEDURE sp_ListarDocumentosIdentidad
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        Id,
        Nombre,
        Abreviatura,
        Pais,
        Longitud,
        SoloNumeros,
        Activo
    FROM DocumentoIdentidad
    WHERE Activo = 1
    ORDER BY Pais, Nombre;
END
GO

-- =============================================
-- SP: Obtener Documento de Identidad por ID
-- =============================================
CREATE OR ALTER PROCEDURE sp_ObtenerDocumentoIdentidad
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        Id,
        Nombre,
        Abreviatura,
        Pais,
        Longitud,
        SoloNumeros,
        Activo
    FROM DocumentoIdentidad
    WHERE Id = @Id;
END
GO