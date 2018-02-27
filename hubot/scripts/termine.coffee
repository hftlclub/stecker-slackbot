mysql = require 'mysql'

module.exports = (bot) ->
	url = process.env.MYSQL_URL
	table = "termine"
	conn = mysql.createConnection(url)

	# Text Listener
	bot.hear /wie bedient man den bot/i, (res) ->
		res.send "es gibt noch keine hilfe"

	bot.hear /^\s*hilfe\s*/i, (res) ->
		res.reply "du bist verloren"

	# Command Listener
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

	conn.connect (err) ->
		if err?
			bot.logger.info "Error\n#{err}"
			bot.logger.info "lalala #{url}"
		else
			bot.logger.info "connected to mysql"


