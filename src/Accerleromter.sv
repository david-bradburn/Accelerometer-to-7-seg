
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================
`include "types.svh"

// Implement some form of prgram counter

module Accerleromter(

	//////////// CLOCK //////////
	//input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	//input 		          		MAX10_CLK2_50,

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY, // button

	//////////// LED //////////
	output		     [9:0]		LEDR,
	
	//////////// GPIO //////////
	output		     [35:0]		debugGPIO,
	
	//////////// Accelerometer //////////
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

	wire rst;

	// system reset controller
	system_reset_controller #(
		.NO_OF_CLK_CYCLES( 40 ),
		.ACTIVE_HIGH (1)
	) rst_controller (
		.clk(MAX10_CLK1_50),
		.reset( rst )
	);

	
	assign LEDR = {2'b11, DBG_STATE};

//=======================================================
//  Structural coding
//=======================================================

	reg   [7:0] register_address;
	reg         R_W;
	reg   [7:0] write_data;
	wire  [7:0] read_data;
	logic [7:0] device_address;

	i2c_state_e DBG_STATE;
	wire [7:0]  DBG_VALS;
	reg         start_i2c_comms;
	wire        i2c_comms_finished;
	wire        ready;

	integer     program_counter = 0;
	
//	assign debugGPIO[35:0] = {36{1'b0}};
	assign debugGPIO[1:0] = {GSENSOR_SCLK, GSENSOR_SDI};
	assign debugGPIO[4:2] = DBG_VALS[2:0];
//	assign debugGPIO[35:2] = {33{1'b1}};
	

	i2c_controller #(
		.SYS_CLK_SPEED (50000000),
		.I2C_CLK_SPEED (100000) //100000
	) G_SENSOR_i2c (
		.clk                (MAX10_CLK1_50),
		.rst                (rst),
      
		.GSENSOR_CS_N       (GSENSOR_CS_N),
		.GSENSOR_INT        (GSENSOR_INT),
		.GSENSOR_SCL        (GSENSOR_SCLK),
		.GSENSOR_SDA        (GSENSOR_SDI),
		.ALT_ADDRESS        (GSENSOR_SDO),
      
		.DEV_ADDR           (7'h1D), //Fixed for now as there is only one device
		.REG_ADDR           (register_address),
		.R_W                (R_W),
		.WRITE_DATA         (write_data),
		.READ_DATA          (read_data),
		      
		.DBG_STATE          (DBG_STATE),
		.DBG_VALS           (DBG_VALS),

		.start_i2c_comms    (start_i2c_comms),
		.i2c_comms_finished (i2c_comms_finished),
		.ready              (ready)
	);

	reg data_read = 1'b0;

	always @(posedge MAX10_CLK1_50) begin
		if(rst) begin
			start_i2c_comms <= 1'b0;
		end else begin
			if(ready & refresh_pulse) begin
				start_i2c_comms <= 1'b1;
			end else begin
				start_i2c_comms <= 1'b0;
			end
		end
	end



	logic driver_ready;

	hex_driver_with_bcd hex_driver_with_bcd (
		.clk   (clk),
		.reset (rst),

		.number_in (read_data),
		.update    (refresh_pulse & driver_ready),

		.HEX0      ( HEX0 ),
		.HEX1      ( HEX1 ),
		.HEX2      ( HEX2 ),
		.HEX3      ( HEX3 ),
		.HEX4      ( HEX4 ),
		.HEX5      ( HEX5 ),

		.driver_ready (driver_ready)
	);

	st_instructionData instruction;
	
	register_memory #(
		.MEMORY_SIZE(255)
	) instructions (
		.clk        (MAX10_CLK1_50),
		.reset      (rst),
		.reg_addr   (program_counter),
		.read_data  (instruction),
		.error_code ()
	);

	always @(posedge MAX10_CLK1_50) begin
		//add comb logic for read_data decoding
		case(instruction.op_code)// might encode instruction to not be i2c specific?
			8'h00: begin // i2c read
				device_address <= instruction.device_address;
				register_address <= instruction.register_address;
				R_W <= 1'b1;
			end

			8'h01: begin // i2c write
				device_address <= instruction.device_address;
				register_address <= instruction.register_address;
				R_W <= 1'b0;
				write_data <= instruction.write_value;
			end
			

		endcase

	end

	`define REFRESH_RATE 50000000 // for 1 second
	logic enable = 1;
	logic refresh_pulse;

	counter 
	#(
	  .max_count ( `REFRESH_RATE )
	)
	refresh_timer (
	  .clk       (MAX10_CLK1_50 ),
	  .reset     (rst ),
	  .enable    (enable ), // need to decide when I want to enable it?
	  .pulse     (refresh_pulse)
	);
	
	






endmodule
