INSERT INTO Nutzer (Name) VALUES ("Max Mustermann");
INSERT INTO Nutzer (Name) VALUES ("Dieter Schnürschuh");
INSERT INTO Nutzer (Name) VALUES ("Klaus Knarre");
INSERT INTO Nutzer (Name) VALUES ("Paula Panzer");
INSERT INTO Nutzer (Name) VALUES ("Donald Duck");
INSERT INTO Nutzer (Name) VALUES ("Bogdan Raczynski");

INSERT INTO TerminTyp (Name) VALUES ("Sitzung");
INSERT INTO TerminTyp (Name) VALUES ("Afterwork");
INSERT INTO TerminTyp (Name) VALUES ("Weihnachtsfeier");
INSERT INTO TerminTyp (Name) VALUES ("Sommerfest");

INSERT INTO Schicht (Beginn, Ende, Teilnehmerzahl) VALUES (TIME("19:00"), TIME("21:00"), (select count(*) from Nutzer));
INSERT INTO Schicht (Beginn, Ende, Teilnehmerzahl) VALUES (TIME("21:00"), TIME("23:00"), 2);
INSERT INTO Schicht (Beginn, Ende, Teilnehmerzahl) VALUES (TIME("18:00"), TIME("23:00"), 10);
INSERT INTO Schicht (Beginn, Ende, Teilnehmerzahl) VALUES (TIME("13:00"), TIME("17:00"), 2);
INSERT INTO Schicht (Beginn, Ende, Teilnehmerzahl) VALUES (TIME("17:00"), TIME("04:00"), 2);


insert into Termin (TerminTypID, Datum, Beschreibung) 	values ((Select TerminTypID from TerminTyp where Name = "Sommerfest"), DATE("2018-04-08"), "Sommerfest 2018");
insert into Termin (TerminTypID, Datum, Beschreibung) 	values ((Select TerminTypID from TerminTyp where Name = "Sitzung"), DATE("2018-04-09"), "Vollversammlung");
insert into Termin (TerminTypID, Datum) 				values ((Select TerminTypID from TerminTyp where Name = "Afterwork"), DATE("2018-04-09"));
insert into Termin (TerminTypID, Datum) 				values ((Select TerminTypID from TerminTyp where Name = "Afterwork"), DATE("2018-04-10"));
insert into Termin (TerminTypID, Datum, Beschreibung) 	values ((Select TerminTypID from TerminTyp where Name = "Weihnachtsfeier"), DATE("2018-04-11"), "zusammen mit Stura");



insert into TerminSchicht (SchichtID, TerminID) values (
	(select schichtid from Schicht where beginn = TIME("13:00")),
    (select terminid from Termin where datum = date("2018-04-08")));
insert into TerminSchicht (SchichtID, TerminID) values (
	(select schichtid from Schicht where beginn = TIME("17:00")),
    (select terminid from Termin where datum = date("2018-04-08")));
insert into TerminSchicht (SchichtID, TerminID) values (
	(select schichtid from Schicht where beginn = TIME("13:00")),
    (select terminid from Termin where datum = date("2018-04-09") and termintypid = (select termintypid from TerminTyp where name = "Sitzung")));
insert into TerminSchicht (SchichtID, TerminID) values (
	(select schichtid from Schicht where beginn = TIME("19:00")),
    (select terminid from Termin where datum = date("2018-04-09") and termintypid = (select termintypid from TerminTyp where name = "Afterwork")));
insert into TerminSchicht (SchichtID, TerminID) values (
	(select schichtid from Schicht where beginn = TIME("21:00")),
    (select terminid from Termin where datum = date("2018-04-09") and termintypid = (select termintypid from TerminTyp where name = "Afterwork")));
insert into TerminSchicht (SchichtID, TerminID) values (
	(select schichtid from Schicht where beginn = TIME("19:00")),
    (select terminid from Termin where datum = date("2018-04-10") and termintypid = (select termintypid from TerminTyp where name = "Afterwork")));
insert into TerminSchicht (SchichtID, TerminID) values (
	(select schichtid from Schicht where beginn = TIME("21:00")),
    (select terminid from Termin where datum = date("2018-04-10") and termintypid = (select termintypid from TerminTyp where name = "Afterwork")));
insert into TerminSchicht (SchichtID, TerminID) values (
	(select schichtid from Schicht where beginn = TIME("18:00") and ende = TIME("23:00")),
    (select terminid from Termin where datum = date("2018-04-11") and termintypid = (select termintypid from TerminTyp where name = "Weihnachtsfeier")));



insert into NutzerSchicht (terminschichtid, nutzerid) values (
	(select terminschichtid from TerminSchicht where
		schichtid = (select schichtid from Schicht where beginn = TIME("13:00")) and 
        terminid  = (select terminid  from Termin  where datum = date("2018-04-08") and termintypid = (select termintypid from TerminTyp where name = "Sommerfest"))),
	(select nutzerid from Nutzer where name = "Max Mustermann"));
insert into NutzerSchicht (terminschichtid, nutzerid) values (
	(select terminschichtid from TerminSchicht where schichtid = (select schichtid from Schicht where beginn = TIME("13:00")) and terminid = 1),
	(select nutzerid from Nutzer where name = "Dieter Schnürschuh"));



