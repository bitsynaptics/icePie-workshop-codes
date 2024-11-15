`include "osdvu/uart.v"

module uart_led_state_machine
(
	input wire clk,
	output wire led_blue_n,
	output wire led_amber_n,
	output wire led_rgb_red_n,
	output wire led_rgb_blue_n,
	output wire led_rgb_green_n,
	input rx,
	output tx
);

/* State Machine States */
localparam STATE_IDLE = 3'd0;
localparam STATE_TRANSMIT_RED_ON_START = 3'd1;
localparam STATE_TRANSMIT_RED_OFF_START = 3'd2;
localparam STATE_TRANSMIT_GREEN_ON_START = 3'd3;
localparam STATE_TRANSMIT_GREEN_OFF_START = 3'd4;
localparam STATE_TRANSMIT_BLUE_ON_START = 3'd5;
localparam STATE_TRANSMIT_BLUE_OFF_START = 3'd6;
localparam STATE_TRANSMIT_IN_PROGRESS = 3'd7;

/* Parameters for the UART Module */
wire reset = 0;
reg transmit;
reg [7:0] tx_byte;
wire received;
wire [7:0] rx_byte;
wire is_receiving;
wire is_transmitting;
wire recv_error;

/* ROM Data */
wire [7:0] rom_data [57:0];

/* State Machine Related Variables */
reg led_red_state = 1'b0;
reg led_green_state = 1'b0;
reg led_blue_state = 1'b0;
reg [2:0] state_machine = STATE_IDLE;
reg [2:0] prev_state_machine = STATE_IDLE;
reg [5:0] current_transmit_address = 6'd0;
reg [5:0] transmit_start_address = 6'd0;
reg [5:0] transmit_stop_address = 6'd0;
reg transmit_in_progress = 1'b0;
reg prev_transmit_in_progress = 1'b0;
reg prev_is_transmitting = 1'b0;

/* LED Indicator Assignments */
assign led_rgb_red_n = ~led_red_state;
assign led_rgb_green_n = ~led_green_state;
assign led_rgb_blue_n = ~led_blue_state;
assign led_amber_n = ~is_receiving;
assign led_blue_n  = ~is_transmitting;

/* ROM Data Mapping */
assign rom_data[0] = "R";
assign rom_data[1] = "e";
assign rom_data[2] = "d";
assign rom_data[3] = " ";
assign rom_data[4] = "O";
assign rom_data[5] = "N";
assign rom_data[6] = "\r";
assign rom_data[7] = "\n";

assign rom_data[8] = "R";
assign rom_data[9] = "e";
assign rom_data[10] = "d";
assign rom_data[11] = " ";
assign rom_data[12] = "O";
assign rom_data[13] = "F";
assign rom_data[14] = "F";
assign rom_data[15] = "\r";
assign rom_data[16] = "\n";

assign rom_data[17] = "G";
assign rom_data[18] = "r";
assign rom_data[19] = "e";
assign rom_data[20] = "e";
assign rom_data[21] = "n";
assign rom_data[22] = " ";
assign rom_data[23] = "O";
assign rom_data[24] = "N";
assign rom_data[25] = "\r";
assign rom_data[26] = "\n";

assign rom_data[27] = "G";
assign rom_data[28] = "r";
assign rom_data[29] = "e";
assign rom_data[30] = "e";
assign rom_data[31] = "n";
assign rom_data[32] = " ";
assign rom_data[33] = "O";
assign rom_data[34] = "F";
assign rom_data[35] = "F";
assign rom_data[36] = "\r";
assign rom_data[37] = "\n";

assign rom_data[38] = "B";
assign rom_data[39] = "l";
assign rom_data[40] = "u";
assign rom_data[41] = "e";
assign rom_data[42] = " ";
assign rom_data[43] = "O";
assign rom_data[44] = "N";
assign rom_data[45] = "\r";
assign rom_data[46] = "\n";

assign rom_data[47] = "B";
assign rom_data[48] = "l";
assign rom_data[49] = "u";
assign rom_data[50] = "e";
assign rom_data[51] = " ";
assign rom_data[52] = "O";
assign rom_data[53] = "F";
assign rom_data[54] = "F";
assign rom_data[55] = "\r";
assign rom_data[56] = "\n";

assign rom_data[57] = " ";

/* UART Module Instantiation */
uart #(
	.baud_rate(9600),                 	// The baud rate in kilobits/s
	.sys_clk_freq(12000000)           	// The master clock frequency
)
uart0(
	.clk(clk),                    		// The master clock for this module
	.rst(reset),                      	// Synchronous reset
	.rx(rx),                			// Incoming serial line
	.tx(tx),                			// Outgoing serial line
	.transmit(transmit),              	// Signal to transmit
	.tx_byte(tx_byte),                	// Byte to transmit
	.received(received),              	// Indicated that a byte has been received
	.rx_byte(rx_byte),                	// Byte received
	.is_receiving(is_receiving),      	// Low when receive line is idle
	.is_transmitting(is_transmitting),	// Low when transmit line is idle
	.recv_error(recv_error)           	// Indicates error in receiving packet.
);

/* Transmit Block */
always @ (posedge clk) begin
	prev_state_machine <= state_machine;
	if (state_machine == STATE_TRANSMIT_IN_PROGRESS) begin
		if (prev_state_machine != state_machine) begin
			current_transmit_address <= transmit_start_address;
			transmit_in_progress <= 1'b1;
			transmit <= 1'b0;
			prev_is_transmitting <= 1'b1;
		end else begin
			prev_is_transmitting <= is_transmitting;
			if (current_transmit_address < transmit_stop_address) begin
				transmit_in_progress <= 1'b1;
				if ((prev_is_transmitting == 1'b1) && (is_transmitting == 1'b0)) begin
					tx_byte <= rom_data[current_transmit_address];
					current_transmit_address <= current_transmit_address + 6'd1;
					transmit <= 1'b1;
				end else begin
					tx_byte <= tx_byte;
					current_transmit_address <= current_transmit_address;
					transmit <= 1'b0;
				end
			end else begin
				transmit_in_progress <= 1'b0;
				tx_byte <= tx_byte;
				current_transmit_address <= current_transmit_address;
				transmit <= 1'b0;
			end
		end
	end else begin
		transmit_in_progress <= 1'b0;
		tx_byte <= tx_byte;
		current_transmit_address <= current_transmit_address;
		transmit <= 1'b0;
		prev_is_transmitting <= 1'b0;
	end
end

/* State Machine */
always @ (posedge clk) begin
	prev_transmit_in_progress <= transmit_in_progress;
	case (state_machine)
		STATE_IDLE: begin
			if (received == 1'b1) begin
				case (rx_byte)
					"r": begin
						led_red_state <= ~led_red_state;
						led_green_state <= led_green_state;
						led_blue_state <= led_blue_state;
						if (led_red_state == 1'b0) begin
							state_machine <= STATE_TRANSMIT_RED_ON_START;
						end else begin
							state_machine <= STATE_TRANSMIT_RED_OFF_START;
						end
					end

					"g": begin
						led_red_state <= led_red_state;
						led_green_state <= ~led_green_state;
						led_blue_state <= led_blue_state;
						if (led_green_state == 1'b0) begin
							state_machine <= STATE_TRANSMIT_GREEN_ON_START;
						end else begin
							state_machine <= STATE_TRANSMIT_GREEN_OFF_START;
						end
					end

					"b": begin
						led_red_state <= led_red_state;
						led_green_state <= led_green_state;
						led_blue_state <= ~led_blue_state;
						if (led_blue_state == 1'b0) begin
							state_machine <= STATE_TRANSMIT_BLUE_ON_START;
						end else begin
							state_machine <= STATE_TRANSMIT_BLUE_OFF_START;
						end
					end

					"R": begin
						led_red_state <= ~led_red_state;
						led_green_state <= led_green_state;
						led_blue_state <= led_blue_state;
						if (led_red_state == 1'b0) begin
							state_machine <= STATE_TRANSMIT_RED_ON_START;
						end else begin
							state_machine <= STATE_TRANSMIT_RED_OFF_START;
						end
					end

					"G": begin
						led_red_state <= led_red_state;
						led_green_state <= ~led_green_state;
						led_blue_state <= led_blue_state;
						if (led_green_state == 1'b0) begin
							state_machine <= STATE_TRANSMIT_GREEN_ON_START;
						end else begin
							state_machine <= STATE_TRANSMIT_GREEN_OFF_START;
						end
					end

					"B": begin
						led_red_state <= led_red_state;
						led_green_state <= led_green_state;
						led_blue_state <= ~led_blue_state;
						if (led_blue_state == 1'b0) begin
							state_machine <= STATE_TRANSMIT_BLUE_ON_START;
						end else begin
							state_machine <= STATE_TRANSMIT_BLUE_OFF_START;
						end
					end

					default: begin
						state_machine <= STATE_IDLE;
						led_red_state <= led_red_state;
						led_green_state <= led_green_state;
						led_blue_state <= led_blue_state;
					end
				endcase
			end else begin
				state_machine <= STATE_IDLE;
				led_red_state <= led_red_state;
				led_green_state <= led_green_state;
				led_blue_state <= led_blue_state;
			end
		end

		STATE_TRANSMIT_RED_ON_START: begin
			transmit_start_address <= 0;
			transmit_stop_address <= 8;
			state_machine <= STATE_TRANSMIT_IN_PROGRESS;
			led_red_state <= led_red_state;
			led_green_state <= led_green_state;
			led_blue_state <= led_blue_state;
		end

		STATE_TRANSMIT_RED_OFF_START: begin
			transmit_start_address <= 8;
			transmit_stop_address <= 17;
			state_machine <= STATE_TRANSMIT_IN_PROGRESS;
			led_red_state <= led_red_state;
			led_green_state <= led_green_state;
			led_blue_state <= led_blue_state;
		end

		STATE_TRANSMIT_GREEN_ON_START: begin
			transmit_start_address <= 17;
			transmit_stop_address <= 27;
			state_machine <= STATE_TRANSMIT_IN_PROGRESS;
			led_red_state <= led_red_state;
			led_green_state <= led_green_state;
			led_blue_state <= led_blue_state;
		end

		STATE_TRANSMIT_GREEN_OFF_START: begin
			transmit_start_address <= 27;
			transmit_stop_address <= 38;
			state_machine <= STATE_TRANSMIT_IN_PROGRESS;
			led_red_state <= led_red_state;
			led_green_state <= led_green_state;
			led_blue_state <= led_blue_state;
		end

		STATE_TRANSMIT_BLUE_ON_START: begin
			transmit_start_address <= 38;
			transmit_stop_address <= 47;
			state_machine <= STATE_TRANSMIT_IN_PROGRESS;
			led_red_state <= led_red_state;
			led_green_state <= led_green_state;
			led_blue_state <= led_blue_state;
		end

		STATE_TRANSMIT_BLUE_OFF_START: begin
			transmit_start_address <= 47;
			transmit_stop_address <= 57;
			state_machine <= STATE_TRANSMIT_IN_PROGRESS;
			led_red_state <= led_red_state;
			led_green_state <= led_green_state;
			led_blue_state <= led_blue_state;
		end

		STATE_TRANSMIT_IN_PROGRESS: begin
			led_red_state <= led_red_state;
			led_green_state <= led_green_state;
			led_blue_state <= led_blue_state;
			if ((prev_transmit_in_progress == 1'b1) && (transmit_in_progress == 1'b0)) begin
				state_machine <= STATE_IDLE;
			end else begin
				state_machine <= STATE_TRANSMIT_IN_PROGRESS;
			end
		end
	endcase
end

endmodule