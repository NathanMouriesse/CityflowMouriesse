CityFlow

VOTRE TOUR — Requêtes à produire
Pour chacune des demandes suivantes, écrivez la requête MongoDB correspondante dans
mongo-express, et notez-la dans votre fichier mes_requetes.md. Aucune requête ne vous est
donnée toute faite.
 
Niveau 1 — Filtres simples
1. Utilisateurs entre 25 et 35 ans
json{ "age": { "$gte": 25, "$lte": 35 } }
J'utilise $gte et $lte pour faire un "entre 25 et 35".
2. Email contenant example.com
json{ "email": { "$regex": "example\\.com" } }
$regex c'est pour chercher un mot dans une chaîne, comme un Ctrl+F.
3. Utilisateurs avec exactement 2 adresses
json{ "addresses": { "$size": 2 } }
$size pour vérifier qu'un tableau a exactement X éléments.
4. Utilisateurs sans le champ preferences
json{ "preferences": { "$exists": false } }
$exists: false pour trouver les documents où le champ n'existe pas du tout.

Niveau 2 — Combinaisons
5. Habitant Lyon OU Villeurbanne, et plus de 25 ans
json{ "addresses.city": { "$in": "Lyon", "Villeurbanne" }, "age": { "$gt": 25 } }
$in c'est comme un "ou" sur une liste de valeurs.
6. Au moins une adresse de type home à Lyon
json{ "addresses": { "$elemMatch": { "type": "home", "city": "Lyon" } } }
$elemMatch parce qu'on veut que le même élément du tableau vérifie les deux conditions en même temps.
7. Tags premium ET eco-friendly ensemble
json{ "tags": { "$all": "premium", "eco-friendly" } }
$all pour vérifier que les deux tags sont présents ensemble.

Niveau 3 — Tri et pagination
8. Les 3 utilisateurs les plus âgés

Query : {}, Projection : { "firstName": 1, "age": 1, "email": 1, "_id": 0 }, Sort : { "age": -1 }, Limit : 3

Sort -1 pour trier du plus grand au plus petit, Limit 3 pour garder que les 3 premiers.
9. Triés par ville puis par âge décroissant

Query : {}, Sort : { "addresses.city": 1, "age": -1 }

On trie sur deux champs à la fois, d'abord la ville puis l'âge.
10. Pagination — page 2 avec 2 utilisateurs par page

Query : {}, Sort : { "createdAt": 1 }, Skip : 2, Limit : 2

Skip 2 pour sauter la première page, Limit 2 pour la taille de la page.

Niveau 4 — Bonus
11. Vérifiés, moins de 30 ans, pas à Lyon
json{ "isVerified": true, "age": { "$lt": 30 }, "addresses.city": { "$ne": "Lyon" } }
On combine trois filtres avec un AND implicite, $ne pour exclure Lyon.
12. Tag commençant par la lettre 'p'
json{ "tags": { "$regex": "^p" } }

___________________________________________________________________________________________________________________________

VOTRE TOUR — Pipelines d'agrégation
Sur votre collection users, écrivez et testez les pipelines suivants. Notez chaque pipeline dans
votre fichier mes_requetes.md avec le résultat obtenu. Pour cette fois vous utilisez le terminal
mongosh.

Niveau 1 — Agrégations simples
1. Nombre total d'utilisateurs
json{ "$count": "total" }
$count pour compter tous les documents de la collection.
2. Âge moyen, le plus jeune et le plus âgé
json{ "$group": { "_id": null, "ageMoyen": { "$avg": "$age" }, "plusJeune": { "$min": "$age" }, "plusAge": { "$max": "$age" } }}
$group avec _id: null pour regrouper tout le monde, puis $avg, $min, $max pour les calculs.
3. Combien sont vérifiés ou non
json{ "$group": { "_id": "$isVerified", "count": { "$sum": 1 } }}
$group sur isVerified — ça crée deux groupes : true et false, avec le compte de chacun.

Niveau 2 — Regroupements
4. Nombre d'utilisateurs par ville
json{ "$unwind": "$addresses" }, { "$group": { "_id": "$addresses.city", "count": { "$sum": 1 } }}
$unwind pour "éclater" le tableau addresses, puis $group par ville.
5. Âge moyen par ville, trié décroissant
json{ "$unwind": "$addresses" }, { "$group": { "_id": "$addresses.city", "ageMoyen": { "$avg": "$age" } }}, { "$sort": { "ageMoyen": -1 } }
Même principe qu'avant mais on ajoute $avg et on trie avec $sort: -1.
6. Les 3 tags les plus utilisés
json{ "$unwind": "$tags" }, { "$group": { "_id": "$tags", "count": { "$sum": 1 } }}, { "$sort": { "count": -1 } }, { "$limit": 3 }
$unwind sur tags pour séparer chaque tag, $group pour compter, $limit pour garder les 3 premiers.

Niveau 3 — Pipelines complexes
7. Liste des prénoms par ville
json{ "$unwind": "$addresses" }, { "$group": { "_id": "$addresses.city", "prenoms": { "$push": "$firstName" } }}
$push pour rassembler tous les prénoms dans un tableau par ville.
8. Proportion d'utilisateurs vérifiés par ville
json[{ "$unwind": "$addresses" }, { "$group": { "_id": "$addresses.city", "total": { "$sum": 1 }, "verifies": { "$sum": { "$cond": ["$isVerified", 1, 0] } } }}, { "$project": { "total": 1, "verifies": 1, "proportion": { "$divide": "$verifies", "$total" } }}]
$cond pour compter uniquement les vérifiés, $divide pour calculer la proportion.
9. Utilisateurs avec le plus d'adresses
json{ "$project": { "firstName": 1, "email": 1, "addressCount": { "$size": "$addresses" } }}, { "$sort": { "addressCount": -1 } }
$project pour créer un champ calculé addressCount avec $size, puis on trie pour voir qui a le plus d'adresses.

1. Champs les plus utilisés en filtre

age — utilisé dans presque toutes les requêtes
addresses.city — filtres par ville très fréquents
isVerified — souvent combiné avec d'autres filtres
tags — recherches par tag
email — recherche utilisateur

2. Champs les plus utilisés en tri

age — tri age
addresses.city — tri alphabétique par ville
createdAt — tri chronologique

