module rotary_encoder (
	input wire clk,
	input wire enc_sw,
	input wire enc_ch_a,
	input wire enc_ch_b,
	output wire led_rgb_red_n,
	output wire led_rgb_green_n,
	output wire led_rgb_blue_n
);

wire count_enable;
wire count_direction;

reg enc_ch_a_delayed;
reg enc_ch_b_delayed;
reg [2:0] counter = 3'b000;

assign count_enable = enc_ch_a ^ enc_ch_a_delayed ^ enc_ch_b ^ enc_ch_b_delayed;
assign count_direction = enc_ch_a ^ enc_ch_b_delayed;

assign led_rgb_red_n = ~counter[2];
assign led_rgb_green_n = ~counter[1];
assign led_rgb_blue_n = ~counter[0];

always @ (posedge clk) begin
	enc_ch_a_delayed <= enc_ch_a;
	enc_ch_b_delayed <= enc_ch_b;
end

always @ (posedge clk) begin
	if (enc_sw == 1'b0) begin
		counter <= 3'b000;
	end else begin
		if (count_enable) begin
			if (count_direction) begin
				counter <= counter + 3'd1;
			end else begin
				counter <= counter - 3'd1;
			end
		end else begin
			counter <= counter;
		end
	end
end

endmodule