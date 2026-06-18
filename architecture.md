# Architecture CityFlow — Persistance Polyglotte

## Schéma global

```
┌─────────────────────────────────────────────────────────────┐
│                     Application CityFlow                     │
└──────────┬──────────┬──────────────┬───────────────┬────────┘
           │          │              │               │
           ▼          ▼              ▼               ▼
       MongoDB      Redis        Cassandra         Neo4j
    (données      (temps       (time-series     (réseau de
     métier)       réel)        & logs)          transport)
```

## Répartition des responsabilités

### MongoDB — Données métier riches
- Collections : `users`, `trips`, `vehicles`
- Justification : schémas flexibles, imbrication JSON naturelle, requêtes ad-hoc fréquentes
- Positionnement CAP : **CP** (cohérence prioritaire)

### Redis — Temps réel et performance
- Structures : Hash (disponibilités), String (sessions/rate limit), Sorted Set (leaderboard)
- Justification : latence sub-milliseconde, expiration TTL automatique, structures spécialisées
- Positionnement CAP : variable selon configuration

### Cassandra — Données massives et historique
- Tables : `station_passages`, `user_connections`
- Justification : volume massif d'écritures (1 mesure/min × 1000+ stations), pattern time-series, scalabilité horizontale
- Positionnement CAP : **AP** (disponibilité prioritaire)

### Neo4j — Relations et itinéraires
- Nœuds : `Station`, `Line`, `User`
- Relations : `CONNECTED_TO`, `BELONGS_TO`, `USES`
- Justification : modèle graphe naturel pour un réseau de transport, requêtes de plus court chemin
- Positionnement CAP : **CP**

## Pourquoi pas une seule base relationnelle ?

| Besoin | SQL seul | Architecture polyglotte |
|--------|----------|------------------------|
| Profils utilisateurs imbriqués | ALTER TABLE complexes | MongoDB : document flexible |
| Disponibilités stations en temps réel | Polling coûteux | Redis : lecture sub-ms |
| 1000 événements/min pendant 5 ans | Partitionnement difficile | Cassandra : time-series natif |
| Plus court chemin dans le réseau | N auto-jointures | Neo4j : Cypher en une requête |

## Trade-offs acceptés

- **Complexité opérationnelle** : 4 bases à administrer au lieu d'une
- **Cohérence inter-bases** : pas de transaction distribuée — les bases sont indépendantes
- **Compétences requises** : l'équipe doit maîtriser MQL, Redis CLI, CQL et Cypher
