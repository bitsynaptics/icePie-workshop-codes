module led_switch (
	input wire btn1_n,
	input wire btn2_n,
	input wire enc_sw,
	output wire led_rgb_red_n,
	output wire led_rgb_green_n,
	output wire led_rgb_blue_n
);

assign led_rgb_red_n = btn1_n;
assign led_rgb_green_n = btn2_n;
assign led_rgb_blue_n = enc_sw;

endmodule