
-- databases
CREATE DATABASE db;
USE db;

-- tables
-- Table: Nutzer
CREATE TABLE Nutzer (
    NutzerID int NOT NULL,
    Name varchar(255) NOT NULL,
    CONSTRAINT Nutzer_pk PRIMARY KEY (NutzerID)
);

-- Table: NutzerSchicht
CREATE TABLE NutzerSchicht (
    NutzerSchichtID int NOT NULL,
    TerminSchichtID int NOT NULL,
    CONSTRAINT NutzerSchicht_pk PRIMARY KEY (NutzerSchichtID,TerminSchichtID)
);

-- Table: Schicht
CREATE TABLE Schicht (
    SchichtID int NOT NULL,
    Beginn time NOT NULL,
    Ende time NOT NULL,
    Teilnehmerzahl int NOT NULL,
    CONSTRAINT Schicht_pk PRIMARY KEY (SchichtID)
);

-- Table: SlackNutzer
CREATE TABLE SlackNutzer (
    SlackNutzerID varchar(255) NOT NULL,
    NutzerID int NOT NULL,
    CONSTRAINT SlackNutzer_pk PRIMARY KEY (SlackNutzerID)
);

-- Table: Termin
CREATE TABLE Termin (
    TerminID int NOT NULL,
    TypID int NOT NULL,
    Name varchar(255) NOT NULL,
    Datum date NOT NULL,
    CONSTRAINT Termin_pk PRIMARY KEY (TerminID)
);

-- Table: TerminSchicht
CREATE TABLE TerminSchicht (
    TerminSchichtID int NOT NULL,
    SchichtID int NOT NULL,
    TerminID int NOT NULL,
    CONSTRAINT TerminSchicht_pk PRIMARY KEY (TerminSchichtID)
);

-- Table: TerminTyp
CREATE TABLE TerminTyp (
    TerminTypID int NOT NULL,
    Name varchar(255) NOT NULL,
    CONSTRAINT TerminTyp_pk PRIMARY KEY (TerminTypID)
);

-- foreign keys
-- Reference: Nutzerschicht_Nutzer (table: NutzerSchicht)
ALTER TABLE NutzerSchicht ADD CONSTRAINT Nutzerschicht_Nutzer FOREIGN KEY Nutzerschicht_Nutzer (NutzerSchichtID)
    REFERENCES Nutzer (NutzerID);

-- Reference: Nutzerschicht_Terminschicht (table: NutzerSchicht)
ALTER TABLE NutzerSchicht ADD CONSTRAINT Nutzerschicht_Terminschicht FOREIGN KEY Nutzerschicht_Terminschicht (TerminSchichtID)
    REFERENCES TerminSchicht (TerminSchichtID);

-- Reference: Slacknutzer_Nutzer (table: SlackNutzer)
ALTER TABLE SlackNutzer ADD CONSTRAINT Slacknutzer_Nutzer FOREIGN KEY Slacknutzer_Nutzer (NutzerID)
    REFERENCES Nutzer (NutzerID);

-- Reference: Termin_TerminTyp (table: Termin)
ALTER TABLE Termin ADD CONSTRAINT Termin_TerminTyp FOREIGN KEY Termin_TerminTyp (TypID)
    REFERENCES TerminTyp (TerminTypID);

-- Reference: Termin_Terminschicht (table: TerminSchicht)
ALTER TABLE TerminSchicht ADD CONSTRAINT Termin_Terminschicht FOREIGN KEY Termin_Terminschicht (TerminID)
    REFERENCES Termin (TerminID);

-- Reference: Terminschicht_Schicht (table: TerminSchicht)
ALTER TABLE TerminSchicht ADD CONSTRAINT Terminschicht_Schicht FOREIGN KEY Terminschicht_Schicht (SchichtID)
    REFERENCES Schicht (SchichtID);

-- End of file.

