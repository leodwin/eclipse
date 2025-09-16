from fedora
maintainer leodwin
arg web=httpd
# this variable web will not be present in the container
env server=$web
env color=black

#all env variable will be present in container
run yum install $server -y
# install httpd web server as default
workdir /opt/
# changing current working dir in the container
copy . .
# will copy the data to the image
expose 80
# exposing port in the container
entrypoint ["/bin/bash","/opt/entrypoint.sh"]
