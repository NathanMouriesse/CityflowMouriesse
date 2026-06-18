# Modélisation Neo4j — CityFlow

## Nœuds et propriétés

### `Station`
```cypher
CREATE (s:Station {
  id: "S001",
  name: "Bellecour",
  arrondissement: "Lyon 2",
  lat: 45.7578,
  lng: 4.8320,
  capacity: 30
})
```

### `Line`
```cypher
CREATE (l:Line {
  id: "L001",
  name: "Ligne A",
  type: "metro",
  color: "#E2001A"
})
```

### `User`
```cypher
CREATE (u:User {
  id: "u42",
  firstName: "Alice",
  lastName: "Dupont"
})
```

---

## Relations et propriétés

### `CONNECTED_TO` (Station → Station)
```cypher
CREATE (s1:Station {name:"Bellecour"})-[:CONNECTED_TO {
  duration_min: 3,
  distance_m: 800,
  transport_type: "metro"
}]->(s2:Station {name:"Guillotière"})
```

### `BELONGS_TO` (Station → Line)
```cypher
CREATE (s:Station {name:"Bellecour"})-[:BELONGS_TO]->(l:Line {name:"Ligne A"})
```

### `USES` (User → Station)
```cypher
CREATE (u:User {id:"u42"})-[:USES {times: 47}]->(s:Station {name:"Bellecour"})
```

---

## Requêtes types

### Plus court chemin entre deux stations
```cypher
MATCH (start:Station {name: "Bellecour"}),
      (end:Station {name: "Part-Dieu"})
MATCH path = shortestPath((start)-[:CONNECTED_TO*]-(end))
RETURN path, length(path) AS nb_stations
```

### Stations accessibles en moins de 15 minutes
```cypher
MATCH (start:Station {name: "Bellecour"})-[r:CONNECTED_TO*1..5]-(s:Station)
WHERE reduce(total = 0, rel IN relationships(path) | total + rel.duration_min) <= 15
RETURN DISTINCT s.name, s.arrondissement
```

### Stations hubs (les plus connectées)
```cypher
MATCH (s:Station)-[:CONNECTED_TO]-()
RETURN s.name, s.arrondissement, count(*) AS connections
ORDER BY connections DESC
LIMIT 5
```

---

## Justification du choix Neo4j

- **Modèle naturel** : un réseau de transport est structurellement un graphe
- **Performance** : les traversées de graphes (shortestPath) sont en O(log n) vs N auto-jointures en SQL
- **Expressivité** : Cypher exprime en 3 lignes ce qui nécessiterait 10 lignes de SQL complexe
