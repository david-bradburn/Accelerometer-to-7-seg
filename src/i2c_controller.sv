
`default_nettype wire
`include "types.svh"

//TODO at somepoint
// - Implement writing lol
// - Clock streching
// - More debug
// - Burst reads?
// - Write this to be more general i2c module


//NEED TO ADD CLOCKSPEED PARAMETER
module i2c_controller #(
	parameter SYS_CLK_SPEED = 50000000, //50 MHz
	parameter I2C_CLK_SPEED = 100000 //100 kHz
)
(

	input  wire clk,
	input  wire rst,

	output wire        GSENSOR_CS_N, //tied to high
	input  wire [1:0]  GSENSOR_INT,  //this can just be ignored, might be an issue in cobnstraints
	output wire        GSENSOR_SCL,
	inout  wire        GSENSOR_SDA,
	inout  wire        ALT_ADDRESS,  //tied to 0

	input wire [6:0]   DEV_ADDR, // 0x1D - for accelerometer
	input wire [7:0]   REG_ADDR,
	input wire         R_W,
	input wire [7:0]   WRITE_DATA,
	output reg [7:0]   READ_DATA,

   output i2c_state_e DBG_STATE,
   output wire [7:0]  DBG_VALS,

	input wire         start_i2c_comms,
	output reg         i2c_comms_finished,
   output reg         ready

);


localparam SCL_CLK_COUNT = SYS_CLK_SPEED / I2C_CLK_SPEED ; 


assign ALT_ADDRESS = 1'b1; //tied to normal address 0x1D
assign GSENSOR_CS_N = 1'b1; //so we are tied into i2c mode


//pullup(GSENSOR_SCL); //can't use pullups // pulldowns on quartus rip



integer clk_count = 0;
reg scl_oe = 1; //just held high
reg scl_o = 0;
reg scl_i = 0;
reg sda_oe = 0;
reg sda_i = 0;
reg sda_o = 0;

reg transistion_state = 0;



wire scl_1qtr;
wire scl_2qtr;
wire scl_3qtr;

reg nack_sent = 0;

wire scl_start;
assign scl_start = (clk_count == 0)   ?  1 : 0;
assign scl_1qtr  = (clk_count == SCL_CLK_COUNT/4)   ?  1 : 0;
assign scl_2qtr  = (clk_count == SCL_CLK_COUNT/2)   ?  1 : 0;
assign scl_3qtr  = (clk_count == 3*SCL_CLK_COUNT/4) ?  1 : 0;

reg [7:0] reg_counter = 7;

// always @(posedge clk) begin
// 	if(rst) begin
// 	end else begin
// 		if(start_i2c_comms) 
// 		if(i2c_comms_finished) ready <= 1'b1;
// 	end
// end

always @(*) begin
	if (scl_oe) begin
		scl_o <= scl_i;
	end
	else begin
		scl_o <= 1'bz;
	end
end

always @(*) begin
	if (sda_oe) begin
		sda_o <= sda_i;
	end
	else begin
		sda_o <= 1'bz;
	end
end

assign GSENSOR_SCL = scl_o;
assign GSENSOR_SDA = sda_o;

assign DBG_VALS = {5'b0, scl_oe, sda_oe, sda_o};


// `define IDLE 0
// `define START 1
// `define SEND_DEVICE_ADDRESS 2
// `define DEV_ADDRESS_ACK 3
// `define SEND_REGISTER_ADDRESS 4
// `define REG_ADDRESS_ACK 5
// `define SEND_WRITE_DATA 6
// `define RESTART 7
// `define SEND_DEVICE_ADDRESS_AGAIN 8
// `define DEV_ADDRESS_ACK_AGAIN 9
// `define RECEIVE_READ_DATA 10
// `define SEND_NACK 11
// `define STOP 12

// `define ERROR 255


i2c_state_e state = IDLE;
i2c_state_e next_state = IDLE;



reg past_ack = 1'b1;

logic burst_write = 0;

assign DBG_STATE = state;

always @(posedge clk) begin //next_state always loop
   if(rst) begin
      next_state <= IDLE;
      i2c_comms_finished <= 1'b0;   
      ready <= 1'b1;
   end else begin
      case(state)
         IDLE: begin
            if(start_i2c_comms & ready) begin
               next_state <= START;
               i2c_comms_finished <= 1'b0;
               ready <= 1'b0;
            end else begin
               sda_oe <= 1'b0;
            end
         end

         START: begin
            if(scl_1qtr) begin
               sda_oe <= 1'b1;
               sda_i <= 1'b0;
               reg_counter <= 7;
            end

            if(scl_3qtr) begin
               next_state <= SEND_DEVICE_ADDRESS;
               //reg_counter <= 7;
            end
         end

         SEND_DEVICE_ADDRESS: begin
            if(reg_counter > 0) sda_i <= DEV_ADDR[reg_counter-1];
            if(reg_counter == 0) sda_i <= 0;
            if(scl_3qtr) reg_counter <= reg_counter - 1;

            if((reg_counter == 8'hff)) begin
               next_state <= DEV_ADDRESS_ACK;
               sda_oe <= 1'b0;
               // reg_counter <= 7;
            end
         end

         DEV_ADDRESS_ACK: begin
            if(scl_start) begin
               past_ack <= GSENSOR_SDA;
            end

            if(scl_3qtr) begin
               if(~past_ack) begin
                  past_ack <= 1'b1;
                  next_state <= SEND_REGISTER_ADDRESS;
                  sda_i <= 1'b1;
                  sda_oe <= 1'b1;
                  reg_counter <= 7;
               end else begin
                  next_state <= ERROR;
               end
            end
         end

         SEND_REGISTER_ADDRESS: begin
            if(reg_counter >= 0) sda_i <= REG_ADDR[reg_counter];
            if(scl_3qtr) reg_counter <= reg_counter - 1;

            if((reg_counter == 8'hff)) begin
               next_state <= REG_ADDRESS_ACK;
               sda_oe <= 1'b0;
            end
         end

         REG_ADDRESS_ACK: begin
            if(scl_start) begin
               past_ack <= GSENSOR_SDA;
            end
            if (scl_3qtr) begin
               if(~past_ack) begin
                  past_ack <= 1'b1;
                  if(R_W) begin 
                     next_state <= RESTART;
                  end else begin
                     next_state <=  SEND_WRITE_DATA;
                     sda_i <= 1'b1;
                     sda_oe <= 1'b1;
                     reg_counter <= 7;
                  end
               end else begin
                  next_state <= ERROR;
               end
            end
         end

         SEND_WRITE_DATA: begin
            if(reg_counter >= 0) sda_i <= WRITE_DATA[reg_counter];
            if(scl_3qtr) reg_counter <= reg_counter - 1;

            if((reg_counter == 8'hff)) begin
               next_state <= WRITE_DATA_ACK;
               sda_oe <= 1'b0;
            end
         end

         WRITE_DATA_ACK: begin
            if(scl_start) begin
               past_ack <= GSENSOR_SDA;
            end
            if (scl_3qtr) begin
               if(~past_ack) begin
                  past_ack <= 1'b1;
                  if(burst_write) begin 
                     next_state <= SEND_WRITE_DATA;
                  end else begin
                     next_state <= STOP;
   
                  end 
                  sda_i <= 1'b1;
                  sda_oe <= 1'b1;
                  reg_counter <= 7;

               end else begin
                  next_state <= ERROR;
               end
            end

         end

         RESTART: begin
            if(scl_1qtr) begin
               sda_oe <= 1'b1;
               sda_i <= 1'b0;
               reg_counter <= 7;
            end

            if(scl_3qtr) begin
               next_state <= SEND_DEVICE_ADDRESS_AGAIN;
               reg_counter <= 7;
            end
         end

         SEND_DEVICE_ADDRESS_AGAIN: begin
            if(reg_counter > 0) sda_i <= DEV_ADDR[reg_counter-1];
            if(reg_counter == 0) sda_i <= 1; //reading
            if(scl_3qtr) reg_counter <= reg_counter - 1;

            if((reg_counter == 8'hff)) begin
               next_state <= DEV_ADDRESS_ACK_AGAIN;
               sda_oe <= 1'b0;
               // reg_counter <= 7;
            end
         end

         DEV_ADDRESS_ACK_AGAIN: begin
            if(scl_start) begin
               past_ack <= GSENSOR_SDA;
            end

            if(scl_3qtr) begin
               if(~past_ack) begin
                  past_ack <= 1'b1;
                  next_state <= RECEIVE_READ_DATA;
                  sda_i <= 1'b0;
                  sda_oe <= 1'b0;
                  reg_counter <= 7;
               end else begin
                  next_state <= ERROR;
               end
            end
         end

         RECEIVE_READ_DATA: begin
            if(scl_start) begin
               READ_DATA[reg_counter] <= GSENSOR_SDA;
            end
            if(scl_3qtr) begin
               reg_counter <= reg_counter - 1;
            end

            if((reg_counter == 8'hff)) begin
               next_state <= SEND_NACK;
               sda_oe <= 1'b1;
               sda_i <= 1'b1;
               reg_counter <= 7;
            end
         end

         SEND_NACK: begin
            if(scl_start & GSENSOR_SDA) begin
               nack_sent <= 1'b1;
            end

            if(scl_3qtr & nack_sent) begin
               sda_oe <= 1'b1;
               nack_sent <= 1'b0;
               next_state <= STOP;
               sda_i <= 1'b0;
            end
         end

         STOP: begin
            if(scl_3qtr) begin
               sda_oe <= 1'b1;
               sda_i <= 1'b1;
               next_state <= IDLE;
               i2c_comms_finished <= 1'b1;
               ready <= 1'b1;
            end
         end

         default: begin
            if(state == IDLE) next_state <= IDLE; // kinda obsolete;?
            if(state == ERROR) next_state <= ERROR;
            next_state <= ERROR;
         end
      endcase
   end
end



always @(posedge clk) begin //what should the transistion be??
   state <= next_state;
end


always @(posedge clk) begin
   if (state != IDLE | state != ERROR) begin
      scl_oe <= 1'b1;
      if (clk_count < (SCL_CLK_COUNT/2)) begin
         scl_i <= 1'b1;
      end
      else begin
         scl_i <= 1'b0;
      end

      if (clk_count < SCL_CLK_COUNT - 1) begin
         clk_count <= clk_count + 1;
      end
      else begin
         clk_count <= 0;
      end
   end else begin
      scl_oe <= 1'b0;
      clk_count <= 0;
   end
end



endmodule

`default_nettype none

