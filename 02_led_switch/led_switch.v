module led_switch (
	input wire btn1_n,
	input wire btn2_n,
	output wire led_blue_n,
	output wire led_amber_n
);

assign led_blue_n = ~btn1_n;
assign led_amber_n = ~btn2_n;

endmodule