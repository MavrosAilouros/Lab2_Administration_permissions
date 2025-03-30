#!/bin/bash

# Author: Jafet Cruz Salazar
# Directory monitoring service script.
# This script will monitor a directory (received as an argument)
# Detect creation, deletion, and modification of files
# Register each event in a log file.

# Check that 1 argument is provided.

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <directorio_a_monitorear>"
    echo "Ejemplo: $0 /home/jafet/Documentos"
    exit 1
fi

# Save the directory and logfile in a variable.

directory="$1"
log_file="$HOME/monitor.log"  # Archivo de log persistente por usuario

# Check that the directory exists.

if [ ! -d "$directory" ]; then
    echo "El directorio $directory no existe."
    exit 1
fi

echo "Monitorizando el directorio $directory"
echo "Registro de eventos en $log_file"

# Loop for monitoring

while true; do
  event=$(inotifywait -e create -e modify -e delete --format '%T %w %e %f' --timefmt '%F %T' "$directory" 2>/dev/null)
  echo "Evento detectado: $event"
  echo "$event" >> "$log_file"
done