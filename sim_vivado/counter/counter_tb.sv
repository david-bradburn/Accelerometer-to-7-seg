module counter_tb;

  // Parameters
  localparam  max_count = 50;

  // Ports
  reg clk = 0;
  reg reset = 0;
  reg enable = 0;
  wire pulse;

  counter 
  #(
    .max_count ( max_count )
  )
  counter_dut (
    .clk       (clk ),
    .reset     (reset ),
    .enable    (enable ),
    .pulse     ( pulse)
  );

  initial begin
    #400;
    #100;
    assert (pulse == 1'b0)
    else $error("Assertion label failed!");

    enable <= 1'b1;
    #500;
    assert (pulse == 1'b1)
    else $error("pulse not 1");
    #10;
    assert (pulse == 1'b0);


    $finish;

  end
  
  system_reset_controller #(
    .NO_OF_CLK_CYCLES( 40 ),
    .ACTIVE_HIGH (1)
    ) rst_controller (
        .clk(clk),
        .reset( rst )
    );

    always begin
        #5  clk = ! clk ;
    end

endmodule
