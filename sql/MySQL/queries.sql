-- MySQL mõtestatud SELECT päringud

-- 1. Kasutajate taimede arv ja keskmine kasvatusaeg
SELECT 
    u.username,
    COUNT(up.user_plant_id) as taimede_arv,
    AVG(up.est_cropping) as keskmine_kasvatusaeg_paevades
FROM users u
LEFT JOIN user_plants up ON u.user_id = up.user_id
WHERE up.is_deleted = FALSE
GROUP BY u.user_id, u.username
HAVING taimede_arv > 0
ORDER BY taimede_arv DESC
LIMIT 5;

-- 2. Populaarseimad taimesordid (kõige rohkem kasvatatud)
SELECT 
    ap.plant_species as liik,
    ap.plant_cultivar as sort,
    COUNT(up.user_plant_id) as kasvatajate_arv,
    AVG(up.est_cropping) as keskmine_kasvatusaeg
FROM all_plants ap
JOIN user_plants up ON ap.plant_id = up.plant_id
WHERE up.is_deleted = FALSE
GROUP BY ap.plant_id, ap.plant_species, ap.plant_cultivar
ORDER BY kasvatajate_arv DESC, keskmine_kasvatusaeg ASC
LIMIT 10;

-- 3. Ilmaandmete statistika linnade kaupa
SELECT 
    location as linn,
    COUNT(*) as mootmiste_arv,
    ROUND(AVG(temperature), 2) as keskmine_temp,
    ROUND(MIN(temperature), 2) as min_temp,
    ROUND(MAX(temperature), 2) as max_temp,
    ROUND(AVG(humidity), 2) as keskmine_niiskus
FROM weather_data
GROUP BY location
HAVING mootmiste_arv >= 2
ORDER BY keskmine_temp DESC;

-- 4. Sensorite andmete kokkuvõte keskkondade kaupa
SELECT 
    ge.name as keskkond,
    u.username as omanik,
    si.sensor_type as sensori_tyyp,
    COUNT(si.input_id) as mootmiste_arv,
    ROUND(AVG(si.value), 2) as keskmine_vaartus,
    si.unit as yhik
FROM growing_environments ge
JOIN users u ON ge.user_id = u.user_id
JOIN sensor_inputs si ON ge.environment_id = si.environment_id
GROUP BY ge.environment_id, ge.name, u.username, si.sensor_type, si.unit
HAVING mootmiste_arv > 1
ORDER BY ge.name, si.sensor_type;

-- 5. Aktuaatorite kasutusstatistika
SELECT 
    ao.actuator_name as aktuaator,
    COUNT(*) as kokku_aktiveerimisi,
    SUM(CASE WHEN ao.state = TRUE THEN 1 ELSE 0 END) as sisselulitamisi,
    SUM(CASE WHEN ao.state = FALSE THEN 1 ELSE 0 END) as valjalulitamisi,
    ROUND(
        (SUM(CASE WHEN ao.state = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 
        2
    ) as sisselulitamiste_protsent
FROM actuator_outputs ao
GROUP BY ao.actuator_name
ORDER BY kokku_aktiveerimisi DESC;

-- 6. Mullatiipide sobivus ja kasutus
SELECT 
    st.soil_type as mullatyyp,
    st.ph_range as pH_vahemik,
    COUNT(ge.environment_id) as kasutavate_keskkondade_arv,
    GROUP_CONCAT(DISTINCT u.username SEPARATOR ', ') as kasutajad
FROM soil_types st
LEFT JOIN growing_environments ge ON st.soil_id = ge.soil_id
LEFT JOIN users u ON ge.user_id = u.user_id
GROUP BY st.soil_id, st.soil_type, st.ph_range
ORDER BY kasutavate_keskkondade_arv DESC;

-- 7. Taimede istutamise hooajalisus
SELECT 
    MONTH(up.planting_time) as kuu,
    MONTHNAME(up.planting_time) as kuu_nimi,
    COUNT(*) as istutatud_taimede_arv,
    AVG(up.est_cropping) as keskmine_kasvatusaeg
FROM user_plants up
WHERE up.is_deleted = FALSE
GROUP BY MONTH(up.planting_time), MONTHNAME(up.planting_time)
ORDER BY kuu;
