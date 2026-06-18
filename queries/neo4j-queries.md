# Requêtes Neo4j — User Stories CityFlow

## US-N1 : Plus court chemin entre deux stations

```cypher
MATCH (start:Station {name: "Bellecour"}),
      (end:Station {name: "Part-Dieu"})
MATCH path = shortestPath((start)-[:CONNECTED_TO*]-(end))
RETURN [node IN nodes(path) | node.name] AS stations,
       length(path) AS nb_correspondances,
       reduce(total = 0, r IN relationships(path) | total + r.duration_min) AS duree_totale_min
```

*Concept démontré : shortestPath, reduce sur les propriétés des relations.*

---

## US-N2 : Stations accessibles en moins de 15 minutes

```cypher
MATCH (start:Station {name: "Bellecour"})
MATCH path = (start)-[:CONNECTED_TO*1..5]-(s:Station)
WHERE s <> start
  AND reduce(total = 0, r IN relationships(path) | total + r.duration_min) <= 15
RETURN DISTINCT s.name, s.arrondissement,
       reduce(total = 0, r IN relationships(path) | total + r.duration_min) AS duree_min
ORDER BY duree_min
```

*Concept démontré : traversée multi-niveaux avec filtre sur propriété de relation, reduce.*

---

## US-N3 : Stations hubs (les plus connectées)

```cypher
MATCH (s:Station)-[:CONNECTED_TO]-()
RETURN s.name, s.arrondissement, count(*) AS nb_connexions
ORDER BY nb_connexions DESC
LIMIT 5
```

*Concept démontré : agrégation sur les relations, identification des nœuds centraux.*

---

## US-N4 : Itinéraire sans correspondance entre deux stations

```cypher
MATCH (start:Station {name: "Bellecour"}),
      (end:Station {name: "Vieux-Lyon"})
MATCH path = (start)-[:CONNECTED_TO]-(end)
RETURN path,
       CASE WHEN path IS NOT NULL THEN "Connexion directe disponible"
            ELSE "Pas de connexion directe" END AS result
```

*Alternative : vérifier l'existence d'une relation directe*
```cypher
RETURN EXISTS {
  MATCH (start:Station {name: "Bellecour"})-[:CONNECTED_TO]-(end:Station {name: "Vieux-Lyon"})
} AS connexion_directe
```

*Concept démontré : MATCH sur relation directe, EXISTS pour vérification booléenne.*
