-- Drop and recreate the database (run from a different database, e.g. 'postgres')
DROP DATABASE IF EXISTS aiabimees;
CREATE DATABASE aiabimees;

-- Connect to the newly created database
\c aiabimees;

-- Table: users
CREATE TABLE users (
                       user_id      BIGSERIAL PRIMARY KEY,
                       username     VARCHAR(191) NOT NULL,
                       password     VARCHAR(191) NOT NULL,
                       email        VARCHAR(191),
                       created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create a trigger or use an ON UPDATE expression for updated_at
-- In PostgreSQL, you'll typically handle updated_at with a trigger, or explicitly in your DML.
-- For a simple approach, you can do something like:
--   updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
-- Then rely on your application or an explicit trigger to update it.
--
-- If you want an automatic update, you'd do something like:
--   CREATE FUNCTION set_current_timestamp() RETURNS trigger AS $$
--   BEGIN
--       NEW.updated_at = now();
--       RETURN NEW;
--   END;
--   $$ LANGUAGE plpgsql;
--
--   CREATE TRIGGER update_users_updated_at
--   BEFORE UPDATE ON users
--   FOR EACH ROW
--   EXECUTE PROCEDURE set_current_timestamp();
--
-- Or simply manage it in your application layer.

-- Unique index on username
CREATE UNIQUE INDEX idx_username ON users(username);

-- Index on email
CREATE INDEX idx_email ON users(email);

------------------------------------------------------------------------

-- Table: all_plants
CREATE TABLE all_plants (
                            plant_id       BIGSERIAL PRIMARY KEY,
                            plant_cultivar VARCHAR(191) NOT NULL,
                            plant_species  VARCHAR(191) NOT NULL,
                            is_deleted     BOOLEAN NOT NULL DEFAULT FALSE,
                            created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Unique index on (plant_cultivar, plant_species)
CREATE UNIQUE INDEX idx_cultivar_species ON all_plants(plant_cultivar, plant_species);
-- Index on plant_species
CREATE INDEX idx_species ON all_plants(plant_species);

------------------------------------------------------------------------

-- Table: user_plants
CREATE TABLE user_plants (
                             user_plant_id  BIGSERIAL PRIMARY KEY,
                             user_id        BIGINT NOT NULL,
                             plant_id       BIGINT NOT NULL,
                             planting_time  DATE NOT NULL,
                             est_cropping   SMALLINT,
                             is_deleted     BOOLEAN NOT NULL DEFAULT FALSE,
                             photo_url      VARCHAR(255),
                             created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Foreign keys
ALTER TABLE user_plants
    ADD CONSTRAINT fk_user_plants_user
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;

ALTER TABLE user_plants
    ADD CONSTRAINT fk_user_plants_plant
        FOREIGN KEY (plant_id) REFERENCES all_plants(plant_id) ON DELETE CASCADE;

-- Additional indexes
CREATE INDEX idx_user_plants ON user_plants(user_id, plant_id);
CREATE INDEX idx_planting_time ON user_plants(planting_time);

------------------------------------------------------------------------

-- Table: weather_data
CREATE TABLE weather_data (
                              weather_id   BIGSERIAL PRIMARY KEY,
                              user_id      BIGINT NOT NULL,
                              location     VARCHAR(191),
                              temperature  DECIMAL(5, 2),
                              humidity     DECIMAL(5, 2),
                              recorded_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE weather_data
    ADD CONSTRAINT fk_user_weather
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;

CREATE INDEX idx_user_weather ON weather_data(user_id);
CREATE INDEX idx_location ON weather_data(location);
CREATE INDEX idx_recorded_at ON weather_data(recorded_at);

------------------------------------------------------------------------

-- Table: soil_types
CREATE TABLE soil_types (
                            soil_id        BIGSERIAL PRIMARY KEY,
                            soil_type      VARCHAR(50) NOT NULL,
                            ph_range       VARCHAR(20),
                            description    TEXT,
                            suitable_plants TEXT,
                            created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Unique index on soil_type
CREATE UNIQUE INDEX idx_soil_type ON soil_types(soil_type);

------------------------------------------------------------------------

-- Table: growing_environments
CREATE TABLE growing_environments (
                                      environment_id BIGSERIAL PRIMARY KEY,
                                      user_id        BIGINT NOT NULL,
                                      soil_id        BIGINT NOT NULL,
                                      name           VARCHAR(191) NOT NULL,
                                      created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE growing_environments
    ADD CONSTRAINT fk_user_environments
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;

ALTER TABLE growing_environments
    ADD CONSTRAINT fk_environment_soil
        FOREIGN KEY (soil_id) REFERENCES soil_types(soil_id) ON DELETE CASCADE;

CREATE INDEX idx_user_environments ON growing_environments(user_id);

------------------------------------------------------------------------

-- Table: actuator_outputs
CREATE TABLE actuator_outputs (
                                  output_id      BIGSERIAL PRIMARY KEY,
                                  actuator_name  VARCHAR(50) NOT NULL,
                                  state          BOOLEAN NOT NULL DEFAULT FALSE,
                                  "timestamp"    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  environment_id BIGINT NOT NULL
);

ALTER TABLE actuator_outputs
    ADD CONSTRAINT fk_environment_actuators
        FOREIGN KEY (environment_id) REFERENCES growing_environments(environment_id) ON DELETE CASCADE;

CREATE INDEX idx_environment_actuators ON actuator_outputs(environment_id);
CREATE INDEX idx_actuator_timestamp ON actuator_outputs("timestamp");

------------------------------------------------------------------------

-- Table: sensor_inputs
CREATE TABLE sensor_inputs (
                               input_id       BIGSERIAL PRIMARY KEY,
                               sensor_name    VARCHAR(50) NOT NULL,
                               sensor_type    VARCHAR(50),
                               value          DECIMAL(10, 2),
                               unit           VARCHAR(20),
                               "timestamp"    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               environment_id BIGINT NOT NULL
);

ALTER TABLE sensor_inputs
    ADD CONSTRAINT fk_environment_sensors
        FOREIGN KEY (environment_id) REFERENCES growing_environments(environment_id) ON DELETE CASCADE;

CREATE INDEX idx_environment_sensors ON sensor_inputs(environment_id);
CREATE INDEX idx_sensor_timestamp ON sensor_inputs("timestamp");

------------------------------------------------------------------------

-- Sample Data for Testing
INSERT INTO users (username, password, email)
VALUES
    ('joonas', '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', 'joonas@example.com'),
    ('test', '$2b$10$p.4iOlmdZ.muJouF0ppY.OPxJU5I23lta4eS5ESIfAqcb/k55Pqx6', 'test@example.com'),
    ('mari', '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', 'mari@example.com'),
    ('kadi', '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', 'kadi@example.com'),
    ('lauri', '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe', 'lauri@example.com');

INSERT INTO all_plants (plant_cultivar, plant_species)
VALUES
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

INSERT INTO soil_types (soil_type, ph_range, description, suitable_plants)
VALUES
    ('Savimullad', '6.0-7.0', 'Toitainerohkad, kuid võivad olla raskesti läbitavad', 'Tomat, basiil, paprika'),
    ('Liivsavimullad', '6.5-7.5', 'Hästi dreneeritud, kuivavad kiiremini', 'Salatid, tomat'),
    ('Turvasmullad', '4.5-6.0', 'Happelised, orgaanilisest ainest rikkad', 'Basiil, salatid'),
    ('Mullamullad', '6.0-7.5', 'Tasakaalustatud, hea struktuuri', 'Kõik tööstatud taimed'),
    ('Lubjasavimullad', '7.0-8.0', 'Kõrge kaltsiumi sisaldusega', 'Paprika, tomat');

INSERT INTO growing_environments (user_id, soil_id, name)
VALUES
    (1, 1, 'Sisekasvandus 1'),
    (1, 2, 'Aed põhjaosas'),
    (2, 3, 'Kasvuhoone'),
    (3, 1, 'Lõunapoolne aken'),
    (4, 4, 'Välipeenrad'),
    (5, 2, 'Automaatkasvatussüsteem');

INSERT INTO user_plants (user_id, plant_id, planting_time, est_cropping, photo_url)
VALUES
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

INSERT INTO weather_data (user_id, location, temperature, humidity, recorded_at)
VALUES
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

INSERT INTO sensor_inputs (sensor_name, sensor_type, value, unit, environment_id, "timestamp")
VALUES
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

INSERT INTO actuator_outputs (actuator_name, state, environment_id, "timestamp")
VALUES
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
