mysql = require 'mysql'

module.exports = (bot) ->
	url = process.env.MYSQL_URL
	conn = mysql.createConnection(url)

	conn.connect (err) ->
		if err?
			bot.logger.info "Error\n#{err}"
		else
			bot.logger.info "connected to mysql"


	################ Text Listener
	bot.hear /wie bedient man den bot/i, (res) ->
		hilfe res
		#res.send "es gibt noch keine hilfe"

	bot.hear /^\s*hilfe\s*/i, (res) ->
		hilfe res
		#res.reply "du bist verloren"

	bot.hear /erstelle\s+sitzung\s+(.+)\s+am\s+(.+)\s+um\s+(\d\d:\d\d)\s+bis(\d\d:\d\d)/i, (res) ->
		erstellesitzung res.match[2],res.match[3],res.match[4],res.match[1],(r) ->
			if r
				bot.reply "Die Sitzung wurde angelegt"
				bot.reply "#{res.match[1]} #{res.match[2]} #{res.match[3]}"
			else
				bot.reply "Fehler: der Termin konnte nicht erstellt werden"
		bot.logger.info res.match[1],res.match[2],res.match[3]

	bot.hear /wer nimmt alles an termin (.*) teil/i, (res) ->
		bot.logger.info "noch nicht implementiert"

	################ Command Listener
	# ANLEGE-BEFEHLE
	bot.respond /füge mich der Datenbank hinzu als (.*)/i, (res) ->
		SlackNutzerID = res.envelope.user.id
		Nutzername = res.match[1]
		bot.logger.info res.envelope.user.real_name + " wird zur DB hinzugefügt"
		conn.query "INSERT INTO SlackNutzer (SlackNutzerID, NutzerID) VALUES ('#{SlackNutzerID}', (SELECT NutzerID FROM Nutzer WHERE Name = '#{Nutzername}'))", (err, row) ->
			if err
				bot.logger.error "ERROR " + err
				res.reply "Es ist etwas schief gelaufen :("
				#res.reply err
			if row
				bot.logger.info row
				res.reply res.envelope.user.real_name + " wurde in die Datenbank als " + Nutzername + " eingefügt"

	bot.respond /erstelle termintyp (.*)/i, (msg) ->
		termintyp = msg.match[1]
		conn.query "insert into TerminTyp (Name) VALUES ('#{termintyp}')", (err, row) ->
			if err
				msg.reply "Der Termintyp konnte nicht angelegt werden. " + err
			else
				msg.reply "Der Termintyp wurde angelegt."

	bot.respond /erstelle termin (.*) mit typ (.*) am (\d\d\d\d-\d\d-\d\d)/i, (msg) ->
		termin = msg.match[1]
		termintyp = msg.match[2]
		datum = msg.match[3]
		conn.query "insert into Termin (TerminID, TypID, Name, Datum) values (3, 1, '#{termin}', date('#{datum}'))", (err, row) ->
			if err
				bot.logger.info err
				bot.reply "Der Termin konnte nicht angelegt werden."
			else
				bot.logger.info "Termin angelegt"
				bot.reply "Der Termin wurde angelegt."

	# ANZEIGE-BEFEHLE
	bot.respond /zeige Schicht/i, (res) ->
		Slacknutzer = res.envelope.user.id
		conn.query "SELECT TerminTyp.Name, ADDTIME(Termin.Datum, Schicht.Beginn) as genauertermin FROM (	SELECT terminschichtid from NutzerSchicht where NutzerID = (SELECT nutzerid from SlackNutzer where SlackNutzerID = '#{Slacknutzer}')	) as ns left join TerminSchicht on TerminSchicht.terminschichtid = ns.terminschichtid left join Schicht on TerminSchicht.SchichtID = Schicht.SchichtID left join Termin on Termin.terminid = TerminSchicht.terminid left join TerminTyp on TerminTyp.TerminTypID = Termin.TerminTypID where ADDTIME(Termin.Datum, Schicht.Beginn) >= NOW() order by genauertermin ASC LIMIT 1", (err, rows) ->
			if err or rows.length == 0
				bot.logger.info "Datenbankabfrage schlug fehl."
				res.reply "Das hat nicht geklappt."
			else
				if rows.length > 1
					res.reply "Es dürfte nur die nächste Schicht zurückkommen."
				else
					name=rows[0].Name
					genauertermin=rows[0].genauertermin
					res.reply "Als nächstes steht für dich folgendes an: #{name} #{genauertermin}"

	bot.respond /hilfe/i, (res) ->
		hilfe res

	bot.respond /nehme an Termin (.*) teil/i, (res) ->
		termin = res.match[1]
		user = "username"
		conn.query "INSERT INTO terminteilnehmer (termin, user) VALUES ('#{termin}', '#{user}')", (err, response) ->
			bot.logger.info "INSERT Teilnehmer: #{user}, Termin: #{termin}"
			if err
				bot.logger.info "ERROR"
				bot.logger.info err
				res.reply "es ist etwas schief gelaufen :("
			else
				if response
					bot.logger.info response
					res.reply "ich habe dich für Termin #{termin} eingetragen"

	bot.respond /datenbank/i, (res) ->
		conn.query "SELECT * FROM `termine` WHERE `id`=1", (err, rows) ->
            if err or rows.length == 0
                bot.logger.info "tabelle leer oder keine daten bekommen"
            else
                bot.logger.info "tabelle termine id 1"
                bot.logger.info rows[0]
                res.reply rows[0].id
	
	bot.respond /store/i, (res) ->
		store ("termin bla")
		res.reply "fertig"

	store = (name) ->
		conn.query "INSERT INTO termine (name) VALUES ('#{name}')", (err, response) ->
			bot.logger.info "INSERT IN DB"
			if err
				bot.logger.info "ERROR"
				bot.logger.info err
			if response
				bot.logger.info response

	load = (id) ->
		conn.query "SELECT * FROM `termine` WHERE `id`=#{id}", (err, rows) ->
			if err or rows.length == 0
				bot.logger.info "tabelle leer oder keine daten bekommen"
			else
				bot.logger.info "tabelle termine id #{id}"
				bot.logger.info rows[0]
				loaded (rows[0])


	erstellesitzung = (datum, zeit, ende, name, callback) ->
		conn.query 'select id from termintyp where name = "Sitzung"', (err, response) ->
			if err
				bot.logger.info "ERROR bei Abfrage des Termintyps Sitzung"
				bot.logger.info err
			else
				if response.length > 1
					bot.logger.info "ERROR mehr als eine Sitzung gefunden"
				else
					bot.logger.info response[0]
					bot.logger.info "Die TermintypID ist #{response[0].id}"
					id = response[0].id
					conn.query "INSERT INTO termine (name, datum, typ) VALUES ('#{name}', STR_TO_DATE('#{datum}', '%d.%m.%Y'), '#{id}')", (err, response) ->
						bot.logger.info "INSERT für Sitzung"
						if err
							bot.logger.info "ERROR"
							bot.logger.info err
							callback false
						if response
							bot.logger.info response
							bot.logger.info "Termin erstellt für #{datum} #{name} #{id}"
							callback true
	hilfe = (res) ->
		res.reply "die hilfe ist nur für dich"
