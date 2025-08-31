-------------------------------------------------------------------------------
-- 1. DROP DATABASE IF EXISTS
-------------------------------------------------------------------------------
IF DB_ID(N'aiabimees') IS NOT NULL
BEGIN
    ALTER DATABASE [aiabimees] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [aiabimees];
END
GO

-------------------------------------------------------------------------------
-- 2. CREATE DATABASE
-------------------------------------------------------------------------------
CREATE DATABASE [aiabimees];
GO

USE [aiabimees];
GO

-------------------------------------------------------------------------------
-- 3. CREATE TABLE: Users
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[users] (
    [user_id]   BIGINT         NOT NULL IDENTITY(1,1),
    [username]  NVARCHAR(191)  NOT NULL,
    [password]  NVARCHAR(191)  NOT NULL,
    [email]     NVARCHAR(191)  NULL,
    [created_at] DATETIME2(0)  NOT NULL CONSTRAINT [DF_users_created_at]
    DEFAULT (GETDATE()),
    [updated_at] DATETIME2(0)  NOT NULL CONSTRAINT [DF_users_updated_at]
    DEFAULT (GETDATE()),
    CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([user_id] ASC),
    CONSTRAINT [UQ_users_username] UNIQUE ([username])
    );
GO

-- Create an index on email (non-clustered)
CREATE NONCLUSTERED INDEX [idx_email]
    ON [dbo].[users]([email]);
GO

-------------------------------------------------------------------------------
-- 4. CREATE TABLE: all_plants
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[all_plants] (
    [plant_id]        BIGINT        NOT NULL IDENTITY(1,1),
    [plant_cultivar]  NVARCHAR(191) NOT NULL,
    [plant_species]   NVARCHAR(191) NOT NULL,
    [is_deleted]      BIT           NOT NULL CONSTRAINT [DF_all_plants_is_deleted]
    DEFAULT (0),
    [created_at]      DATETIME2(0)  NOT NULL CONSTRAINT [DF_all_plants_created_at]
    DEFAULT (GETDATE()),
    CONSTRAINT [PK_all_plants] PRIMARY KEY CLUSTERED ([plant_id] ASC),
    CONSTRAINT [UQ_all_plants_cultivar_species] UNIQUE ([plant_cultivar], [plant_species])
    );
GO

-- Create an index on plant_species (non-clustered)
CREATE NONCLUSTERED INDEX [idx_species]
    ON [dbo].[all_plants]([plant_species]);
GO

-------------------------------------------------------------------------------
-- 5. CREATE TABLE: user_plants
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[user_plants] (
    [user_plant_id] BIGINT       NOT NULL IDENTITY(1,1),
    [user_id]       BIGINT       NOT NULL,
    [plant_id]      BIGINT       NOT NULL,
    [planting_time] DATE         NOT NULL,
    [est_cropping]  TINYINT      NULL,
    [is_deleted]    BIT          NOT NULL CONSTRAINT [DF_user_plants_is_deleted]
    DEFAULT (0),
    [photo_url]     NVARCHAR(255) NULL,
    [created_at]    DATETIME2(0) NOT NULL CONSTRAINT [DF_user_plants_created_at]
    DEFAULT (GETDATE()),
    [updated_at]    DATETIME2(0) NOT NULL CONSTRAINT [DF_user_plants_updated_at]
    DEFAULT (GETDATE()),
    CONSTRAINT [PK_user_plants] PRIMARY KEY CLUSTERED ([user_plant_id] ASC),
    CONSTRAINT [FK_user_plants_users]
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[users]([user_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_user_plants_all_plants]
    FOREIGN KEY ([plant_id]) REFERENCES [dbo].[all_plants]([plant_id]) ON DELETE CASCADE
    );
GO

-- Create non-clustered indexes
CREATE NONCLUSTERED INDEX [idx_user_plants]
    ON [dbo].[user_plants]([user_id], [plant_id]);

CREATE NONCLUSTERED INDEX [idx_planting_time]
    ON [dbo].[user_plants]([planting_time]);
GO

-------------------------------------------------------------------------------
-- 6. CREATE TABLE: weather_data
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[weather_data] (
    [weather_id]  BIGINT        NOT NULL IDENTITY(1,1),
    [user_id]     BIGINT        NOT NULL,
    [location]    NVARCHAR(191) NULL,
    [temperature] DECIMAL(5, 2) NULL,
    [humidity]    DECIMAL(5, 2) NULL,
    [recorded_at] DATETIME2(0)  NOT NULL CONSTRAINT [DF_weather_data_recorded_at]
    DEFAULT (GETDATE()),
    CONSTRAINT [PK_weather_data] PRIMARY KEY CLUSTERED ([weather_id] ASC),
    CONSTRAINT [FK_weather_data_users]
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[users]([user_id]) ON DELETE CASCADE
    );
GO

-- Create non-clustered indexes
CREATE NONCLUSTERED INDEX [idx_user_weather]
    ON [dbo].[weather_data]([user_id]);

CREATE NONCLUSTERED INDEX [idx_location]
    ON [dbo].[weather_data]([location]);

CREATE NONCLUSTERED INDEX [idx_recorded_at]
    ON [dbo].[weather_data]([recorded_at]);
GO

-------------------------------------------------------------------------------
-- 7. CREATE TABLE: soil_types
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[soil_types] (
    [soil_id]        BIGINT         NOT NULL IDENTITY(1,1),
    [soil_type]      NVARCHAR(50)   NOT NULL,
    [ph_range]       NVARCHAR(20)   NULL,
    [description]    NVARCHAR(MAX)  NULL,
    [suitable_plants] NVARCHAR(MAX) NULL,
    [created_at]     DATETIME2(0)   NOT NULL CONSTRAINT [DF_soil_types_created_at]
    DEFAULT (GETDATE()),
    CONSTRAINT [PK_soil_types] PRIMARY KEY CLUSTERED ([soil_id] ASC),
    CONSTRAINT [UQ_soil_types_soil_type] UNIQUE ([soil_type])
    );
GO

-------------------------------------------------------------------------------
-- 8. CREATE TABLE: growing_environments
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[growing_environments] (
    [environment_id] BIGINT       NOT NULL IDENTITY(1,1),
    [user_id]        BIGINT       NOT NULL,
    [soil_id]        BIGINT       NOT NULL,
    [name]           NVARCHAR(191) NOT NULL,
    [created_at]     DATETIME2(0) NOT NULL CONSTRAINT [DF_growing_env_created_at]
    DEFAULT (GETDATE()),
    [updated_at]     DATETIME2(0) NOT NULL CONSTRAINT [DF_growing_env_updated_at]
    DEFAULT (GETDATE()),
    CONSTRAINT [PK_growing_environments] PRIMARY KEY CLUSTERED ([environment_id] ASC),
    CONSTRAINT [FK_growing_environments_users]
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[users]([user_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_growing_environments_soil_types]
    FOREIGN KEY ([soil_id]) REFERENCES [dbo].[soil_types]([soil_id]) ON DELETE CASCADE
    );
GO

-- Create non-clustered index on (user_id)
CREATE NONCLUSTERED INDEX [idx_user_environments]
    ON [dbo].[growing_environments]([user_id]);
GO

-------------------------------------------------------------------------------
-- 9. CREATE TABLE: actuator_outputs
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[actuator_outputs] (
    [output_id]     BIGINT       NOT NULL IDENTITY(1,1),
    [actuator_name] NVARCHAR(50) NOT NULL,
    [state]         BIT          NOT NULL CONSTRAINT [DF_actuator_outputs_state]
    DEFAULT (0),
    [timestamp]     DATETIME2(0) NOT NULL CONSTRAINT [DF_actuator_outputs_timestamp]
    DEFAULT (GETDATE()),
    [environment_id] BIGINT      NOT NULL,
    CONSTRAINT [PK_actuator_outputs] PRIMARY KEY CLUSTERED ([output_id] ASC),
    CONSTRAINT [FK_actuator_outputs_growing_env]
    FOREIGN KEY ([environment_id]) REFERENCES [dbo].[growing_environments]([environment_id])
    ON DELETE CASCADE
    );
GO

-- Create non-clustered indexes
CREATE NONCLUSTERED INDEX [idx_environment_actuators]
    ON [dbo].[actuator_outputs]([environment_id]);

CREATE NONCLUSTERED INDEX [idx_actuator_timestamp]
    ON [dbo].[actuator_outputs]([timestamp]);
GO

-------------------------------------------------------------------------------
-- 10. CREATE TABLE: sensor_inputs
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[sensor_inputs] (
    [input_id]      BIGINT       NOT NULL IDENTITY(1,1),
    [sensor_name]   NVARCHAR(50) NOT NULL,
    [sensor_type]   NVARCHAR(50) NULL,
    [value]         DECIMAL(10,2) NULL,
    [unit]          NVARCHAR(20)  NULL,
    [timestamp]     DATETIME2(0)  NOT NULL CONSTRAINT [DF_sensor_inputs_timestamp]
    DEFAULT (GETDATE()),
    [environment_id] BIGINT       NOT NULL,
    CONSTRAINT [PK_sensor_inputs] PRIMARY KEY CLUSTERED ([input_id] ASC),
    CONSTRAINT [FK_sensor_inputs_growing_env]
    FOREIGN KEY ([environment_id]) REFERENCES [dbo].[growing_environments]([environment_id])
    ON DELETE CASCADE
    );
GO

-- Create non-clustered indexes
CREATE NONCLUSTERED INDEX [idx_environment_sensors]
    ON [dbo].[sensor_inputs]([environment_id]);

CREATE NONCLUSTERED INDEX [idx_sensor_timestamp]
    ON [dbo].[sensor_inputs]([timestamp]);
GO

-------------------------------------------------------------------------------
-- 11. SAMPLE DATA INSERTS
-------------------------------------------------------------------------------
INSERT INTO [dbo].[users] ([username], [password], [email])
VALUES
    (N'joonas', N'$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', N'joonas@example.com'),
    (N'test', N'$2b$10$p.4iOlmdZ.muJouF0ppY.OPxJU5I23lta4eS5ESIfAqcb/k55Pqx6', N'test@example.com'),
    (N'mari', N'$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', N'mari@example.com'),
    (N'kadi', N'$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', N'kadi@example.com'),
    (N'lauri', N'$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', N'lauri@example.com');
GO

INSERT INTO [dbo].[all_plants] ([plant_cultivar], [plant_species])
VALUES
    (N'Roma', N'Solanum lycopersicum'),
    (N'Beefsteak', N'Solanum lycopersicum'),
    (N'Cherry', N'Solanum lycopersicum'),
    (N'Genovese', N'Ocimum basilicum'),
    (N'Thai', N'Ocimum basilicum'),
    (N'Purple', N'Ocimum basilicum'),
    (N'Butterhead', N'Lactuca sativa'),
    (N'Romaine', N'Lactuca sativa'),
    (N'Iceberg', N'Lactuca sativa'),
    (N'Green', N'Capsicum annuum'),
    (N'Red', N'Capsicum annuum'),
    (N'Yellow', N'Capsicum annuum'),
    (N'Habanero', N'Capsicum chinense'),
    (N'Roma VF', N'Solanum lycopersicum'),
    (N'Beefmaster', N'Solanum lycopersicum');
GO

INSERT INTO [dbo].[soil_types] ([soil_type], [ph_range], [description], [suitable_plants])
VALUES
    (N'Savimullad', N'6.0-7.0', N'Toitainerohkad, kuid võivad olla raskesti läbitavad', N'Tomat, basiil, paprika'),
    (N'Liivsavimullad', N'6.5-7.5', N'Hästi dreneeritud, kuivavad kiiremini', N'Salatid, tomat'),
    (N'Turvasmullad', N'4.5-6.0', N'Happelised, orgaanilisest ainest rikkad', N'Basiil, salatid'),
    (N'Mullamullad', N'6.0-7.5', N'Tasakaalustatud, hea struktuuri', N'Kõik tööstatud taimed'),
    (N'Lubjasavimullad', N'7.0-8.0', N'Kõrge kaltsiumi sisaldusega', N'Paprika, tomat');
GO

INSERT INTO [dbo].[growing_environments] ([user_id], [soil_id], [name])
VALUES
    (1, 1, N'Sisekasvandus 1'),
    (1, 2, N'Aed põhjaosas'),
    (2, 3, N'Kasvuhoone'),
    (3, 1, N'Lõunapoolne aken'),
    (4, 4, N'Välipeenrad'),
    (5, 2, N'Automaatkasvatussüsteem');
GO

INSERT INTO [dbo].[user_plants] ([user_id], [plant_id], [planting_time], [est_cropping], [photo_url])
VALUES
    (1, 1, '2024-03-15', 85, N'/uploads/roma_tomato.jpg'),
    (1, 4, '2024-04-01', 45, N'/uploads/genovese_basil.jpg'),
    (1, 7, '2024-04-10', 30, N'/uploads/butterhead_lettuce.jpg'),
    (2, 2, '2024-03-20', 90, N'/uploads/beefsteak_tomato.jpg'),
    (2, 5, '2024-04-05', 50, N'/uploads/thai_basil.jpg'),
    (2, 10, '2024-04-15', 75, N'/uploads/green_pepper.jpg'),
    (3, 3, '2024-03-25', 70, N'/uploads/cherry_tomato.jpg'),
    (3, 6, '2024-04-08', 40, N'/uploads/purple_basil.jpg'),
    (3, 8, '2024-04-12', 35, N'/uploads/romaine_lettuce.jpg'),
    (4, 11, '2024-03-30', 80, N'/uploads/red_pepper.jpg'),
    (4, 12, '2024-04-02', 85, N'/uploads/yellow_pepper.jpg'),
    (5, 13, '2024-04-20', 95, N'/uploads/habanero.jpg'),
    (5, 14, '2024-04-25', 88, N'/uploads/roma_vf.jpg'),
    (1, 9, '2024-05-01', 25, N'/uploads/iceberg_lettuce.jpg'),
    (2, 15, '2024-05-05', 92, N'/uploads/beefmaster.jpg');
GO

INSERT INTO [dbo].[weather_data] ([user_id], [location], [temperature], [humidity], [recorded_at])
VALUES
    (1, N'Tallinn', 18.5, 65.2, '2024-08-01 08:00:00'),
    (1, N'Tallinn', 22.3, 58.7, '2024-08-01 14:00:00'),
    (1, N'Tallinn', 19.8, 72.1, '2024-08-01 20:00:00'),
    (2, N'Tartu', 17.2, 68.9, '2024-08-01 08:00:00'),
    (2, N'Tartu', 21.7, 61.3, '2024-08-01 14:00:00'),
    (2, N'Tartu', 18.9, 75.4, '2024-08-01 20:00:00'),
    (3, N'Pärnu', 19.1, 63.8, '2024-08-01 08:00:00'),
    (3, N'Pärnu', 23.4, 55.2, '2024-08-01 14:00:00'),
    (4, N'Narva', 16.8, 71.6, '2024-08-01 08:00:00'),
    (4, N'Narva', 20.9, 64.7, '2024-08-01 14:00:00'),
    (5, N'Viljandi', 18.3, 69.2, '2024-08-01 08:00:00'),
    (1, N'Tallinn', 20.1, 62.5, '2024-08-02 08:00:00'),
    (1, N'Tallinn', 24.7, 54.8, '2024-08-02 14:00:00'),
    (2, N'Tartu', 19.5, 66.1, '2024-08-02 08:00:00'),
    (2, N'Tartu', 23.8, 59.7, '2024-08-02 14:00:00');
GO

INSERT INTO [dbo].[sensor_inputs] ([sensor_name], [sensor_type], [value], [unit], [environment_id], [timestamp])
VALUES
    (N'Temp_Sensor_1', N'Temperature', 23.5, N'°C', 1, '2024-08-01 08:00:00'),
    (N'Humidity_Sensor_1', N'Humidity', 65.2, N'%', 1, '2024-08-01 08:00:00'),
    (N'pH_Sensor_1', N'pH', 6.8, N'pH', 1, '2024-08-01 08:00:00'),
    (N'Light_Sensor_1', N'Light', 450.0, N'lux', 1, '2024-08-01 08:00:00'),
    (N'Temp_Sensor_2', N'Temperature', 21.8, N'°C', 2, '2024-08-01 08:00:00'),
    (N'Humidity_Sensor_2', N'Humidity', 58.7, N'%', 2, '2024-08-01 08:00:00'),
    (N'Temp_Sensor_3', N'Temperature', 25.2, N'°C', 3, '2024-08-01 08:00:00'),
    (N'Humidity_Sensor_3', N'Humidity', 72.1, N'%', 3, '2024-08-01 08:00:00'),
    (N'pH_Sensor_3', N'pH', 6.2, N'pH', 3, '2024-08-01 08:00:00'),
    (N'Temp_Sensor_1', N'Temperature', 24.1, N'°C', 1, '2024-08-01 14:00:00'),
    (N'Humidity_Sensor_1', N'Humidity', 62.8, N'%', 1, '2024-08-01 14:00:00'),
    (N'Light_Sensor_1', N'Light', 680.0, N'lux', 1, '2024-08-01 14:00:00'),
    (N'Temp_Sensor_4', N'Temperature', 22.7, N'°C', 4, '2024-08-01 12:00:00'),
    (N'Humidity_Sensor_4', N'Humidity', 69.3, N'%', 4, '2024-08-01 12:00:00'),
    (N'Temp_Sensor_5', N'Temperature', 26.8, N'°C', 5, '2024-08-01 10:00:00');
GO

INSERT INTO [dbo].[actuator_outputs] ([actuator_name], [state], [environment_id], [timestamp])
VALUES
    (N'Water_Pump_1', 1, 1, '2024-08-01 09:00:00'),
    (N'LED_Light_1', 1, 1, '2024-08-01 06:00:00'),
    (N'Fan_1', 0, 1, '2024-08-01 08:00:00'),
    (N'Water_Pump_2', 1, 2, '2024-08-01 10:00:00'),
    (N'Heater_1', 0, 2, '2024-08-01 08:00:00'),
    (N'Water_Pump_3', 1, 3, '2024-08-01 11:00:00'),
    (N'LED_Light_3', 1, 3, '2024-08-01 07:00:00'),
    (N'Fan_3', 1, 3, '2024-08-01 12:00:00'),
    (N'Water_Pump_4', 0, 4, '2024-08-01 09:30:00'),
    (N'LED_Light_4', 0, 4, '2024-08-01 18:00:00'),
    (N'Water_Pump_5', 1, 5, '2024-08-01 08:30:00'),
    (N'Fan_5', 1, 5, '2024-08-01 13:00:00'),
    (N'Heater_5', 0, 5, '2024-08-01 20:00:00');
GO
