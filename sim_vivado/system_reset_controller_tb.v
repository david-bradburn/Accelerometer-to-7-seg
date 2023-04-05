module system_reset_controller_tb;

  // Parameters
  localparam  SYS_CLK_SPEED = 50000000;
  localparam  NO_OF_CLK_CYCLES = 20;

  // Ports
  reg  clk = 0;
  wire  reset;

  system_reset_controller 
  #(
    .NO_OF_CLK_CYCLES ( NO_OF_CLK_CYCLES )
  )
  system_reset_controller_dut (
    .clk ( clk ),
    .reset  ( reset)
  );

  initial begin
    #1000;
  end

  always begin
    #5  clk = ! clk ;
  end

endmodule
