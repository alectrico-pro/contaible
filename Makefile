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



#Inicialmente era para probar dtes, pero terminó sindo una alternativa rápida a make mobi
build-dte:  *.xml.bak 
	make reset
	echo '(version (id 2) (version $(VERSION)) (asin $(ASIN)) (mes $(MES)) (dia $(DIA)))' > version.txt
	if rm dte/server/*.html; then echo .; fi
	docker run -e PUID=1000 -e PGID=10 -v $(shell pwd)/:/doc cupercupu/clipspy /doc/dte.py
	if docker rm dte-server -fv; then echo .; fi
	if docker rm epub -fv; then echo .; fi
	if docker rm 4000 -fv; then echo .; fi
	docker run --name dte-server  -e PUID=1000 -e PGID=1000 -p 4001:4000 -v $(shell pwd)/:/srv/jekyll jekyll/jekyll bash -c 'jekyll build -s ./${EMPRESA} -d dte/server && mv dte/server/*.png dte && mv dte/server/*.pdf dte && cp assets/main.css dte/mobi.css && cd dte/server && cp ../../version.txt . && cp ../../Makefile . && cp ../../*.erb . &&  cp ../../script/mobi_postprocess.rb ./script && make mobi VERSION=${VERSION} ASIN=${ASIN} MES=${MES} DIA=${DIA}'
	docker run --name epub -e PUID=1000 -e PGID=1000 -e TZ=Europe/London -e PASSWORD= `optional` -e CLI_ARGS= `optional` -p 8080:8080 -p 8081:8081 -v $(shell pwd)/:/doc --restart unless-stopped lscr.io/linuxserver/calibre bash -c 'cd /doc/dte/server && ebook-convert book-${VERSION}-${ASIN}-${MES}-${DIA}.mobi book-${VERSION}-${ASIN}-${MES}-${DIA}.epub && rm *.bak'
	rsync -rltgoDv ~/contaible/dte/server/book*.epub /run/user/1000/gvfs/smb-share:server=ubuntu,share=maker/ --progress --outbuf=N -T=tmp
	rsync -rltgoDv ~/contaible/dte/server/book*.mobi /run/user/1000/gvfs/smb-share:server=ubuntu,share=maker/ --progress --outbuf=N -T=tmp
	docker run --rm --name 4000 -p 4000:4000 -v $(shell pwd)/:/srv/jekyll jekyll/jekyll bash -c 'jekyll serve -s ./${EMPRESA} -d dte/server'

#docker exec dte-server bash -c 'make reset && make dte5139951384.xml.bak && cat dte_process.log'

#.jpg: %.png
#convert -quality 90 -frame 20 -border 100 -density 300x300 -resize 800x  $^ $@  2>/dev/null

#%.jpg: %.png
#	convert -annotate 0,140,140,140 "alectrico ®" -stroke '#ffffff' -strokewidth 2  -style normal -undercolor '#0000ff' -bordercolor '#00ff00'  -background '#0fffff' -fill '#19FFFF' -matte  -mattecolor '#ffff00' -opaque '#00ffff' -transparent '#000000' $^ $@  2>/dev/null


clean: 
	rm cover*.png.*
	rm cover*.png.*.*


#agrega una franja arriba
cover%.jpg: cover%.png-arriba
	convert -background '#0008' -fill white -gravity center -size 2810x120\
        caption:"  Contiene ejercicio contable año 2021 de alectrico ®  " \
        $^ +swap -gravity North -composite  $@


#agrega una franja abajo
cover%.jpg: cover%.png-abajo
	convert -background '#0008' -fill white -gravity center -size 2810x120\
        caption:"  Contiene ejercicio contable año 2021 de alectrico ®  " \
        $^ +swap -gravity south -composite  $@

cover%.jpg: cover%.png-abajo
	convert -background '#0008' -fill white -gravity center -size 2810x120\
        caption:"  Contiene ejercicio contable año 2021 de alectrico ®  " \
        $^ +swap -gravity south -composite  $@

#posicionando man con bolsa
cover%.jpg: cover%.png-bolsa
	for i in 100 200 ; do echo "Posicionando en x= $$i "; composite -geometry "+$$i+3304" ticket_man_pagado_image.png $^ "$@.$$i" ; done

#agregando baterias-con for
cover%.jpg: cover%.png-for
	for i in 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 ; do echo "Posicionando en x= $$i "; composite -geometry "+$$i+3304" consumo_de_creditos.png $^ "$@.$$i" ; done

#proband while baterias
cover%.jpg: cover%.png-while
	x=1 ;  \
	while [ $$x -le 5 ] ; do \
	  echo "Posicionado en $$x" ;  \
	  x=$$(( $$x + 1 ))  ; \
	done

#agregando baterias-con-while
cover%.jpg: cover%.png-while
	x=1 ;  \
        while [ $$x -le 2050 ] ; do \
          echo "Posicionado en $$x" ;  \
          composite -geometry "+$$x+3304" consumo_de_creditos.png $^ "$@.$$x" ; \
	x=$$(( $$x + 10 ))  ; \
        done

#titula todas las cubiertas que estén en volumenes.txt
titular-cubiertas: 
	docker run -e PUID=1000 -e PGID=10 -v $(shell pwd)/:/doc cupercupu/clipspy /doc/titular-cubiertas.py


#pone título TITULO a la imagen en ARCHIVO
tit:  
	onvert -background '#0008' -fill white -gravity  center -size 2510x510 \
        caption:" ${TITULO} " \
        ${ARCHIVO}.png +swap -gravity south -composite ${ARCHIVO}.jpg ; \


b2b:    
	make cover-back-to-business.jpg


bo:     
	rm cover-b2b*.jpg ; \
	numeracion=1 ; \
	for archivo in cover-back-to-business.png.*.*.* ;  do \
          echo "Elaborando cubierta $$numeracion" para archivo $$archivo ; \
          convert "$$archivo" "cover-b2b-$$numeracion.jpg" ; \
          convert -background '#0008' -fill white -gravity  center -size 2310x510 \
          caption:" $$numeracion " \
          "cover-b2b-$$numeracion.jpg.tmp" +swap -gravity center -composite "cover-b2b-$$numeracion.png" ; \
          numeracion=$$(( $$numeracion + 1 )) ; \
	done; \
	rm cover-back-to-business.png.*.*.* \
	

#agregando baterias-apiladas-a-serie-de-cubiertas
cover%.jpg: cover%.png
	if \
	rm cover*.png.*.*.* ; \
	rm cover*.png.*.* ; \
	rm conver*.png.* ; \
	then 	 echo . ; \
	fi ; \
        orden=main_switch.png ; \
	warning=4441.png ; \
        carrito=carrito.png ; \
	descargado=consumo_de_creditos.png ; \
	numeracion=0 ; \
        for y in 3004 3104 3204 3304 ; do \
          x=1; \
	  xlabel=10001 ; \
          composite -geometry "+100+100" "$$orden" $^ "$^.$$y.$$xlabel.cargado" ; \
          composite -geometry "+2130+83" "$$warning" "$^.$$y.$$xlabel.cargado" "$^.$$y.$$xlabel.cargado" ; \
          composite -geometry "+1100+1650" "$$carrito" "$^.$$y.$$xlabel.cargado" "$^.$$y.$$xlabel.cargado" ; \
          convert -background '#0008' -fill white -gravity center -size 2810x120 \
          caption:"  Contiene ejercicio contable año 2021 de alectrico ®  " \
          "$^.$$y.$$xlabel.cargado" +swap -gravity south -composite "$^.$$y.$$xlabel.cargado"; \
	  for separacion in 450 500 ; do \
            xlabel=10001 ; \
	    x=50 ; \
	    bateria=compra_de_creditos.png ; \
            composite -geometry "+$$x+$$y" "$$bateria" "$^.$$y.$$xlabel.cargado" "$^.$$y.$$xlabel.cargado"  ; \
            while [ $$x -le 2000 ] ; do \
              a=$$xlabel ; \
	      x=$$(( $$x + $$separacion ))  ; \
	      xlabel=$$(( 10000 + $$x )) ; \
              numeracion=$$(( $$numeracion + 1 )) ; \
              echo "Posicionado en $$numeracion xlabel=$$xlabel x=$$x y=$$y bateria= $$bateria" ; \
	      composite -geometry "+$$x+$$y" "$$bateria" "$^.$$y.$$a.cargado" "$^.$$y.$$xlabel.cargado" ; \
              if [ $$separacion -eq 450 ] ; then  \
                numeracion=$$(( $$numeracion + 1 )) ; \
                echo "Posicionado en $$numeracion xlabel=$$xlabel x=$$x y=$$y bateria= $$descargado" ; \
                composite -geometry "+$$x+$$y" "$$descargado" "$^.$$y.$$a.cargado" "$^.$$y.$$xlabel.descargado" ; \
              fi; \
	    done; \
	  done; \
	done; \

#ocupa dte_rules.clp
dte:    *.xml.bak cover-b2b-*.jpg
	cp cover-b2b*.jpg alectrico-2021
	make build-dte TITULO='MIERDA' VERSION=financiero ASIN=B09XQZ6B9P MES=enero EMPRESA=alectrico-2021 DIA=1

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
	if docker rm st -fv; then echo volumen docker st eliminado exitosamente st; fi 
	if docker rm mobi -fv; then echo volumen docker mobi eliminado exitosamente; fi
	if docker rm calibre -fv; then echo volumen docker mobi eliminado exitosamente; fi
	f docker rm epub -fv; then echo volumen docker epub eliminado exitosamente; fi
	docker build . -t contaible -f DockerfileContaible
	docker run -p 4000:4000 --name st -v $(shell pwd)/docs:/doc contaible bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R' --no-cache
	docker run --name mobi --volumes-from st -v $(shell pwd)/docs:/doc contaible bash -c 'jekyll build . && cp /doc/_site/${EMPRESA}/*.html /doc/mobi && cp /doc/_site/*.html /doc/mobi && cp /doc/_site/assets/* /doc/mobi/assets && cp /doc/_site/assets/main.css /doc/mobi.css && cd /doc/mobi && make mobi VERSION=${VERSION} ASIN=${ASIN} MES=${MES} DIA=${DIA}'
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

