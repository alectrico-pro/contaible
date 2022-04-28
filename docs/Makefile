RUBY = ruby
ERB = erb
KINDLEGEN = ./kindlegen

#Llamar con VERSION, ASIN Y MES
#mobi: libro-diario.html mobi-${VERSION}.ncx book-${VERSION}-${ASIN}-${MES}.opf
#obi: libro-diario.html mobi-${VERSION}.ncx book-${VERSION}.opf
	#mobi
	#cp $< $<.bak
	#-$(RUBY) script/mobi_postprocess.rb $<.bak > $<
	#cat assets/main.css >> libro-diario.css


%.html.bak: %.html
	cp $< $<.bak
	-$(RUBY) script/mobi_postprocess.rb $<.bak > $<


mobi-%.ncx: mobi-%.ncx.erb
	$(ERB) $<  >  $@


#Requisitos es que se haya hecho un resguardo de los html
#Pero eso se hace luego de aplicar mobi_postprocess que es lo que queremos
#Pues no nos interesa el .html.bak sin el .html que quede procesado
#Deben existir los archivos de configuración pertienentes a la VERSIÓN
#La versión puede ser un número, pero ha derviado en una palabra
#Ejemplo FINANCIERO
#mobi debe recibir como parámentro el asin y el mes, de esa forma
#se pueden generar archivos *.mobi y *.epub cuyos nombres indiquen
#la calidad del contenido.
#El asin se chequea con un registro de volumenes.txt en el ambiente clips
#De esa forma llevamos una organización de qué ha sido publicado y donde
#Entre otros datos que se puedan ir agregando al registro de volúmenes
mobi:  libro-diario.html.bak libro-mayor.html.bak iva.html.bak final.html.bak tributario.html.bak f29.html.bak f22.html.bak comprobacion.html.bak subcuentas.html.bak inventario.html.bak resultado-sii.html.bak liquidacion.html.bak remuneraciones.html.bak valor-activos.html.bak bi.html.bak contaible.html.bak mobi-${VERSION}.ncx book-${VERSION}.opf
	cat assets/main.css >> mobi.css
	-$(KINDLEGEN) book-${VERSION}.opf
	mv book-${VERSION}.mobi book-${VERSION}-${ASIN}-${MES}.mobi


asiento: 
	make build VERSION=1 ASIN=B09DXLR7P9 MES=enero
	make build VERSION=1 ASIN=B09Y47TJ92 MES=febrero
	make build VERSION=1 ASIN=B09Y46KDVS MES=marzo
	make build VERSION=1 ASIN=B09Y46BP4D MES=abril
	make build VERSION=1 ASIN=B09Y47LV3S MES=mayo
	make build VERSION=1 ASIN=B09Y47J2MV MES=junio
	make build VERSION=1 ASIN=B09Y48CP4P MES=julio
	make build VERSION=1 ASIN=B09Y474J4L MES=agosto
	make build VERSION=1 ASIN=B09Y48ZNJY MES=septiembre
	make build VERSION=1 ASIN=B09Y48Y56F MES=octubre
	make build VERSION=1 ASIN=B09Y47WB9Y MES=noviembre
	make build VERSION=1 ASIN=B09NRKYKN7 MES=diciembre
	make sync



.PHONY: contaible
contaible:
	make build VERSION=2 ASIN=B09XQZ6B9P MES=diciembre
	make sync


mayor:
	make build VERSION=mayor ASIN=MAYOR MES=enero
	make sync


financiero:
	make build VERSION=financiero ASIN=FINANCIERO MES=diciembre EMPRESA=alectrico-2021
	make sync

l:
	make build VERSION=liquidaciones ASIN=L MES=diciembre EMPRESA=alectrico-2021
	make sync


r:
	make build VERSION=remuneraciones ASIN=R MES=enero EMPRESA=alectrico-2021
	make sync

a:
	make build VERSION=activos ASIN=A MES=diciembre EMPRESA=alectrico-2021
	make sync

t:  
	make build VERSION=tributario ASIN=T MES=enero EMPRESA=alectrico-2021
	make sync

f:
	make build VERSION=f22 ASIN=T MES=diciembre EMPRESA=alectrico-2021
	make sync



#suministrar make build VERSION=1 ASIN=b999 MES=enero EMPRESA=alectrico-2021
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

	echo '(version (id 2) (version $(VERSION)) (asin $(ASIN)) (mes $(MES)))' > version.txt

	if docker rm st; then echo volumen docker st eliminado exitosamente st; fi 
	if docker rm mobi; then echo volumen docker mobi eliminado exitosamente; fi
	if docker stop calibre; docker rm calibre; then echo volumen docker mobi eliminado exitosamente; fi
	docker build . -t jeky -f DockerfileJeky  
	docker run -p 4000:4000 --name st -v $(shell pwd)/docs:/doc jeky bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R' --no-cache
	docker run --name mobi  --volumes-from st -v $(shell pwd)/docs:/doc jeky bash -c 'jekyll build . && cp /doc/_site/${EMPRESA}/*.html /doc/mobi && cp /doc/_site/contaible/index.html /doc/mobi/contaible.html && cp /doc/_site/assets/* /doc/mobi/assets && cp /doc/_site/assets/main.css /doc/mobi.css && cd /doc/mobi && make mobi VERSION=${VERSION} ASIN=${ASIN} MES=${MES}'
	docker run  --volumes-from mobi --name=calibre -e PUID=1000 -e PGID=1000 -e TZ=Europe/London -e PASSWORD= `#optional` -e CLI_ARGS= `#optional` -p 8080:8080 -p 8081:8081 -v $(shell pwd)/docs:/doc --restart unless-stopped lscr.io/linuxserver/calibre bash -c 'cd /doc/mobi && ebook-convert book-${VERSION}-${ASIN}-${MES}.mobi book-${VERSION}-${ASIN}-${MES}.epub'
	# && cp mobi.mobi mobi-${VERSION}-${ASIN}-${MES}.mobi '
	
#La parte de red en docker todavía no la domino, así que intentaré usar sync desde fuera de ddocker


sync:
	rsync -rltgoDv ~/contaible/docs/mobi/book*.epub /run/user/1000/gvfs/smb-share:server=ubuntu,share=maker/ --progress --outbuf=N -T=tmp
	rsync -rltgoDv ~/contaible/docs/mobi/book*.mobi /run/user/1000/gvfs/smb-share:server=ubuntu,share=maker/ --progress --outbuf=N -T=tmp
	
	
	
	
#; then echo "Los ebooks fueron transferidos al notebook para su revisión y envío a kdp.amazon."; else echo No funcionó async para transferir eboosk al notebook. Agregue el sitio de red en el organizador de archivos. Luego reintente.



ls: 
	if ls docs/mobi/book*.*; then  echo todo bin else echo No se generaron los books; fi


#%.html.bak: %.html
#	cp $^ $^.bak

#html: iva.html libro-diario.html libro-mayor.html final.html tributario.html
#	$(RUBY) script/mobi_postprocess.rb $^

