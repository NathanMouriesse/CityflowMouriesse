CityFlow

VOTRE TOUR — Requêtes à produire
Pour chacune des demandes suivantes, écrivez la requête MongoDB correspondante dans
mongo-express, et notez-la dans votre fichier mes_requetes.md. Aucune requête ne vous est
donnée toute faite.


Niveau 1 — Filtres simples

1. Trouvez tous les utilisateurs entre 25 et 35 ans (inclus aux deux bornes). { "age": { "$gte": 25, "$lte": 35 } } J'utilise $gte et $lte pour faire un "entre 25 et 35".

2. Trouvez les utilisateurs dont l'email contient example.com (indice : opérateur $regex). { "email": { "$regex": "example\\.com" } }
$regex c'est pour chercher un mot dans une chaîne, comme un Ctrl+F.

3. Trouvez les utilisateurs qui ont exactement 2 adresses. { "addresses": { "$size": 2 } } $size pour vérifier qu'un tableau a exactement X éléments.

4. Trouvez les utilisateurs qui n'ont pas le champ preferences. { "preferences": { "$exists": false } }
 $exists: false pour trouver les documents où le champ n'existe pas du tout. 

Niveau 2 — Combinaisons
5. Trouvez les utilisateurs habitant Lyon OU Villeurbanne, et de plus de 25 ans. { "addresses.city": { "$in": ["Lyon", "Villeurbanne"] }, "age": { "$gt": 25 } }  $in c'est comme un "ou" sur une liste de valeurs.

6. Trouvez les utilisateurs qui ont au moins une adresse de type home à Lyon. { "addresses": { "$elemMatch": { "type": "home", "city": "Lyon" } } } $elemMatch parce qu'on veut que le même élément du tableau vérifie les deux conditions en même temps. 

7. Trouvez les utilisateurs qui ont les tags premium ET eco-friendly ensemble.{ "tags": { "$all": ["premium", "eco-friendly"] } } 7. $all pour vérifier que les deux tags sont présents ensemble.

Niveau 3 — Tri et pagination
8. Affichez les 3 utilisateurs les plus âgés, en ne renvoyant que firstName, age et email.
9. Affichez les utilisateurs triés par ville (alphabétique), puis par âge décroissant.
10. Implémentez une pagination : page 2 avec 2 utilisateurs par page, triés par createdAt.
Niveau 4 — Bonus pour les rapides
11. Trouvez les utilisateurs vérifiés âgés de moins de 30 ans, n'habitant pas Lyon.
12. Trouvez les utilisateurs dont au moins un tag commence par la lettre 'p' (indice : $regex dans
un tableau).
