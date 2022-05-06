#Solo genera la contabilidad, no se preocupa de mostrarla
#No calcula totales
#En realidad hace lo que le pongas en test_rules.clp
c=$(docker ps -q) && [[ $c ]] && docker kill $c


docker build . -t test -f Dockertest


