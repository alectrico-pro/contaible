RUBY = ruby
ERB = erb
KINDLEGEN = ./kindlegen


mobi: libro-diario.html mobi.ncx mobi.opf
	cp $< $<.bak
	-$(RUBY) script/mobi_postprocess.rb $<.bak > $<
	cat assets/main.css >> libro-diario.css
	-$(KINDLEGEN) mobi.opf

mobi.ncx: mobi.ncx.erb
	$(ERB) $<  >  $@


all: 
	echo '(version (id 1) (version 1.0) (asin B09NRKYkN7) (mes enero))' > version.txt
	make build VERSION=1.0 ASIN=B09NRKYkN7 MES=enero
	echo '(version (id 2) (version 1.0) (asin B09NRKYkN7) (mes febrero))' > version.txt
	make build VERSION=1.0 ASIN=B09NRKYkN7 MES=febrero
	make sync

#suministrar make build VERSION=1 ASIN=b999 MES=enero
build:
	echo
	echo
	echo
	echo
	-echo '==================================='
	-echo 'ATENCION: Comenzando procesamiento en make build con VERSION ${VERSION}, ASIN ${ASIN}, MES ${MES} '	
	-echo '==================================='
	echo 
	echo

	if docker rm st; then echo volumen docker st eliminado exitosamente st; fi 
	if docker rm mobi; then echo volumen docker mobi eliminado exitosamente; fi
	if docker stop calibre; docker rm calibre; then echo volumen docker mobi eliminado exitosamente; fi


	if docker build . -t jeky -f DockerfileJeky; then echo DockerfileJeky generado exitosamente; fi
	docker run -p 4000:4000 --name st -v $(shell pwd)/docs:/doc jeky bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R' --no-cache
	docker run --name mobi  --volumes-from st -v $(shell pwd)/docs:/doc jeky bash -c 'jekyll build . && cp /doc/_site/necios-2021/*.html /doc/mobi && cp /doc/_site/assets/* /doc/mobi/assets && cp /doc/_site/assets/main.css /doc/mobi.css && cd /doc/mobi && make mobi'
	docker run  --volumes-from mobi --name=calibre -e PUID=1000 -e PGID=1000 -e TZ=Europe/London -e PASSWORD= `#optional` -e CLI_ARGS= `#optional` -p 8080:8080 -p 8081:8081 -v $(shell pwd)/docs:/doc --restart unless-stopped lscr.io/linuxserver/calibre bash -c 'cd /doc/mobi && ebook-convert mobi.mobi book-${VERSION}-${ASIN}-${MES}.epub && cp mobi.mobi mobi-${VERSION}-${ASIN}-${MES}.mobi '
	
#La parte de red en docker todavía no la domino, así que intentaré usar sync desde fuera de ddocker


sync:
	rsync -rltgoDv ~/contaible/docs/mobi/book*.* /run/user/1000/gvfs/smb-share:server=ubuntu,share=maker/ --progress --outbuf=N -T=tmp
	
	
	
	
#; then echo "Los ebooks fueron transferidos al notebook para su revisión y envío a kdp.amazon."; else echo No funcionó async para transferir eboosk al notebook. Agregue el sitio de red en el organizador de archivos. Luego reintente.



ls: 
	if ls docs/mobi/book*.*; then  echo todo bin else echo No se generaron los books; fi


#%.html.bak: %.html
#	cp $^ $^.bak

#html: iva.html libro-diario.html libro-mayor.html final.html tributario.html
#	$(RUBY) script/mobi_postprocess.rb $^

