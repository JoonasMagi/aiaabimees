use studentdb

db.createCollection('users', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['username', 'password'],
            properties: {
                username: {
                    bsonType: 'string',
                    description: 'Must be a string and is required'
                },
                password: {
                    bsonType: 'string',
                    description: 'Must be a string and is required'
                },
                email: {
                    bsonType: 'string',
                    description: 'Must be a string if the field exists'
                },
                created_at: {
                    bsonType: 'date',
                    description: 'Stores the user creation date'
                },
                updated_at: {
                    bsonType: 'date',
                    description: 'Stores the user update date'
                }
            }
        }
    }
})
db.users.createIndex({username: 1}, {unique: true})
db.users.createIndex({email: 1})
db.users.insertMany([
    {
        _id: ObjectId("605a1c2d14f5c41d245746dd"),
        username: 'joonas',
        password: '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe',
        email: 'joonas@example.com',
        created_at: new Date(),
        updated_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746de"),
        username: 'test',
        password: '$2b$10$p.4iOlmdZ.muJouF0ppY.OPxJU5I23lta4eS5ESIfAqcb/k55Pqx6',
        email: 'test@example.com',
        created_at: new Date(),
        updated_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e1"),
        username: 'mari',
        password: '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe',
        email: 'mari@example.com',
        created_at: new Date(),
        updated_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e2"),
        username: 'kadi',
        password: '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe',
        email: 'kadi@example.com',
        created_at: new Date(),
        updated_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e3"),
        username: 'lauri',
        password: '$2b$10$H0/fwx3mnPLuNLve4k74CO44iZy8MZ8KSJbvWwchgpjqeNVBIi6Xe',
        email: 'lauri@example.com',
        created_at: new Date(),
        updated_at: new Date()
    }
])
db.createCollection('all_plants', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['plant_cultivar', 'plant_species'],
            properties: {
                plant_cultivar: {bsonType: 'string'},
                plant_species: {bsonType: 'string'},
                is_deleted: {bsonType: 'bool'},
                created_at: {bsonType: 'date'}
            }
        }
    }
})

// Indexes
db.all_plants.createIndex({plant_cultivar: 1, plant_species: 1}, {unique: true})
db.all_plants.createIndex({plant_species: 1})
db.all_plants.insertMany([
    {
        _id: ObjectId("605a1c2d14f5c41d245746df"),
        plant_cultivar: 'Roma',
        plant_species: 'Solanum lycopersicum',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e0"),
        plant_cultivar: 'Beefsteak',
        plant_species: 'Solanum lycopersicum',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e4"),
        plant_cultivar: 'Cherry',
        plant_species: 'Solanum lycopersicum',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e5"),
        plant_cultivar: 'Genovese',
        plant_species: 'Ocimum basilicum',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e6"),
        plant_cultivar: 'Thai',
        plant_species: 'Ocimum basilicum',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e7"),
        plant_cultivar: 'Purple',
        plant_species: 'Ocimum basilicum',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e8"),
        plant_cultivar: 'Butterhead',
        plant_species: 'Lactuca sativa',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746e9"),
        plant_cultivar: 'Romaine',
        plant_species: 'Lactuca sativa',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746ea"),
        plant_cultivar: 'Iceberg',
        plant_species: 'Lactuca sativa',
        is_deleted: false,
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746eb"),
        plant_cultivar: 'Green',
        plant_species: 'Capsicum annuum',
        is_deleted: false,
        created_at: new Date()
    }
])
db.createCollection('user_plants', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['user_id', 'plant_id', 'planting_time'],
            properties: {
                user_id: {
                    bsonType: 'objectId',
                    description: 'Reference to _id from users collection'
                },
                plant_id: {
                    bsonType: 'objectId',
                    description: 'Reference to _id from all_plants collection'
                },
                planting_time: {bsonType: 'date'},
                est_cropping: {bsonType: 'int'},
                is_deleted: {bsonType: 'bool'},
                photo_url: {bsonType: 'string'},
                created_at: {bsonType: 'date'},
                updated_at: {bsonType: 'date'}
            }
        }
    }
})

// Indexes (optional, based on usage)
db.user_plants.createIndex({user_id: 1, plant_id: 1})
db.user_plants.createIndex({planting_time: 1})
const joonasId = ObjectId("605a1c2d14f5c41d245746dd")
const testUserId = ObjectId("605a1c2d14f5c41d245746de")
const tomatoId = ObjectId("605a1c2d14f5c41d245746df")
const basilId = ObjectId("605a1c2d14f5c41d245746e0")

db.user_plants.insertMany([
    {
        user_id: joonasId,
        plant_id: tomatoId,
        planting_time: new Date("2025-01-01"),
        est_cropping: 60,
        is_deleted: false,
        photo_url: "/uploads/tomato.jpg",
        created_at: new Date(),
        updated_at: new Date()
    },
    {
        user_id: joonasId,
        plant_id: basilId,
        planting_time: new Date("2025-01-05"),
        est_cropping: 45,
        is_deleted: false,
        photo_url: "/uploads/basil.jpg",
        created_at: new Date(),
        updated_at: new Date()
    }
])
db.createCollection('weather_data', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['user_id'],
            properties: {
                user_id: {bsonType: 'objectId'},
                location: {bsonType: 'string'},
                temperature: {bsonType: 'decimal'},
                humidity: {bsonType: 'decimal'},
                recorded_at: {bsonType: 'date'}
            }
        }
    }
})

// Indexes
db.weather_data.createIndex({user_id: 1})
db.weather_data.createIndex({location: 1})
db.weather_data.createIndex({recorded_at: 1})
db.weather_data.insertMany([
    {
        user_id: ObjectId("605a1c2d14f5c41d245746dd"),
        location: "Tallinn",
        temperature: NumberDecimal("18.5"),
        humidity: NumberDecimal("65.2"),
        recorded_at: new Date("2024-08-01T08:00:00Z")
    },
    {
        user_id: ObjectId("605a1c2d14f5c41d245746dd"),
        location: "Tallinn",
        temperature: NumberDecimal("22.3"),
        humidity: NumberDecimal("58.7"),
        recorded_at: new Date("2024-08-01T14:00:00Z")
    },
    {
        user_id: ObjectId("605a1c2d14f5c41d245746de"),
        location: "Tartu",
        temperature: NumberDecimal("17.2"),
        humidity: NumberDecimal("68.9"),
        recorded_at: new Date("2024-08-01T08:00:00Z")
    },
    {
        user_id: ObjectId("605a1c2d14f5c41d245746de"),
        location: "Tartu",
        temperature: NumberDecimal("21.7"),
        humidity: NumberDecimal("61.3"),
        recorded_at: new Date("2024-08-01T14:00:00Z")
    },
    {
        user_id: ObjectId("605a1c2d14f5c41d245746e1"),
        location: "Pärnu",
        temperature: NumberDecimal("19.1"),
        humidity: NumberDecimal("63.8"),
        recorded_at: new Date("2024-08-01T08:00:00Z")
    }
])
db.createCollection('soil_types', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['soil_type'],
            properties: {
                soil_type: {bsonType: 'string'},
                ph_range: {bsonType: 'string'},
                description: {bsonType: 'string'},
                suitable_plants: {bsonType: 'string'},
                created_at: {bsonType: 'date'}
            }
        }
    }
})

// Index
db.soil_types.createIndex({soil_type: 1}, {unique: true})

db.soil_types.insertMany([
    {
        _id: ObjectId("605a1c2d14f5c41d245746f0"),
        soil_type: 'Savimullad',
        ph_range: '6.0-7.0',
        description: 'Toitainerohkad, kuid võivad olla raskesti läbitavad',
        suitable_plants: 'Tomat, basiil, paprika',
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746f1"),
        soil_type: 'Liivsavimullad',
        ph_range: '6.5-7.5',
        description: 'Hästi dreneeritud, kuivavad kiiremini',
        suitable_plants: 'Salatid, tomat',
        created_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746f2"),
        soil_type: 'Turvasmullad',
        ph_range: '4.5-6.0',
        description: 'Happelised, orgaanilisest ainest rikkad',
        suitable_plants: 'Basiil, salatid',
        created_at: new Date()
    }
])

db.growing_environments.insertMany([
    {
        _id: ObjectId("605a1c2d14f5c41d245746f3"),
        user_id: ObjectId("605a1c2d14f5c41d245746dd"),
        soil_id: ObjectId("605a1c2d14f5c41d245746f0"),
        name: 'Sisekasvandus 1',
        created_at: new Date(),
        updated_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746f4"),
        user_id: ObjectId("605a1c2d14f5c41d245746de"),
        soil_id: ObjectId("605a1c2d14f5c41d245746f1"),
        name: 'Kasvuhoone',
        created_at: new Date(),
        updated_at: new Date()
    },
    {
        _id: ObjectId("605a1c2d14f5c41d245746f5"),
        user_id: ObjectId("605a1c2d14f5c41d245746e1"),
        soil_id: ObjectId("605a1c2d14f5c41d245746f2"),
        name: 'Lõunapoolne aken',
        created_at: new Date(),
        updated_at: new Date()
    }
])
db.createCollection('growing_environments', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['user_id', 'soil_id', 'name'],
            properties: {
                user_id: {bsonType: 'objectId'},
                soil_id: {bsonType: 'objectId'},
                name: {bsonType: 'string'},
                created_at: {bsonType: 'date'},
                updated_at: {bsonType: 'date'}
            }
        }
    }
})

db.growing_environments.createIndex({user_id: 1})
db.createCollection('actuator_outputs', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['actuator_name', 'environment_id'],
            properties: {
                actuator_name: {bsonType: 'string'},
                state: {bsonType: 'bool'},
                timestamp: {bsonType: 'date'},
                environment_id: {bsonType: 'objectId'}
            }
        }
    }
})

db.actuator_outputs.createIndex({environment_id: 1})
db.actuator_outputs.createIndex({timestamp: 1})
db.createCollection('sensor_inputs', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['sensor_name', 'environment_id'],
            properties: {
                sensor_name: {bsonType: 'string'},
                sensor_type: {bsonType: 'string'},
                value: {bsonType: 'decimal'},
                unit: {bsonType: 'string'},
                timestamp: {bsonType: 'date'},
                environment_id: {bsonType: 'objectId'}
            }
        }
    }
})

db.sensor_inputs.createIndex({environment_id: 1})
db.sensor_inputs.createIndex({timestamp: 1})

db.sensor_inputs.insertMany([
    {
        sensor_name: 'Temp_Sensor_1',
        sensor_type: 'Temperature',
        value: NumberDecimal("23.5"),
        unit: '°C',
        environment_id: ObjectId("605a1c2d14f5c41d245746f3"),
        timestamp: new Date("2024-08-01T08:00:00Z")
    },
    {
        sensor_name: 'Humidity_Sensor_1',
        sensor_type: 'Humidity',
        value: NumberDecimal("65.2"),
        unit: '%',
        environment_id: ObjectId("605a1c2d14f5c41d245746f3"),
        timestamp: new Date("2024-08-01T08:00:00Z")
    },
    {
        sensor_name: 'pH_Sensor_1',
        sensor_type: 'pH',
        value: NumberDecimal("6.8"),
        unit: 'pH',
        environment_id: ObjectId("605a1c2d14f5c41d245746f3"),
        timestamp: new Date("2024-08-01T08:00:00Z")
    },
    {
        sensor_name: 'Temp_Sensor_2',
        sensor_type: 'Temperature',
        value: NumberDecimal("25.2"),
        unit: '°C',
        environment_id: ObjectId("605a1c2d14f5c41d245746f4"),
        timestamp: new Date("2024-08-01T08:00:00Z")
    },
    {
        sensor_name: 'Humidity_Sensor_2',
        sensor_type: 'Humidity',
        value: NumberDecimal("72.1"),
        unit: '%',
        environment_id: ObjectId("605a1c2d14f5c41d245746f4"),
        timestamp: new Date("2024-08-01T08:00:00Z")
    }
])

db.actuator_outputs.insertMany([
    {
        actuator_name: 'Water_Pump_1',
        state: true,
        environment_id: ObjectId("605a1c2d14f5c41d245746f3"),
        timestamp: new Date("2024-08-01T09:00:00Z")
    },
    {
        actuator_name: 'LED_Light_1',
        state: true,
        environment_id: ObjectId("605a1c2d14f5c41d245746f3"),
        timestamp: new Date("2024-08-01T06:00:00Z")
    },
    {
        actuator_name: 'Fan_1',
        state: false,
        environment_id: ObjectId("605a1c2d14f5c41d245746f3"),
        timestamp: new Date("2024-08-01T08:00:00Z")
    },
    {
        actuator_name: 'Water_Pump_2',
        state: true,
        environment_id: ObjectId("605a1c2d14f5c41d245746f4"),
        timestamp: new Date("2024-08-01T10:00:00Z")
    },
    {
        actuator_name: 'LED_Light_2',
        state: true,
        environment_id: ObjectId("605a1c2d14f5c41d245746f4"),
        timestamp: new Date("2024-08-01T07:00:00Z")
    }
])

// Example objects (if needed, otherwise remove them)
const exampleUsers = [
    {
        _id: ObjectId("605a1c2d14f5c41d245746dd"),
        username: "joonas",
        password: "$2b$10$H0/fwx3mnPLuNLve4k74CO...",
        email: "joonas@example.com",
        created_at: ISODate("2025-01-01T00:00:00Z"),
        updated_at: ISODate("2025-01-01T00:00:00Z")
    }
]

const examplePlants = [
    {
        _id: ObjectId("605a1c2d14f5c41d245746df"),
        plant_cultivar: "Tomato",
        plant_species: "Solanum lycopersicum",
        is_deleted: false,
        created_at: ISODate("2025-01-01T00:00:00Z")
    }
]

const exampleUserPlants = [
    {
        _id: ObjectId("someObjectId"),
        user_id: ObjectId("605a1c2d14f5c41d245746dd"),   // references users._id
        plant_id: ObjectId("605a1c2d14f5c41d245746df"),  // references all_plants._id
        planting_time: ISODate("2025-01-01T00:00:00Z"),
        est_cropping: 60,
        is_deleted: false,
        photo_url: "/uploads/tomato.jpg",
        created_at: ISODate("2025-01-01T00:00:00Z"),
        updated_at: ISODate("2025-01-02T00:00:00Z")
    }
]

use studentdbs