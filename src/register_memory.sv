
//read only register

module register_memory #(
    parameter MEMORY_SIZE = 255
)
(
    input wire clk,
    input wire reset,
    input wire [NO_OF_BITS - 1:0] reg_addr,

    output reg [31:0]  read_data,
    output reg [3:0]   error_code
    
);

    localparam NO_OF_BITS = $bits(MEMORY_SIZE);

    //localparam NO_OF_BITS = $bits(MEMORY_SIZE);

    //data 32 bits
    // OP code
    // 00 = NOP
    // 01 = I2C Read
    // 02 = I2C Write
    // 03 = ?
    ///////////////
    // 
    // error code 4 bits
    // 0 - invalid register address

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            read_data <= 32'h0;
            error_code <= 4'b0; //could be coded better
        end else begin
            case(reg_addr) 
                // op | dev | reg | data
                8'h0: read_data <= 32'h01_1d_00_00; //Read device ID
                8'h1: read_data <= 32'h02_1d_2d_08; //Change mode on accelerometer to measure
                8'h2: read_data <= 32'h01_1d_32_00; //Read x0
                8'h3: read_data <= 32'h01_1d_33_00; //Read x1

                default : begin
                    read_data <= 32'h0;
                    error_code <= 4'h1;
                end

            endcase //TO DO: Write a script to turn instructions into data in memory
        end
    end

endmodule