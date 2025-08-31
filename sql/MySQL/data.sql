USE studentdb;

-- Teeme kindlaks, et kasutatud student ID väärtused on automaatselt genereeritud
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

-- Nüüd proovime uuesti kasvukeskkondade lisamist
INSERT INTO `growing_environments` (`user_id`, `soil_id`, `name`) VALUES
                                                                      (1, 1, 'Sisekasvandus 1'),
                                                                      (1, 2, 'Aed põhjaosas'),
                                                                      (2, 3, 'Kasvuhoone'),
                                                                      (3, 1, 'Lõunapoolne aken'),
                                                                      (4, 4, 'Välipeenrad'),
                                                                      (5, 2, 'Automaatkasvatussüsteem');

-- Lisame kasutajate taimi
INSERT INTO `user_plants` (`user_id`, `plant_id`, `planting_time`, `est_cropping`) VALUES
                                                                                        (1, 1, '2024-03-15', 85),
                                                                                        (1, 4, '2024-04-01', 45),
                                                                                        (1, 7, '2024-04-10', 30),
                                                                                        (2, 2, '2024-03-20', 90),
                                                                                        (2, 5, '2024-04-05', 50),
                                                                                        (2, 10, '2024-04-15', 75),
                                                                                        (3, 3, '2024-03-25', 70),
                                                                                        (3, 6, '2024-04-08', 40),
                                                                                        (3, 8, '2024-04-12', 35),
                                                                                        (4, 11, '2024-03-30', 80),
                                                                                        (4, 12, '2024-04-02', 85),
                                                                                        (5, 13, '2024-04-20', 95),
                                                                                        (5, 14, '2024-04-25', 88),
                                                                                        (1, 9, '2024-05-01', 25),
                                                                                        (2, 15, '2024-05-05', 92);

-- Lisame ilmaandmeid
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

-- Lisame sensorite andmeid
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

-- Lisame aktuaatorite andmeid
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