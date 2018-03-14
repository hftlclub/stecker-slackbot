# Masterprojekt
## Methoden
* Idee: huBot, siehe https://hubot.github.com/
* iCal-feed mit huBot parsen?
* 30 Seiten oder so + Ausblick
* DB mit Veranstaltungen + Zuweisungen von Pers-Slack
* doodle mit Diensten ist vorhanden
* Fokus muss auf Bot liegen, Datenquelle ist egal
* Tracken wer wieviele Dienste macht
* Bot für Erinnerung und Abfrage
* Erinnerung immer Anfang der Woche automatisch (Veranstaltungen und Dienste)
* Erinnerung: vor Veranstaltung öffentlich 1h vorher "jetzt ist dienst an person" (soll alles konfigurierbar sein, also alle oder nur betreffende informieren, zeit vorher)
* Abfrage: manuelles Anstoßen von "schick rum wer morgen dienst hat" (ohne berechtigungszeugs erstmal), persönliche Abfrage "wann hab ich dienst"

## Ziele
* Einfache Bedienbarkeit wichtig, so dass es sich jeder merken kann
* Rahmen ist wichtiger als Endprodukt
* NodeJS + TS (alles was eingebunden wird soll über npm kommen und MIT-lizenz haben)
* Optionen für E-Mail oder andere Systeme offen halten
* db-Verbindung darf die ganze zeit offen bleiben (SQL)

## Mensatreff 12.12.2017:
* Docker-compose für Dev-Env - check
* DB-Server vorhanden - Daten generisch halten + dokumentieren, ggf. extra Tabellen für Bot (z.B. Mapping Wort-Datensatz)
* Redis-Cache? Geschwindigkeit - check
* install/backup-Skripts + Strategie - Betrachtung in Doku reicht
* Coffeescript vs. Typescript? -  ~ToDo~
* Netzwerkkonfig/Ports? - Doppel-NAT, HTTP-Ports 80, 443 über vHosts
* Sicherheitsbedenken - keine
* Termin-API/Datenmodell - normalisiert, siehe Aufgabenstellung
* E-Mail an Bots als extra Schnittstelle? - möglich, in Zukunft
* Berechtigungsstruktur/Nutzerrollen? - Status von Ferdi
* "Besoffen bedienbar", Zielgruppe: Informatiker, aber auch Lehrer

## Gespräch mit Prof. Frank am 14.04.2018
* Dienstplan aus Doodle? Geht das? Ja, mittels ~CSV~ Excel-Export
* kein Berechtigungskonzept kann funktionieren..auch in größeren Umgebungen
* Demnächst: Code fertig machen, dann wird's schick
* Abgabe: CD mit Code + PDF, dann Abnahme mit Prof. Frank
* Link: Youtube - die Reise nach Rossa
* Nächster Termin: vor Ostern, Abnahme, davor Doku + Code schicken
* TODOS:
    * Entscheidungsbaum für Konversationen, Havariefälle [ ] <- Aktivitäsdiagramme, überarbeiten
    * S.11 Sichten zu Schichten ändern [x]
    * Nach Doppelpunkt Großschreibung [x]
    * DB: Nutzernamen eindeutig, werden von Admin eingetragen [x]
    * Doku ganz gut, reicht so aus. Wenn Steckerteam zufrieden [ ]
    * Aufwandsabschätzung für Slack-Panel o.ä. [ ]
    * Evtl. Fragen zur IT-Sicherheit, einzuhaltende Sicherheitsaspekte, z.B. SQL-Injektion [ ]
    * Absicherung gegen DB-Angriffe mittels RegEx [x]

## Nützliche Links
* [Redis Tutorial](http://www.try.redis.io)
* [Resources for Slack Bots](https://www.botwiki.org/resources/slackbots/)
* [Slack App Testing](https://slackapi.github.io/steno/)
