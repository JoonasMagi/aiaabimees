# Andmebaasihaldussüsteemide Seadistamine ja Kasutamine

See projekt sisaldab kuue erineva andmebaasihaldussüsteemi seadistust ja näidisandmeid:

## Andmebaasihaldussüsteemid

### 1. MySQL
- **Port:** 3307
- **Kasutaja:** student
- **Parool:** Passw0rd
- **Andmebaas:** studentdb
- **Failid:** `sql/MySQL/dump.sql`, `sql/MySQL/data.sql`, `sql/MySQL/queries.sql`

### 2. MariaDB
- **Port:** 3306
- **Kasutaja:** student
- **Parool:** Passw0rd
- **Andmebaas:** studentdb
- **Failid:** `sql/MariaDB/dump.sql`, `sql/MariaDB/queries.sql`

### 3. PostgreSQL
- **Port:** 5432
- **Kasutaja:** student
- **Parool:** Passw0rd
- **Andmebaas:** studentdb
- **Failid:** `sql/PostgreSQL/dump.sql`, `sql/PostgreSQL/queries.sql`

### 4. Microsoft SQL Server
- **Port:** 1433
- **Kasutaja:** sa
- **Parool:** Passw0rd
- **Andmebaas:** aiabimees
- **Failid:** `sql/MicrosoftSQL/dump.sql`, `sql/MicrosoftSQL/queries.sql`

### 5. MongoDB
- **Port:** 27017
- **Kasutaja:** student
- **Parool:** Passw0rd
- **Andmebaas:** studentdb
- **Failid:** `sql/MongoDB/dump.sql`, `sql/MongoDB/queries.js`

### 6. Redis
- **Port:** 6379
- **Parool:** Passw0rd
- **Failid:** `sql/Reddis/seed.redis`, `sql/Reddis/queries.redis`

## Andmeskeem

Kõik relatsioonilised andmebaasid (MySQL, MariaDB, PostgreSQL, MS SQL Server) kasutavad sama andmeskeemi:

### Tabelid:
- **users** - Kasutajate andmed
- **all_plants** - Kõikide taimede kataloog
- **user_plants** - Kasutajate kasvatatud taimed
- **weather_data** - Ilmaandmed
- **soil_types** - Mullatiipide andmed
- **growing_environments** - Kasvukeskkonnad
- **sensor_inputs** - Sensorite andmed
- **actuator_outputs** - Aktuaatorite andmed

### MongoDB ja Redis
- MongoDB kasutab dokumendipõhist struktuuri samade andmetega
- Redis kasutab võti-väärtus struktuuri koos erinevate andmetüüpidega

## Käivitamine

### Docker konteinerite käivitamine:
```bash
docker-compose up -d
```

### Andmete laadimine:

#### MySQL:
```bash
docker exec -i mysql_container mysql -u student -pPassw0rd studentdb < sql/MySQL/dump.sql
docker exec -i mysql_container mysql -u student -pPassw0rd studentdb < sql/MySQL/data.sql
```

#### MariaDB:
```bash
docker exec -i mariadb_container mysql -u student -pPassw0rd studentdb < sql/MariaDB/dump.sql
```

#### PostgreSQL:
```bash
docker exec -i postgres_container psql -U student -d studentdb < sql/PostgreSQL/dump.sql
```

#### Microsoft SQL Server:
```bash
docker exec -i mssql_container /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -i /sql/MicrosoftSQL/dump.sql
```

#### MongoDB:
```bash
docker exec -i mongodb_container mongo studentdb --username student --password Passw0rd < sql/MongoDB/dump.sql
```

#### Redis:
```bash
docker exec -i redis_studentdb redis-cli -a Passw0rd < sql/Reddis/seed.redis
```

## Näidispäringud

Iga andmebaasihaldussüsteemi jaoks on loodud mõtestatud SELECT päringud, mis demonstreerivad:

1. **Agregeerimisfunktsioonid** (COUNT, AVG, SUM, MIN, MAX)
2. **WHERE tingimused** ja filtreerimine
3. **GROUP BY** ja **HAVING** klauslid
4. **JOIN** operatsioonid mitme tabeli vahel
5. **ORDER BY** ja **LIMIT** tulemuste sortimiseks ja piiramiseks
6. **Andmebaasispetsiifilised funktsioonid**

### Näited päringute käivitamiseks:

#### MySQL/MariaDB:
```bash
docker exec -i mysql_container mysql -u student -pPassw0rd studentdb < sql/MySQL/queries.sql
```

#### PostgreSQL:
```bash
docker exec -i postgres_container psql -U student -d studentdb -f sql/PostgreSQL/queries.sql
```

#### MongoDB:
```bash
docker exec -i mongodb_container mongo studentdb --username student --password Passw0rd sql/MongoDB/queries.js
```

#### Redis:
```bash
docker exec -i redis_studentdb redis-cli -a Passw0rd < sql/Reddis/queries.redis
```

## Andmete kirjeldus

Andmebaasides on piisavalt andmeid mõtestatud päringute tegemiseks:

- **5 kasutajat** (joonas, test, mari, kadi, lauri)
- **15 erinevat taimesort** (tomatid, basiilik, salatid, paprikad)
- **15 kasutaja taime** erinevate kasvatusaegadega
- **15 ilmaandmete kirjet** erinevatest linnadest
- **5 mullatiüpi** erinevate pH väärtustega
- **6 kasvukeskkonda** erinevate kasutajate jaoks
- **15 sensori mõõtmist** erinevates keskkondades
- **13 aktuaatori aktiveerimist** erinevatel aegadel

## Eripärad

### MySQL vs MariaDB
- MariaDB toetab JSON funktsioone ja Window functions
- MariaDB toetab Common Table Expressions (CTE)

### PostgreSQL
- Kasutab SERIAL andmetüüpi AUTO_INCREMENT asemel
- Toetab täiustatud statistilisi funktsioone (CORR)
- Kasutab STRING_AGG funktsiooni GROUP_CONCAT asemel

### Microsoft SQL Server
- Kasutab NVARCHAR Unicode stringide jaoks
- Kasutab IDENTITY(1,1) AUTO_INCREMENT asemel
- Toetab STRING_AGG ja DATEPART funktsioone

### MongoDB
- Kasutab dokumendipõhist struktuuri
- Toetab komplekseid aggregation pipeline päringuid
- Kasutab ObjectId viiteid

### Redis
- Kasutab erinevaid andmestruktuure (Hash, Set, Sorted Set, String)
- Toetab TTL (Time To Live) võtmete jaoks
- Optimeeritud cache ja session andmete jaoks
