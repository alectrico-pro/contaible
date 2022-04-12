RUBY = ruby
ERB = erb

#Debe generar una tabla de cotenidos
mobi: libro-diario.html libro-diario.ncx
	mv libro-diario.html libro-diario.html.bak
	$(RUBY) script/mobi_postprocess.rb $<.bak > libro-diario.html


%.ncx: %.ncx.erb
	$(ERB) $<  >  $@

