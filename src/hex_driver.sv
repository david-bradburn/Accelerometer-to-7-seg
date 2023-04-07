

module hex_driver (
    input clk,
    input reset,

    input  number_bcd,

    output HEX0,
    output HEX1,
    output HEX2,
    output HEX2,
    output HEX4,
    output HEX5

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

    dec_num_e seg_array [0:5];

 
    always @(posedge MAX10_CLK1_50) begin
        if (reset) begin
            for (i = 0; i < 6; i = i + 1) begin	
                seg_array[i] <= zero;
            end
        end else begin	
            for (n = 0; n <= 5; n = n + 1) begin
                case(seg[n])
                    0 : seg_array[n] <=  zero;
                    1 : seg_array[n] <= 	 one;
                    2 : seg_array[n] <=   two;
                    3 : seg_array[n] <= three;
                    4 : seg_array[n] <=  four;
                    5 : seg_array[n] <=  five;
                    6 : seg_array[n] <= 	 six;
                    7 : seg_array[n] <= seven;
                    8 : seg_array[n] <= eight;
                    9 : seg_array[n] <= 	nine;
                    default : seg_array[n] <= zero;
                endcase
            end
        end  
    end

endmodule