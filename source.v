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
