module debounce (
    input wire clk,          // Clock input
    input wire switch_in,    // Raw switch input
    output reg switch_out    // Debounced switch output
);

    // Parameters for debouncing
    parameter DEBOUNCE_TIME = 24'd1000000;
    reg [23:0] counter = 24'd0;
    reg switch_ff1 = 1'b0;
    reg switch_ff2 = 1'b0;

    // Double flop synchronizer
    always @(posedge clk) begin
        switch_ff1 <= switch_in;
        switch_ff2 <= switch_ff1;
    end

    // Debouncing logic
    always @(posedge clk) begin
        if (switch_ff2 != switch_out) begin
            if (counter == DEBOUNCE_TIME) begin
                switch_out <= switch_ff2;
                counter <= 24'd0;
            end else begin
                counter <= counter + 24'd1;
            end
        end else begin
            counter <= 24'd0;
        end
    end

endmodule