#Solo genera la contabilidad, no se preocupa de mostrarla
#No calcula totales
#En realidad hace lo que le pongas en asiento_inicial_rules.clp
c=$(docker ps -q) && [[ $c ]] && docker kill $c



docker rm st
docker rm calibre
docker rm mobi
docker build . -t as

docker build . -t jeky -f DockerfileAS

docker run -p 4000:4000 --name st -v $(pwd)/docs:/doc jeky bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R'

#ocker run -p 4000:4000 --volumes-from st -v $(pwd)/docs:/doc jeky bash -c 'cd /doc && jekyll serve'

docker run --name mobi  --volumes-from st -v $(pwd)/docs:/doc jeky bash -c 'jekyll build . &&  cp /doc/_site/necios-2021/*.html /doc/mobi/ && cp /doc/_site/assets/* /doc/mobi/assets && cd /doc/mobi && make mobi '


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
  bash -c 'cd /doc/mobi && ebook-convert libro-diario.mobi libro-diario.epub ' 


#docker run -p 4000:4000 --volumes-from st -v $(pwd)/docs:/doc jeky bash -c 'cd /doc && jekyll serve'

