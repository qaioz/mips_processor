// Page 94, Chapter 4.3 3 port RAM for General Purpose Registers
module GPRFile (
    input clk,
    input [31:0] sin, 
    input [4:0] sa, sb, sc,
    input sw,
    output [31:0] souta, soutb
);

reg [31:0] regfile [31:0];

// initialize to 0
integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        regfile[i] = 0;
    end
end


always @(posedge clk) begin
    // do not write to register 0
    if (sw && sc != 0) begin
        regfile[sc] <= sin;
    end
end

assign souta = regfile[sa];
assign soutb = regfile[sb];

endmodule
