#!/bin/bash

# Author: Jafet Cruz Salazar
# User and group administrator script.
# This script will manage users, groups and permissions over a file.
# It will create a group, add a user to the group, set permissions and ownership.

# Log file
log="ejercicio1.log"
echo "=== Log de ejecución ===" > "$log"

# Check if user is root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como Root" | tee -a "$log"
    exit 1
fi

# Check that the correct number of arguments is provided.
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <usuario> <grupo> <ruta_del_archivo>" | tee -a "$log"
    echo "Ejemplo: $0 jafet administradores /home/jafet/archivo" | tee -a "$log"
    exit 1
fi

User=$1
Group=$2
File=$3

# Check if the group already exists if not create a group with the same name.
if getent group "$Group" > /dev/null; then
    echo "El grupo $Group ya existe." | tee -a "$log"
else
    echo "El grupo $Group no existe. Creando grupo..." | tee -a "$log"
    groupadd "$Group"
fi  

# Check if the user already exists if not create a user with the same name.
if id "$User" &>/dev/null; then
    echo "El usuario $User ya existe." | tee -a "$log"
    if id -nG "$User" | grep -qw "$Group"; then
        echo "El usuario $User ya pertenece al grupo $Group." | tee -a "$log"
    else
        echo "Agregando el usuario $User al grupo $Group..." | tee -a "$log"
        usermod -aG "$Group" "$User"
        echo "El usuario $User ha sido agregado al grupo $Group." | tee -a "$log"
    fi
else
    echo "El usuario $User no existe. Creando usuario y asignandolo al grupo $Group..." | tee -a "$log"
    useradd -m -g "$Group" "$User"
    echo "El usuario $User ha sido creado y agregado al grupo $Group." | tee -a "$log"
fi

# Check if the file exists
if [ -e "$File" ]; then
  echo "El archivo $File existe." | tee -a "$log"

  read owner group <<< $(stat -c "%U %G" "$File")
  if [ "$owner" = "$User" ] && [ "$group" = "$Group" ]; then
    echo "El archivo ya es propiedad de $User:$Group." | tee -a "$log"
  else
    echo "Cambiando la propiedad del archivo a $User:$Group..." | tee -a "$log"
    chown "$User:$Group" "$File"
  fi

  perms=$(stat -c "%a" "$File")
  if [ "$perms" = "740" ]; then
    echo "El archivo ya tiene permisos 740." | tee -a "$log"
  else
    echo "Cambiando permisos a 740..." | tee -a "$log"
    chmod 740 "$File"
    if [ $? -eq 0 ]; then
        echo "Permisos cambiados a 740." | tee -a "$log"
    else
        echo "No se pudieron cambiar los permisos del archivo $File." | tee -a "$log"
        exit 1
    fi
  fi

else
  echo "El archivo $File no existe. Terminando ejecución." | tee -a "$log"
  exit 1
fi
