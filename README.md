Para elasticsearsh solo comprobamos si el servicio se está ejecutando
curl -X GET "localhost:9200"

Para configurar el servicio kibana tenemos que crear un usuario administrativo y crear un proxy inverso usando nginx

echo "kibanaadmin`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users

creamos un archivo en esta ubicacion

sudo vi /etc/nginx/sites-available/example.com
Y copiamos el siguiente código 

server {
    listen 80;
    server_name example.com;
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
Con este código, se configura Nginx para dirigir el tráfico HTTP de su servidor a la aplicación de Kibana y pedir una autenticación básica.
Luego creamos un enlace simbólico en esta dirección 
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
verificamos si está bien el código y reiniciamos el servicio nginx
sudo nginx -t
sudo systemctl restart nginx
Ahora modificamos el archivo hosts para que pueda entrar 
/etc/hosts 
Agregaos en la siguiente línea con el nombre de la pagina 
127.0.0.1	localhost example.com
En el servicio logstash creamos 2 archivo que nos permite 
sudo vim /etc/logstash/conf.d/02-beats-input.conf
copiamos el siguiente contenido 
input {
  beats {
    port => 5044
  }
}
------------------------------------------------------------------------------------------------------------------------------
sudo vim /etc/logstash/conf.d/30-elasticsearch-output.conf
copiamos lo siguiente
output {
  elasticsearch {
    hosts => ["localhost:9200"]
    manage_template => false
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
Comprobamos si está bien la sisntaxis 
sudo -u logstash /usr/share/logstash/bin/logstash --path.settings /etc/logstash -t
Finalizamos con la configuración de filebeat                                                                                
Establecemos conexión con logstash esto hará un procesamiento adicional a los datos recopilados por Filebeat, para eso entramos en el siguiente archivo y buscamos la sección output.elasticsearch y comentamos las siguiente líneas con # 
sudo nano /etc/filebeat/filebeat.yml
#output.elasticsearch:
 #hosts: ["localhost:9200"]
esto deshabilita la conexión directa con elasticsearch para poder establecer la conexión con logstash, ahora vamos a la sección output.logstash y borramos los # las siguientes líneas 
output.logstash:
hosts: ["localhost:5044"]
Ahora habilitamos los módulos del sistema para que recopile y analice los registros creados por el servicio de registro del sistema de distribuciones comunes de Linux.
sudo filebeat modules enable system
A continuación, cargamos la plantilla de índice en Elasticsearch
sudo filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
