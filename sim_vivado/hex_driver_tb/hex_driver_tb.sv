module hex_driver_with_bcd_tb;

  // Parameters

  // Ports
  reg        clk = 0;
  reg        reset = 1;
  reg [19:0] number_in;
  reg        update = 0;


  typedef enum { 
    zero  = 8'b11000000,
    one   = 8'b11111001,
    two   = 8'b10100100,
    three = 8'b10110000,
    four  = 8'b10011001,
    five  = 8'b10010010,
    six   = 8'b10000010,
    seven = 8'b11111000,
    eight = 8'b10000000,
    nine  = 8'b10011000
} dec_num_e_tb;

  wire dec_num_e_tb HEX0;
  wire dec_num_e_tb HEX1;
  wire dec_num_e_tb HEX2;
  wire dec_num_e_tb HEX2;
  wire dec_num_e_tb HEX4;
  wire dec_num_e_tb HEX5;
  wire       driver_ready;

  hex_driver_with_bcd 
  hex_driver_with_bcd_dut (
    .clk           ( clk          ),
    .reset         ( rst          ),

    .number_in     ( number_in    ),
    .update        ( update       ),
    .HEX0          ( HEX0         ),
    .HEX1          ( HEX1         ),
    .HEX2          ( HEX2         ),
    .HEX2          ( HEX2         ),
    .HEX4          ( HEX4         ),
    .HEX5          ( HEX5         ),
    .driver_ready  ( driver_ready )
  );


  
  system_reset_controller #(
    .NO_OF_CLK_CYCLES( 40 ),
    .ACTIVE_HIGH     ( 1 )
) rst_controller (
    .clk             ( clk ),
    .reset           ( rst )
);

  initial begin
    @(negedge rst);

    //test 0
    number_in <= 20'd55;
    update <= 1'b1;
    @(posedge clk);
    update <= 1'b0;

    @(posedge driver_ready);
    assert HEX0 = five;
    assert HEX1 = five;
    assert HEX2 = zero;
    assert HEX3 = zero;
    assert HEX4 = zero;
    assert HEX5 = zero;

    //test 1
    @(posedge clk);
    number_in <= 20'd123456;
    update <= 1'b1;
    @(posedge clk);
    update <= 1'b0;

    @(posedge driver_ready);
    assert HEX0 = six;
    assert HEX1 = five;
    assert HEX2 = four;
    assert HEX3 = three;
    assert HEX4 = two;
    assert HEX5 = one;

    //test 2
    @(posedge clk);
    number_in <= 20'd101010;
    update <= 1'b1;
    @(posedge clk);
    update <= 1'b0;

    @(posedge driver_ready);
    assert HEX0 = zero;
    assert HEX1 = one;
    assert HEX2 = zero;
    assert HEX3 = one;
    assert HEX4 = zero;
    assert HEX5 = one;

    //test 3
    @(posedge clk);
    number_in <= 20'd999999;
    update <= 1'b1;
    @(posedge clk);
    update <= 1'b0;

    @(posedge driver_ready);
    assert HEX0 = nine;
    assert HEX1 = nine;
    assert HEX2 = nine;
    assert HEX3 = nine;
    assert HEX4 = nine;
    assert HEX5 = nine;

  end

  always begin
    #5  clk = ! clk ;
  end


endmodule
