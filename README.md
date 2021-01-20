# Prerrequisitos

$ sudo apt-get install sendxmpp

$ sudo apt-get install members

# Instalación

$ curl https://raw.githubusercontent.com/cyttorak/say/master/install.sh | bash

# Configuración

Crear fichero .sendxmpprc en la home de los usuarios que van a poder enviar con el formato:

user@server.com password componentname

y le damos solo permisos para su usuario

chmod 700 ~/.sendxmpprc

Crear fichero .toxmpp en la home de los usuarios que van a poder recivir mensajes que contenga las direcciones xmpp a las que se les va a enviar el mensaje que se mande a dicho usuario:

user@server.com user1@server2.com user3@server3.com

y le damos permisos de lectura a todos los usuarios

chmod 744 ~/.toxmpp

# Ejemplos de uso

* Enviar un mensaje desde root al usuario juan

sudo say --to juan Hola, soy root
* Enviar un mensaje desde el usuario conectado a root

say --to root Hola, root

ó

say Hola, root
* Enviar un mensaje desde el usuario conectado a una cuenta xmpp en concreto

sudo say --to ejemplo@xmpp.net Hola, ejemplo
* Enviar un mensaje desde el usuario conectado a una lista de cuentas xmpp contenida en un fichero y separadas por un espacio

sudo say --to amigos.txt Hola, amigos
* Enviar un mensaje desde el usuario conectado a los miembros del grupo trabajo

say --group trabajo Por fin es viernes
* Enviar un mensaje a todos los usuarios disponibles de la maquina

say --all Hola a todos

Para todos los casos el mensaje enviado puede obtenerse de tambien la entrada estandar o de un fichero:

$ echo "mensaje" | say --to juan

$ say --to juan mensaje.txt

# Ejemplo práctico

Imaginemos que queremos que cuando ocurra un login con exito por ssh se envie un mensaje a la cuenta xmpp de ese usuario para que en caso de no ser él quede avisado y pueda dar la alerta.

1- Descargamos notif-login y le damos permisos

$ wget https://raw.githubusercontent.com/cyttorak/say/master/ejemplos/notif-login

$ chmod 755 notif-login

2- Modificamos /etc/pam.d/sshd añadiendo la linea:

session optional pam_exec.so /ruta_script/notif-login

Con esto, cuando alguien entre a la maquina con el usuario juan, las cuentas xmpp detaladas en /home/juan/.toxmpp reciviran un mensaje como este:

20/07/2015 17:27 > juan@456.234.7.8 inicia sshd en TTY ssh
