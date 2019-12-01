onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.clk_wiz_for_cpu xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {clk_wiz_for_cpu.udo}

run -all

quit -force
