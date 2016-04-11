parts = pipeline

pdfs = $(addsuffix .pdf,$(parts))
print = $(addsuffix -print.pdf,$(parts))

html = $(addsuffix .html,$(parts))
css = initstyle.css

all: $(html)
handout: $(print)

%.pdf: %.html
	./s52pdf.sh $<

%.html: %.txt $(css)
	LC_ALL=sv_SE.UTF-8 rst2s5 --link-stylesheet --stylesheet=$(css) --smart-quotes=yes --current-slide $< $@
	perl -pi -e 's%<div class="layout">%<div class="layout">\n<img id="slant" src="img/slant.png">%' $@

index.html: $(html)
	cp $< $@

%-print.pdf: %.pdf
	./twoup.sh $?

publish: $(html) $(css) img ui index.html
	@sshadd
	rsync -ztvua --delete --progress $? lekstugan:/var/www/jonas.init.se/htdocs/pipeline/
