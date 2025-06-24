
#  FPGA Traffic Light Controller using Verilog  Basys 3

This notebook explains the Verilog code for a traffic light controller designed using a finite state machine (FSM) and implemented on the Basys 3 FPGA board using Xilinx Vivado.

---

##  Verilog Code

###  Module: `traffic_light_controller.v`

module traffic_light_controller(
    input clk,
    input reset,
    output reg [2:0] lights  // [2] = Red, [1] = Yellow, [0] = Green
);

// Define FSM states
typedef enum logic [1:0] {
    GREEN  = 2'b00,
    YELLOW = 2'b01,
    RED    = 2'b10
} state_t;

state_t current_state;
integer count;

// Duration definitions (based on 50MHz clock)
parameter GREEN_TIME  = 50_000_000;  // ~1 sec
parameter YELLOW_TIME = 25_000_000;  // ~0.5 sec
parameter RED_TIME    = 50_000_000;  // ~1 sec

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= GREEN;
        count <= 0;
    end else begin
        count <= count + 1;
        case (current_state)
            GREEN: begin
                if (count >= GREEN_TIME) begin
                    current_state <= YELLOW;
                    count <= 0;
                end
            end
            YELLOW: begin
                if (count >= YELLOW_TIME) begin
                    current_state <= RED;
                    count <= 0;
                end
            end
            RED: begin
                if (count >= RED_TIME) begin
                    current_state <= GREEN;
                    count <= 0;
                end
            end
        endcase
    end
end

// Output logic based on current state
always @(*) begin
    case (current_state)
        GREEN:  lights = 3'b001;
        YELLOW: lights = 3'b010;
        RED:    lights = 3'b100;
        default: lights = 3'b000;
    endcase
end

endmodule




##  TestbenchOverview

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


##  Notes

- This system models a basic real-world traffic light using synchronous logic.
- The FSM cycles through Green → Yellow → Red → Green, with specified delays.
- Simulate using Vivado or ModelSim. Deploy on Basys 3 using XDC constraints.

---

**Author**: [Durga Nadupuru] • RGUKT-AP • India
