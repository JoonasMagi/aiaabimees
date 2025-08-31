-- Drop existing database if it exists
DROP DATABASE IF EXISTS `aiabimees`;

-- Create aiabimees database
CREATE DATABASE `aiabimees` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `aiabimees`;

-- Table: Users
CREATE TABLE `users` (
    `user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `idx_username` (`username`),
    KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: AllPlants
CREATE TABLE `all_plants` (
    `plant_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `plant_cultivar` VARCHAR(191) NOT NULL,
    `plant_species` VARCHAR(191) NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`plant_id`),
    UNIQUE KEY `idx_cultivar_species` (`plant_cultivar`, `plant_species`),
    KEY `idx_species` (`plant_species`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: UserPlants
CREATE TABLE `user_plants` (
    `user_plant_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `plant_id` BIGINT UNSIGNED NOT NULL,
    `planting_time` DATE NOT NULL,
    `est_cropping` TINYINT UNSIGNED DEFAULT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `photo_url` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_plant_id`),
    KEY `idx_user_plants` (`user_id`, `plant_id`),
    KEY `idx_planting_time` (`planting_time`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`plant_id`) REFERENCES `all_plants` (`plant_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: WeatherData
CREATE TABLE `weather_data` (
    `weather_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `location` VARCHAR(191) DEFAULT NULL,
    `temperature` DECIMAL(5, 2) DEFAULT NULL,
    `humidity` DECIMAL(5, 2) DEFAULT NULL,
    `recorded_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`weather_id`),
    KEY `idx_user_weather` (`user_id`),
    KEY `idx_location` (`location`),
    KEY `idx_recorded_at` (`recorded_at`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: SoilTypes
CREATE TABLE `soil_types` (
    `soil_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `soil_type` VARCHAR(50) NOT NULL,
    `ph_range` VARCHAR(20) DEFAULT NULL,
    `description` TEXT DEFAULT NULL,
    `suitable_plants` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`soil_id`),
    UNIQUE KEY `idx_soil_type` (`soil_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: GrowingEnvironments
CREATE TABLE `growing_environments` (
    `environment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `soil_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`environment_id`),
    KEY `idx_user_environments` (`user_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`soil_id`) REFERENCES `soil_types` (`soil_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: ActuatorOutputs
CREATE TABLE `actuator_outputs` (
    `output_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `actuator_name` VARCHAR(50) NOT NULL,
    `state` BOOLEAN NOT NULL DEFAULT FALSE,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `environment_id` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`output_id`),
    KEY `idx_environment_actuators` (`environment_id`),
    KEY `idx_actuator_timestamp` (`timestamp`),
    FOREIGN KEY (`environment_id`) REFERENCES `growing_environments` (`environment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: SensorInputs
CREATE TABLE `sensor_inputs` (
    `input_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `sensor_name` VARCHAR(50) NOT NULL,
    `sensor_type` VARCHAR(50) DEFAULT NULL,
    `value` DECIMAL(10, 2) DEFAULT NULL,
    `unit` VARCHAR(20) DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `environment_id` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`input_id`),
    KEY `idx_environment_sensors` (`environment_id`),
    KEY `idx_sensor_timestamp` (`timestamp`),
    FOREIGN KEY (`environment_id`) REFERENCES `growing_environments` (`environment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Data for Testing
INSERT INTO `users` (`username`, `password`, `email`) VALUES
('joonas', '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', 'joonas@example.com'),
('test', '$2b$10$p.4iOlmdZ.muJouF0ppY.OPxJU5I23lta4eS5ESIfAqcb/k55Pqx6', 'test@example.com'),
('mari', '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', 'mari@example.com'),
('kadi', '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', 'kadi@example.com'),
('lauri', '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', 'lauri@example.com');

INSERT INTO `all_plants` (`plant_cultivar`, `plant_species`) VALUES
('Roma', 'Solanum lycopersicum'),
('Beefsteak', 'Solanum lycopersicum'),
('Cherry', 'Solanum lycopersicum'),
('Genovese', 'Ocimum basilicum'),
('Thai', 'Ocimum basilicum'),
('Purple', 'Ocimum basilicum'),
('Butterhead', 'Lactuca sativa'),
('Romaine', 'Lactuca sativa'),
('Iceberg', 'Lactuca sativa'),
('Green', 'Capsicum annuum'),
('Red', 'Capsicum annuum'),
('Yellow', 'Capsicum annuum'),
('Habanero', 'Capsicum chinense'),
('Roma VF', 'Solanum lycopersicum'),
('Beefmaster', 'Solanum lycopersicum');

INSERT INTO `soil_types` (`soil_type`, `ph_range`, `description`, `suitable_plants`) VALUES
('Savimullad', '6.0-7.0', 'Toitainerohkad, kuid võivad olla raskesti läbitavad', 'Tomat, basiil, paprika'),
('Liivsavimullad', '6.5-7.5', 'Hästi dreneeritud, kuivavad kiiremini', 'Salatid, tomat'),
('Turvasmullad', '4.5-6.0', 'Happelised, orgaanilisest ainest rikkad', 'Basiil, salatid'),
('Mullamullad', '6.0-7.5', 'Tasakaalustatud, hea struktuuri', 'Kõik tööstatud taimed'),
('Lubjasavimullad', '7.0-8.0', 'Kõrge kaltsiumi sisaldusega', 'Paprika, tomat');

INSERT INTO `growing_environments` (`user_id`, `soil_id`, `name`) VALUES
(1, 1, 'Sisekasvandus 1'),
(1, 2, 'Aed põhjaosas'),
(2, 3, 'Kasvuhoone'),
(3, 1, 'Lõunapoolne aken'),
(4, 4, 'Välipeenrad'),
(5, 2, 'Automaatkasvatussüsteem');

INSERT INTO `user_plants` (`user_id`, `plant_id`, `planting_time`, `est_cropping`, `photo_url`) VALUES
(1, 1, '2024-03-15', 85, '/uploads/roma_tomato.jpg'),
(1, 4, '2024-04-01', 45, '/uploads/genovese_basil.jpg'),
(1, 7, '2024-04-10', 30, '/uploads/butterhead_lettuce.jpg'),
(2, 2, '2024-03-20', 90, '/uploads/beefsteak_tomato.jpg'),
(2, 5, '2024-04-05', 50, '/uploads/thai_basil.jpg'),
(2, 10, '2024-04-15', 75, '/uploads/green_pepper.jpg'),
(3, 3, '2024-03-25', 70, '/uploads/cherry_tomato.jpg'),
(3, 6, '2024-04-08', 40, '/uploads/purple_basil.jpg'),
(3, 8, '2024-04-12', 35, '/uploads/romaine_lettuce.jpg'),
(4, 11, '2024-03-30', 80, '/uploads/red_pepper.jpg'),
(4, 12, '2024-04-02', 85, '/uploads/yellow_pepper.jpg'),
(5, 13, '2024-04-20', 95, '/uploads/habanero.jpg'),
(5, 14, '2024-04-25', 88, '/uploads/roma_vf.jpg'),
(1, 9, '2024-05-01', 25, '/uploads/iceberg_lettuce.jpg'),
(2, 15, '2024-05-05', 92, '/uploads/beefmaster.jpg');

INSERT INTO `weather_data` (`user_id`, `location`, `temperature`, `humidity`, `recorded_at`) VALUES
(1, 'Tallinn', 18.5, 65.2, '2024-08-01 08:00:00'),
(1, 'Tallinn', 22.3, 58.7, '2024-08-01 14:00:00'),
(1, 'Tallinn', 19.8, 72.1, '2024-08-01 20:00:00'),
(2, 'Tartu', 17.2, 68.9, '2024-08-01 08:00:00'),
(2, 'Tartu', 21.7, 61.3, '2024-08-01 14:00:00'),
(2, 'Tartu', 18.9, 75.4, '2024-08-01 20:00:00'),
(3, 'Pärnu', 19.1, 63.8, '2024-08-01 08:00:00'),
(3, 'Pärnu', 23.4, 55.2, '2024-08-01 14:00:00'),
(4, 'Narva', 16.8, 71.6, '2024-08-01 08:00:00'),
(4, 'Narva', 20.9, 64.7, '2024-08-01 14:00:00'),
(5, 'Viljandi', 18.3, 69.2, '2024-08-01 08:00:00'),
(1, 'Tallinn', 20.1, 62.5, '2024-08-02 08:00:00'),
(1, 'Tallinn', 24.7, 54.8, '2024-08-02 14:00:00'),
(2, 'Tartu', 19.5, 66.1, '2024-08-02 08:00:00'),
(2, 'Tartu', 23.8, 59.7, '2024-08-02 14:00:00');

INSERT INTO `sensor_inputs` (`sensor_name`, `sensor_type`, `value`, `unit`, `environment_id`, `timestamp`) VALUES
('Temp_Sensor_1', 'Temperature', 23.5, '°C', 1, '2024-08-01 08:00:00'),
('Humidity_Sensor_1', 'Humidity', 65.2, '%', 1, '2024-08-01 08:00:00'),
('pH_Sensor_1', 'pH', 6.8, 'pH', 1, '2024-08-01 08:00:00'),
('Light_Sensor_1', 'Light', 450.0, 'lux', 1, '2024-08-01 08:00:00'),
('Temp_Sensor_2', 'Temperature', 21.8, '°C', 2, '2024-08-01 08:00:00'),
('Humidity_Sensor_2', 'Humidity', 58.7, '%', 2, '2024-08-01 08:00:00'),
('Temp_Sensor_3', 'Temperature', 25.2, '°C', 3, '2024-08-01 08:00:00'),
('Humidity_Sensor_3', 'Humidity', 72.1, '%', 3, '2024-08-01 08:00:00'),
('pH_Sensor_3', 'pH', 6.2, 'pH', 3, '2024-08-01 08:00:00'),
('Temp_Sensor_1', 'Temperature', 24.1, '°C', 1, '2024-08-01 14:00:00'),
('Humidity_Sensor_1', 'Humidity', 62.8, '%', 1, '2024-08-01 14:00:00'),
('Light_Sensor_1', 'Light', 680.0, 'lux', 1, '2024-08-01 14:00:00'),
('Temp_Sensor_4', 'Temperature', 22.7, '°C', 4, '2024-08-01 12:00:00'),
('Humidity_Sensor_4', 'Humidity', 69.3, '%', 4, '2024-08-01 12:00:00'),
('Temp_Sensor_5', 'Temperature', 26.8, '°C', 5, '2024-08-01 10:00:00');

INSERT INTO `actuator_outputs` (`actuator_name`, `state`, `environment_id`, `timestamp`) VALUES
('Water_Pump_1', TRUE, 1, '2024-08-01 09:00:00'),
('LED_Light_1', TRUE, 1, '2024-08-01 06:00:00'),
('Fan_1', FALSE, 1, '2024-08-01 08:00:00'),
('Water_Pump_2', TRUE, 2, '2024-08-01 10:00:00'),
('Heater_1', FALSE, 2, '2024-08-01 08:00:00'),
('Water_Pump_3', TRUE, 3, '2024-08-01 11:00:00'),
('LED_Light_3', TRUE, 3, '2024-08-01 07:00:00'),
('Fan_3', TRUE, 3, '2024-08-01 12:00:00'),
('Water_Pump_4', FALSE, 4, '2024-08-01 09:30:00'),
('LED_Light_4', FALSE, 4, '2024-08-01 18:00:00'),
('Water_Pump_5', TRUE, 5, '2024-08-01 08:30:00'),
('Fan_5', TRUE, 5, '2024-08-01 13:00:00'),
('Heater_5', FALSE, 5, '2024-08-01 20:00:00');
