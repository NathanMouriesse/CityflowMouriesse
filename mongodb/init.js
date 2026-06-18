// Script de seed MongoDB — CityFlow
// Exécuter avec : docker exec -i cityflow-mongo mongosh -u admin -p cityflow2025 < seed/mongodb/init.js

use cityflow;

// ─── Nettoyage ────────────────────────────────────────────
db.users.drop();
db.trips.drop();
db.vehicles.drop();

// ─── Vehicles ─────────────────────────────────────────────
db.vehicles.insertMany([
  { type: "bike", brand: "Peugeot", status: "available", location: { arrondissement: "Lyon 1", station: "Bellecour", coordinates: { lat: 45.7578, lng: 4.8320 } } },
  { type: "bike", brand: "Decathlon", status: "available", location: { arrondissement: "Lyon 2", station: "Guillotière", coordinates: { lat: 45.7489, lng: 4.8382 } } },
  { type: "bike", brand: "Btwin", status: "maintenance", location: { arrondissement: "Lyon 3", station: "Part-Dieu", coordinates: { lat: 45.7607, lng: 4.8598 } } },
  { type: "scooter", brand: "Yamaha", status: "available", location: { arrondissement: "Lyon 1", station: "Hôtel de Ville", coordinates: { lat: 45.7669, lng: 4.8341 } } },
  { type: "scooter", brand: "Piaggio", status: "available", location: { arrondissement: "Lyon 6", station: "Masséna", coordinates: { lat: 45.7693, lng: 4.8485 } } },
  { type: "car", brand: "Renault", model: "Zoé", status: "available", location: { arrondissement: "Lyon 8", station: "Mermoz", coordinates: { lat: 45.7365, lng: 4.8712 } } },
]);

// ─── Users ────────────────────────────────────────────────
db.users.insertMany([
  { email: "alice.dupont@example.com", firstName: "Alice", lastName: "Dupont", age: 28, isVerified: true, createdAt: new Date("2025-09-01"), addresses: [{ type: "home", street: "12 rue de la République", city: "Lyon", zipCode: "69001" }], preferences: { language: "fr", notifications: { email: true, sms: false } }, tags: ["premium", "early-adopter"] },
  { email: "bob.martin@example.com", firstName: "Bob", lastName: "Martin", age: 34, isVerified: true, createdAt: new Date("2025-09-05"), addresses: [{ type: "home", street: "5 rue Garibaldi", city: "Lyon", zipCode: "69003" }], tags: ["eco-friendly"] },
  { email: "carla.renard@example.com", firstName: "Carla", lastName: "Renard", age: 22, isVerified: false, createdAt: new Date("2025-09-10"), addresses: [{ type: "home", street: "18 cours Gambetta", city: "Lyon", zipCode: "69007" }], tags: [] },
  { email: "david.petit@example.com", firstName: "David", lastName: "Petit", age: 45, isVerified: true, createdAt: new Date("2025-08-20"), addresses: [{ type: "home", street: "3 avenue des Frères Lumière", city: "Villeurbanne", zipCode: "69100" }, { type: "work", street: "10 rue de la Part-Dieu", city: "Lyon", zipCode: "69003" }], tags: ["premium"] },
  { email: "emma.blanc@example.com", firstName: "Emma", lastName: "Blanc", age: 19, isVerified: false, createdAt: new Date("2025-10-01"), addresses: [{ type: "home", street: "7 rue Anatolie France", city: "Vénissieux", zipCode: "69200" }], tags: ["early-adopter"] },
]);

print("Seed MongoDB terminé !");
print("Users : " + db.users.countDocuments());
print("Vehicles : " + db.vehicles.countDocuments());
