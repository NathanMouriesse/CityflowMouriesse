// Script de seed Neo4j — CityFlow
// Coller dans le Neo4j Browser : http://localhost:7474

// ─── Nettoyage ────────────────────────────────────────────
MATCH (n) DETACH DELETE n;

// ─── Lignes de métro ──────────────────────────────────────
CREATE (la:Line {id: "LA", name: "Ligne A", type: "metro", color: "#E2001A"})
CREATE (lb:Line {id: "LB", name: "Ligne B", type: "metro", color: "#0055A5"})
CREATE (ld:Line {id: "LD", name: "Ligne D", type: "metro", color: "#00A550"});

// ─── Stations ─────────────────────────────────────────────
CREATE (bellecour:Station {id: "S001", name: "Bellecour", arrondissement: "Lyon 2", lat: 45.7578, lng: 4.8320, capacity: 30})
CREATE (guillotiere:Station {id: "S002", name: "Guillotière", arrondissement: "Lyon 7", lat: 45.7489, lng: 4.8382, capacity: 20})
CREATE (partdieu:Station {id: "S003", name: "Part-Dieu", arrondissement: "Lyon 3", lat: 45.7607, lng: 4.8598, capacity: 50})
CREATE (hoteldeville:Station {id: "S004", name: "Hôtel de Ville", arrondissement: "Lyon 1", lat: 45.7669, lng: 4.8341, capacity: 25})
CREATE (saxegambetta:Station {id: "S005", name: "Saxe-Gambetta", arrondissement: "Lyon 6", lat: 45.7520, lng: 4.8470, capacity: 20})
CREATE (vieuxlyon:Station {id: "S006", name: "Vieux-Lyon", arrondissement: "Lyon 5", lat: 45.7622, lng: 4.8222, capacity: 15});

// ─── Connexions (Ligne A) ─────────────────────────────────
MATCH (b:Station {name:"Bellecour"}), (g:Station {name:"Guillotière"})
CREATE (b)-[:CONNECTED_TO {duration_min: 2, distance_m: 600, transport_type: "metro", line: "A"}]->(g);

MATCH (b:Station {name:"Bellecour"}), (h:Station {name:"Hôtel de Ville"})
CREATE (b)-[:CONNECTED_TO {duration_min: 2, distance_m: 700, transport_type: "metro", line: "A"}]->(h);

MATCH (h:Station {name:"Hôtel de Ville"}), (p:Station {name:"Part-Dieu"})
CREATE (h)-[:CONNECTED_TO {duration_min: 5, distance_m: 1500, transport_type: "metro", line: "A"}]->(p);

MATCH (g:Station {name:"Guillotière"}), (s:Station {name:"Saxe-Gambetta"})
CREATE (g)-[:CONNECTED_TO {duration_min: 3, distance_m: 900, transport_type: "metro", line: "B"}]->(s);

MATCH (b:Station {name:"Bellecour"}), (v:Station {name:"Vieux-Lyon"})
CREATE (b)-[:CONNECTED_TO {duration_min: 3, distance_m: 500, transport_type: "metro", line: "D"}]->(v);

// ─── Appartenance aux lignes ──────────────────────────────
MATCH (s:Station {name:"Bellecour"}), (l:Line {id:"LA"}) CREATE (s)-[:BELONGS_TO]->(l);
MATCH (s:Station {name:"Bellecour"}), (l:Line {id:"LD"}) CREATE (s)-[:BELONGS_TO]->(l);
MATCH (s:Station {name:"Hôtel de Ville"}), (l:Line {id:"LA"}) CREATE (s)-[:BELONGS_TO]->(l);
MATCH (s:Station {name:"Part-Dieu"}), (l:Line {id:"LA"}) CREATE (s)-[:BELONGS_TO]->(l);
MATCH (s:Station {name:"Guillotière"}), (l:Line {id:"LB"}) CREATE (s)-[:BELONGS_TO]->(l);

RETURN "Seed Neo4j terminé !" AS message;
