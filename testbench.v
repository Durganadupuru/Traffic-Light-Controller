
##  Testbench

###  File: `testbench.v`


`timescale 1ns / 1ps

module testbench;

reg clk;`timescale 1ns / 1ps

module testbench;

// Testbench signals
reg clk;
reg reset;
wire [2:0] lights;  // Output from DUT: [2]=Red, [1]=Yellow, [0]=Green

// Instantiate the Design Under Test (DUT)
traffic_light_controller dut (
    .clk(clk),
    .reset(reset),
    .lights(lights)
);

// Generate 50 MHz clock => 20 ns period
always #10 clk = ~clk;

initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;

    // Hold reset for some time
    #50;
    reset = 0;

    // Run simulation for a few seconds
    #300000000;  // Adjust this time as needed for full cycle visibility

    // End simulation
    $finish;
end

// Optional: Dump waveforms for viewing in simulator
initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, testbench);
end

endmodule