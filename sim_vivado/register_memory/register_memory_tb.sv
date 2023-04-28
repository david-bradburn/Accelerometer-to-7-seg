
module register_memory_tb;

// Parameters

// Ports

reg clk = 0;
reg reset;
reg [7:0] reg_addr;
wire [31:0] read_data;
wire [3:0] error_code; 

register_memory #(
    .MEMORY_SIZE(255)
) DUT (
    .clk (clk),
    .reset(reset),
    .reg_addr(reg_addr),
    .read_data(read_data),
    .error_code(error_code)
);



system_reset_controller #(
    .NO_OF_CLK_CYCLES( 20 )
) rst_controller (
    .clk(clk),
    .reset( reset )
);

initial begin
    #5
    @(negedge reset);
    @(posedge clk);

    reg_addr <= 0;
    @(posedge clk);
    assert(read_data == 32'h01_1d_00_00);

    reg_addr <= 1;
    @(posedge clk);
    assert(read_data == 32'h02_1d_2d_08);

    reg_addr <= 2;
    @(posedge clk);
    assert(read_data == 32'h01_1d_32_00);

    reg_addr <= 3;
    @(posedge clk);
    assert(read_data == 32'h01_1d_33_00);

    reg_addr <= 4;
    @(posedge clk);
    assert(read_data == 32'h0);

    $finish();
end

always begin
    #5 clk <= ~clk;
end 


endmodule
