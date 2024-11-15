module led_one_second_blink (
	input wire clk,
	output reg led_blue_n = 1'b1,
	output reg led_amber_n = 1'b0
);

localparam OSCILLATOR_MAX = 24'd12000000;
reg [23:0] counter = 24'd0;

always @ (posedge clk) begin
	if (counter == (OSCILLATOR_MAX - 1)) begin
		led_blue_n <= ~led_blue_n;
		led_amber_n <= ~led_amber_n;
		counter <= 24'd0;
	end else begin
		led_blue_n <= led_blue_n;
		led_amber_n <= led_amber_n;
		counter <= counter + 1;
	end
end

endmodule