module Accerleromter_tb;

  // Parameters

  // Ports
  reg MAX10_CLK1_50 = 0;
  wire [7:0] HEX0;
  wire [7:0] HEX1;
  wire [7:0] HEX2;
  wire [7:0] HEX3;
  wire [7:0] HEX4;
  wire [7:0] HEX5;
  reg [1:0] KEY;
  wire [9:0] LEDR;
  wire [35:0] debugGPIO;
  wire GSENSOR_CS_N;
  reg [2:1] GSENSOR_INT;
  wire GSENSOR_SCLK;
  wire GSENSOR_SDI;
  wire GSENSOR_SDO;

  Accerleromter 
  Accerleromter_dut (
    .MAX10_CLK1_50 (MAX10_CLK1_50 ),
    .HEX0 (HEX0 ),
    .HEX1 (HEX1 ),
    .HEX2 (HEX2 ),
    .HEX3 (HEX3 ),
    .HEX4 (HEX4 ),
    .HEX5 (HEX5 ),
    .KEY (KEY ),
    .LEDR (LEDR ),
    .debugGPIO (debugGPIO ),
    .GSENSOR_CS_N (GSENSOR_CS_N ),
    .GSENSOR_INT (GSENSOR_INT ),
    .GSENSOR_SCLK (GSENSOR_SCLK ),
    .GSENSOR_SDI (GSENSOR_SDI ),
    .GSENSOR_SDO  ( GSENSOR_SDO)
  );

  initial begin
    $finish();
  end


endmodule
