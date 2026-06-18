# Requêtes Redis — User Stories CityFlow

## US-R1 : Disponibilité temps réel d'une station

```bash
# Lire les disponibilités de la station S001
HGETALL station:S001:availability
# → bikes=12, scooters=3, updated_at=2025-10-15T14:32:00Z

# Mettre à jour après un emprunt de vélo
HINCRBY station:S001:availability bikes -1
```

*Concept démontré : Hash Redis, lecture atomique de plusieurs champs, incrémentation.*

---

## US-R2 : Session utilisateur avec expiration 30 minutes

```bash
# Créer ou rafraîchir la session
SET session:abc123xyz '{"userId":"u42","email":"alice@example.com"}' EX 1800

# Vérifier la session (à chaque requête API)
GET session:abc123xyz

# Rafraîchir le TTL après une action (reset à 30 min)
EXPIRE session:abc123xyz 1800

# Vérifier le temps restant
TTL session:abc123xyz
```

*Concept démontré : String avec TTL automatique, EXPIRE pour reset la durée.*

---

## US-R3 : Classement des 10 utilisateurs les plus actifs

```bash
# Ajouter/incrémenter le score d'un utilisateur
ZINCRBY leaderboard:drivers:2025:10 1 "user:42"

# Récupérer le top 10 (score décroissant)
ZREVRANGE leaderboard:drivers:2025:10 0 9 WITHSCORES

# Rang d'un utilisateur spécifique
ZREVRANK leaderboard:drivers:2025:10 "user:42"
```

*Concept démontré : Sorted Set, ZINCRBY, ZREVRANGE pour classement.*

---

## US-R4 : Rate limiting — 100 requêtes/minute par utilisateur

```bash
# À chaque requête API de l'utilisateur u42
INCR ratelimit:u42:202510151432
EXPIRE ratelimit:u42:202510151432 60

# Vérifier si la limite est atteinte (côté applicatif)
GET ratelimit:u42:202510151432
# Si valeur > 100 → renvoyer HTTP 429 Too Many Requests
```

*Concept démontré : compteur atomique INCR + TTL glissant par minute.*
