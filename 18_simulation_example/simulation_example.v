module simulation_example
(
	input wire clk,
	input wire btn1_n,
	output wire led_rgb_red_n
);

reg prev_btn = 1'b0;
reg [2:0] counter = 3'd0;

wire led_state;
assign led_state = (counter == 3'd6) ? 1'b1 : 1'b0;
assign led_rgb_red_n = ~led_state;

always @ (posedge clk) begin
	prev_btn <= btn1_n;
	if ((prev_btn == 1'b1) && (btn1_n == 1'b0)) begin
		counter <= (counter + 3'd1) % 3'd7;
	end else begin
		counter <= counter;
	end
end

endmodule