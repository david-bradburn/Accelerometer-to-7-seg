// add assert statements
 

`include "types.svh"

module i2c_controller_tb;

  // Parameters
  localparam  I2C_CLK_SPEED = 100000;
  localparam  SYS_CLK_SPEED = 50000000; // MHz
  localparam  HALF_CLK_DELAY = 1000000000/(2*SYS_CLK_SPEED);
  // Ports
  reg  clk = 0;
  reg  rst = 1;
  wire  GSENSOR_CS_N;
  reg [1:0] GSENSOR_INT; 
  wire      GSENSOR_SCL;
  wire      GSENSOR_SDA;
  wire  ALT_ADDRESS;
  reg [6:0] DEV_ADDR;
  reg [7:0] REG_ADDR;
  reg  R_W = 0;
  reg [7:0] WRITE_DATA;
  wire [7:0] READ_DATA;
  i2c_state_e DBG_STATE;
  wire [7:0] DBG_VALS;
  reg  start_i2c_comms = 0;
  wire i2c_comms_finished;
  wire ready;

  pullup(GSENSOR_SDA);
  pullup(GSENSOR_SCL);

  i2c_controller 
  #(
    .SYS_CLK_SPEED(SYS_CLK_SPEED),
    .I2C_CLK_SPEED (I2C_CLK_SPEED )
  )
  i2c_controller_dut (
    .clk (clk ),
    .rst (rst ),
    .GSENSOR_CS_N (GSENSOR_CS_N ),
    .GSENSOR_INT (GSENSOR_INT ),
    .GSENSOR_SCL (GSENSOR_SCL ),  
    .GSENSOR_SDA (GSENSOR_SDA ),
    .ALT_ADDRESS (ALT_ADDRESS ),
    .DEV_ADDR (DEV_ADDR ),
    .REG_ADDR (REG_ADDR ),
    .R_W (R_W ),
    .WRITE_DATA (WRITE_DATA ),
    .READ_DATA (READ_DATA ),
    .DBG_STATE (DBG_STATE ),
    .DBG_VALS (DBG_VALS),
    .start_i2c_comms (start_i2c_comms ),
    .i2c_comms_finished (i2c_comms_finished ),
    .ready  ( ready)
  );

  logic GSENSOR_SDA_i;
  logic GSENSOR_SDA_oe = 1'b0;
  
  assign GSENSOR_SDA = GSENSOR_SDA_oe ? GSENSOR_SDA_i : 1'bz;

  initial begin
    rst <= 1'b1;

    #100;
    rst <= 1'b0;
    GSENSOR_INT <= 2'b0;
    DEV_ADDR <= 8'h1D;
    REG_ADDR <= 8'h0;
    R_W <= 1'b1;

    #20
    assert(i2c_controller_dut.state == IDLE);

    @(posedge clk);
    start_i2c_comms <= 1'b1;
    #20
    start_i2c_comms <= 1'b0;
    @(negedge GSENSOR_SCL);
    assert(i2c_controller_dut.state == START);

    // $display("egg");

    @(posedge GSENSOR_SCL);
    assert(i2c_controller.state == SEND_DEVICE_ADDRESS);
    // $display("egg");

    //sending device addess
    #77520;
    assert(i2c_controller_dut.state == DEV_ADDRESS_ACK);
    // $display("egg");

    //sending device address ack
    GSENSOR_SDA_oe <= 1'b1;
    GSENSOR_SDA_i <= 1'b0;
    @(posedge GSENSOR_SCL);
    GSENSOR_SDA_oe <= 1'b0;

    //sending register address
    #87540;
    //sending register address ack
    GSENSOR_SDA_oe <= 1'b1;
    GSENSOR_SDA_i <= 1'b0;
    @(posedge GSENSOR_SCL);
    GSENSOR_SDA_oe <= 1'b0;

    //restart
    //sending device address
    #97540;

    //sending device address ack
    GSENSOR_SDA_oe <= 1'b1;
    GSENSOR_SDA_i <= 1'b0;
    @(posedge GSENSOR_SCL);
    GSENSOR_SDA_oe <= 1'b0;
    // Reading register data

    #107520;
    //just idle it
    #1000;
    //write time
    REG_ADDR <= 8'hee;
    WRITE_DATA <= 8'hAB;
    R_W <= 1'b0;
    #200

    @(posedge clk);
    start_i2c_comms <= 1'b1;
    #20
    start_i2c_comms <= 1'b0;
        //sending device addess
    #84880;
    //sending device address ack
    GSENSOR_SDA_oe <= 1'b1;
    GSENSOR_SDA_i <= 1'b0;
    @(posedge GSENSOR_SCL);
    GSENSOR_SDA_oe <= 1'b0;

    //sending register address
    #87540;
    //sending register address ack
    GSENSOR_SDA_oe <= 1'b1;
    GSENSOR_SDA_i <= 1'b0;
    @(posedge GSENSOR_SCL);
    GSENSOR_SDA_oe <= 1'b0;

    @(posedge clk);
    start_i2c_comms <= 1'b1;
    #20
    start_i2c_comms <= 1'b0;

    //sending write data
    #87520;
    //sending ack
    GSENSOR_SDA_oe <= 1'b1;
    GSENSOR_SDA_i <= 1'b0;
    @(posedge GSENSOR_SCL);
    GSENSOR_SDA_oe <= 1'b0;

    #1000;
    @(posedge GSENSOR_SCL);
    @(posedge GSENSOR_SCL);
    #1000;

    $finish;

    // $finish;
  end

  always @(posedge clk) begin
    if(DBG_STATE == ERROR) begin
      $display("Have entered error state");
      $finish;
    end
  end

  always begin
    #HALF_CLK_DELAY  clk = ! clk ;
  end


endmodule
