docker run --restart="always" --name "lizmap"  -p 80:80 -d -t -v /home/lizmap_project:/home -v /home/lizmap_var:/var/www/websig/lizmap/var  lizmap
echo "Now connect to geopoppy wifi and point your browser at: http://10.10.0.25"
