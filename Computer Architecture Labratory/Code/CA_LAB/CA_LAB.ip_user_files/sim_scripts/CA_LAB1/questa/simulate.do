onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib CA_LAB1_opt

do {wave.do}

view wave
view structure
view signals

do {CA_LAB1.udo}

run -all

quit -force
