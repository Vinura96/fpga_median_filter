onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib input_output_ram_opt

do {wave.do}

view wave
view structure
view signals

do {input_output_ram.udo}

run -all

quit -force
