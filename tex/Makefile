# Beschreibung:	Makefile fuer ein LaTeX Projekt
# Autor:				Sebastian Stein <seb.stein@hpfsc.de>
# Datum:				2004/03/03 22:07:00 Mit

# http://latex.hpfsc.de/content/latex_tutorial/makefile/
# legt das Suffix der zentralen tex Datein fest, also z. B. index.tex
#
# In dieser Datei werden alle Einstellungen fuer das Projekt vorgenommen.
# Weiterhin werden in dieser Datei die einzelnen Kapitel in der richtigen
# Reihenfolge reingehaengt. Fuer jedes Kapitel sollte eine eigene tex Datei
# angelegt werden.
#
# Beispiel: ZENTRAL_TEX = index
ZENTRAL_TEX = main
FINAL_NAME = masterprojekt_steckerbot.pdf
MAKE = make


all:
	latexmk -pdf -shell-escape $(ZENTRAL_TEX).tex

final:
	latexmk -pdf -shell-escape $(ZENTRAL_TEX).tex
	cp $(ZENTRAL_TEX).pdf $(FINAL_NAME)

# RTF erstellen
rtf:
	latex2rtf $(ZENTRAL_TEX).tex

# Index/Stichwortverzeichnis erstellen
stichwort:
	$(MAKE) index

# Glossar erstellen
glossar:
	makeindex $(ZENTRAL_TEX).glo -s nomencl.ist -o $(ZENTRAL_TEX).gls

# HTML mittels latex2html erzeugen
html:
	echo "\usepackage{ngerman}" > l2h.tex
	latex2html -noinfo -image_type png -accent_images png -show_section_numbers -dir html -mkdir -up_url "../index.html" -up_title "Zur Startseite" -local_icons index.tex
	./tidy.sh
	rm html/*.pl
	rm html/images.*
	rm html/WARNINGS
	cat html/index.html | sed -e "s/oliver.friedrich@stud.htwk-leipzig.de/oliver.friedrich-AT-stud.htwk-leipzig.de/" > html/tmp
	mv html/tmp html/index.html
	echo "" > l2h.tex

# alle Dateien loeschen, die von latex automatisch erzeugt werden;
clean:
	latexmk -C
	rm -Rf html/

# fuehrt aspell auf alle tex Dateien ausser auf die zentrale tex Datei, da dort
# hauptsaechlich tex Befehle sind und aspell nur viele Falschwarnungen
# produziert
aspell:
	@liste=`ls *.tex`; \
	for tex in $$liste;  \
	do  \
		if [ $$tex != "$(ZENTRAL_TEX).tex" ]; then  \
			echo "aspell -t -x -c $$tex" ;  \
			aspell -t -x -c $$tex ; \
		fi ; \
	done

# ruft die Rechtschreibpruefung durch aspell auf
spell:
	$(MAKE) aspell

# ruft die Rechtschreibpruefung durch aspell auf
rechtschreibung:
	$(MAKE) aspell
