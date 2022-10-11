

module system_reset_controller #(
    parameter NO_OF_CLK_CYCLES = 20
)(
    input wire clk,
    output wire reset //positive reset
);

    
    integer reset_count = 0;
    assign reset = (reset_count == NO_OF_CLK_CYCLES) ? 0 : 1;

    always_ff @(posedge clk) begin
        if(reset_count < NO_OF_CLK_CYCLES) begin
            reset_count <= reset_count + 1;
        end
    end

endmodule