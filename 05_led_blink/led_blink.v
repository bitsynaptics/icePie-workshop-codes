module led_blink (
	input wire clk,
	output wire led_blue_n,
	output wire led_amber_n
);

reg [26:0] counter = 26'd0;

always @ (posedge clk) begin
	counter <= counter + 1;
end

assign led_blue_n = counter[23];
assign led_amber_n = ~led_blue_n;

endmodule