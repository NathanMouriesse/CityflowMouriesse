# Modélisation Cassandra — CityFlow

## Keyspace

```cql
CREATE KEYSPACE cityflow
WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 1
};

USE cityflow;
```

## Tables

### 1. `station_passages`

Historique horodaté des passages aux stations.

```cql
CREATE TABLE station_passages (
  station_id  text,
  day         date,
  ts          timestamp,
  bikes_dispo int,
  user_id     text,
  vehicle_id  text,
  event_type  text,
  PRIMARY KEY ((station_id, day), ts)
) WITH CLUSTERING ORDER BY (ts DESC);
```

**Partition key :** `(station_id, day)` — regroupe les données d'une station par jour sur un même nœud.  
**Clustering key :** `ts DESC` — les passages les plus récents en premier.

**Justification du choix Cassandra :**
- Volume : 1 mesure/min × 1000 stations = 1 440 000 insertions/jour
- Pattern time-series : toujours interrogé par station + plage de dates
- Scalabilité horizontale : ajout de nœuds transparent

---

### 2. `user_connections`

Logs de connexions pour audit utilisateur.

```cql
CREATE TABLE user_connections (
  user_id    text,
  month      text,
  ts         timestamp,
  ip_address text,
  device     text,
  action     text,
  PRIMARY KEY ((user_id, month), ts)
) WITH CLUSTERING ORDER BY (ts DESC);
```

**Partition key :** `(user_id, month)` — partitionnement mensuel pour éviter les partitions trop larges.  
**Clustering key :** `ts DESC` — connexions les plus récentes en premier.

---

## Règle de modélisation Cassandra : Query-First Design

Contrairement à SQL où l'on normalise puis requête, Cassandra impose de **concevoir les tables selon les requêtes**.

| User Story | Requête cible | Table utilisée |
|------------|---------------|----------------|
| US-C1 | Passages d'une station sur une période | `station_passages` |
| US-C2 | Insertions massives d'événements | `station_passages` |
| US-C3 | Connexions d'un user sur 30 jours | `user_connections` |
| US-C4 | Évolution journalière des passages | `station_passages` (agrégation applicative) |

## Anti-patterns à éviter

- ❌ `SELECT * FROM station_passages` sans partition key → full scan
- ❌ `WHERE ts > ...` sans fournir `station_id` et `day`
- ❌ Modifier le schéma pour faire des requêtes ad-hoc → créer une nouvelle table
