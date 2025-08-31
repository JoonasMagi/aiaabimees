# Andmebaaside Testimise Käsud

## Docker konteinerite käivitamine
```bash
# Kõikide konteinerite käivitamine
docker-compose up -d

# Konteinerite oleku kontroll
docker-compose ps

# Logide vaatamine
docker-compose logs
```

## Andmebaaside testimine

### 1. MySQL (Port 3307)
```bash
# Ühenduse testimine
docker exec -it mysql_container mysql -u student -pPassw0rd studentdb

# Andmete laadimine
docker exec -i mysql_container mysql -u student -pPassw0rd studentdb < sql/MySQL/dump.sql
docker exec -i mysql_container mysql -u student -pPassw0rd studentdb < sql/MySQL/data.sql

# Päringute käivitamine
docker exec -i mysql_container mysql -u student -pPassw0rd studentdb < sql/MySQL/queries.sql

# Interaktiivne sessioon
docker exec -it mysql_container mysql -u student -pPassw0rd studentdb
```

### 2. MariaDB (Port 3306)
```bash
# Ühenduse testimine
docker exec -it mariadb_container mysql -u student -pPassw0rd studentdb

# Andmete laadimine
docker exec -i mariadb_container mysql -u student -pPassw0rd studentdb < sql/MariaDB/dump.sql

# Päringute käivitamine
docker exec -i mariadb_container mysql -u student -pPassw0rd studentdb < sql/MariaDB/queries.sql

# Interaktiivne sessioon
docker exec -it mariadb_container mysql -u student -pPassw0rd studentdb
```

### 3. PostgreSQL (Port 5432)
```bash
# Ühenduse testimine
docker exec -it postgres_container psql -U student -d studentdb

# Andmete laadimine
docker exec -i postgres_container psql -U student -d studentdb -f sql/PostgreSQL/dump.sql

# Päringute käivitamine
docker exec -i postgres_container psql -U student -d studentdb -f sql/PostgreSQL/queries.sql

# Interaktiivne sessioon
docker exec -it postgres_container psql -U student -d studentdb
```

### 4. Microsoft SQL Server (Port 1433)
```bash
# Ühenduse testimine
docker exec -it mssql_container /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd

# Andmete laadimine (kopeeri fail konteinerisse)
docker cp sql/MicrosoftSQL/dump.sql mssql_container:/tmp/dump.sql
docker exec -it mssql_container /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -i /tmp/dump.sql

# Päringute käivitamine
docker cp sql/MicrosoftSQL/queries.sql mssql_container:/tmp/queries.sql
docker exec -it mssql_container /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -i /tmp/queries.sql

# Interaktiivne sessioon
docker exec -it mssql_container /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd
```

### 5. MongoDB (Port 27017)
```bash
# Ühenduse testimine
docker exec -it mongodb_container mongo --username student --password Passw0rd --authenticationDatabase admin

# Andmete laadimine
docker cp sql/MongoDB/dump.sql mongodb_container:/tmp/dump.js
docker exec -it mongodb_container mongo studentdb --username student --password Passw0rd --authenticationDatabase admin /tmp/dump.js

# Päringute käivitamine
docker cp sql/MongoDB/queries.js mongodb_container:/tmp/queries.js
docker exec -it mongodb_container mongo studentdb --username student --password Passw0rd --authenticationDatabase admin /tmp/queries.js

# Interaktiivne sessioon
docker exec -it mongodb_container mongo studentdb --username student --password Passw0rd --authenticationDatabase admin
```

### 6. Redis (Port 6379)
```bash
# Ühenduse testimine
docker exec -it redis_studentdb redis-cli -a Passw0rd

# Andmete laadimine
docker cp sql/Reddis/seed.redis redis_studentdb:/tmp/seed.redis
docker exec -i redis_studentdb redis-cli -a Passw0rd < /tmp/seed.redis

# Päringute käivitamine
docker cp sql/Reddis/queries.redis redis_studentdb:/tmp/queries.redis
docker exec -i redis_studentdb redis-cli -a Passw0rd < /tmp/queries.redis

# Interaktiivne sessioon
docker exec -it redis_studentdb redis-cli -a Passw0rd
```

## Kiired testpäringud

### MySQL/MariaDB
```sql
-- Kasutajate arv
SELECT COUNT(*) FROM users;

-- Taimede arv kasutaja kohta
SELECT u.username, COUNT(up.user_plant_id) as taimede_arv
FROM users u
LEFT JOIN user_plants up ON u.user_id = up.user_id
GROUP BY u.user_id, u.username;
```

### PostgreSQL
```sql
-- Kasutajate arv
SELECT COUNT(*) FROM users;

-- Ilmaandmete keskmine temperatuur linna kohta
SELECT location, ROUND(AVG(temperature), 2) as keskmine_temp
FROM weather_data
GROUP BY location;
```

### Microsoft SQL Server
```sql
-- Kasutajate arv
SELECT COUNT(*) FROM [dbo].[users];

-- Aktuaatorite olekud
SELECT actuator_name, state, COUNT(*) as arv
FROM [dbo].[actuator_outputs]
GROUP BY actuator_name, state;
```

### MongoDB
```javascript
// Kasutajate arv
db.users.count()

// Taimede arv liigi kohta
db.all_plants.aggregate([
    {$group: {_id: "$plant_species", arv: {$sum: 1}}}
])
```

### Redis
```redis
# Kõikide võtmete vaatamine
KEYS *

# Kasutaja andmete vaatamine
HGETALL user:1

# Populaarsete taimede vaatamine
ZRANGE popular_plants 0 -1 WITHSCORES
```

## Probleemide lahendamine

### Kui konteiner ei käivitu:
```bash
# Konteinerite peatamine
docker-compose down

# Volüümide kustutamine
docker-compose down -v

# Uuesti käivitamine
docker-compose up -d
```

### Kui andmebaasiga ei saa ühendust:
```bash
# Konteinerite logide vaatamine
docker-compose logs [teenuse_nimi]

# Näiteks MySQL logid
docker-compose logs mysql

# Konteinerite oleku kontroll
docker-compose ps
```

### Portide kontroll:
```bash
# Vaata, millised pordid on kasutusel
netstat -an | grep LISTEN
# või
ss -tuln
```

## Andmebaaside peatamine
```bash
# Kõikide konteinerite peatamine
docker-compose down

# Konteinerite ja volüümide kustutamine
docker-compose down -v

# Ainult konteinerite peatamine (andmed jäävad alles)
docker-compose stop
```
