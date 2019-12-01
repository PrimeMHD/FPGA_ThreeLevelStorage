onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib cache_opt

do {wave.do}

view wave
view structure
view signals

do {cache.udo}

run -all

quit -force
