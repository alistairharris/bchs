.SUFFIXES: .xml .html .dot .svg .gnuplot .png .c.xml

PREFIX		?= /var/www/vhosts/kristaps.bsd.lv/htdocs/bchs
PAGES		 = index.html \
		   start.html \
		   tools.html \
		   easy.html \
		   json.html \
		   pledge.html \
		   ksql.html \
		   kwebapp.html
CSSS		 = index.css \
		   start.css \
		   style.css \
		   easy.css \
		   json.css \
		   pledge.css \
		   ksql.css \
		   kwebapp.css
GENS		 = easy.c.xml \
		   style.css \
		   easy.conf.xml \
		   easy.sh.xml \
		   json.c.xml \
		   json.json.xml \
		   json.xhtml.xml \
		   kwebapp.txt.xml \
		   kwebapp.main1.c.xml \
		   kwebapp.main2.c.xml \
		   ksql-fig1.c.xml \
		   ksql-fig2.c.xml \
		   ksql-fig4.c.xml \
		   ksql-fig5.c.xml \
		   $(GENHTMLS) \
		   $(IMAGES)
GENHTMLS	 = kwebapp.db.c.html \
		   kwebapp.db.h.html \
		   kwebapp.db.js.html \
		   kwebapp.db.sql.html \
		   kwebapp.db.sqldiff.html \
		   kwebapp.main.c.html
IMAGES		 = pledge-fig1.svg \
		   pledge-fig2.svg \
		   pledge-fig3.png \
		   ksql-fig3.svg \
		   ksql-fig6.svg \
		   kwebapp-fig1.svg \
		   kwebapp-fig2.svg
BUILT		 = arrow-left.png \
		   arrow-right-long.png \
		   arrow-right.png \
		   arrow-up.png \
		   arrow-down.png \
		   logo-blue.png \
		   logo-white.png

www: $(PAGES) 

.xml.html:
	cp -f $< $@

.dot.svg:
	dot -Tsvg $< | xsltproc --novalid notugly.xsl - >$@

.gnuplot.png:
	gnuplot $<

pledge-fig3.png: pledge-fig3.dat

easy.html: easy.xml easy.c.xml easy.conf.xml easy.sh.xml
	sblg -s cmdline -t easy.xml -o $@ easy.c.xml easy.conf.xml easy.sh.xml

json.html: json.xml json.c.xml json.json.xml json.xhtml.xml
	sblg -s cmdline -t json.xml -o $@ json.c.xml json.json.xml json.xhtml.xml

json.xhtml.xml: json.xhtml
json.json.xml: json.json
easy.sh.xml: easy.sh
easy.conf.xml: easy.conf
kwebapp.txt.xml: kwebapp.txt

easy.sh.xml easy.conf.xml json.json.xml json.xhtml.xml kwebapp.txt.xml:
	echo '<article data-sblg-article="1">' >$@
	highlight -l -f --out-format=xhtml --enclose-pre `basename $@ .xml` >>$@
	echo '</article>' >>$@

kwebapp.db: kwebapp.db.c kwebapp.main.c kwebapp.db.h
	$(CC) -W -Wall $(CFLAGS) -I/usr/local/include -L/usr/local/lib -static -o $@ kwebapp.db.c kwebapp.main.c -lkcgi -lz -lksql -lsqlite3 -lpthreads

kwebapp.db.c.html: kwebapp.db.c
	highlight --config-file=github.theme -l --css=style.css --src-lang=c kwebapp.db.c > $@

kwebapp.db.c: kwebapp.txt
	kwebapp -Ocsource -Fjson -Fvalids kwebapp.db.h kwebapp.txt > $@

kwebapp.db.h.html: kwebapp.db.h
	highlight --config-file=github.theme -l --css=style.css --src-lang=c kwebapp.db.h > $@

kwebapp.db.h: kwebapp.txt
	kwebapp -Ocheader -Fjson -Fvalids kwebapp.txt > $@

kwebapp.db.sql.html: kwebapp.txt
	kwebapp -Osql kwebapp.txt | highlight --config-file=github.theme -l --css=style.css --src-lang=sql > $@

kwebapp.db.sqldiff.html: kwebapp.txt
	kwebapp -Osqldiff kwebapp.old.txt kwebapp.txt | highlight --config-file=github.theme -l --css=style.css --src-lang=sql > $@

kwebapp.db.js.html: kwebapp.txt
	kwebapp -Ojavascript kwebapp.txt | highlight --config-file=github.theme -l --css=style.css --src-lang=js > $@

kwebapp.main.c.html: kwebapp.main.c
	highlight --config-file=github.theme -l --css=style.css --src-lang=c kwebapp.main.c > $@

kwebapp.main1.c.xml: kwebapp.main.c
	echo '<article data-sblg-article="1">' >$@
	sed -n '212,225p' kwebapp.main.c |  highlight -l -f --out-format=xhtml --enclose-pre --src-lang=c >>$@
	echo '</article>' >>$@

kwebapp.main2.c.xml: kwebapp.main.c
	echo '<article data-sblg-article="1">' >$@
	sed -n '124,140p' kwebapp.main.c |  highlight -l -f --out-format=xhtml --enclose-pre --src-lang=c >>$@
	echo '</article>' >>$@

pledge.html: pledge-fig1.svg \
	pledge-fig2.svg \
	pledge-fig3.png

KWEB_MEDIA = kwebapp-fig1.svg \
	     kwebapp-fig2.svg \
	     kwebapp.db.c.html \
	     kwebapp.db.h.html \
	     kwebapp.db.sql.html \
	     kwebapp.db.sqldiff.html \
	     kwebapp.db.js.html \
	     kwebapp.main.c.html
KWEB_DEPS  = kwebapp.txt.xml \
	     kwebapp.main1.c.xml \
	     kwebapp.main2.c.xml
KSQL_MEDIA = ksql-fig3.svg \
	     ksql-fig6.svg
KSQL_DEPS  = ksql-fig1.c.xml \
	     ksql-fig2.c.xml \
	     ksql-fig4.c.xml \
	     ksql-fig5.c.xml


kwebapp.html: kwebapp.xml $(KWEB_DEPS) $(KWEB_MEDIA)
	sblg -s cmdline -t kwebapp.xml -o $@ $(KWEB_DEPS)

.c.c.xml:
	echo '<article data-sblg-article="1">' >$@
	highlight -l -f --out-format=xhtml --enclose-pre --src-lang=c $< >>$@
	echo '</article>' >>$@

ksql.html: ksql.xml $(KSQL_DEPS) $(KSQL_MEDIA)
	sblg -s cmdline -t ksql.xml -o $@ $(KSQL_DEPS)

installwww: www
	mkdir -p $(PREFIX)
	install -m 0444 $(IMAGES) $(GENHTMLS) $(BUILT) $(CSSS) $(PAGES) $(PREFIX)
	install -m 0444 icons/*.{png,ico,xml,json,svg} $(PREFIX)

clean:
	rm -f $(PAGES) $(GENS) kwebapp.db.c kwebapp.db.h
