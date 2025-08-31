// MongoDB mõtestatud päringud

// 1. Kasutajate taimede arv ja keskmine kasvatusaeg
db.user_plants.aggregate([
    {
        $match: { is_deleted: false }
    },
    {
        $lookup: {
            from: "users",
            localField: "user_id",
            foreignField: "_id",
            as: "user"
        }
    },
    {
        $unwind: "$user"
    },
    {
        $group: {
            _id: "$user_id",
            username: { $first: "$user.username" },
            taimede_arv: { $sum: 1 },
            keskmine_kasvatusaeg: { $avg: "$est_cropping" }
        }
    },
    {
        $match: { taimede_arv: { $gt: 0 } }
    },
    {
        $sort: { taimede_arv: -1 }
    },
    {
        $limit: 5
    }
])

// 2. Populaarseimad taimesordid
db.user_plants.aggregate([
    {
        $match: { is_deleted: false }
    },
    {
        $lookup: {
            from: "all_plants",
            localField: "plant_id",
            foreignField: "_id",
            as: "plant"
        }
    },
    {
        $unwind: "$plant"
    },
    {
        $group: {
            _id: "$plant_id",
            liik: { $first: "$plant.plant_species" },
            sort: { $first: "$plant.plant_cultivar" },
            kasvatajate_arv: { $sum: 1 },
            keskmine_kasvatusaeg: { $avg: "$est_cropping" }
        }
    },
    {
        $sort: { kasvatajate_arv: -1, keskmine_kasvatusaeg: 1 }
    },
    {
        $limit: 10
    }
])

// 3. Ilmaandmete statistika linnade kaupa
db.weather_data.aggregate([
    {
        $group: {
            _id: "$location",
            mootmiste_arv: { $sum: 1 },
            keskmine_temp: { $avg: { $toDouble: "$temperature" } },
            min_temp: { $min: { $toDouble: "$temperature" } },
            max_temp: { $max: { $toDouble: "$temperature" } },
            keskmine_niiskus: { $avg: { $toDouble: "$humidity" } }
        }
    },
    {
        $match: { mootmiste_arv: { $gte: 2 } }
    },
    {
        $sort: { keskmine_temp: -1 }
    },
    {
        $project: {
            linn: "$_id",
            mootmiste_arv: 1,
            keskmine_temp: { $round: ["$keskmine_temp", 2] },
            min_temp: { $round: ["$min_temp", 2] },
            max_temp: { $round: ["$max_temp", 2] },
            keskmine_niiskus: { $round: ["$keskmine_niiskus", 2] },
            _id: 0
        }
    }
])

// 4. Sensorite andmete kokkuvõte keskkondade kaupa
db.sensor_inputs.aggregate([
    {
        $lookup: {
            from: "growing_environments",
            localField: "environment_id",
            foreignField: "_id",
            as: "environment"
        }
    },
    {
        $unwind: "$environment"
    },
    {
        $lookup: {
            from: "users",
            localField: "environment.user_id",
            foreignField: "_id",
            as: "user"
        }
    },
    {
        $unwind: "$user"
    },
    {
        $group: {
            _id: {
                environment_id: "$environment_id",
                sensor_type: "$sensor_type"
            },
            keskkond: { $first: "$environment.name" },
            omanik: { $first: "$user.username" },
            sensori_tyyp: { $first: "$sensor_type" },
            mootmiste_arv: { $sum: 1 },
            keskmine_vaartus: { $avg: { $toDouble: "$value" } },
            yhik: { $first: "$unit" }
        }
    },
    {
        $match: { mootmiste_arv: { $gt: 1 } }
    },
    {
        $sort: { keskkond: 1, sensori_tyyp: 1 }
    },
    {
        $project: {
            keskkond: 1,
            omanik: 1,
            sensori_tyyp: 1,
            mootmiste_arv: 1,
            keskmine_vaartus: { $round: ["$keskmine_vaartus", 2] },
            yhik: 1,
            _id: 0
        }
    }
])

// 5. Aktuaatorite kasutusstatistika
db.actuator_outputs.aggregate([
    {
        $group: {
            _id: "$actuator_name",
            kokku_aktiveerimisi: { $sum: 1 },
            sisselulitamisi: {
                $sum: { $cond: [{ $eq: ["$state", true] }, 1, 0] }
            },
            valjalulitamisi: {
                $sum: { $cond: [{ $eq: ["$state", false] }, 1, 0] }
            }
        }
    },
    {
        $project: {
            aktuaator: "$_id",
            kokku_aktiveerimisi: 1,
            sisselulitamisi: 1,
            valjalulitamisi: 1,
            sisselulitamiste_protsent: {
                $round: [
                    { $multiply: [
                        { $divide: ["$sisselulitamisi", "$kokku_aktiveerimisi"] },
                        100
                    ]}, 2
                ]
            },
            _id: 0
        }
    },
    {
        $sort: { kokku_aktiveerimisi: -1 }
    }
])

// 6. Mullatiipide sobivus ja kasutus
db.soil_types.aggregate([
    {
        $lookup: {
            from: "growing_environments",
            localField: "_id",
            foreignField: "soil_id",
            as: "environments"
        }
    },
    {
        $lookup: {
            from: "users",
            localField: "environments.user_id",
            foreignField: "_id",
            as: "users"
        }
    },
    {
        $project: {
            mullatyyp: "$soil_type",
            pH_vahemik: "$ph_range",
            kasutavate_keskkondade_arv: { $size: "$environments" },
            kasutajad: {
                $reduce: {
                    input: "$users.username",
                    initialValue: "",
                    in: {
                        $cond: [
                            { $eq: ["$$value", ""] },
                            "$$this",
                            { $concat: ["$$value", ", ", "$$this"] }
                        ]
                    }
                }
            },
            _id: 0
        }
    },
    {
        $sort: { kasutavate_keskkondade_arv: -1 }
    }
])

// 7. Taimede istutamise hooajalisus
db.user_plants.aggregate([
    {
        $match: { is_deleted: false }
    },
    {
        $project: {
            kuu: { $month: "$planting_time" },
            est_cropping: 1
        }
    },
    {
        $group: {
            _id: "$kuu",
            istutatud_taimede_arv: { $sum: 1 },
            keskmine_kasvatusaeg: { $avg: "$est_cropping" }
        }
    },
    {
        $project: {
            kuu: "$_id",
            kuu_nimi: {
                $switch: {
                    branches: [
                        { case: { $eq: ["$_id", 1] }, then: "Jaanuar" },
                        { case: { $eq: ["$_id", 2] }, then: "Veebruar" },
                        { case: { $eq: ["$_id", 3] }, then: "Märts" },
                        { case: { $eq: ["$_id", 4] }, then: "Aprill" },
                        { case: { $eq: ["$_id", 5] }, then: "Mai" },
                        { case: { $eq: ["$_id", 6] }, then: "Juuni" },
                        { case: { $eq: ["$_id", 7] }, then: "Juuli" },
                        { case: { $eq: ["$_id", 8] }, then: "August" },
                        { case: { $eq: ["$_id", 9] }, then: "September" },
                        { case: { $eq: ["$_id", 10] }, then: "Oktoober" },
                        { case: { $eq: ["$_id", 11] }, then: "November" },
                        { case: { $eq: ["$_id", 12] }, then: "Detsember" }
                    ],
                    default: "Tundmatu"
                }
            },
            istutatud_taimede_arv: 1,
            keskmine_kasvatusaeg: { $round: ["$keskmine_kasvatusaeg", 2] },
            _id: 0
        }
    },
    {
        $sort: { kuu: 1 }
    }
])

// 8. MongoDB spetsiifiline - Geospatial päring (kui oleks koordinaadid)
// Näide: leia kõik ilmaandmed 10km raadiuses Tallinnast
/*
db.weather_data.find({
    location_coords: {
        $near: {
            $geometry: { type: "Point", coordinates: [24.7536, 59.4370] },
            $maxDistance: 10000
        }
    }
})
*/

// 9. Text search näide (kui oleks text index)
/*
db.all_plants.createIndex({ plant_cultivar: "text", plant_species: "text" })
db.all_plants.find({ $text: { $search: "tomato basil" } })
*/
