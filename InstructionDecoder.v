module InstructionDecoder (
    input [31:0] instruction,
    output itype,
    rtype,
    gprw,
    su,
    jump,
    b,
    j,
    jr,
    jal,
    jalr,
    l,
    s,
    alu,
    output [4:0] cad,
    sa,
    output [3:0] af,
    bf,
    output [1:0] sf,
    output [25:0] iindex,
    output [31:0] zxtimm,
    sxtimm
);

  wire [5:0] opc;
  wire [4:0] rs, rt, rd;
  wire [ 5:0] fun;
  wire [15:0] imm;
  wire [25:0] iindex;
  wire alur, alui;
  wire jtype;


  assign opc = instruction[31:26];

  assign rtype = (opc == 6'b000000) | (opc == 6'b010000);
  assign jtype = (opc == 6'b000010) | (opc == 6'b000011);
  assign itype = !rtype & !jtype;

  assign rs = instruction[25:21];
  assign rt = instruction[20:16];
  assign rd = instruction[15:11];

  assign fun = instruction[5:0];

  assign sa = instruction[10:6];
  assign imm = instruction[15:0];
  assign iindex = instruction[25:0];

  assign zxtimm = {16'b0, imm};
  assign sxtimm = {{16{imm[15]}}, imm};

  // ALU operations of I-type and R-type 

  assign alur = rtype & fun[5:4] == 2'b10;
  assign alui = itype & opc[5:3] == 3'b001;
  assign alu = alur | alui;

  // Shift operations 

  assign su = rtype & fun[5:2] == 3'b000;

  // Load and stores

  assign l = opc[5:3] == 3'b100;
  assign s = opc[5:3] == 3'b101;
  assign ls = l | s;

  // Branches

  assign b = itype & opc[5:3] == 3'b000;

  // Jumps

  assign jr = rtype & (fun == 6'b001000);
  assign jalr = rtype & (fun == 6'b001001);
  assign j = jtype & (opc == 6'b000010);
  assign jal = jtype & (opc == 6'b000011);
  assign jump = jr | j | jal | jalr;

  // ALU functions

  wire [3:0] af;

  assign af[2:0] = rtype ? fun[2:0] : opc[2:0];
  assign af[3]   = rtype ? fun[3] : ~opc[2] & opc[1];

  // Shift functions

  wire [1:0] sf;

  assign sf = fun[1:0];

  // Branch functions 

  wire [3:0] bf;

  assign bf = {opc[2:0], rt[0]};

  // CAD

  wire [4:0] cad;

  assign cad  = jal ? 5'b11111 : rtype ? rs : rt;

  assign gprw = alu | su | l | jal | jalr;

endmodule
