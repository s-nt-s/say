#!/bin/bash
TARGET=""
if [ "$1" == "--all" ]; then
	shift
	TARGET=$(cat $(awk -F":" '{if ($6 && !a[$6]++) print $6 "/.toxmpp"}' /etc/passwd) 2>/dev/null | tr "\\n" " ")
	if [ -z "$TARGET" ]; then
		echo "No hay destinatarios disponibles"
		exit 1
	fi
elif [ "$1" == "--group" ]; then
	shift
	TO=$(members $1)
	if [ $? -ne 0 ]; then
		exit 1
	fi
	if [ -z "$TO" ]; then
		echo "El grupo $1 no tiene miembros"
		exit 1
	fi
	TARGET=$(cat $(awk -F":" -v u=" $TO " '{if ($6 && !a[$6]++ && index(u," " $1 " ")) print $6 "/.toxmpp"}' /etc/passwd) 2>/dev/null | tr "\\n" " ")
	if [ -z "$TARGET" ]; then
		echo "El grupo $1 no tiene destinatarios disponibles"
		exit 1
	fi
	shift
elif [ "$1" == "--to" ]; then
	shift
	TO=$1
	TARGET=$1
	shift
	if [[ ! $TARGET =~ .+@.+\..+ ]]; then
		if getent passwd $TARGET >/dev/null 2>&1; then
			TARGET=$(eval echo "~$TARGET/.toxmpp")
			if [ ! -f $TARGET ]; then
				echo "El usuario $TO no dispone de cuenta xmpp"
				exit 1
			fi
		fi
		if [ -f $TARGET ]; then
			TARGET=$(< $TARGET)
		else
			echo "Destinatario $TO incorrecto. Pruebe con: cuenta xmpp, fichero o usuario linux"
			exit 1
		fi
	fi
fi
if [ -z "$TARGET" ] && [ -f "/root/.toxmpp" ]; then
	TARGET=$(<"/root/.toxmpp")
fi

if ( [ $# -eq 0 ] && [ -t 0 ] ) || [ -z "$TARGET" ]; then
	echo "Ejemplos de uso:"
	echo "	say file.txt"
	echo "	cat file.txt | say"
	echo "	say < file.txt"
	echo "	say Hola, soy un mensaje"
	echo "Usa --to para indicar un destinatario. Admite: cuenta xmpp, fichero que contenga cuentas xmpp o usuario linux"
	echo "Usa --all para mandar el mensaje a todos los usuarios disponibles"
	echo "Usa --group para mandar el mensaje a todos los miembros de un grupo"
	echo "En caso contrario el destinatario por defecto es root"
	exit 1
fi

CMD="sendxmpp -t $TARGET"

if [ ! -t 0 ]; then
	cat - | $CMD
fi
if [ $# -ge 1 ]; then
	if [ -f "$1" ]; then
		cat "$1" | $CMD
	else
		echo "$*" | $CMD
	fi
fi
exit 0
