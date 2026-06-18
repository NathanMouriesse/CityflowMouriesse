# Modélisation Redis — CityFlow

## Structures de données et naming

### 1. Disponibilités des stations (Hash)

**Pattern de clé :** `station:{station_id}:availability`

```bash
HSET station:S001:availability bikes 12 scooters 3 updated_at "2025-10-15T14:32:00Z"
HGETALL station:S001:availability
# → bikes=12, scooters=3, updated_at=2025-10-15T14:32:00Z
```

**Justification :** Hash pour regrouper plusieurs champs d'une même station en une seule clé.  
**TTL :** 5 minutes — données temps réel, rafraîchies régulièrement.

---

### 2. Sessions utilisateurs (String avec TTL)

**Pattern de clé :** `session:{session_token}`

```bash
SET session:abc123xyz '{"userId":"u42","email":"alice@example.com","role":"user"}' EX 1800
GET session:abc123xyz
TTL session:abc123xyz
```

**Justification :** TTL automatique de 1800s (30 min) — expire à chaque inactivité.  
**US-R2** : session active pendant 30 min après la dernière action.

---

### 3. Leaderboard des conducteurs (Sorted Set)

**Pattern de clé :** `leaderboard:drivers:{year}:{month}`

```bash
ZADD leaderboard:drivers:2025:10 150 "user:42"
ZADD leaderboard:drivers:2025:10 230 "user:17"
ZADD leaderboard:drivers:2025:10 89  "user:55"

# Top 10 décroissant
ZREVRANGE leaderboard:drivers:2025:10 0 9 WITHSCORES
```

**Justification :** Sorted Set ordonné nativement par score — parfait pour les classements.  
**US-R3** : top 10 utilisateurs les plus actifs du mois.

---

### 4. Rate limiting (String avec incrémentation)

**Pattern de clé :** `ratelimit:{user_id}:{minute}`

```bash
INCR ratelimit:u42:202510151432
EXPIRE ratelimit:u42:202510151432 60
GET ratelimit:u42:202510151432
# → "47" (47 requêtes cette minute)
```

**Justification :** Incrémentation atomique + TTL 60s = compteur glissant par minute.  
**US-R4** : limiter à 100 requêtes par minute par utilisateur.

---

## Récapitulatif des structures

| Clé                              | Structure   | TTL      | Usage                    |
|----------------------------------|-------------|----------|--------------------------|
| `station:{id}:availability`      | Hash        | 5 min    | Vélos/scooters dispo     |
| `session:{token}`                | String      | 30 min   | Session utilisateur      |
| `leaderboard:drivers:{Y}:{M}`    | Sorted Set  | 32 jours | Classement mensuel       |
| `ratelimit:{user_id}:{minute}`   | String      | 60 s     | Rate limiting API        |
