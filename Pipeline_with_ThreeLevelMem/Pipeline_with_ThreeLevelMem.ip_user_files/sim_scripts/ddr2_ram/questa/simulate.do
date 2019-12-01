onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ddr2_ram_opt

do {wave.do}

view wave
view structure
view signals

do {ddr2_ram.udo}

run -all

quit -force
