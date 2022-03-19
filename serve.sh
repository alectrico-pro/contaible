



#sudo usermod -aG docker ${USER}
#doc es el directorio interno en los contenedores, se debe corresponder  docs en el host
#docs es el direcotorio donde github podría esperar que esté los archivos del servidor web
#Los arcchivos del servidor los genera entonces jekyll a partir de los archivos que genera
#contabilidad.py
#contabildiad.py ocupa el archivo alectrico-2021-facts.txt para generar mucho markdown en
#la carpeta alectrico-2021


#/ussr/bin/snap run docker.dockerd
#annot update snap namespace: cannot create symlink in "/etc/docker": existing file in the way
#snap-update-ns failed with code 1
#sudo rm /etc/docker -rf
#sudo /usr/bin/snap run docker.dockerd
#ailed to load listeners: can't create unix socket /var/run/docker.sock: listen unix /var/run/docker.sock: bind: permission denied



#sudo rm /var/run/docker.pid
#sudo dockerd --group docker --exec-root=/run/snap.docker --data-root=/var/snap/docker/common/var-lib



#/etc/systemd/system/docker.service.d/.#override.confdf74a5b8ed425ce7 
#sudo dockerd --debug 
#sudo dockerd --group docker --exec-root=/run/snap.docker --data-root=/var/snap/docker/common/var-lib
#sudo rm /var/run/docker.sock
#snap list
#sudo systemctl status snap.docker.dockerd.service
#sudo systemctl daemon-reload
#sudo systemctl start snap.docker.dockerd.service
#sudo rm /var/run/docker -rf
#journalctl -u docker
#sudo chown $USER /var/run/docker.sock
#tio@tarara:~/guarded-ravine-40763/contabilidad$ sudo systemctl status snap.docker.dockerd.service
#● snap.docker.dockerd.service - Service for snap application docker.dockerd
#   Loaded: loaded (/etc/systemd/system/snap.docker.dockerd.service; enabled; vendor preset: enabled)
#   Active: failed (Result: exit-code) since Sun 2022-01-09 17:53:12 -03; 424ms ago
#  Process: 6850 ExecStart=/usr/bin/snap run docker.dockerd (code=exited, status=1/FAILURE)
# Main PID: 6850 (code=exited, status=1/FAILURE)
#tio@tarara:~/guarded-ravine-40763/contabilidad$ dockerd --group docker --exec-root=/run/snap.docker --data-root=/var/snap/docker/common/var-lib

#INFO[2022-01-09T17:54:44.724929331-03:00] Starting up                                  
#dockerd needs to be started with root. To see how to run dockerd in rootless mode with unprivileged user, see the documentation
#tio@tarara:~/guarded-ravine-40763/contabilidad$ 
#tio@tarara:~/guarded-ravine-40763/contabilidad$ sudo dockerd --group docker --exec-root=/run/snap.docker --data-root=/var/snap/docker/common/var-lib
#INFO[2022-01-09T17:54:51.541554318-03:00] Starting up                                  
#failed to start daemon: pid file found, ensure docker is not running or delete /var/run/docker.pid
#tio@tarara:~/guarded-ravine-40763/contabilidad$ sudo rm /var/run/docker.pid
##tio@tarara:~/guarded-ravine-40763/contabilidad$ sudo dockerd --group docker --exec-root=/run/snap.docker --data-root=/var/snap/docker/common/var-lib
#INFO[2022-01-09T17:55:47.674099362-03:00] Starting up                                  
#INFO[2022-01-09T17:55:47.675036644-03:00] detected 127.0.0.53 nameserver, assuming systemd-resolved, so using resolv.conf: /run/systemd/resolve/resolv.conf 
#INFO[2022-01-09T17:55:48.210366497-03:00] parsed scheme: "unix"                         module=grpc
#INFO[2022-01-09T17:55:48.210438385-03:00] scheme "unix" not registered, fallback to default scheme  module=grpc
#INFO[2022-01-09T17:55:48.210502279-03:00] ccResolverWrapper: sending update to cc: {[{unix:///run/containerd/containerd.sock  <nil> 0 <nil>}] <nil> <nil>}  module=grpc
#INFO[2022-01-09T17:55:48.210539475-03:00] ClientConn switching balancer to "pick_first"  module=grpc
#INFO[2022-01-09T17:55:48.423032879-03:00] parsed scheme: "unix"                         module=grpc
#INFO[2022-01-09T17:55:48.423080356-03:00] scheme "unix" not registered, fallback to default scheme  module=grpc
#INFO[2022-01-09T17:55:48.423159423-03:00] ccResolverWrapper: sending update to cc: {[{unix:///run/containerd/containerd.sock  <nil> 0 <nil>}] <nil> <nil>}  module=grpc
#INFO[2022-01-09T17:55:48.423196472-03:00] ClientConn switching balancer to "pick_first"  module=grpc
#WARN[2022-01-09T17:55:55.022272653-03:00] Your kernel does not support swap memory limit 
#WARN[2022-01-09T17:55:55.022319676-03:00] Your kernel does not support CPU realtime scheduler 
#INFO[2022-01-09T17:55:55.067491175-03:00] Loading containers: start.                   
#INFO[2022-01-09T17:56:01.222954446-03:00] Default bridge (docker0) is assigned with an IP address 172.17.0.0/16. Daemon option --bip can be used to set a preferred IP address 
#INFO[2022-01-09T17:56:05.592214865-03:00] Loading containers: done.                    
#INFO[2022-01-09T17:56:12.593205121-03:00] Docker daemon                                 commit="20.10.7-0ubuntu5~18.04.3" graphdriver(s)=overlay2 version=20.10.7
#INFO[2022-01-09T17:56:12.961965589-03:00] Daemon has completed initialization          
#INFO[2022-01-09T17:56:16.078241870-03:00] API listen on /var/run/docker.sock    

c=$(docker ps -q) && [[ $c ]] && docker kill $c


docker rm store 
docker build . -t necios
docker run -p 4000:4000 --name store -v $(pwd)/docs:/doc necios bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R'

docker run -p 4000:4000 --volumes-from store -v $(pwd)/docs:/doc necios bash -c 'cd /doc && jekyll serve'

