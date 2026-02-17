# Besvarelse - Refleksjon og Analyse

**Student:** [Haider Hamid]

**Studentnummer:** [341688]

**Dato:** [01.03.2026]

---

## Del 1: Datamodellering

### Oppgave 1.1: Entiteter og attributter

**Identifiserte entiteter:**
**Attributter for hver entitet:**
''
Kunde: KundeID(PK), Fornavn, Etternavn, Mobil (unik), Epost(unik). 
Sykkel: SykkelID (PK), LåsID
Stasjon: StasjonID (PK), Navn.  
Lås: LåsID(PK), StasjonsID
Utleie: Utleie(ID), KundeID, SykkelID, Utleveringstid, Innleveringstid, Leiebeløp.

---

### Oppgave 1.2: Datatyper og `CHECK`-constraints

**Valgte datatyper og begrunnelser:**

KundeID, StasjonsID, LåsID, SykkelID, UtleieID: SERIAL. Generer en automatisk unik heltall, som er ideelt for primærnøkler. 
Fornavn/Etternavn: VARCHAR(50), Vanlig tekstfelt som er mer lagringseffektivt enn CHAR. 50 tegn er standard begrensning for navn. 
Mobil: VARCHAR(15), 15 tegn er maks lengde i følge internasjonal standard. 
Epost: VARCHAR(100), i tilfelle det er lange epostadresse.  

Navn (stasjon): VARCHAR(100), navn på stasjoner, gir nok plass for beskrivende navn. 

Utleveringstid/Innleveringstid: TIMESTAMP, lagrer både dato og klokkeslett, som er nødvendig for å kunne beregne nøyaktig leievarighet.  
Leiebeløp: NUMERIC(10,2), siden det er penger. 

**`CHECK`-constraints:**

Mobil: CHECK (Mobil ~ '^[0-9+ ]+$'), dette sikrer at feltet kune inneholder tall, mellomrom eller pluss tegn, og ikke noen bokstaver. 

Epost: CHECK (Epost LIKE '%@%'), sikrer at eposten inneholder en @. 

Leiebeløp: CHECK(Leiebeløp >= 0), sikrer at beløpet aldri blir negativt. 

**ER-diagram:**

erDiagram
    KUNDE ||--o{ UTLEIE: "utfører"
    SYKKEL ||--o{ UTLEIE: "leies ut" 
    STASJON ||--|{ LÅS: "inneholder"
    LÅS |o--o| SYKKEL: "låser" 


KUNDE {
    SERIAL kunde_id PK
    VARCHAR_50 fornavn
    VARCHAR_50 etternavn
    VARCHAR_15 mobil "UNIQUE"
    VARCHAR_100 epost "UNIQUE"
}

STASJON{
    SERIAL stasjon_id PK
    VARCHAR_100 navn
}

LÅS{
    SERIAL lås_id PK
    INTEGER stasjon_id FK 
}

SYKKEL{
    SERIAL sykkel_id PK 
    INTEGER lås_id FK "NULL hvis utleid"
}

UTLEIE{
    SERIAL utleie_id PK
    INTEGER kunde_id FK 
    INTEGER sykkel_id FK 
    TIMESTAMP utleveringstid
    TIMESTAMP innleveringstid "NULL"
    NUMERIC_10_2 leiebeløp
}


---

### Oppgave 1.3: Primærnøkler

**Valgte primærnøkler og begrunnelser:**

KundeID: Unik ID som identifiserer hver kunde, kunne ha brukt epost eller mobil men disse kan endres. 
StasjonsID: Unik ID som identifiserer hver stasjon. 
LåsID: Unik ID som identifiserer hver lås, slik at vi vet hvilken lås sykkelen har blitt innlevert. 
SykkelID: Unik ID for hver sykkel, blir samme som kundeID men på sykler. 
UtleieID: Unik ID for hver utleietransaksjon. En kunde kan leie samme sykkel flere ganger, dermed trenger vi en unik id for hver utleie. 


**Naturlige vs. surrogatnøkler:**

Har brukt surrogatnøkler og ikke naturlige nøkler. Naturlige nøkler kan endre seg over tid, f.eks e-post. Hvis en kunde bytter e-post må alle relaterte tabeller oppdateres, som er ressurskrevende. Naturlige nøkler kan også inneholde sensitiv informasjon, som f.eks personnummer. 


**Oppdatert ER-diagram:**

erDiagram
    KUNDE ||--o{ UTLEIE: "utfører"
    SYKKEL ||--o{ UTLEIE: "leies ut" 
    STASJON ||--|{ LÅS: "inneholder"
    LÅS |o--o| SYKKEL: "låser" 


KUNDE {
    SERIAL kunde_id PK
    VARCHAR_50 fornavn
    VARCHAR_50 etternavn
    VARCHAR_15 mobil "UNIQUE"
    VARCHAR_100 epost "UNIQUE"
}

STASJON{
    SERIAL stasjon_id PK
    VARCHAR_100 navn
}

LÅS{
    SERIAL lås_id PK
    INTEGER stasjon_id FK 
}

SYKKEL{
    SERIAL sykkel_id PK 
    INTEGER lås_id FK "NULL hvis utleid"
}

UTLEIE{
    SERIAL utleie_id PK
    INTEGER kunde_id FK 
    INTEGER sykkel_id FK 
    TIMESTAMP utleveringstid
    TIMESTAMP innleveringstid "NULL"
    NUMERIC_10_2 leiebeløp
}

---

### Oppgave 1.4: Forhold og fremmednøkler

**Identifiserte forhold og kardinalitet:**


KUNDE ||--o{ UTLEIE: En kunde kan ha 0 eller flere utleier, men en utleie kan bare ha en kunde. 

SYKKEL ||--o{ UTLEIE: En sykkel kan ha null eller flere utleier gjennom tiden sin, men hver utleie kan bare ha nøyaktig en sykkel. 

STASJON ||--|{ LÅS: En stasjon har en eller flere låser, men en lås tilhører nøyaktig en stasjon. 

LÅS |o--o| SYKKEL: En lås kan inneholde null eller en sykkel, og en sykkel kan være parkert i null eller en lås. 

**Fremmednøkler:**

stasjons_id i tabellen LÅS: kobler hver lås til en spesifikk stasjon. Vi hadde ikke visst hvor låsen er uten denne. 

lås_id i tabellen SYKKEL: Denne tillater NULL. Viser at hvis den har en verdi så er sykkelen i den låsen, hvis den er NULL så er sykkelen utleid. 

kunde_id i tabellen UTLEIE: Kobler utleie til kunden. 

sykkel_id i tabellen UTLEIE: Kobler utleie til sykkelen som skal brukes. 

**Oppdatert ER-diagram:**

erDiagram
    KUNDE ||--o{ UTLEIE: "utfører"
    SYKKEL ||--o{ UTLEIE: "leies ut" 
    STASJON ||--|{ LÅS: "inneholder"
    LÅS |o--o| SYKKEL: "låser" 


KUNDE {
    SERIAL kunde_id PK
    VARCHAR_50 fornavn
    VARCHAR_50 etternavn
    VARCHAR_15 mobil "UNIQUE"
    VARCHAR_100 epost "UNIQUE"
}

STASJON{
    SERIAL stasjon_id PK
    VARCHAR_100 navn
}

LÅS{
    SERIAL lås_id PK
    INTEGER stasjon_id FK 
}

SYKKEL{
    SERIAL sykkel_id PK 
    INTEGER lås_id FK "NULL hvis utleid"
}

UTLEIE{
    SERIAL utleie_id PK
    INTEGER kunde_id FK 
    INTEGER sykkel_id FK 
    TIMESTAMP utleveringstid
    TIMESTAMP innleveringstid "NULL"
    NUMERIC_10_2 leiebeløp
}

---

### Oppgave 1.5: Normalisering

**Vurdering av 1. normalform (1NF):**


Modellen min tilfredsstiller 1NF fordi alle tabeller har en unik primærnøkkel. Alle attributter inneholder også atomære verdier, der f.eks er navn delt opp i fornavn og etternavn.Det finnes ingen kolonner som inneholder lister eller repeterende grupper. 

**Vurdering av 2. normalform (2NF):**

Modellen min tilfredsstiller 2NF fordi alle tabeller bruker en enkel ID som KundeID, der alle andre opplysninger i tabellen hører direkte til denne IDen. 

**Vurdering av 3. normalform (3NF):**

Modellen min tilfredsstiller også 3NF fordi jeg har ikke informasjon som er avhengig av andre felt enn selve primærnøkkelen.  F.eks har ikke lagret stasjonsnavn inne i lås-tabellen, jeg har bare lagt inn en id som peker til stasjonen. 

**Eventuelle justeringer:**

[Skriv ditt svar her - hvis modellen ikke var på 3NF, forklar hvilke justeringer du har gjort]

---

## Del 2: Database-implementering

### Oppgave 2.1: SQL-skript for database-initialisering

**Plassering av SQL-skript:**

Bekrefter at SQL skriptet ligger i filmappen.

**Antall testdata:**

- Kunder: 5
- Sykler: 100
- Sykkelstasjoner: 5
- Låser: 100
- Utleier: 50

---

### Oppgave 2.2: Kjøre initialiseringsskriptet

**Dokumentasjon av vellykket kjøring:**

haiderhamid@MacBook-Air data1500-oblig-01 % docker-compose up -d 
[+] up 17/17
 ✔ Image postgres:15-alpine                       Pulled                   10.3s
 ✔ Network data1500-oblig-01_data1500-network     Created                  0.0s
 ✔ Volume data1500-oblig-01_postgres_data_oblig_1 Created                  0.0s
 ✔ Container data1500-postgres                    Created                  0.1s


**Spørring mot systemkatalogen:**

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Resultat:**

```
oblig01=# SELECT table_name 
oblig01-# FROM information_schema.tables 
oblig01-# WHERE table_schema = 'public' 
oblig01-#   AND table_type = 'BASE TABLE'
oblig01-# ORDER BY table_name;
 table_name 
------------
 kunde
 laas
 stasjon
 sykkel
 utleie
(5 rows)

oblig01=# 
```

---

## Del 3: Tilgangskontroll

### Oppgave 3.1: Roller og brukere

**SQL for å opprette rolle:**

```sql
CREATE ROLE kunde; 
```

**SQL for å opprette bruker:**

```sql
CREATE USER kunde_1 WITH PASSWORD 'kundepassord'; 
GRANT kunde TO kunde_1; 
```

**SQL for å tildele rettigheter:**

```sql
GRANT CONNECT ON DATABASE oblig01 TO kunde; 
GRANT USAGE ON SCHEMA public to kunde; 
GRANT SELECT ON TABLE Stasjon, Laas, Sykkel, Kunde, Utleie TO kunde; 
```

---

### Oppgave 3.2: Begrenset visning for kunder

**SQL for VIEW:**

```sql
CREATE VIEW mine_utleier AS 
SELECT Utleie.*
FROM Utleie
JOIN Kunde ON Utleie.kunde_id = Kunde.kunde_id
WHERE Kunde.fornavn = SESSION_USER; 

GRANT SELECT ON mine_utleier TO kunde; 

```

**Ulempe med VIEW vs. POLICIES:**

Ved bruk av VIEW kan brukere omgå sikkerhet hvis de får tilgang til den originale tabellen, de kan f.eks skrive SELECT * FROM Utleie og deretter se alle data. Men med POLICY så er sikkerheten bygget inn i selve tabellen slik at brukere ser kunde sine egne rader uansett hvilken spørring de kjører. POLICY er mer robust og lettere å administrere. 

---

## Del 4: Analyse og Refleksjon

### Oppgave 4.1: Lagringskapasitet

**Gitte tall for utleierate:**

- Høysesong (mai-september): 20000 utleier/måned
- Mellomsesong (mars, april, oktober, november): 5000 utleier/måned
- Lavsesong (desember-februar): 500 utleier/måned

**Totalt antall utleier per år:**

Totalt antall utleier per år: 
Høysesong = 5 måneder x 20 000 = 100 000 utleier
Mellomsesong = 4 måneder x 5000 = 20 000 utleier
Lavsesong = 3 måneder x 500 = 1500 utleier
Totalt = 121 500 utleier i året. 

**Estimat for lagringskapasitet:**

Kundetabell: 
Antar 1000 kunder ca: 
kunde_id: 4 bytes
fornavn: ca 10 bytes
etternavn: ca 10 bytes
mobil: ca 10 bytes
epost: ca 20 bytes
per rad: 4 + 10 + 10 + 10 + 20 = 54 bytes
Totalt: 1000 x 54 bytes = 54 KB

Stasjontabell: 
5 stasjoner
stasjon_id: 4 bytes
navn: 20 bytes
per rad: 4 + 20 = 24 
totalt: 5 x 24 = 0.12 KB 

Laastabell:
100 låser 
laas_id: 4 bytes
stasjon_id: 4 bytes
Per rad: 8 bytes
totalt = 100 x 8 = 0,8 KB

Sykkeltabell: 
100 sykler
sykkel_id: 4 bytes
laas_id: 4 bytes
Per rad: 8 bytes
Totalt: 8 x 100 = 0.8 KB 

Utleietabell: 
121 500 utleier
utleie_id: 4 bytes
kunde_id: 4 bytes
sykkel_id: 4 bytes
utleveringstid: 8 bytes
innleveringstid: 8 bytes
leiebeloep: 8 bytes
per rad: 4+4+4+8+8+8= 36 bytes
Totalt: 121 500 x 36 = 4 374 000 bytes = 4.4 MB



**Totalt for første år:**

Totalt i KB = 54+0.12+0.8+0.8+4374= 4429 KB = 4.43MB.

---

### Oppgave 4.2: Flat fil vs. relasjonsdatabase

**Analyse av CSV-filen (`data/utleier.csv`):**

**Problem 1: Redundans**

CSV filen inneholder mye duplisering av data. F.eks så gjentas kundeinformasjon flere ganger, i dette tilfellet så gjentas Ole Hansen med hans info 3 ganger. Stasjonsinformasjon gjentas flere ganger også, f.eks Sentrum stasjon gjentas flere ganger. Dette gjør at filen blir unødvendig større.
**Problem 2: Inkonsistens**

Med redundans så skaper det at data kan bli modstridende. F.eks hvis Ole Hansen bytter telefonnummeret sitt så må dette oppdateres på alle radene med telefonnummeret hans. Hvis vi glemmer å oppdatere en av radene så vil systemet tro at det finnes to forskjellige personer. 

**Problem 3: Oppdateringsanomalier**

Sletteanomali: Hvis vi f.eks sletter alle utleier av en kunde, så mister vi alt av informasjon om dem som kunde. Vi kan ikke beholde data om kunder uten at de har minst en utleie registrert. 

Innsettingsanomali: En ny sykkel kan ikke legges til før noen har leid den.

Oppdateringsanomali: Hvis en adresse til en stasjon endres, må den finnes og endres i alle radene der stasjonen er nevnt. Glemmer vi en rad, så får vi forskjellige adresser på samme stasjon i systemet. 

**Fordeler med en indeks:**

Fordelen med indeks er at den kan slå opp direkte hvor radene ligger, uten den så måtte databasen lese alle 121 500 radene for å finne en utleier av en sykkel. Blir tusenvis av ganger raskere med indeks. 

**Case 1: Indeks passer i RAM**
Hvis indeksen passer i RAM vil oppslag skje umiddelbart. Her vil databasen laste indeksen inn i minnet når den starter og vil ikke være behov for å hente data fra harddisken. Brukes vanligvis et B+ tre. 

**Case 2: Indeks passer ikke i RAM**

Hvis den ikke passer i RAM så vil databasen bruek ekstern flettesortering der data deles i mindre biter og sorteres i RAM og skrives til disk og deretter flettes sammen. 

**Datastrukturer i DBMS:**

B+ tre: Er standard for de fleste databaser, der denne datastrukteren gjør det lett å finne ekstakte verdier og verdier som er i en spesifikk periode. 

Hash-indeks: Er veldig rask for eksakte søk, men fungerer ikke for verdier i en periode eller sortering. I dette tilfelle er B+ tre bedre for systemet vårt. 

---

### Oppgave 4.3: Datastrukturer for logging

**Foreslått datastruktur:**

LSM-tree

**Begrunnelse:**

LSM-tre legger til nye hendelser på slutten, uten å organisere det. Disse loggene skrives direkte til en memtable i RAM, dette gjør at skrivingen er veldig rask. Lesingen er litt tregere men siden logging sjeldent leses så er dette greit. Når memtable er full så legges den i disk som en fil, og deretter starter en ny tom memtable. 

**Skrive-operasjoner:**

Med et LSM tre vil vi hele tiden skrive ny hendelser, f.eks nr det skjer innlogginger, utleier osv. Skrivingen skjer ved at alt blir lagt til i slutten i memtable uten noe sortering. Skrivingen er veldig rask i dette tilfellet. Datastrukturen håndterer konstant skriving veldig effektivt. 

**Lese-operasjoner:**

Lesingen er tregere med LSM tre, men dette er greit siden logger leses sjeldent. Lesingen skjer vanligvis hvis det skal feilsøkes eller at admin vil se aktivitetshistorikken. Lesingen er tregere hvis vi skal finne et spesifikk hendelse , der det må søkes gjennom memtable og flere filer på disken. Men hvis vi ønsker bare å se de siste 50 hendelsene så er dette veldig raskt siden nyeste data ligger i memtable. 

---

### Oppgave 4.4: Validering i flerlags-systemer

**Hvor bør validering gjøres:**

Validering bør gjøres i tre lag, i frontend, applikasjonslag og database. 

**Validering i nettleseren:**

Fordeler: Rask tilbakemelding til brukeren uten å vente på server, som reduserer nettverkstrafikken. 

Ulemper: Hvis en bruker ønsker å gjøre skade så kan de slå av JavaScript eller bruke verktøy som Postman. Validering i nettleseren kan ikke stoles på alene. 
**Validering i applikasjonslaget:**

Fordeler: Her valideres all input før den når databasen. Dette er det viktigste sikkerhetslaget. Her kan det utføres avanserte kontroller som f.eks sjekke om et mobilnummer er allerede registrert. Dette laget kan også beskytte mot SQL injection ved å håndtere inndata på en trygg måte. 

Ulemper: Data må sendes til serveren og tilbake før man får feilmelding, som kan ta lengre tid enn hvis det ble gjort i nettleseren. 

**Validering i databasen:**

Fordeler: CHECK constraints som f.eks for mobilnummer sikrer at ugyldig data aldri kommer inn, samme om applikasjonslaget har en feil. FOREIGN KEY relasjoner sikrer også at dataen holder seg konsistente. 

Ulemper: Feilmeldingene er ikke brukervennlige. Databasen kan bare gjøre enkle valideringer som format og datatype. 
**Konklusjon:**

Alle tre lag bør brukes. Hvis en av de feiler som vil den andre fange opp feilen. 

---

### Oppgave 4.5: Refleksjon over læringsutbytte

**Hva har du lært så langt i emnet:**
 
Designe databaser, og lage ER diagrammer. 
Hvordan primærnøkler og fremmednøkler kobler tabeller sammen. 
SQL for å lage tabeller, sette in data og sette opp sikkerhet. 
Hvordan å bruke DOCKER for å sette opp en database. 


**Hvordan har denne oppgaven bidratt til å oppnå læringsmålene:**

Gitt meg praktisk erfaring å faktisk designe og lage en database, skrive SQL kode som bygger databasen, tegne ER diagrammer. Teorispørsmålene har også hjulpet meg å forstå hvordan databaser faktisk fungerer. 

Se oversikt over læringsmålene i en PDF-fil i Canvas https://oslomet.instructure.com/courses/33293/files/folder/Plan%20v%C3%A5ren%202026?preview=4370886

**Hva var mest utfordrende:**

Det mest utfordrende var bygging av databasen, finne ut forholdene mellom de ulike dataene. Hvordan å sette opp docker og hvordan det brukes. 

**Hva har du lært om databasedesign:**

Å tenke hvordan dataene skal brukes i praksis. Unngå unødvendig gjentakelse av data. Tenke på hva som kobles sammen og ligge i de forskjellige tabellene. Forstår også at god planlegging på starten vil gjøre kodeskrivingen og vedlikeholdingen av databasen lettere. 

---

## Del 5: SQL-spørringer og Automatisk Testing

**Plassering av SQL-spørringer:**

[Bekreft at du har lagt SQL-spørringene i `test-scripts/queries.sql`]


**Eventuelle feil og rettelser:**

[Skriv ditt svar her - hvis noen tester feilet, forklar hva som var feil og hvordan du rettet det]

---

## Del 6: Bonusoppgaver (Valgfri)

### Oppgave 6.1: Trigger for lagerbeholdning

**SQL for trigger:**

```sql
[Skriv din SQL-kode for trigger her, hvis du har løst denne oppgaven]
```

**Forklaring:**

[Skriv ditt svar her - forklar hvordan triggeren fungerer]

**Testing:**

[Skriv ditt svar her - vis hvordan du har testet at triggeren fungerer som forventet]

---

### Oppgave 6.2: Presentasjon

**Lenke til presentasjon:**

[Legg inn lenke til video eller presentasjonsfiler her, hvis du har løst denne oppgaven]

**Hovedpunkter i presentasjonen:**

[Skriv ditt svar her - oppsummer de viktigste punktene du dekket i presentasjonen]

---

**Slutt på besvarelse**
