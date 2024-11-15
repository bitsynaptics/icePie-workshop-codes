module led_switch_reg (
	input wire clk,
	input wire btn1_n,
	output wire led_blue_n
);

reg prev_btn = 1'b0;
reg led_state = 1'b1;

assign led_blue_n = led_state;

always @ (posedge clk) begin
	prev_btn <= btn1_n;
	if ((prev_btn == 1'b1) && (btn1_n == 1'b0)) begin
		led_state <= ~led_state;
	end else begin
		led_state <= led_state;
	end
end

endmodule