//
// Holds the system in reset for N cycles configurable to be active high or low
//

module system_reset_controller #(
    parameter NO_OF_CLK_CYCLES = 20,
    parameter ACTIVE_HIGH = 1'b1
)(
    input wire clk,
    output wire reset //positive reset
);

    
    integer reset_count = 0;
    assign reset = (reset_count == NO_OF_CLK_CYCLES) ? ~ACTIVE_HIGH : ACTIVE_HIGH;

    always_ff @(posedge clk) begin
        if(reset_count < NO_OF_CLK_CYCLES) begin
            reset_count <= reset_count + 1;
        end
    end

endmodule