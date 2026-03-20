module mac8bit(
    input clk, rst,
    input clear_acc,
    input [7:0] a,
    input signed [7:0] b,
    output signed [23:0] Y
);

wire signed [15:0] prod;
reg signed [23:0] acc = 0;

assign prod = $signed(a) * b;

always @(posedge clk) begin
    if(rst || clear_acc)
        acc <= 0;
    else
        acc <= acc + {{8{prod[15]}}, prod}; // sign extend
end

assign Y = acc;

endmodule