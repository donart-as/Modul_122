# Modul_122
## Checkpoint Linux Befehle

### Übung 1 - Repetition: Navigieren in Verzeichnissen

- cd ~

- cd /var/log

- cd /etc/udev/

- cd ..

- cd newt

- cd ../../dev

![Bashscript](Aufgabe_1.png)

### Übung 2 - Wildcards

- mkdir ~/Docs

- touch ~/Docs/file{1..10}

- rm ~/Docs/*1*

- rm ~/Docs/file2 ~/Docs/file4 ~/Docs/file7

- rm ~/Docs/*

- mkdir ~/Ordner

- touch ~/Ordner/file{1..10}

- cp -r ~/Ordner ~/Ordner2

- cp -r ~/Ordner ~/Ordner2/Ordner3

- mv ~/Ordner ~/Ordner1

- rm -r ~/Docs ~/Ordner1 ~/Ordner2

![Bashscript](Aufgabe_2.png)

### Übung 3 - grep, cut (, awk)

a: 

- grep --color=auto 'obelix' ~/textfile.txt

- grep --color=auto '2' ~/textfile.txt

- grep --color=auto 'e' ~/textfile.txt

- grep --color=auto -v 'gamma' ~/textfile.txt

- grep --color=auto -E '1|2|3' ~/textfile.txt

b:

- cut -d ':' -f 1 ~/textfile.txt

- cut -d ':' -f 2 ~/textfile.txt

- cut -d ':' -f 3 ~/textfile.txt


### Übung 5 - stdout, stdin, stderr

a Textdatei mit cat und <<

- cat << END > buchstaben.txt
a
b
c
d
e
END

b:

- sudo ls -z 2> /root/errorsLs.log


c:

1.  echo "Das ist eine Testzeile." > test.txt
2. Umleiten mit einem >:  cat test.txt > ausgabe.txt
 cat ausgabe.txt    Es überschreibt die Datei
3. cat test.txt >> ausgabe.txt
Dies tut die Datei zur anderen Datei anhängen
4. cat test.txt > test.txt : die Datei wird vor dem Lesen überschrieben und bleibt deswegen leer oder beschädigt

d: 

- whoami > info.txt

e:

- id >> info.txt

f:

wc -w < info.txt

# Variablen

Bearbeite diesen Code
BIRTHDATE="Jan 1, 2000"
Presents=10
BIRTHDAY=$(date -d "$BIRTHDATE" +%A)

Testcode

if [ "$BIRTHDATE" == "Jan 1, 2000" ] ; then
    echo "BIRTHDATE ist korrekt, es ist $BIRTHDATE"
else
    echo "BIRTHDATE ist nicht korrekt"
fi
if [ $Presents == 10 ] ; then
    echo "Ich habe $Presents Geschenke bekommen."
else
    echo "Presents ist nicht korrekt"
fi
if [ "$BIRTHDAY" == "Saturday" ]||[ "$BIRTHDAY" == "Samstag" ] ; then
    echo "Ich wurde an einem $BIRTHDAY geboren."
else
    echo "BIRTHDAY ist nicht korrekt"
fi


# Verzweigung

#!/bin/bash

DATEI="daten.txt"

# Prüfen, ob die Datei existiert
if [ ! -e "$DATEI" ]; then
  echo "[FEHLER] Datei nicht vorhanden."
elif [ ! -r "$DATEI" ]; then
  echo "[WARNUNG] Datei existiert, aber ist nicht lesbar."
else
  # Wortanzahl in der Datei ermitteln
  WORTANZAHL=$(wc -w < "$DATEI")

  if [ "$WORTANZAHL" -lt 20 ]; then
    echo "[HINWEIS] Datei ist sehr klein."
  elif [ "$WORTANZAHL" -le 100 ]; then
    echo "[OK] Datei hat akzeptable Grösse."
  else
    echo "[ACHTUNG] Datei ist ungewöhnlich gross."
  fi
fi


# Schleifen

## Aufgabe 1

#!/bin/bash

NUMBERS=(951 402 984 651 360 69 408 319 601 485 980 507 725 547 544 615 83 165 141 501 263 617 865 575 219 39>
echo "Zahlen größer als 400:"
for zahl in "${NUMBERS[@]}"; do
  if [ "$zahl" -gt 400 ]; then
    echo "$zahl"
  fi
done 

## Aufgabe 2

#!/bin/bash

echo "Jede zweite IP-Adresse von 192.168.10.50 bis 192.168.10.70:"
for ((i=50; i<=70; i+=2)); do
  echo "192.168.10.$i"
done


# Beziehung mit Einschränkung (constraint) erstellen

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `tbl_Projekt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tbl_Projekt` ;

CREATE TABLE IF NOT EXISTS `tbl_Projekt` (
  `ID_Projekt` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(30) NOT NULL,
  `Budget` DECIMAL(10) NULL,
  `tbl_Projekt_ID_Projekt` INT NOT NULL,
  PRIMARY KEY (`ID_Projekt`),
  CONSTRAINT `fk_tbl_Projekt_tbl_Projekt`
    FOREIGN KEY (`tbl_Projekt_ID_Projekt`)
    REFERENCES `tbl_Projekt` (`ID_Projekt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_Projekt_tbl_Projekt_idx` ON `tbl_Projekt` (`tbl_Projekt_ID_Projekt` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `tbl_Fahrer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tbl_Fahrer` ;

CREATE TABLE IF NOT EXISTS `tbl_Fahrer` (
  `ID_Fahrer` INT NOT NULL,
  `Vorname` VARCHAR(30) NOT NULL,
  `Nachname` VARCHAR(30) NOT NULL,
  `Geb.datum` DATE NOT NULL,
  PRIMARY KEY (`ID_Fahrer`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tbl_Bus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tbl_Bus` ;

CREATE TABLE IF NOT EXISTS `tbl_Bus` (
  `ID_Bus` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(30) NOT NULL,
  `Kennzeichen` VARCHAR(30) NOT NULL,
  `Anzahl_Plätze` VARCHAR(30) NOT NULL,
  `tbl_Fahrer_ID_Fahrer` INT NOT NULL,
  PRIMARY KEY (`ID_Bus`),
  CONSTRAINT `fk_tbl_Bus_tbl_Fahrer1`
    FOREIGN KEY (`tbl_Fahrer_ID_Fahrer`)
    REFERENCES `tbl_Fahrer` (`ID_Fahrer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_Bus_tbl_Fahrer1_idx` ON `tbl_Bus` (`tbl_Fahrer_ID_Fahrer` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `tbl_Ausweis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tbl_Ausweis` ;

CREATE TABLE IF NOT EXISTS `tbl_Ausweis` (
  `ID_Ausweis` INT NOT NULL,
  `Nummer` VARCHAR(30) NULL,
  `Art` INT NULL,
  `tbl_Fahrer_ID_Fahrer` INT NOT NULL,
  PRIMARY KEY (`ID_Ausweis`),
  CONSTRAINT `fk_tbl_Ausweis_tbl_Fahrer1`
    FOREIGN KEY (`tbl_Fahrer_ID_Fahrer`)
    REFERENCES `tbl_Fahrer` (`ID_Fahrer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_Ausweis_tbl_Fahrer1_idx` ON `tbl_Ausweis` (`tbl_Fahrer_ID_Fahrer` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `tbl_Passagier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tbl_Passagier` ;

CREATE TABLE IF NOT EXISTS `tbl_Passagier` (
  `ID_Passagier` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(30) NOT NULL,
  `Platznummer` VARCHAR(30) NULL,
  `tbl_Bus_ID_Bus` INT NOT NULL,
  PRIMARY KEY (`ID_Passagier`),
  CONSTRAINT `fk_tbl_Passagier_tbl_Bus1`
    FOREIGN KEY (`tbl_Bus_ID_Bus`)
    REFERENCES `tbl_Bus` (`ID_Bus`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_Passagier_tbl_Bus1_idx` ON `tbl_Passagier` (`tbl_Bus_ID_Bus` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

**Wie wird beim Fremdschlüssel der Constraint NOT NULL erstellt?**

- CREATE TABLE Bestellung (
    BestellungID INT PRIMARY KEY,
    KundeID INT NOT NULL, -- Fremdschlüssel darf nicht leer sein
    FOREIGN KEY (KundeID) REFERENCES Kunde(KundeID)
);
**Weshalb wird für jeden Fremdschlüssel ein Index erstellt? Lesen Sie hier!**

Ein Index hilft der Datenbank, schneller zu arbeiten.
Bei Fremdschlüsseln braucht man das, damit:
 
- die Daten schneller gefunden werden (z. B. bei JOINs),
 
- die Verbindung zur anderen Tabelle geprüft werden kann.

**Wie wird der Constraint UNIQUE für einen Fremdschlüssel im Workbench mit Forward Engineering erstellt?**

CREATE TABLE Dozent (
    DozentID INT PRIMARY KEY,
    StudiengangID INT UNIQUE,  -- UNIQUE Constraint
    FOREIGN KEY (StudiengangID) REFERENCES Studiengang(StudiengangID)
);

man muss es beim erstellen der neuen Constraint einstellen

**Beachte: Jede Beziehung wird auch mit einer Beziehungs-Überprüfung (Constraint ...) versehen. Erstellen Sie eine allgemeine Syntax für die CONSTRAINT-Anweisung.**

CONSTRAINT fk_kunde
FOREIGN KEY (kunden_id)
REFERENCES kunde(kunden_id)

**Was geschieht, wenn Sie bei der 1:mc Beziehung tbl_Ausweis den FS-Wert NULL eingeben? Oder einen FS-Wert, der als PK-Wert nicht existiert?**
 
FK_Inhaber = NULL:
Nicht erlaubt, weil das Feld NOT NULL ist im SQL-Skript. Du musst einen Fahrer angeben.
 
FK_Inhaber = 9999:
Fehler! Fremdschlüssel-Verletzung, weil kein Fahrer mit ID 9999 existiert.
 
**Fügen Sie ein paar Daten in die Tabellen tbl_Projekt ein. Möglich? Was müsste gändert werden? (Tipp siehe Tag 3 rekursive Beziehung)**
 
Es funktioniert nicht wegen rekursive Beziehungungen. = auf sich selbst bezieht
 
Lösung: Auf NULL setzen also:
-- Hauptprojekt (kein Parent, darum NULL)
INSERT INTO tbl_Projekt (Bezeichnung, Budget, tbl_Projekt_ID_Projekt)
VALUES ('Hauptprojekt', 50000, NULL);
 

### Know How
 
| Symbol  | Bedeutung           | Beispiel    | Erklärung                                                           |
|---------|---------------------|-------------|----------------------------------------------------------------------|
| ∈       | Element einer Menge | a ∈ A       | a ist ein Element der Menge A                                       |
| ∉       | Nicht in Menge      | b ∉ B       | b ist **nicht** in der Menge B                                      |
| {} / Ø  | Leere Menge          | A = {}      | A enthält keine Elemente                                            |
| ⊂ / ⊆   | Teilmenge           | B ⊂ A       | Alle Elemente von B sind auch in A                                  |
| ∩       | Schnittmenge        | A ∩ B       | Nur die **gemeinsamen** Elemente von A und B                        |
| ∪       | Vereinigungsmenge   | A ∪ B       | Alle Elemente aus A **oder** B (doppelte zählen nur einmal)         |
| Aᶜ      | Komplementärmenge   | Aᶜ          | Alles aus der Grundmenge G, was **nicht** in A ist                  |
| \       | Differenzmenge      | B \ A       | Alle Elemente in B, die **nicht** in A sind                         |

---

### Aufgabe 1: Teilmengen beurteilen

Gegeben:

- A = {c, e, z, r, d, g, u, x}  
- B = {c, e, g}  
- C = {r, d, g, t}  
- D = {e, z, u}  
- E = {z, r, u}  

**Aussagen:**

a) **B ⊂ A**  
Richtig – Alle Elemente von B sind in A enthalten.

b) **C ⊂ A**  
 Falsch – Das Element **t** ist nicht in A.

c) **E ⊂ A**  
 Richtig – Alle Elemente von E sind in A enthalten.

d) **B ⊂ C**  
 Falsch – **e** ist in B, aber nicht in C.

e) **E ⊂ C**  
 Falsch – **z** ist in E, aber nicht in C.

---

### Aufgabe 2: Mengenoperationen

Gegeben:

- A = {1, 2, 3, 4, 5}  
- B = {2, 5}  
- C = {3, 5, 7, 9}

**Berechnungen:**

a) **A ∩ B**  
= {2, 5} – Schnittmenge: gemeinsame Elemente von A und B.

b) **A ∪ C**  
= {1, 2, 3, 4, 5, 7, 9} – Vereinigungsmenge ohne doppelte Werte.

c) **Bᶜ** (ergänzt zu A)  
= {1, 3, 4, 7, 9} – Elemente in A, die nicht in B sind, plus fremde Elemente aus C.

d) **B \ C**  
= {2} – Elemente in B, die nicht in C sind.

e) **C \ B**  
= {3, 7, 9} – Elemente in C, die nicht in B sind.

---

### Aufgabe 3: Eigene Mengenbeispiele

#### ⊂ (Teilmenge)

**Brettspiele ⊂ Spiele**  
Alle Brettspiele sind Spiele, aber nicht alle Spiele sind Brettspiele.

---

#### ∩ (Schnittmenge)

- Nahrung = {Pizza, Apfel, Brot}  
- Lieblingsessen = {Pizza, Burger, Pasta}  
- **Nahrung ∩ Lieblingsessen** = {Pizza}

---

#### ∪ (Vereinigungsmenge)

- Konsolen = {PS5, Xbox, Switch}  
- PC-Spiele = {Valorant, Minecraft, GTA}  
- **Konsolen ∪ PC-Spiele** = {PS5, Xbox, Switch, Valorant, Minecraft, GTA}

---

#### \ (Differenz)

- Haustiere = {Hund, Katze, Papagei}  
- Tiere mit Fell = {Hund, Katze}  
- **Haustiere \ Tiere mit Fell** = {Papagei}
