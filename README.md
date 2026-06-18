# CityFlow — Plateforme de mobilité urbaine

Projet fil rouge NoSQL — B3 INFO Tronc Commun — Ynov Campus Lyon 2025/2026

## Équipe
- Nathan Mouriesse

## Présentation

CityFlow est une startup fictive qui développe une plateforme unifiée de mobilité urbaine pour la métropole de Lyon : covoiturage, transports en commun et vélos en libre-service depuis une seule application.

L'architecture repose sur une **persistance polyglotte** : chaque base de données est choisie pour son adéquation au type de données qu'elle stocke.

| Base       | Rôle dans CityFlow                                          |
|------------|-------------------------------------------------------------|
| MongoDB    | Profils utilisateurs, trajets effectués, véhicules          |
| Redis      | Cache stations, sessions, leaderboard, rate limiting        |
| Cassandra  | Historique horodaté des passages, logs de connexions        |
| Neo4j      | Réseau de transport, calcul d'itinéraires                   |

## Lancement

```bash
docker compose up -d
```

Puis vérifier que les 4 conteneurs sont `Up` :

```bash
docker compose ps
```

## Accès aux interfaces

| Service        | URL                     | Identifiants               |
|----------------|-------------------------|----------------------------|
| mongo-express  | http://localhost:8081   | student / nosql2025        |
| RedisInsight   | http://localhost:8001   | —                          |
| Neo4j Browser  | http://localhost:7474   | neo4j / cityflow2025       |
| Cassandra cqlsh| `docker exec -it cityflow-cassandra cqlsh` | — |

## Structure du dépôt

```
cityflow/
├── README.md
├── docker-compose.yml
├── .env.example
├── architecture.md
├── cassandra/
├── mongodb/
├── neo4j/
├── queries/
├── modelisation-cassandra.md
├── modelisation-mongodb.md
├── modelisation-neo4j.md
└── modelisation-redis.md
```

## Documentation

- [Architecture globale](architecture.md)
- [Modélisation MongoDB](modelisation-mongodb.md)
- [Modélisation Redis](modelisation-redis.md)
- [Modélisation Cassandra](modelisation-cassandra.md)
- [Modélisation Neo4j](modelisation-neo4j.md)
