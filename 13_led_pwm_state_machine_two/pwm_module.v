module pwm_module#(
    parameter DUTY_CYCLE_MAX = 8'd200
)
(
    input wire clk,
    input wire [7:0] duty_cycle,
    output wire pwm_out
);

reg [7:0] pwm_counter = 8'd0;
assign pwm_out = (pwm_counter < duty_cycle) ? 1'b1 : 1'b0;

always @ (posedge clk) begin
    if (pwm_counter < DUTY_CYCLE_MAX) begin
        pwm_counter <= pwm_counter + 8'd1;
    end else begin
        pwm_counter <= 8'd0;
    end
end

endmodule