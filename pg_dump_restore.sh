#!/bin/sh 

## SCRIPT DE SYNCHRONISATION RPI DB TO SERVER DB
#
	## tout d'abord permettre le transfert sans password de fichier en ssh donc génération d'une clef
	## sur le rpi: 			ssh-keygen -t dsa 
	## puis: 			scp .ssh/id_dsa.pub me@0.0.0.0:~/.ssh/authorized_keys 
	## enfin sur le maitre:		chmod 0600 ~/.ssh/authorized_keys 
	## Et faire l'inverse pour la restauration
#
	## ne pas oublier de rendre son script exécutable: sudo chmod +x /home/pi/pg_dump_restore.sh

#--------------------------------------------------------------------------------------------------------------------------------------

# sur le serveur central
IP='0.0.0.0'  					      	# quelle ip server central?
USER='me'    				        		# quel utilisateur du serveur central?
REP='/home/postgres/dump_rpi' 	# quel repertoire du serveur central pour la sauvegarde du dump (racine du fichier remanent docker-postgis)?
BD_NAME_SERVER='docker'					# nom d'utilisateur de la base serveur
BD_ROLE_SERVER='docker'					# role de l'utilisateur de la base seveur
BD_REST='vierge'					    	# Base sur serveur utilisé pour lancer la restauration (template0 + UTF8 + pas de schema)

# sur le rpi
REP_RPI='/home/postgres'				# quel répertoire de sauvegarde des dump sur le rpi (racine du fichier remanent docker-postgis)?
BD_DUMP='my_db'							    # Base RPI à dumper
BD_NAME_RPI='docker'						# nom d'utilisateur de la base rpi
BD_ROLE_RPI='docker'						# role de l'utilisateur de la base rpi
NAME="dump_rpi-`date +%Y-%m-%d-%H:%M:%S`.backup"		# nom du dump sur le rpi

# verification des branchements
ETHERNET=`cat /sys/class/net/eth0/carrier`			# le cable ethernet est t'il branché?
PING=`ping -q -c5 $IP > /dev/null` 				      # ping du serveur distant


if [ "$ETHERNET" -eq 1 ]; then	#cable branché?
  if [ "$PING"? -eq 0 ]; then   #serveur distant accessible?

     #pg_dump db rpi via docker
     docker exec  postgis sh -c "pg_dump -w --host localhost --port 5432 --username $BD_NAME_RPI --role $BD_ROLE_RPI --format custom  --encoding UTF8 --ignore-version -f /var/lib/postgresql/$NAME $BD_DUMP " 

     #transert du dump vers serveur central
     scp -B $REP_RPI/$NAME $USER@$IP:$REP

     #pg_restore db serveur via docker via ssh
     ssh $USER@$IP 'docker exec postgis sh -c "pg_restore -w --host '$IP' --port 5432 --username '$BD_NAME_SERVER' --dbname '$BD_REST' --role '$BD_ROLE_SERVER' -Fc --clean --create --ignore-version /var/lib/postgresql/dump_rpi/'$NAME'";'
	
	echo ' OK DUMP RPI, OK RESTORE SERVER, à plus'
  else
	echo 'ça ping pas !!!'
  fi 
else
echo 'cable ethernet non branché !!!'
fi
