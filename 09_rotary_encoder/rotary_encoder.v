module rotary_encoder (
	input wire enc_ch_a,
	input wire enc_ch_b,
	output wire led_blue_n,
	output wire led_amber_n
);

assign led_blue_n = enc_ch_a;
assign led_amber_n = enc_ch_b;

endmodule