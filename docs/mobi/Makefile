RUBY = ruby
ERB = erb
KINDLEGEN = ./kindlegen


#Debe generar una tabla de cotenidos
mobi: as.html css/mobi.css as.ncx as.opf
	$(RUBY) script/mobi_postprocess.rb $<.bak > $<
	cat css/mobi.css >> mobi.css
	-$(KINDLEGEN) as.opf

%.ncx: %.ncx.erb
	$(ERB) $<  >  $@


