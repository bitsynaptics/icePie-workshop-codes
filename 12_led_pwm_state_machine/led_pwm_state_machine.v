module led_pwm_state_machine (
	input wire clk,
	input wire enc_ch_a,
	input wire enc_ch_b,
	output wire led_rgb_red_n
);

localparam DUTY_CYCLE_MAXIMUM = 8'd200;

wire pwm_out;
wire count_enable;
wire count_direction;

reg [7:0] dc_counter = 8'd0;

assign led_rgb_red_n = ~pwm_out;

pwm_module#(.DUTY_CYCLE_MAX(DUTY_CYCLE_MAXIMUM)) pwm_module_inst(.clk(clk), .duty_cycle(dc_counter), .pwm_out(pwm_out));
rotary_encoder rotary_encoder_inst(.clk(clk), .enc_ch_a(enc_ch_a), .enc_ch_b(enc_ch_b), .count_enable(count_enable), .count_direction(count_direction));

always @ (posedge clk) begin
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
end

endmodule