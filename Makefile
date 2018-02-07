STRIPTARGET = platex.ltx jarticle.cls pl209.def platexrelease.sty \
	nidanfloat.sty tascmac.sty jltxdoc.cls
DOCTARGET = platex platexrelease pldoc nidanfloat ascmac exppl2e \
	platex-en
PDFTARGET = $(addsuffix .pdf,$(DOCTARGET))
DVITARGET = $(addsuffix .dvi,$(DOCTARGET))
KANJI = -kanji=jis
FONTMAP = -f ipaex.map -f ptex-ipaex.map
TEXMF = $(shell kpsewhich -var-value=TEXMFHOME)

default: $(STRIPTARGET) $(DVITARGET)
strip: $(STRIPTARGET)
all: $(STRIPTARGET) $(PDFTARGET)

PLFMT = platex.ltx plcore.ltx kinsoku.tex pldefs.ltx \
	jy1mc.fd jy1gt.fd jt1mc.fd jt1gt.fd plext.sty \
	ptrace.sty pfltrace.sty

PLFMT_SRC = platex.dtx plvers.dtx plfonts.dtx plcore.dtx \
	kinsoku.dtx plext.dtx

PLCLS = jarticle.cls jreport.cls jbook.cls jsize10.clo \
	jsize11.clo jsize12.clo jbk10.clo jbk11.clo jbk12.clo \
	tarticle.cls treport.cls tbook.cls tsize10.clo \
	tsize11.clo tsize12.clo tbk10.clo tbk11.clo tbk12.clo

PLCLS_SRC = jclasses.dtx

PL209 = pl209.def oldpfont.sty jarticle.sty tarticle.sty \
	jbook.sty tbook.sty jreport.sty treport.sty

PL209_SRC = pl209.dtx

PLREL = platexrelease.sty

PLREL_SRC = platexrelease.dtx $(PLFMT_SRC)

NIDAN = nidanfloat.sty

NIDAN_SRC = nidanfloat.dtx

ASCMAC = tascmac.sty ascmac.sty

ASCMAC_SRC = ascmac.dtx

INTRODOC_SRC = platex.dtx

PLRELDOC_SRC = platexrelease.dtx

PLDOC_SRC = platex.dtx plvers.dtx plfonts.dtx plcore.dtx plext.dtx \
	pl209.dtx kinsoku.dtx jclasses.dtx jltxdoc.dtx

platex.ltx: $(PLFMT_SRC)
	rm -f $(PLFMT)
	platex $(KANJI) plfmt.ins
	rm plfmt.log

jarticle.cls: $(PLCLS_SRC)
	rm -f $(PLCLS)
	platex $(KANJI) plcls.ins
	rm plcls.log

pl209.def: $(PL209_SRC)
	rm -f $(PL209)
	platex $(KANJI) pl209.ins
	rm pl209.log

platexrelease.sty: $(PLREL_SRC)
	rm -f $(PLREL)
	platex $(KANJI) platexrelease.ins
	rm platexrelease.log

nidanfloat.sty: $(NIDAN_SRC)
	rm -f $(NIDAN)
	platex $(KANJI) nidanfloat.ins
	rm nidanfloat.log

tascmac.sty: $(ASCMAC_SRC)
	rm -f $(ASCMAC)
	platex $(KANJI) ascmac.ins
	rm ascmac.log

jltxdoc.cls: jltxdoc.dtx
	rm -f jltxdoc.cls pldoc.tex Xins.ins
	platex $(KANJI) pldocs.ins
	rm pldocs.log pldoc.tex Xins.ins

platex.dvi: $(INTRODOC_SRC)
	rm -f platex.cfg
	platex $(KANJI) platex.dtx
	mendex -J -f -s gglo.ist -o platex.gls platex.glo
	platex $(KANJI) platex.dtx
	rm platex.aux platex.log
	rm platex.glo platex.gls platex.ilg

platexrelease.dvi: $(PLRELDOC_SRC)
	rm -f platex.cfg
	platex $(KANJI) platexrelease.dtx
	platex $(KANJI) platexrelease.dtx
	rm platexrelease.aux platexrelease.log

pldoc.dvi: $(PLDOC_SRC)
	rm -f platex.cfg
	rm -f jltxdoc.cls pldoc.tex Xins.ins
	platex $(KANJI) pldocs.ins
	rm -f mkpldoc.sh dstcheck.pl
	platex $(KANJI) Xins.ins
	sh mkpldoc.sh
	rm *.aux *.log pldoc.toc pldoc.idx pldoc.ind pldoc.ilg
	rm pldoc.glo pldoc.gls pldoc.tex Xins.ins
	rm ltxdoc.cfg pldoc.dic mkpldoc.sh dstcheck.pl

nidanfloat.dvi: $(NIDAN_SRC)
	rm -f platex.cfg
	platex $(KANJI) nidanfloat.dtx
	platex $(KANJI) nidanfloat.dtx
	rm nidanfloat.aux nidanfloat.log

ascmac.dvi: $(ASCMAC_SRC)
	rm -f platex.cfg
	platex $(KANJI) ascmac.dtx
	platex $(KANJI) ascmac.dtx
	rm ascmac.aux ascmac.log ascmac.toc

exppl2e.dvi: exppl2e.sty
	rm -f platex.cfg
	platex $(KANJI) exppl2e.sty
	platex $(KANJI) exppl2e.sty
	rm exppl2e.aux exppl2e.log

platex-en.dvi: $(INTRODOC_SRC)
	# built-in echo in shell is troublesome, so use perl instead
	perl -e "print \"\\\\newif\\\\ifJAPANESE\\n"\" >platex.cfg
	platex -jobname=platex-en $(KANJI) platex.dtx
	mendex -J -f -s gglo.ist -o platex-en.gls platex-en.glo
	platex -jobname=platex-en $(KANJI) platex.dtx
	rm platex-en.aux platex-en.log
	rm platex-en.glo platex-en.gls platex-en.ilg
	rm platex.cfg

platex.pdf: platex.dvi
	dvipdfmx $(FONTMAP) $<
platexrelease.pdf: platexrelease.dvi
	dvipdfmx $(FONTMAP) $<
pldoc.pdf: pldoc.dvi
	dvipdfmx $(FONTMAP) $<
nidanfloat.pdf: nidanfloat.dvi
	dvipdfmx $(FONTMAP) $<
ascmac.pdf: ascmac.dvi
	dvipdfmx $(FONTMAP) $<
exppl2e.pdf: exppl2e.dvi
	dvipdfmx $(FONTMAP) $<
platex-en.pdf: platex-en.dvi
	dvipdfmx $(FONTMAP) $<

.PHONY: install clean cleanstrip cleanall cleandoc
install:
	mkdir -p ${TEXMF}/doc/platex/base
	cp ./LICENSE ${TEXMF}/doc/platex/base/
	cp ./README.md ${TEXMF}/doc/platex/base/
	cp ./*.pdf ${TEXMF}/doc/platex/base/
	cp ./*.txt ${TEXMF}/doc/platex/base/
	mkdir -p ${TEXMF}/source/platex/base
	cp ./Makefile ${TEXMF}/source/platex/base/
	cp ./plnews* ${TEXMF}/source/platex/base/
	cp ./*.dtx ${TEXMF}/source/platex/base/
	cp ./*.ins ${TEXMF}/source/platex/base/
	mkdir -p ${TEXMF}/tex/platex/base
	cp ./kinsoku.tex ${TEXMF}/tex/platex/base/
	cp ./*.clo ${TEXMF}/tex/platex/base/
	ls ./*.cls | grep -v plnews.cls | xargs -I % cp % ${TEXMF}/tex/platex/base
	cp ./*.def ${TEXMF}/tex/platex/base/
	cp ./*.fd  ${TEXMF}/tex/platex/base/
	cp ./*.ltx ${TEXMF}/tex/platex/base/
	cp ./*.sty ${TEXMF}/tex/platex/base/
	mkdir -p ${TEXMF}/tex/platex/config
	cp ./platex.ini ${TEXMF}/tex/platex/config/
clean:
	rm -f $(PLFMT) $(PLCLS) $(PL209) $(PLREL) \
	$(NIDAN) $(ASCMAC) \
	$(DVITARGET) \
	jltxdoc.cls pldoc.tex Xins.ins
cleanstrip:
	rm -f $(PLFMT) $(PLCLS) $(PL209) $(PLREL) \
	$(NIDAN) $(ASCMAC) \
	jltxdoc.cls pldoc.tex Xins.ins
cleanall:
	rm -f $(PLFMT) $(PLCLS) $(PL209) $(PLREL) \
	$(NIDAN) $(ASCMAC) \
	$(DVITARGET) $(PDFTARGET) \
	jltxdoc.cls pldoc.tex Xins.ins
cleandoc:
	rm -f $(DVITARGET) $(PDFTARGET)
