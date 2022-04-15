#Prapara programas y dependencias para
#Generar una version mobi y otra epub de la contabilidad decedidia en seleccines-mobi.txt
#Depedne de 
#mobi.py
# mobi.bat
# Makefile
# mobi_rules.clp
# DockerfileMobi
#
#Programas y sus dependencias:
#1-Libreria clipspy en python- se carga en DockerFileMobi y luego se instala y usa  en el almacen docker as
#2.Jekyll- se carga en almacen docker as
#Pero todo esto está unido a un almacenamiento local en contabiles/docs.
#3. Se hace l resultado se almacen an alamacen st. 
#4. Opcionalmente  El resutlado de la contabilidad en formato markdown y html listo para ser visto desde una http por un servidor funcionando en 4000 powered por jekyll
#5. Se usa Makefile en make mobi con kindlegen y scripts en ruby y erb para generar el archivo .mobi. Resutlado en almacen mobi
#6. Se usa calibre para convertir de mobi a epub
#No calcula totales
#En realidad hace lo que le pongas en asiento_inicial_rules.clp
c=$(docker ps -q) && [[ $c ]] && docker kill $c


docker rm jeky
docker rm st
docker rm calibre
docker rm mobi

docker build . -t jeky -f DockerfileJeky

docker run -p 4000:4000 --name st -v $(pwd)/docs:/doc jeky bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R'

#ocker run -p 4000:4000 --volumes-from st -v $(pwd)/docs:/doc jeky bash -c 'cd /doc && jekyll serve'

docker run --name mobi  --volumes-from st -v $(pwd)/docs:/doc jeky bash -c 'jekyll build . && cp /doc/_site/necios-2021/*.html /doc/mobi && cp /doc/_site/assets/* /doc/mobi/assets && cp /doc/_site/assets/main.css  mobi.css && cd /doc/mobi && make mobi && mv mobi.mobi book.mobi'

docker run  \
  --volumes-from mobi \
  --name=calibre \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e PASSWORD= `#optional` \
  -e CLI_ARGS= `#optional` \
  -p 8080:8080 \
  -p 8081:8081 \
  -v $(pwd)/docs/guacamole:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/calibre \
  bash -c 'cd /doc/mobi && ebook-convert book.mobi book.epub'


# bash -c 'cd /doc/mobi && ebook-convert book.mobi book.epub --input-encoding=utf-8'


rsync -rltgoDv docs/mobi/book.* /run/user/1000/gvfs/smb-share:server=ubuntu,share=maker/ --progress --outbuf=N -T=tmp


#&& cp book.* acer '
 
# ln -s /run/user/1000/gvfs/smb-share:server=ubuntu,share=maker acer'


#docker run  \
#  --volumes-from mobi \
#  -t \
#  -i \
#  -e PUID=1000 \
#  -e PGID=1000 \
#  -e TZ=Europe/London \
#  -e PASSWORD= `#optional` \
#  -e CLI_ARGS= `#optional` \
#  -p 8080:8080 \
#  -p 8081:8081 \
#  -v $(pwd)/docs/guacamole:/config \
#  --restart unless-stopped \
#  lscr.io/linuxserver/calibre 

#docker run -p 4000:4000 --volumes-from st -v $(pwd)/docs:/doc jeky bash -c 'cd /doc && jekyll serve'

