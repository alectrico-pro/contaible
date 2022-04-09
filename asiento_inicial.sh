#Solo genera la contabilidad, no se preocupa de mostrarla
#No calcula totales
#En realidad hace lo que le pongas en asiento_inicial_rules.clp
c=$(docker ps -q) && [[ $c ]] && docker kill $c



docker rm st
docker build . -t as

docker build . -t as -f DockerfileAsientoInicial

docker run -p 4000:4000 --name st -v $(pwd)/docs:/doc as bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R'

docker run -p 4000:4000 --volumes-from st -v $(pwd)/docs:/doc as bash -c 'cd /doc && jekyll serve'



