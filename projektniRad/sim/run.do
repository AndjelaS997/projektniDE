if [file exists "work"] {vdel -all}
vlib work

vcom -2002 +acc ../hdl/counter_74S163.vhd
vcom -2002 +acc ../hdl/my_package.vhd
vcom -2002 +acc ../hdl/clock.vhd

vcom -2002 +acc ../hdl/tb_clock.vhd

vsim tb_clock -t 1ps -displaymsgmode both -debugDB -lib work -do "onbreak {resume};  log /* -r; \
    add wave -position end  sim:/tb_clock/*; 
    run -all; quit" -wlf top.wlf -l top.log 
