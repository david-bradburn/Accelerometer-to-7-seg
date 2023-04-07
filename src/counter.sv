

module counter #(
    parameter max_count
)(
    input clk,
    input reset,
    input enable,

    output logic pulse
);

integer refresh_rate_counter;
// logic pulse;


always @(posedge clk or posedge reset) begin
    if(reset) begin
        refresh_rate_counter <= 0;
        pulse <= 1'b0;
    end
    else begin
        if(enable) begin
            pulse <= 1'b0;
            if(refresh_rate_counter == max_count - 1) begin
                pulse <= 1'b1;
                refresh_rate_counter <= 0;
            end else begin
                refresh_rate_counter <= refresh_rate_counter + 1;
            end
        end
    end
end


endmodule