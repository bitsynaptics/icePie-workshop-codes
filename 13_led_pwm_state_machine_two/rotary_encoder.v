module rotary_encoder (
	input wire clk,
	input wire enc_ch_a,
	input wire enc_ch_b,
    output wire count_enable,
    output wire count_direction
);

reg enc_ch_a_delayed;
reg enc_ch_b_delayed;

assign count_enable = enc_ch_a ^ enc_ch_a_delayed ^ enc_ch_b ^ enc_ch_b_delayed;
assign count_direction = enc_ch_a ^ enc_ch_b_delayed;

always @ (posedge clk) begin
	enc_ch_a_delayed <= enc_ch_a;
	enc_ch_b_delayed <= enc_ch_b;
end

endmodule