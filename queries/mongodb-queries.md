# Requêtes MongoDB — User Stories CityFlow

## US-M1 : Profil utilisateur + 10 derniers trajets

**Requête 1 — Récupérer le profil**
```javascript
db.users.findOne({ _id: ObjectId("USER_ID") })
```

**Requête 2 — 10 derniers trajets**
```javascript
db.trips.find(
  { userId: ObjectId("USER_ID") },
  { startedAt: 1, endedAt: 1, distance: 1, comment: 1, rating: 1 }
).sort({ startedAt: -1 }).limit(10)
```

*Concept démontré : requête find avec projection, tri et limite.*

---

## US-M2 : Véhicules d'un type donné dans un arrondissement

```javascript
db.vehicles.find({
  type: "bike",
  status: "available",
  "location.arrondissement": "Lyon 1"
})
```

*Concept démontré : notation pointée pour accéder aux champs imbriqués, filtre composé.*

---

## US-M3 : Statistiques agrégées

**Nombre de trajets par jour**
```javascript
db.trips.aggregate([
  {
    $group: {
      _id: { $dateToString: { format: "%Y-%m-%d", date: "$startedAt" } },
      count: { $sum: 1 },
      avgDistance: { $avg: "$distance" }
    }
  },
  { $sort: { "_id": -1 } }
])
```

**Top 5 des conducteurs (par nombre de trajets)**
```javascript
db.trips.aggregate([
  { $group: { _id: "$userId", totalTrips: { $sum: 1 }, totalDistance: { $sum: "$distance" } } },
  { $sort: { totalTrips: -1 } },
  { $limit: 5 },
  {
    $lookup: {
      from: "users",
      localField: "_id",
      foreignField: "_id",
      as: "userInfo"
    }
  },
  { $project: { totalTrips: 1, totalDistance: 1, "userInfo.firstName": 1, "userInfo.lastName": 1 } }
])
```

*Concept démontré : pipeline d'agrégation, $group, $sort, $limit, $lookup.*

---

## US-M4 : Recherche full-text sur les commentaires

**Étape 1 — Créer l'index text**
```javascript
db.trips.createIndex({ comment: "text" })
```

**Étape 2 — Requête full-text**
```javascript
db.trips.find(
  { $text: { $search: "vélo rapide" } },
  { score: { $meta: "textScore" }, comment: 1, userId: 1 }
).sort({ score: { $meta: "textScore" } })
```

*Concept démontré : index text MongoDB, opérateur $text avec $search, tri par pertinence.*
