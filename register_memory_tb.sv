
module register_memory_tb;

// Parameters

// Ports

reg clk = 0;
reg reset;
reg [7:0] reg_addr;
wire [31:0] reg_data;
wire [3:0] error_code; 

register_memory #(
    .MEMORY_SIZE(255)
) DUT (
    .clk (clk),
    .reset(reset),
    .reg_addr(reg_addr),
    .reg_data(reg_data),
    .error_code(error_code)
);


system_reset_controller #(
    .NO_OF_CLK_CYCLES( 20 )
) rst_controller (
    .clk(clk),
    .reset( reset )
);

initial begin

end

always begin
    #5 clk <= ~clk;
end 


endmodule
