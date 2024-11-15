module uart_echo (
    input wire rx,
    output wire tx
);

assign tx = rx;

endmodule