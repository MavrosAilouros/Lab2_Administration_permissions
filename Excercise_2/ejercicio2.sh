#!/bin/bash

# Author: Jafet Cruz Salazar
# CPU and RAM usage monitoring script.
# This script will monitor CPU and RAM usage of a process
# Plot the usage in a graph and save it to a file.
# Register usage in a log file.

# Check that 1 argument is provided.

if [ "$#" -lt 1 ]; then
    echo "Uso: $0 <nombre_del_proceso>"
    echo "Ejemplo: $0 firefox"
    exit 1
fi

# Save the command in a variable.

command="$@"

# Execute the command using setsid to maintain session linkage and save the PID.

setsid $command &
pid=$!
echo "Ejecutando "$command", PID: $pid"

# Wait for the process to start.
sleep 0.5

# Create a log file.

log_file="reporte_de_uso.log"
printf "%-8s %-7s %-7s\n" "Segundos" "CPU(%)" "MEM(%)" > $log_file

# Initialize time counter
SECONDS_SINCE_START=0

# Monitor while the process is active

while kill -0 "$pid" 2>/dev/null; do 
    Usage=$(ps -p $pid -o %cpu,%mem --no-headers)
    printf "%-8s %-7s %-7s\n" "$SECONDS_SINCE_START" $Usage >> $log_file
    sleep 1
    SECONDS_SINCE_START=$((SECONDS_SINCE_START + 1))
done

# Plot the usage in a graph and save it to a file.

Plotfile="grafico_uso.png"
GNUplotfile="grafico.gnuplot"

cat << EOF > "$GNUplotfile"

set terminal png size 800,600
set output "$Plotfile"
set title "Consumo de CPU y Memoria"
set xlabel "Segundos"
unset xdata
unset timefmt
unset format
set ylabel "Uso (%)"
set yrange [0:*]
set grid
plot "$log_file" using 1:2 with lines title "CPU (%)", \
     "$log_file" using 1:3 with lines title "Memoria (%)"
EOF

# Execute gnuplot to create the graph.

gnuplot "$GNUplotfile"

echo "El grafico ha sido guardado en $Plotfile"