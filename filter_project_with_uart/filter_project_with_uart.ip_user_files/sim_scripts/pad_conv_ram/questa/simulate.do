onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib pad_conv_ram_opt

do {wave.do}

view wave
view structure
view signals

do {pad_conv_ram.udo}

run -all

quit -force
