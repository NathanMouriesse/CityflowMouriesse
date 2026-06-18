# Modélisation MongoDB — CityFlow

## Collections

### 1. `users`

Profils des utilisateurs de la plateforme.

```json
{
  "_id": ObjectId("..."),
  "email": "alice.dupont@example.com",
  "firstName": "Alice",
  "lastName": "Dupont",
  "age": 28,
  "isVerified": true,
  "createdAt": ISODate("2025-09-15T10:30:00Z"),
  "addresses": [
    {
      "type": "home",
      "street": "12 rue de la République",
      "city": "Lyon",
      "zipCode": "69001"
    }
  ],
  "preferences": {
    "language": "fr",
    "notifications": {
      "email": true,
      "sms": false
    }
  },
  "tags": ["premium", "early-adopter"]
}
```

**Choix embedding/référencement :**
- `addresses` → **Embedding** : peu d'adresses par utilisateur (1-3), toujours lues avec le profil, pas d'existence propre
- `preferences` → **Embedding** : relation 1-1, lecture systématique avec le profil
- `trips` → **Référencement** : un utilisateur peut avoir des milliers de trajets, lus séparément

---

### 2. `trips`

Trajets effectués sur la plateforme.

```json
{
  "_id": ObjectId("..."),
  "userId": ObjectId("..."),
  "vehicleId": ObjectId("..."),
  "startedAt": ISODate("2025-10-15T08:30:00Z"),
  "endedAt": ISODate("2025-10-15T09:05:00Z"),
  "distance": 12.5,
  "steps": [
    { "station": "Bellecour", "time": ISODate("2025-10-15T08:30:00Z") },
    { "station": "Part-Dieu", "time": ISODate("2025-10-15T09:05:00Z") }
  ],
  "comment": "Trajet rapide, vélo en bon état",
  "rating": 4
}
```

**Choix embedding/référencement :**
- `steps` → **Embedding** : propres au trajet, toujours lus ensemble
- `userId` / `vehicleId` → **Référencement** : entités indépendantes avec existence propre

---

### 3. `vehicles`

Véhicules disponibles (vélos, scooters, voitures).

```json
{
  "_id": ObjectId("..."),
  "type": "bike",
  "brand": "Peugeot",
  "status": "available",
  "location": {
    "arrondissement": "Lyon 1",
    "station": "Bellecour",
    "coordinates": { "lat": 45.7578, "lng": 4.8320 }
  },
  "lastMaintenanceAt": ISODate("2025-09-01T00:00:00Z")
}
```

---

## Index recommandés

| Collection | Champ(s)           | Type      | Justification                        |
|------------|--------------------|-----------|--------------------------------------|
| users      | email              | Unique    | Login, unicité garantie              |
| users      | addresses.city     | Simple    | Filtres fréquents par ville          |
| trips      | userId             | Simple    | Récupérer les trajets d'un user      |
| trips      | startedAt          | Simple    | Tri chronologique                    |
| trips      | comment            | Text      | Recherche full-text (US-M4)          |
| vehicles   | type + status      | Compound  | Filtrer véhicules dispo par type     |
| vehicles   | location.arrondissement | Simple | Filtres géographiques            |
