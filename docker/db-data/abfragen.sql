
-- betrachte 5min bereich, aber taste aller 3min im bot ab
select b.TerminSchichtID, tt.`name`, b.genauertermin from Termin as t, TerminTyp as tt, (
	select TerminSchicht.TerminSchichtID, TerminSchicht.TerminID, ADDTIME(Termin.Datum, Schicht.Beginn) as genauertermin
	FROM TerminSchicht
	left join Termin on TerminSchicht.TerminID = Termin.TerminID
	left join Schicht on TerminSchicht.SchichtID = Schicht.SchichtID
	where ADDTIME(Termin.Datum, Schicht.Beginn) >= ADDTIME(        NOW(), "13 00:45:00")
	and   ADDTIME(Termin.Datum, Schicht.Beginn) <  ADDTIME(ADDTIME(NOW(), "13 00:45:00"), "00:05:00")
	order by genauertermin ASC
) as b
where b.TerminID = t.TerminID and tt.TerminTypID = t.TerminTypID
-- resultat :
-- terminschichtid, name     , genauertermin
-- 4              , afterwork, 2018-04-09 19:00:00

-- finde die nächste schicht für einen slacknutzer
SELECT TerminTyp.Name, ADDTIME(Termin.Datum, Schicht.Beginn) as genauertermin
FROM (	SELECT terminschichtid from NutzerSchicht
		where NutzerID = (SELECT nutzerid from SlackNutzer where SlackNutzerID = "U7L1UA484")	) as ns
left join TerminSchicht on TerminSchicht.terminschichtid = ns.terminschichtid
left join Schicht on TerminSchicht.SchichtID = Schicht.SchichtID
left join Termin on Termin.terminid = TerminSchicht.terminid
left join TerminTyp on TerminTyp.TerminTypID = Termin.TerminTypID
where ADDTIME(Termin.Datum, Schicht.Beginn) >= NOW()
order by genauertermin ASC
LIMIT 1







select Schicht.Beginn, Termin.Datum
FROM TerminSchicht
left join Termin on TerminSchicht.TerminID = Termin.TerminID
left join Schicht on TerminSchicht.SchichtID = Schicht.SchichtID
where datum = DATE("2018-04-09")


select Schicht.Beginn, Termin.Datum
FROM TerminSchicht
left join Termin on TerminSchicht.TerminID = Termin.TerminID
left join Schicht on TerminSchicht.SchichtID = Schicht.SchichtID
order by Termin.Datum ASC, Schicht.Beginn ASC
where datum = DATE("2018-04-09")
