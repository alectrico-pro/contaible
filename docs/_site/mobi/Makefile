RUBY = ruby
ERB = erb
KINDLEGEN = ./kindlegen


mobi: libro-diario.html mobi.ncx mobi.opf
	-$(RUBY) script/mobi_postprocess.rb $<.bak > $<
	cat assets/main.css >> libro-diario.css
	-$(KINDLEGEN) mobi.opf

mobi.ncx: mobi.ncx.erb
	$(ERB) $<  >  $@

%.html.bak: %.html
	cp $^ $^.bak

#html: iva.html libro-diario.html libro-mayor.html final.html tributario.html
#	$(RUBY) script/mobi_postprocess.rb $^


cp: book.mobi
	rsync -avr book.mobi /run/user/1000/gvfs/smb-share:server=ubuntu,share=maker 
