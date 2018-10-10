
# Instructions pour builder / run l'app

## Build de l'app
    mvn clean package
    

## Base de données

- creation arborescence local pour persistance des données mysql
       
       mkdir -p /home/hackathon/storage/mysql1/mysqlbank1-datadir
 
 
- creation arborescence local pour fichier de config mysql
   
         mkdir -p /home/hackathon/storage/config-files/rct-mysql


- Copier les scripts d'init BDD vers 

/home/hackathon/storage/config-files/rct-mysql/init_user.sql

/home/hackathon/storage/config-files/rct-mysql/initDB.sql

/home/hackathon/storage/config-files/rct-mysql/populateDB.sql


- pull de mysql 5.7.23

       sudo docker pull mysql:5.7.23


- creation du container mysql avec volumes persitants

       sudo docker run -d --name=mysql_bank1 -p 33009:3306 -e MYSQL_ROOT_PASSWORD=mypasswd -v /home/hackathon/storage/mysql1/mysqlbank1-datadir:/var/lib/mysql mysql


- init du user root ( 1 seule fois) 

       sudo mysql -uroot -h 192.168.1.238 -P 33009 --protocol=tcp -p  < /home/hackathon/storage/config-files/rct-mysql/init_user.sql


- lancement des scripts d'initialisation schema

       sudo mysql -uroot -h 192.168.1.238 -P 33009 --protocol=tcp -p < /home/hackathon/storage/config-files/rct-mysql/initDB.sql


- lancement insert des données

      sudo mysql -uroot -h 192.168.1.238 -P 33009 --protocol=tcp -p < /home/hackathon/storage/config-files/rct-mysql/populateDB.sql


## Run de l'app:
    docker run -d -p 8888:8080 -e jpa.database=MYSQL -e jdbc.driverClassName=com.mysql.jdbc.Driver -e jdbc.url=jdbc:mysql://192.168.1.149:3306/containerbank?serverTimezone=GMT -e jdbc.username=root -e jdbc.password=toto catitres:1.0
