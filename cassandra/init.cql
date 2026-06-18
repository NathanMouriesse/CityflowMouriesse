-- Script de seed Cassandra — CityFlow
-- Exécuter avec : docker exec -i cityflow-cassandra cqlsh < cassandra/init.cql

-- Création du keyspace
CREATE KEYSPACE IF NOT EXISTS cityflow
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE cityflow;

-- Table des passages aux stations
CREATE TABLE IF NOT EXISTS station_passages (
  station_id  text,
  day         date,
  ts          timestamp,
  bikes_dispo int,
  user_id     text,
  vehicle_id  text,
  event_type  text,
  PRIMARY KEY ((station_id, day), ts)
) WITH CLUSTERING ORDER BY (ts DESC);

-- Table des connexions utilisateurs
CREATE TABLE IF NOT EXISTS user_connections (
  user_id    text,
  month      text,
  ts         timestamp,
  ip_address text,
  device     text,
  action     text,
  PRIMARY KEY ((user_id, month), ts)
) WITH CLUSTERING ORDER BY (ts DESC);

-- Données de test — station_passages
INSERT INTO station_passages (station_id, day, ts, bikes_dispo, user_id, vehicle_id, event_type)
VALUES ('S001', '2025-10-15', '2025-10-15 08:30:00+0000', 12, 'u42', 'v01', 'borrow');

INSERT INTO station_passages (station_id, day, ts, bikes_dispo, user_id, vehicle_id, event_type)
VALUES ('S001', '2025-10-15', '2025-10-15 09:15:00+0000', 11, 'u17', 'v02', 'borrow');

INSERT INTO station_passages (station_id, day, ts, bikes_dispo, user_id, vehicle_id, event_type)
VALUES ('S001', '2025-10-15', '2025-10-15 12:00:00+0000', 13, 'u42', 'v01', 'return');

INSERT INTO station_passages (station_id, day, ts, bikes_dispo, user_id, vehicle_id, event_type)
VALUES ('S002', '2025-10-15', '2025-10-15 10:00:00+0000', 5, 'u55', 'v03', 'borrow');

-- Données de test — user_connections
INSERT INTO user_connections (user_id, month, ts, ip_address, device, action)
VALUES ('u42', '2025-10', '2025-10-15 08:00:00+0000', '192.168.1.10', 'iPhone 15', 'login');

INSERT INTO user_connections (user_id, month, ts, ip_address, device, action)
VALUES ('u42', '2025-10', '2025-10-14 17:30:00+0000', '192.168.1.10', 'iPhone 15', 'login');
