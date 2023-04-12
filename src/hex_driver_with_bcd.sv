// need to simulate

`include "types.svh"

module hex_driver_with_bcd (
    input  clk,
    input  reset,

    input  [19:0] number_in,
    input  update,

    output dec_num_e HEX0,
    output dec_num_e HEX1,
    output dec_num_e HEX2,
    output dec_num_e HEX3,
    output dec_num_e HEX4,
    output dec_num_e HEX5,

    output wire driver_ready
);

localparam DECIMAL_DIGITS = 6;


logic [DECIMAL_DIGITS*4 - 1:0] number_out;

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


    dec_num_e dec_seg_array [0:5];
    logic [3:0] dec_raw_array [0:5];

    assign HEX0 = dec_seg_array[0];
    assign HEX1 = dec_seg_array[1];
    assign HEX2 = dec_seg_array[2];
    assign HEX3 = dec_seg_array[3];
    assign HEX4 = dec_seg_array[4];
    assign HEX5 = dec_seg_array[5];

    generate
        always_comb begin
            for (integer m = 0; m < DECIMAL_DIGITS; m = m + 1) begin
                dec_raw_array[m][3:0] = number_out[4*m+3 -:4];
            end
        end
    endgenerate

 
    always @(posedge clk) begin
        if (reset) begin
            for (integer i = 0; i < DECIMAL_DIGITS; i = i + 1) begin	
                dec_seg_array[i] <= zero;
            end
        end else begin	
            for (integer n = 0; n < DECIMAL_DIGITS; n = n + 1) begin
                case(dec_raw_array[n])
                    0 : dec_seg_array[n]       <=  zero;
                    1 : dec_seg_array[n]       <=   one;
                    2 : dec_seg_array[n]       <=   two;
                    3 : dec_seg_array[n]       <= three;
                    4 : dec_seg_array[n]       <=  four;
                    5 : dec_seg_array[n]       <=  five;
                    6 : dec_seg_array[n]       <=   six;
                    7 : dec_seg_array[n]       <= seven;
                    8 : dec_seg_array[n]       <= eight;
                    9 : dec_seg_array[n]       <=  nine;
                    default : dec_seg_array[n] <=  zero;
                endcase
            end
        end  
    end

endmodule