// need to simulate

module hex_driver_with_bcd (
    input  clk,
    input  reset,

    input  [19:0] number_in,
    input  update,

    output dec_num_e HEX0,
    output dec_num_e HEX1,
    output dec_num_e HEX2,
    output dec_num_e HEX2,
    output dec_num_e HEX4,
    output dec_num_e HEX5,

    output wire driver_ready
);

localparam DECIMAL_DIGITS = 6;


    logic []
   Binary_to_BCD # (
    .INPUT_WIDTH    (20),
    .DECIMAL_DIGITS (DECIMAL_DIGITS)
   ) hex_bcd (
    .i_Clock  ( clk          ),
    .i_Binary ( number_in    ),
    .i_Start  ( update       ),
    //
    .o_BCD    ( number_out   ),
    .o_DV     ( driver_ready )
   );

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
    } dec_num_e;

    dec_num_e dec_seg_array [0:5];
    logic [DECIMAL_DIGITS*4 - 1:0] number_out;
    logic [3:0] dec_raw_array [0:5];

    assign HEX0 = dec_seg_array[0];
    assign HEX1 = dec_seg_array[1];
    assign HEX2 = dec_seg_array[2];
    assign HEX3 = dec_seg_array[3];
    assign HEX4 = dec_seg_array[4];
    assign HEX5 = dec_seg_array[5];

    always_comb begin
        for (n = 0; n < DECIMAL_DIGITS; n = n + 1) begin
            dec_raw_array[n] <= number_out[4*n+3:4*n];
        end
    end

 
    always @(posedge MAX10_CLK1_50) begin
        if (reset) begin
            for (i = 0; i < 6; i = i + 1) begin	
                dec_seg_array[i] <= zero;
            end
        end else begin	
            for (n = 0; n <= 5; n = n + 1) begin
                case(dec_raw_array[n])
                    0 : dec_seg_array[n] <=       zero;
                    1 : dec_seg_array[n] <=        one;
                    2 : dec_seg_array[n] <=        two;
                    3 : dec_seg_array[n] <=      three;
                    4 : dec_seg_array[n] <=       four;
                    5 : dec_seg_array[n] <=       five;
                    6 : dec_seg_array[n] <=        six;
                    7 : dec_seg_array[n] <=      seven;
                    8 : dec_seg_array[n] <=      eight;
                    9 : dec_seg_array[n] <=       nine;
                    default : dec_seg_array[n] <= zero;
                endcase
            end
        end  
    end

endmodule