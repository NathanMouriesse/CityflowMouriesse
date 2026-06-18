# Requêtes Cassandra — User Stories CityFlow

## US-C1 : Historique des passages d'une station sur une période

```cql
SELECT ts, bikes_dispo, user_id, event_type
FROM station_passages
WHERE station_id = 'S001'
  AND day >= '2025-10-01'
  AND day <= '2025-10-15'
  AND ts >= '2025-10-01 00:00:00'
  AND ts <= '2025-10-15 23:59:59'
ORDER BY ts DESC;
```

*Concept démontré : requête sur partition key + clustering key, plage de dates.*

---

## US-C2 : Insertion massive d'événements de passage

```cql
INSERT INTO station_passages (station_id, day, ts, bikes_dispo, user_id, vehicle_id, event_type)
VALUES ('S001', '2025-10-15', '2025-10-15 14:32:00', 11, 'u42', 'v07', 'borrow');

INSERT INTO station_passages (station_id, day, ts, bikes_dispo, user_id, vehicle_id, event_type)
VALUES ('S001', '2025-10-15', '2025-10-15 14:47:00', 12, 'u88', 'v07', 'return');
```

*Concept démontré : insertions rapides sans coordination, Cassandra optimisé pour l'écriture séquentielle.*

---

## US-C3 : Connexions d'un utilisateur sur les 30 derniers jours

```cql
SELECT ts, ip_address, device, action
FROM user_connections
WHERE user_id = 'u42'
  AND month IN ('2025-09', '2025-10')
ORDER BY ts DESC;
```

*Concept démontré : partition mensuelle évitant les partitions trop larges, requête d'audit.*

---

## US-C4 : Évolution journalière des passages (pic d'affluence)

```cql
-- Récupérer les données brutes par jour (agrégation côté applicatif)
SELECT day, COUNT(*) as nb_passages
FROM station_passages
WHERE station_id = 'S001'
  AND day >= '2025-10-01'
  AND day <= '2025-10-31'
GROUP BY day;
```

*Concept démontré : GROUP BY sur la partition key, Cassandra 4.x supporte les agrégations simples.*
