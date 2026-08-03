module arbiter_props (
    input logic       clk,
    input logic       rst_n,
    input logic [3:0] req,
    input logic [3:0] gnt
);

    // =========================================================================
    // 1. MUTUAL EXCLUSION (The most important arbiter property)
    // =========================================================================
    // Prove that it is impossible for more than one grant to be active at a time.
    // $onehot0 checks that a vector has at most one bit high (0 or 1 bits high).
    assert_mutual_exclusion: assert property (
        @(posedge clk) disable iff (!rst_n)
        $onehot0(gnt)
    );

    // =========================================================================
    // 2. NO SPURIOUS GRANTS
    // =========================================================================
    // A grant should only be given if the corresponding agent actually requested it.
    assert_no_spurious_gnt_0: assert property (@(posedge clk) disable iff (!rst_n) gnt[0] |-> req[0]);
    assert_no_spurious_gnt_1: assert property (@(posedge clk) disable iff (!rst_n) gnt[1] |-> req[1]);
    assert_no_spurious_gnt_2: assert property (@(posedge clk) disable iff (!rst_n) gnt[2] |-> req[2]);
    assert_no_spurious_gnt_3: assert property (@(posedge clk) disable iff (!rst_n) gnt[3] |-> req[3]);

    // =========================================================================
    // 3. WORK CONSERVATION
    // =========================================================================
    // If there is any request, the arbiter MUST issue a grant in the same cycle.
    assert_work_conservation: assert property (
        @(posedge clk) disable iff (!rst_n)
        (req != 0) |-> (gnt != 0)
    );

    // =========================================================================
    // 4. ENVIRONMENT CONSTRAINTS (Hold Requests)
    // =========================================================================
    // A requester must hold its request high until it receives a grant.
    // If it asks and doesn't get it, it must keep asking next cycle.
    assume_hold_req_0: assume property (@(posedge clk) disable iff (!rst_n) (req[0] && !gnt[0]) |=> req[0]);
    assume_hold_req_1: assume property (@(posedge clk) disable iff (!rst_n) (req[1] && !gnt[1]) |=> req[1]);
    assume_hold_req_2: assume property (@(posedge clk) disable iff (!rst_n) (req[2] && !gnt[2]) |=> req[2]);
    assume_hold_req_3: assume property (@(posedge clk) disable iff (!rst_n) (req[3] && !gnt[3]) |=> req[3]);

    // =========================================================================
    // 4. FAIRNESS (No Starvation)
    // =========================================================================
    // If agent 0 requests, does it *eventually* get a grant?
    // Using the [->1] (goto) operator. This proves the Round-Robin logic works.
    assert_fairness_0: assert property (
        @(posedge clk) disable iff (!rst_n)
        req[0] |-> ##[0:$] gnt[0]
    );

endmodule

bind arbiter arbiter_props bind_inst (.*);
