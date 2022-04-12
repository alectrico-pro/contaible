RUBY = ruby
ERB = erb
KINDLEGEN = ./kindlegen

#Debe generar una tabla de cotenidos
mobi: libro-diario.html libro-diario.ncx libro-diario.opf
	mv libro-diario.html libro-diario.html.bak
	$(RUBY) script/mobi_postprocess.rb $<.bak > libro-diario.html
	-$(KINDLEGEN) libro-diario.opf

%.ncx: %.ncx.erb
	$(ERB) $<  >  $@

