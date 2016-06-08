.PHONY = all clean

LATEX = latexmk -xelatex

all: rfcs.pdf ids.pdf

clean:
	$(LATEX) -C
	$(RM) rfcs.bib rfcs.bbl rfcs.run.xml
	$(RM) ids.bib ids.bbl ids.run.xml
	$(RM) -r auto

rfcs.bib:
	./rfc2bib >| rfcs.bib

ids.bib:
	./id2bib >| ids.bib

%.pdf: %.tex %.bib
	$(LATEX) $*
