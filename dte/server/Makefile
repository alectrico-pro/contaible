RUBY = ruby
ERB = erb
KINDLEGEN = ../../kindlegen

#Llamar con VERSION, ASIN Y MES y DIA
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

book-%.opf: book-%.opf.erb
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
mobi_antiguo:  B09Z7Y5HZF.html.bak B09XQZ6B9P.html.bak introduccion.html.bak volumen.html.bak toc.html.bak libro-diario.html.bak libro-mayor.html.bak iva.html.bak final.html.bak tributario.html.bak f29.html.bak f22.html.bak comprobacion.html.bak subcuentas.html.bak inventario.html.bak resultado-sii.html.bak liquidacion.html.bak remuneraciones.html.bak valor-activos.html.bak bi.html.bak contaible.html.bak 
	make mobi-${VERSION}.ncx book-${VERSION}.opf

mobi:   B09Z7Y5HZF.html.bak B09XQZ6B9P.html.bak introduccion.html.bak volumen.html.bak toc.html.bak libro-diario.html.bak libro-mayor.html.bak iva.html.bak final.html.bak tributario.html.bak f22.html.bak comprobacion.html.bak subcuentas.html.bak inventario.html.bak resultado-sii.html.bak liquidacion.html.bak valor-activos.html.bak contaible.html.bak
	make mobi-${VERSION}.ncx book-${VERSION}.opf
	cat assets/main.css >> mobi.css
	-$(KINDLEGEN) book-${VERSION}.opf
	mv book-${VERSION}.mobi book-${VERSION}-${ASIN}-${MES}-${DIA}.mobi


asiento: 
	make build VERSION=1 ASIN=B09DXLR7P9 MES=enero DIA=31
	make build VERSION=1 ASIN=B09Y47TJ92 MES=febrero DIA=31
	make build VERSION=1 ASIN=B09Y46KDVS MES=marzo  DIA=31
	make build VERSION=1 ASIN=B09Y46BP4D MES=abril  DIA=31
	make build VERSION=1 ASIN=B09Y47LV3S MES=mayo   DIA=31
	make build VERSION=1 ASIN=B09Y47J2MV MES=junio  DIA=31
	make build VERSION=1 ASIN=B09Y48CP4P MES=julio  DIA=31
	make build VERSION=1 ASIN=B09Y474J4L MES=agosto  DIA=31
	make build VERSION=1 ASIN=B09Y48ZNJY MES=septiembre DIA=31
	make build VERSION=1 ASIN=B09Y48Y56F MES=octubre    DIA=31
	make build VERSION=1 ASIN=B09Y47WB9Y MES=noviembre  DIA=31
	make build VERSION=1 ASIN=B09NRKYKN7 MES=diciembre  DIA=31
	make sync



.PHONY: contaible
contaible:
	make build VERSION=2 ASIN=B09XQZ6B9P MES=diciembre DIA=31
	make sync

mayor:
	make build VERSION=mayor ASIN=MAYOR MES=enero DIA=31
	make sync


financiero:
	make build VERSION=financiero ASIN=FINANCIERO MES=diciembre EMPRESA=alectrico-2021 DIA=31
	make sync

l:
	make build VERSION=liquidaciones ASIN=L MES=diciembre EMPRESA=alectrico-2021 DIA=31
	make sync


r:
	make build VERSION=remuneraciones ASIN=R MES=enero EMPRESA=alectrico-2021 DIA=31
	make sync

a:
	make build VERSION=activos ASIN=A MES=diciembre EMPRESA=alectrico-2021 DIA=31
	make sync

t:  
	make build VERSION=tributario ASIN=T MES=enero EMPRESA=alectrico-2021 DIA=1
	make sync

f1:
	make build VERSION=financiero ASIN=B09XQZ6B9P MES=enero EMPRESA=alectrico-2021 DIA=1
	make sync

f2:
	make build VERSION=financiero ASIN=B09Z7Y5HZF MES=enero EMPRESA=alectrico-2021 DIA=1
	make sync


nx:     mobi-prueba.ncx	
	pwd
	cp  mobi-prueba.ncx ./doc
	
%.xml.bak: %.xml
	cp $< $<.bak
	-$(RUBY) script/dte_process.rb $<.bak > $<.out



#Inicialmente era para probar dtes, pero terminó sindo una alterntavia rapida a make mobi
build-dte:  *.xml.bak
	make reset
	if rm dte/server/*.html; then echo .; fi
	docker run -e PUID=1000 -e PGID=10 -v $(shell pwd)/:/doc cupercupu/clipspy /doc/dte.py
	if docker stop dte-server; then docker rm dte-server; fi
	if docker stop epub; then docker rm epub; fi
	docker run --name dte-server  -e PUID=1000 -e PGID=1000 -p 4001:4000 -v $(shell pwd)/:/srv/jekyll jekyll/jekyll bash -c 'jekyll build -s ./${EMPRESA} -d dte/server && cd dte/server && cp ../../version.txt . && cp ../../Makefile . && cp ../../*.erb . &&  cp ../../script/mobi_postprocess.rb ./script && make mobi VERSION=${VERSION} ASIN=${ASIN} MES=${MES} DIA=${DIA}'
	docker run --name epub -e PUID=1000 -e PGID=1000 -e TZ=Europe/London -e PASSWORD= `optional` -e CLI_ARGS= `optional` -p 8080:8080 -p 8081:8081 -v $(shell pwd)/:/doc --restart unless-stopped lscr.io/linuxserver/calibre bash -c 'cd /doc/dte/server && ebook-convert book-${VERSION}-${ASIN}-${MES}-${DIA}.mobi book-${VERSION}-${ASIN}-${MES}-${DIA}.epub'

#docker exec dte-server bash -c 'make reset && make dte5139951384.xml.bak && cat dte_process.log'



dte:    *.xml.bak
	make build-dte VERSION=financiero ASIN=B09XQZ6B9P MES=enero EMPRESA=alectrico-2021 DIA=1

pandoc:
	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex --pdf-engine=xelatex introduccion.markdown -o introduccion.pdf

reset:  *.xml.bak
	mv *.xml.bak *.xml

#suministrar make build VERSION=1 ASIN=b999 MES=enero EMPRESA=alectrico-2021
prueba: 
	docker build . -t j -f DockerfileJeky --no-cache
	docker run -v $(shell pwd)/:/srv/jekyll j bash -c 'make nx'
   

#suministrar make build VERSION=1 ASIN=b999 MES=enero EMPRESA=alectrico-2021
build:
	echo '(version (id 2) (version $(VERSION)) (asin $(ASIN)) (mes $(MES)) (dia $(DIA)))' > version.txt
	if docker rm st; then echo volumen docker st eliminado exitosamente st; fi 
	if docker rm mobi; then echo volumen docker mobi eliminado exitosamente; fi
	if docker stop calibre; docker rm calibre; then echo volumen docker mobi eliminado exitosamente; fi
	docker build . -t contaible -f DockerfileContaible
	docker run -p 4000:4000 --name st -v $(shell pwd)/docs:/doc contaible bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R' --no-cache
	docker run --name mobi  --volumes-from st -v $(shell pwd)/docs:/doc contaible bash -c 'jekyll build . && cp /doc/_site/${EMPRESA}/*.html /doc/mobi && cp /doc/_site/*.html /doc/mobi && cp /doc/_site/assets/* /doc/mobi/assets && cp /doc/_site/assets/main.css /doc/mobi.css && cd /doc/mobi && make mobi VERSION=${VERSION} ASIN=${ASIN} MES=${MES} DIA=${DIA}'
	docker run  --volumes-from mobi --name=calibre -e PUID=1000 -e PGID=1000 -e TZ=Europe/London -e PASSWORD= `optional` -e CLI_ARGS= `optional` -p 8080:8080 -p 8081:8081 -v $(shell pwd)/docs:/doc --restart unless-stopped lscr.io/linuxserver/calibre bash -c 'cd /doc/mobi && ebook-convert book-${VERSION}-${ASIN}-${MES}-${DIA}.mobi book-${VERSION}-${ASIN}-${MES}-${DIA}.epub'
	


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

