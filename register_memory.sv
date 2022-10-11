
module register_memory #(
    parameter MEMORY_SIZE = 255,
    localparam NO_OF_BITS = $bits(MEMORY_SIZE) 
)
(
    input wire clk,
    input wire reset,
    input wire [NO_OF_BITS - 1:0] reg_addr,

    output reg [31:0] reg_data,
    output reg [3:0] error_code
);

    //localparam NO_OF_BITS = $bits(MEMORY_SIZE);

    //data 32 bits
    // OP code
    // 00 = NOP
    // 01 = Write
    // 02 = Read
    ///////////////
    // 

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            reg_data <= 32'b0;
            error_code <= 4'b0; //could be coded better
        end else begin
            case(reg_addr) 
                8'h0 : reg_data <= 32'h0; //need to determine the split of this opcode etc
            endcase //TO DO: Write a script to turn instructions into data in memory
        end
    end

endmodule