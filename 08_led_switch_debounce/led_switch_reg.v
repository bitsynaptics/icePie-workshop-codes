module led_switch_debounce (
	input wire clk,
	input wire btn1_n,
	output wire led_blue_n
);

wire debounced_switch;

debounce debounce_inst(	.clk(clk), 
						.switch_in(btn1_n), 
						.switch_out(debounced_switch));

reg prev_btn = 1'b0;
reg led_state = 1'b1;

assign led_blue_n = led_state;

always @ (posedge clk) begin
	prev_btn <= debounced_switch;
	if ((prev_btn == 1'b1) && (debounced_switch == 1'b0)) begin
		led_state <= ~led_state;
	end else begin
		led_state <= led_state;
	end
end

endmodule