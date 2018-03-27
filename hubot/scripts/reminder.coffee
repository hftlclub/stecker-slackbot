mysql = require 'mysql'

module.exports = (robot) ->
  vorlauf="12 23:55:00" # 13d + 45min

  url = process.env.MYSQL_URL
  conn = mysql.createConnection(url)

  room = "C8E616MD5" #roomid
  robot.messageRoom room, 'Der Erinnerungsbot ist gestartet worden.'

  letzteterminschichtid=[]

  conn.connect (err) ->
    if err?
      robot.logger.info "Error\n#{err}"
    else
      robot.logger.info "connected to mysql"

      setInterval () ->
        remind()
        robot.messageRoom room, "checke DB"
        robot.logger.info "geht"
      , 3*5*1000                        # aller 3min 3*60*1000

  remind = ->
    conn.query "select b.TerminSchichtID, tt.`name`, b.genauertermin from Termin as t, TerminTyp as tt, (	select TerminSchicht.TerminSchichtID, TerminSchicht.TerminID, ADDTIME(Termin.Datum, Schicht.Beginn) as genauertermin	FROM TerminSchicht	left join Termin on TerminSchicht.TerminID = Termin.TerminID	left join Schicht on TerminSchicht.SchichtID = Schicht.SchichtID	where ADDTIME(Termin.Datum, Schicht.Beginn) >= ADDTIME(        NOW(), '#{vorlauf}')	and   ADDTIME(Termin.Datum, Schicht.Beginn) <  ADDTIME(ADDTIME(NOW(), '#{vorlauf}'), '00:05:00')	order by genauertermin ASC) as b where b.TerminID = t.TerminID and tt.TerminTypID = t.TerminTypID;", (err, rows) ->
      if err
        robot.logger.info err
      else
        if rows.length > 0
          robot.logger.info rows
          for r in rows
            terminschichtid=r.TerminSchichtID # 4
            terminname=r.name                 # Afterwork
            beginn=r.genauertermin            # 2018-04-09 19:00:00
            if terminschichtid not in letzteterminschichtid
              robot.messageRoom room, "Erinnerung an alle für den nächsten Termin: #{terminname} #{beginn}"
            letzteterminschichtid.push terminschichtid
        else
          letzteterminschichtid=[]

