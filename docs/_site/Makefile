RUBY = ruby
ERB = erb
KINDLEGEN = ./kindlegen


mobi: iva.html libro-diario.html libro-mayor.html final.html tributario.html css/mobi.css mobi.ncx mobi.opf
	#$(RUBY) script/mobi_postprocess.rb $<.bak > $<
	cat css/mobi.css >> mobi.css
	$(KINDLEGEN) mobi.opf

mobi.ncx: mobi.ncx.erb
	$(ERB) $<  >  $@

html: iva.html libro-diario.html libro-mayor.html final.html tributario.html
	$(RUBY) script/mobi_postprocess.rb $^
