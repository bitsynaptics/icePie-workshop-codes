`timescale 1ns/100ps

module simulation_tb (
    output reg clk = 1'b0,
    output reg switch = 1'b1,
    output wire led
);

simulation_example simex_inst(.clk(clk), .btn1_n(switch), .led_rgb_red_n(led));

initial begin
    $dumpfile("simulation_tb.vcd"); 
    $dumpvars(0, simulation_tb);

    clk <= 1'b0;
    #100; switch <= 1'b0;
    #10; switch <= 1'b1;

    #100; switch <= 1'b0;
    #10; switch <= 1'b1;

    #100; switch <= 1'b0;
    #10; switch <= 1'b1;

    #100; switch <= 1'b0;
    #10; switch <= 1'b1;

    #100; switch <= 1'b0;
    #10; switch <= 1'b1;

    #100; switch <= 1'b0;
    #10; switch <= 1'b1;

    #100; switch <= 1'b0;
    #10; switch <= 1'b1;

    #100; switch <= 1'b0;
    #10; switch <= 1'b1;

    #10000;
    $finish;
end

always begin
    #5; clk <= ~clk;
end


endmodule