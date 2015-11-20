raspberry pi docker-lizmap 
=============

![docker_lizmap](https://cloud.githubusercontent.com/assets/6421175/5647770/4ac27af4-9689-11e4-809a-dce0c2d60b1c.png)
__________________________________________________________________

Go to the WIKI (in french) for global installation of standalone server WebGIS with Docker, Postgresql/Postgis, Qgis-server and lizmap :

https://github.com/jancelin/rpi-docker-lizmap/wiki

____________________________________________________________________

LizMap est une solution complète de publication de cartes QGIS sur Internet.

LizMap is a complete Internet QGIS map publishing.

=============
lizmap-plugin-master / lizmap-web-client-3.0pre / qgis-mapserver-2.8.3 
=============

for install docker in the raspberry pi : 

http://blog.hypriot.com/heavily-armed-after-major-upgrade-raspberry-pi-with-docker-1-dot-5-0


![docker_lizmap](https://cloud.githubusercontent.com/assets/6421175/11306745/27df8ff2-8fb4-11e5-9624-c51fd70b6956.jpg)

This image contains a WebGIS server: 
Apache, qgis-mapsever, lizmap-web-client, and all dependencies required for operation


To build the image do:

 you can build an image from Dockerfile:

```
docker build -t jancelin/rpi-docker-lizmap git://github.com/jancelin/rpi-docker-lizmap

```

-----------------------------------------------------------------------------------

2.before running :  

Copy or create the .qgs files and .cfg.qgs (lizmap plugin) into a directory on the host, do a chown -R :www-data on the folder

```
mkdir /your_qgis_folder
chown -R :www-data /your_qgis_folder
```

To run a container do:
```
docker run --restart="always" --name "websig-lizmap" -p 80:80 -d -t -v /your_qgis_folder:/home:ro jancelin/rpi-docker-lizmap
```

-p 80:80 ---> link between the port 80 of the host  and port 80 of the Container

-v /your_folder:/home:ro ---> provides a link between your host file (read-only)containing the .qgs, and / home Container.

* If you want to edit the container: 
```
docker run  -i -t jancelin/docker-lizmap /bin/bash 
```
if you want to save your edition into a new image: 
```
docker commit "id_of_container" "new_image_name"
```
____________________________________________________________________________________


Lizmap working with your data and config at : 

http://"your_ip_rpi_wifi_serveur"/websig/lizmap/www/

lizmap admin at 

http://"your_ip_rpi_wifi_serveur"/websig/lizmap/www/admin.php



____________________________________________________________________________________

Lizmap Web Application generates dynamically a web map application (php/html/css/js) with the help of Qgis Server ( QGIS Server Tutorial ). You can configure one web map per Qgis project with the QGIS LizMap Plugin.

http://docs.3liz.com/

http://www.3liz.com/

____________________________________________________________________________________

Julien ANCELIN ( julien.ancelin@stlaurent.lusignan.inra.fr) 01/2015

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Licence Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>

