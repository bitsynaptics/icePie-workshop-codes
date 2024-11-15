module led_pwm (
    input wire clk,
    input wire enable,
    input wire reset_counter,
    input wire count_enable,
    input wire count_direction,
    output wire led
);

localparam DUTY_CYCLE_MAXIMUM = 8'd200;

wire pwm_out;

reg [7:0] dc_counter = 8'd0;

assign led = ~((enable == 1) & pwm_out);

pwm_module#(.DUTY_CYCLE_MAX(DUTY_CYCLE_MAXIMUM)) pwm_module_inst(.clk(clk), .duty_cycle(dc_counter), .pwm_out(pwm_out));

always @ (posedge clk) begin
    if (reset_counter == 1'b1) begin
        dc_counter <= 8'd0;
    end else begin
        if (enable == 1'b1) begin
            if (count_enable == 1'b1) begin
                if (count_direction == 1'b1) begin
                    dc_counter <= (dc_counter + 8'd1) % DUTY_CYCLE_MAXIMUM;
                end else begin
                    if (dc_counter == 8'd0) begin
                        dc_counter <= DUTY_CYCLE_MAXIMUM - 8'd1;
                    end else begin
                        dc_counter <= (dc_counter - 8'd1);  
                    end			
                end
            end else begin
                dc_counter <= dc_counter;
            end
        end else begin
            dc_counter <= dc_counter;
        end
    end
end

endmodule