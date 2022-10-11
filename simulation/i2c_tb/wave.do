onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_controller_tb/I2C_CLK_SPEED
add wave -noupdate /i2c_controller_tb/SYS_CLK_SPEED
add wave -noupdate /i2c_controller_tb/HALF_CLK_DELAY
add wave -noupdate /i2c_controller_tb/clk
add wave -noupdate /i2c_controller_tb/rst
add wave -noupdate /i2c_controller_tb/GSENSOR_CS_N
add wave -noupdate /i2c_controller_tb/GSENSOR_INT
add wave -noupdate /i2c_controller_tb/GSENSOR_SCL
add wave -noupdate /i2c_controller_tb/GSENSOR_SDA
add wave -noupdate /i2c_controller_tb/ALT_ADDRESS
add wave -noupdate /i2c_controller_tb/DEV_ADDR
add wave -noupdate /i2c_controller_tb/REG_ADDR
add wave -noupdate /i2c_controller_tb/R_W
add wave -noupdate /i2c_controller_tb/WRITE_DATA
add wave -noupdate /i2c_controller_tb/READ_DATA
add wave -noupdate /i2c_controller_tb/DBG_STATE
add wave -noupdate /i2c_controller_tb/DBG_VALS
add wave -noupdate /i2c_controller_tb/start_i2c_comms
add wave -noupdate /i2c_controller_tb/i2c_comms_finished
add wave -noupdate /i2c_controller_tb/ready
add wave -noupdate /i2c_controller_tb/i2c_controller_dut/clk_count
add wave -noupdate /i2c_controller_tb/i2c_controller_dut/scl_1qtr
add wave -noupdate /i2c_controller_tb/i2c_controller_dut/scl_2qtr
add wave -noupdate /i2c_controller_tb/i2c_controller_dut/scl_3qtr
add wave -noupdate /i2c_controller_tb/i2c_controller_dut/scl_start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6143 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {24389 ns}
