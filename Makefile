.SUFFIXES: .xml .html .dot .svg .gnuplot .png

PREFIX		?= /var/www/vhosts/kristaps.bsd.lv/htdocs/bchs
PAGES		 = index.html \
		   start.html \
		   tools.html \
		   easy.html \
		   json.html \
		   pledge.html
CSSS		 = index.css \
		   start.css \
		   highlight.css \
		   easy.css \
		   json.css \
		   pledge.css
GENS		 = easy.c.xml \
		   highlight.css \
		   easy.conf.xml \
		   easy.sh.xml \
		   json.c.xml \
		   json.json.xml \
		   json.xhtml.xml \
		   pledge-fig1.svg \
		   pledge-fig2.svg \
		   pledge-fig3.png
IMAGES		 = pledge-fig1.svg \
		   pledge-fig2.svg \
		   pledge-fig3.png
THEMEDIR	 = /usr/local/share/highlight/themes
BUILT		 = arrow-left.png \
		   arrow-right-long.png \
		   arrow-right.png \
		   arrow-up.png \
		   arrow-down.png \
		   logo-white.png
HIGHLIGHT_FLAGS	 = -l --config-file=$(THEMEDIR)/biogoo.theme

www: $(PAGES) $(CSSS)

.xml.html:
	cp -f $< $@

.dot.svg:
	dot -Tsvg $< | xsltproc notugly.xsl - >$@

.gnuplot.png:
	gnuplot $<

pledge-fig3.png: pledge-fig3.dat

highlight.css:
	highlight $(HIGHLIGHT_FLAGS) --print-style -c $@

easy.html: easy.xml easy.c.xml easy.conf.xml easy.sh.xml
	sblg -s cmdline -t easy.xml -o $@ easy.c.xml easy.conf.xml easy.sh.xml

json.html: json.xml json.c.xml json.json.xml json.xhtml.xml
	sblg -s cmdline -t json.xml -o $@ json.c.xml json.json.xml json.xhtml.xml

json.xhtml.xml: json.xhtml
json.json.xml: json.json
json.c.xml: json.c
easy.c.xml: easy.c
easy.sh.xml: easy.sh
easy.conf.xml: easy.conf

easy.c.xml easy.sh.xml easy.conf.xml json.c.xml json.json.xml json.xhtml.xml:
	echo '<article data-sblg-article="1">' >$@
	highlight $(HIGHLIGHT_FLAGS) -f --out-format=xhtml --enclose-pre `basename $@ .xml` >>$@
	echo '</article>' >>$@

installwww: www
	mkdir -p $(PREFIX)
	install -m 0444 $(IMAGES) $(BUILT) $(CSSS) $(PAGES) $(PREFIX)

pledge.html: pledge-fig1.svg pledge-fig2.svg pledge-fig3.png

clean:
	rm -f $(PAGES) $(GENS)
