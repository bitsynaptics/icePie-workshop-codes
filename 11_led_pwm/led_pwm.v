module led_pwm (
	input wire clk,
	output wire led_rgb_red_n
);

wire pwm_out;

pwm_module#(.DUTY_CYCLE_MAX(200)) pwm_module_inst(.clk(clk), .duty_cycle(8'd10), .pwm_out(pwm_out));

assign led_rgb_red_n = ~pwm_out;

endmodule