
# Instructions pour builder / run l'app

## Base de données
...

## Run de l'app:
    docker run -d -p 8888:8080 -e jpa.database=MYSQL -e jdbc.driverClassName=com.mysql.jdbc.Driver -e jdbc.url=jdbc:mysql://192.168.1.149:3306/containerbank?serverTimezone=GMT -e jdbc.username=root -e jdbc.password=toto catitres:1.0
