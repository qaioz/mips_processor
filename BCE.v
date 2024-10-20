module BCE(
    input [31:0] a,b,
    input [3:0] bf,
    output [31:0] bcres
);

wire eq, lt, le;

assign eq = a == b;
assign lt = $signed(a) < 0;
assign le = lt | (bf[3:2] == 2'b10 ? eq : a == 0);

// not bf3 and not bf2 and bf1 and (bf0 xor lt) or
// bf3 and not bf2 and (bf1 xor eq) or 
// bf3 and bf2 and (bf1 xor le) 

assign bcres = (~bf[3] & ~bf[2] & bf[1] & (bf[0] ^ lt)) | 
              (bf[3] & ~bf[2] & (bf[1] ^ eq)) | 
              (bf[3] & bf[2] & (bf[1] ^ le));

// Above expression should give the same result as the following table
// 0010 => $signed(a) < 0
// 0011 => $signed(a) >= 0
// 100* => a == b
// 101* => a != b
// 110* => $signed(a) <= 0
// 111* => $signed(a) > 0


endmodule
