mysql = require 'mysql'

module.exports = (bot) ->
	url = process.env.MYSQL_URL
	table = "termine"
	conn = mysql.createConnection(url)

	conn.connect (err) ->
		if err?
			bot.logger.info "Error\n#{err}"
		else
			bot.logger.info "connected to mysql"


	################ Text Listener
	bot.hear /wie bedient man den bot/i, (res) ->
		res.send "es gibt noch keine hilfe"

	bot.hear /^\s*hilfe\s*/i, (res) ->
		res.reply "du bist verloren"

	bot.hear /erstelle\s+sitzung\s+(.+)\s+am\s+(.+)\s+um\s+(\d\d:\d\d)/i, (res) ->
		erstellesitzung res.match[2],res.match[3],res.match[1],(r) ->
			if r
				bot.reply "Die Sitzung wurde angelegt"
				bot.reply "#{res.match[1]} #{res.match[2]} #{res.match[3]}"
			else
				bot.reply "Fehler: der Termin konnte nicht erstellt werden"
		bot.logger.info res.match[1],res.match[2],res.match[3]

	bot.hear /wer nimmt alles an termin (.*) teil/i, (res) ->
		bot.logger.info "noch nicht implementiert"

	################ Command Listener
	bot.respond /hilfe/i, (res) ->
		res.reply "die hilfe ist nur für dich"

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


	erstellesitzung = (datum, zeit, name, callback) ->
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
