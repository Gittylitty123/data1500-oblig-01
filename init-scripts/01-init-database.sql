-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller
CREATE TABLE Stasjon (
	stasjon_id SERIAL PRIMARY KEY,
	navn VARCHAR(100) NOT NULL
);

CREATE TABLE Laas (
	laas_id SERIAL PRIMARY KEY,
	stasjon_id INTEGER REFERENCES Stasjon (stasjon_id)
); 

CREATE TABLE Sykkel (
	sykkel_id SERIAL PRIMARY KEY,
	laas_id INTEGER UNIQUE REFERENCES Laas(laas_id) ON DELETE SET NULL
);

CREATE TABLE Kunde (
	kunde_id SERIAL PRIMARY KEY,
	fornavn VARCHAR(50) NOT NULL, 
	etternavn VARCHAR(50) NOT NULL,
	mobil VARCHAR(15) UNIQUE NOT NULL CHECK (mobil ~ '^[0-9+ ]+$'),
	epost VARCHAR(100) UNIQUE NOT NULL CHECK (epost LIKE '%@%')
);

CREATE TABLE Utleie (
	utleie_id SERIAL PRIMARY KEY, 
	kunde_id INTEGER NOT NULL REFERENCES Kunde(kunde_id),
	sykkel_id INTEGER NOT NULL REFERENCES Sykkel(sykkel_id),
	utleveringstid TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	innleveringstid TIMESTAMP CHECK (innleveringstid IS NULL OR innleveringstid >= utleveringstid), 
	leiebeloep NUMERIC(10,2) CHECK (leiebeloep >= 0)
); 

-- Sett inn testdata

INSERT INTO Stasjon (navn) VALUES
('Jernbanetorget'), ('Nationalteateret'), ('Stortinget'), ('Grønland'), ('Grunerløkka'); 

INSERT INTO Laas (stasjon_id)
SELECT s.stasjon_id
From Stasjon s
CROSS JOIN generate_series(1,20); 

INSERT INTO Sykkel (laas_id)
SELECT laas_id FROM Laas; 

INSERT INTO Kunde (fornavn, etternavn, mobil, epost) VALUES
('Kari', 'Nordmann', '11122233', 'kari@epost.no'),
('Ola', 'Nordmann', '11122234', 'ola@epost.no'),
('Ida', 'Nordmann', '11122235', 'ida@epost.no'),
('Lars', 'Nordmann', '11122236', 'lars@epost.no'),
('kunde_1', 'Test', '1111222', 'test@epost.no');

INSERT INTO Utleie (kunde_id, sykkel_id, utleveringstid, innleveringstid, leiebeloep)
SELECT
	floor(random() * 5 + 1)::int,
	floor(random() * 100 + 1)::int, 
	now() - (random() * interval '365 days'),
	now() - (random () * interval '1 day'), 
	(random() * 180 + 20)::numeric(10,2)
FROM generate_series(1,50); 

-- DBA setninger (rolle: kunde, bruker: kunde_1)
CREATE ROLE kunde; 
CREATE USER kunde_1 WITH PASSWORD 'kundepassord'; 
GRANT kunde TO kunde_1;
GRANT CONNECT ON DATABASE oblig01 TO kunde; 
GRANT USAGE ON SCHEMA public to kunde; 
GRANT SELECT ON TABLE Stasjon, Laas, Sykkel, Kunde, Utleie TO kunde; 

CREATE VIEW mine_utleier AS 
SELECT Utleie.*
FROM Utleie
JOIN Kunde ON Utleie.kunde_id = Kunde.kunde_id
WHERE Kunde.fornavn = SESSION_USER; 

GRANT SELECT ON mine_utleier TO kunde; 


-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;