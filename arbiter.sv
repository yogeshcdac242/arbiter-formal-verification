module arbiter (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] req,
    output logic [3:0] gnt
);

    logic [1:0] priority_ptr; // Keeps track of who has highest priority (0 to 3)
    
    // Determine grants based on priority
    always_comb begin
        gnt = 4'b0000;
        if (req != 4'b0000) begin
            if (req[priority_ptr]) begin
                gnt[priority_ptr] = 1'b1;
            end else if (req[(priority_ptr + 1) % 4]) begin
                gnt[(priority_ptr + 1) % 4] = 1'b1;
            end else if (req[(priority_ptr + 2) % 4]) begin
                gnt[(priority_ptr + 2) % 4] = 1'b1;
            end else if (req[(priority_ptr + 3) % 4]) begin
                gnt[(priority_ptr + 3) % 4] = 1'b1;
            end
        end
    end

    // Update priority pointer
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            priority_ptr <= 2'b00;
        end else if (gnt != 4'b0000) begin
            // Move priority to the agent *after* the one who just got the grant
            case (gnt)
                4'b0001: priority_ptr <= 2'd1;
                4'b0010: priority_ptr <= 2'd2;
                4'b0100: priority_ptr <= 2'd3;
                4'b1000: priority_ptr <= 2'd0;
                default: priority_ptr <= priority_ptr;
            endcase
        end
    end

endmodule
