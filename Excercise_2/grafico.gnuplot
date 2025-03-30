
set terminal png size 800,600
set output "grafico_uso.png"
set title "Consumo de CPU y Memoria"
set xlabel "Segundos"
unset xdata
unset timefmt
unset format
set ylabel "Uso (%)"
set yrange [0:*]
set grid
plot "reporte_de_uso.log" using 1:2 with lines title "CPU (%)",      "reporte_de_uso.log" using 1:3 with lines title "Memoria (%)"
