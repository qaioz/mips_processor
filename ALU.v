module ALU (
    input [31:0] a,
    b,
    input [3:0] af,
    input itype,
    output [31:0] alures,
    output ovfalu
);


  wire [31:0] add_res;
  wire [31:0] addu_res;
  wire [31:0] sub_res;
  wire [31:0] subu_res;
  wire [31:0] and_res;
  wire [31:0] or_res;
  wire [31:0] xor_res;
  wire [31:0] nor_res;
  wire [31:0] lui_res;
  wire [31:0] slt_res;
  wire [31:0] sltu_res;

  assign add_res = $signed(a) + $signed(b);
  assign addu_res = a + b;
  assign sub_res = $signed(a) - $signed(b);
  assign subu_res = a - b;
  assign and_res = a & b;
  assign or_res = a | b;
  assign xor_res = a ^ b;
  assign nor_res = ~(a | b);
  assign lui_res = {b[16:0], 16'b0};
  assign slt_res = $signed(a) < $signed(b) ? 32'b1 : 32'b0;
  assign sltu_res = a < b ? 32'b1 : 32'b0;

  // overflow happens if the sign of the operands is the same and the sign of the result is different
  // in order ovflow to be output, the operation must be signed addintion or subtraction

  assign ovfalu = af == 4'b0000 || af == 4'b0010 ? (a[31] == b[31] && add_res[31] != a[31]) : 1'b0;

  assign alures = af == 4'b0000 ? add_res :
                     af == 4'b0001 ? addu_res :
                     af == 4'b0010 ? sub_res :
                     af == 4'b0011 ? subu_res :
                     af == 4'b0100 ? and_res :
                     af == 4'b0101 ? or_res :
                     af == 4'b0110 ? xor_res :
                     
                     af == 4'b1010 ? slt_res :
                     af == 4'b1011 ? sltu_res :
                     itype ? lui_res : nor_res;


endmodule
