-- ============================================================================
-- TEST-SKRIPT FOR OBLIG 1
-- ============================================================================

-- Kjør med: docker-compose exec postgres psql -h -U admin -d data1500_db -f test-scripts/queries.sql

-- En test med en SQL-spørring mot metadata i PostgreSQL (kan slettes fra din script)
select nspname as schema_name from pg_catalog.pg_namespace;

-- 5.1
SELECT * FROM Sykkel;

-- 5.2 
SELECT etternavn, fornavn, mobil
FROM Kunde
ORDER BY etternavn, fornavn; 

-- 5.3 
SELECT DISTINCT Sykkel.sykkel_id
FROM Sykkel 
JOIN Utleie ON Sykkel.sykkel_id = Utleie.sykkel_id
WHERE Utleie.utleveringstid > '2026-01-01'
ORDER BY Sykkel.sykkel_id; 

-- 5.4 
SELECT COUNT(*) AS antall_kunder
FROM Kunde; 

-- 5.5 
SELECT Kunde.fornavn, Kunde.etternavn, COUNT (Utleie.utleie_id) AS antall_utleier
FROM Kunde
LEFT JOIN Utleie ON Kunde.kunde_id = Utleie.kunde_id
GROUP BY Kunde.kunde_id, Kunde.fornavn, Kunde.etternavn
ORDER BY antall_utleier DESC; 

-- 5.6
SELECT Kunde.fornavn, Kunde.etternavn
FROM Kunde
LEFT JOIN Utleie ON Kunde.kunde_id = Utleie.kunde_id
WHERE Utleie.utleie_id IS NULL; 

-- 5.7 
SELECT Sykkel.sykkel_id
FROM Sykkel
LEFT JOIN Utleie ON Sykkel.sykkel_id = Utleie.sykkel_id
WHERE Utleie.utleie_id IS NULL; 

-- 5.8 
SELECT Sykkel.sykkel_id, Kunde.fornavn, Kunde.etternavn, Utleie.utleveringstid
FROM Utleie 
JOIN Sykkel ON Utleie.sykkel_id = Sykkel.sykkel_id
JOIN Kunde ON Utleie.kunde_id = Kunde.kunde_id
WHERE Utleie.innleveringstid IS NULL
AND Utleie.utleveringstid < NOW() - INTERVAL '1 day'; 

