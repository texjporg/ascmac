STRIPTARGET = tascmac.sty
DOCTARGET = ascmac
PDFTARGET = $(addsuffix .pdf,$(DOCTARGET))
DVITARGET = $(addsuffix .dvi,$(DOCTARGET))
KANJI = -kanji=utf8
FONTMAP = -f ipaex.map -f ptex-ipaex.map
TEXMF = $(shell kpsewhich -var-value=TEXMFHOME)

default: $(STRIPTARGET) $(DVITARGET)
strip: $(STRIPTARGET)
all: $(STRIPTARGET) $(PDFTARGET)

ASCMAC = tascmac.sty ascmac.sty

ASCMAC_SRC = ascmac.dtx

# for generating files, we use pdflatex incidentally.
# current packages contain ASCII characters only, safe enough
tascmac.sty: $(ASCMAC_SRC)
	rm -f $(ASCMAC)
	pdflatex ascmac.ins
	rm ascmac.log

ascmac.dvi: $(ASCMAC_SRC)
	rm -f platex.cfg
	platex $(KANJI) ascmac.dtx
	platex $(KANJI) ascmac.dtx
	rm ascmac.aux ascmac.log ascmac.toc

ascmac.pdf: ascmac.dvi
	dvipdfmx $(FONTMAP) $<

.PHONY: install clean cleanstrip cleanall cleandoc
install:
	mkdir -p ${TEXMF}/doc/latex/ascmac
	cp ./LICENSE ${TEXMF}/doc/latex/ascmac/
	cp ./README.md ${TEXMF}/doc/latex/ascmac/
	cp ./*.pdf ${TEXMF}/doc/latex/ascmac/
	mkdir -p ${TEXMF}/fonts/source/public/ascmac
	cp ./*.mf ${TEXMF}/fonts/source/public/ascmac/
	mkdir -p ${TEXMF}/fonts/map/dvips/ascmac
	cp ./*.map ${TEXMF}/fonts/map/dvips/ascmac/
	mkdir -p ${TEXMF}/fonts/type1/public/ascmac
	cp ./*.pfb ${TEXMF}/fonts/type1/public/ascmac/
	mkdir -p ${TEXMF}/fonts/tfm/public/ascmac
	cp ./*.tfm ${TEXMF}/fonts/tfm/public/ascmac/
	mkdir -p ${TEXMF}/source/latex/ascmac
	cp ./Makefile ${TEXMF}/source/latex/ascmac/
	cp ./*.dtx ${TEXMF}/source/latex/ascmac/
	cp ./*.ins ${TEXMF}/source/latex/ascmac/
	mkdir -p ${TEXMF}/tex/latex/ascmac
	cp ./*.sty ${TEXMF}/tex/latex/ascmac/
clean:
	rm -f $(ASCMAC) $(DVITARGET)
cleanstrip:
	rm -f $(ASCMAC)
cleanall:
	rm -f $(ASCMAC) $(DVITARGET) $(PDFTARGET)
cleandoc:
	rm -f $(DVITARGET) $(PDFTARGET)
