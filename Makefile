.PHONY = all clean

PDFLATEX = xelatex

all: rfcs.pdf

clean:
	$(RM) *.pdf rfcs.bib rfc-index.txt

rfc-index.txt:
	wget -q http://www.rfc-editor.org/rfc/rfc-index.txt

rfcs.bib: rfc-index.txt
	gawk -f rfc2bib.awk -- rfc-index.txt >| rfcs.bib

%.pdf: %.tex %.bib
	$(PDFLATEX) $*
	-bibtex $*
	-for f in *.aux; do bibtex $${f#.aux} ; done
	if [ -e $*.toc ] ; then $(PDFLATEX) $* ; fi
	if [ -e $*.bbl ] ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi
	$(RM) *.aux *.log *.bbl *.blg *.toc *.dvi *.out
