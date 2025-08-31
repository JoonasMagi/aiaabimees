USE studentdb;

-- Kui tabelid juba eksisteerivad, võib esmalt DROP käsud käivitada
DROP TABLE IF EXISTS actuator_outputs;
DROP TABLE IF EXISTS sensor_inputs;
DROP TABLE IF EXISTS growing_environments;
DROP TABLE IF EXISTS weather_data;
DROP TABLE IF EXISTS user_plants;
DROP TABLE IF EXISTS soil_types;
DROP TABLE IF EXISTS all_plants;
DROP TABLE IF EXISTS users;

-- Table: Users
CREATE TABLE IF NOT EXISTS `users` (
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
CREATE TABLE IF NOT EXISTS `all_plants` (
                                            `plant_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                                            `plant_cultivar` VARCHAR(191) NOT NULL,
                                            `plant_species` VARCHAR(191) NOT NULL,
                                            `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
                                            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                            PRIMARY KEY (`plant_id`),
                                            UNIQUE KEY `idx_cultivar_species` (`plant_cultivar`, `plant_species`),
                                            KEY `idx_species` (`plant_species`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: SoilTypes
CREATE TABLE IF NOT EXISTS `soil_types` (
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
CREATE TABLE IF NOT EXISTS `growing_environments` (
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

-- Table: UserPlants
CREATE TABLE IF NOT EXISTS `user_plants` (
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
CREATE TABLE IF NOT EXISTS `weather_data` (
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

-- Table: SensorInputs
CREATE TABLE IF NOT EXISTS `sensor_inputs` (
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

-- Table: ActuatorOutputs
CREATE TABLE IF NOT EXISTS `actuator_outputs` (
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