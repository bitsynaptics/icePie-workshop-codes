`include "osdvu/uart.v"

module uart_echo
(
	input wire clk,
	output wire led_blue_n,
	output wire led_amber_n,
	input rx,
	output tx
);

/*  LEDs are wired active low */

wire reset = 0;
reg transmit;
reg [7:0] tx_byte;
wire received;
wire [7:0] rx_byte;
wire is_receiving;
wire is_transmitting;
wire recv_error;

assign led_amber_n = ~is_receiving;
assign led_blue_n  = ~is_transmitting;

uart #(
	.baud_rate(9600),                 // The baud rate in kilobits/s
	.sys_clk_freq(12000000)           // The master clock frequency
)
uart0(
	.clk(clk),                    // The master clock for this module
	.rst(reset),                      // Synchronous reset
	.rx(rx),                // Incoming serial line
	.tx(tx),                // Outgoing serial line
	.transmit(transmit),              // Signal to transmit
	.tx_byte(tx_byte),                // Byte to transmit
	.received(received),              // Indicated that a byte has been received
	.rx_byte(rx_byte),                // Byte received
	.is_receiving(is_receiving),      // Low when receive line is idle
	.is_transmitting(is_transmitting),// Low when transmit line is idle
	.recv_error(recv_error)           // Indicates error in receiving packet.
);

always @(posedge clk) begin
	if (received) 
	begin
		tx_byte <= rx_byte;		
		transmit <= 1'b1;
	end 
	else 
	begin
		transmit <= 1'b0;
	end
end

endmodule