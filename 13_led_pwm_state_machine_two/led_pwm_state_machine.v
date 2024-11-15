module led_pwm_state_machine (
	input wire clk,
	input wire enc_sw,
	input wire enc_ch_a,
	input wire enc_ch_b,
	input wire btn1_n,
	output wire led_rgb_red_n,
	output wire led_rgb_green_n,
	output wire led_rgb_blue_n
);

localparam STATE_RED = 2'b00;
localparam STATE_GREEN = 2'b01;
localparam STATE_BLUE = 2'b10;
localparam STATE_ALL = 2'b11;

wire reset_counter;
wire enable_red;
wire enable_green;
wire enable_blue;
wire count_enable;
wire count_direction;
wire state_change;

reg [1:0] state_machine = STATE_ALL;
reg prev_btn;
reg prev_enc_sw;

assign enable_red = ((state_machine == STATE_RED) | (state_machine == STATE_ALL)) ? 1'b1 : 1'b0;
assign enable_green = ((state_machine == STATE_GREEN) | (state_machine == STATE_ALL)) ? 1'b1 : 1'b0;
assign enable_blue = ((state_machine == STATE_BLUE) | (state_machine == STATE_ALL)) ? 1'b1 : 1'b0;
assign reset_counter = ((prev_btn == 1'b1) && (btn1_n == 1'b0)) ? 1'b1 : 1'b0;
assign state_change = ((prev_enc_sw == 1'b1) && (enc_sw == 1'b0)) ? 1'b1 : 1'b0;

rotary_encoder rotary_encoder_inst(.clk(clk), .enc_ch_a(enc_ch_a), .enc_ch_b(enc_ch_b), .count_enable(count_enable), .count_direction(count_direction));

led_pwm led_pwm_red_inst (.clk(clk), .enable(enable_red), .reset_counter(reset_counter), .count_enable(count_enable), .count_direction(count_direction), .led(led_rgb_red_n));
led_pwm led_pwm_green_inst (.clk(clk), .enable(enable_green), .reset_counter(reset_counter), .count_enable(count_enable), .count_direction(count_direction), .led(led_rgb_green_n));
led_pwm led_pwm_blue_inst (.clk(clk), .enable(enable_blue), .reset_counter(reset_counter), .count_enable(count_enable), .count_direction(count_direction), .led(led_rgb_blue_n));

always @ (posedge clk) begin
	prev_btn <= btn1_n;
	prev_enc_sw <= enc_sw;
	if (state_change) begin
		case (state_machine)
			STATE_RED: begin
				state_machine <= STATE_GREEN;
			end

			STATE_GREEN: begin
				state_machine <= STATE_BLUE;
			end

			STATE_BLUE: begin
				state_machine <= STATE_ALL;
			end

			STATE_ALL: begin
				state_machine <= STATE_RED;
			end
		endcase
	end else begin
		state_machine <= state_machine;
	end
end

endmodule