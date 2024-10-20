module ShiftUnit (
    input  [31:0] a,
    input  [ 4:0] sdist,
    input  [ 1:0] sf,
    output [31:0] sres
);

  // sf == 00 sll, 01 srl, 11 sra
  // assign signed_a = $signed(a);

assign sres = (sf == 2'b00) ? a << sdist : 
              (sf == 2'b01) ? a >> sdist : 
              (sf == 2'b11) ? ({ {32{a[31]}}, a } >>> sdist) : a;

endmodule
