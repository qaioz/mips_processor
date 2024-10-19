// include
`include "InstructionDecoder.v"
module InstructionDecoderTB;

reg [31:0] instruction;
wire itype, rtype, gprw, su, jump, b, j, jr, jal, jalr, l, s, alu;
wire [4:0] cad, sa;
wire [3:0] af, bf;
wire [1:0] sf;
wire [25:0] iindex;
wire [31:0] zxtimm, sxtimm;

InstructionDecoder uut (
    .instruction(instruction),
    .itype(itype),
    .rtype(rtype),
    .gprw(gprw),
    .su(su),
    .jump(jump),
    .b(b),
    .j(j),
    .jr(jr),
    .jal(jal),
    .jalr(jalr),
    .l(l),
    .s(s),
    .alu(alu),
    .cad(cad),
    .sa(sa),
    .af(af),
    .bf(bf),
    .sf(sf),
    .iindex(iindex),
    .zxtimm(zxtimm),
    .sxtimm(sxtimm)
);

// Task to apply instruction and verify expected outputs
task test_instruction;
    input [31:0] inst;
    input exp_itype, exp_rtype, exp_gprw, exp_su, exp_jump, exp_b, exp_j, exp_jr, exp_jal, exp_jalr, exp_l, exp_s, exp_alu;
    input [4:0] exp_cad, exp_sa;
    input [3:0] exp_af, exp_bf;
    input [1:0] exp_sf;
    input [25:0] exp_iindex;
    input [31:0] exp_zxtimm, exp_sxtimm;

    begin
        // Apply instruction
        instruction = inst;
        #10;  // Wait for the instruction to be processed

        // Check each expected output
        if (itype !== exp_itype) $display("Test failed for instruction %b: Expected itype = %b, got %b", inst, exp_itype, itype);
        if (rtype !== exp_rtype) $display("Test failed for instruction %b: Expected rtype = %b, got %b", inst, exp_rtype, rtype);
        if (gprw !== exp_gprw) $display("Test failed for instruction %b: Expected gprw = %b, got %b", inst, exp_gprw, gprw);
        if (su !== exp_su) $display("Test failed for instruction %b: Expected su = %b, got %b", inst, exp_su, su);
        if (jump !== exp_jump) $display("Test failed for instruction %b: Expected jump = %b, got %b", inst, exp_jump, jump);
        if (b !== exp_b) $display("Test failed for instruction %b: Expected b = %b, got %b", inst, exp_b, b);
        if (j !== exp_j) $display("Test failed for instruction %b: Expected j = %b, got %b", inst, exp_j, j);
        if (jr !== exp_jr) $display("Test failed for instruction %b: Expected jr = %b, got %b", inst, exp_jr, jr);
        if (jal !== exp_jal) $display("Test failed for instruction %b: Expected jal = %b, got %b", inst, exp_jal, jal);
        if (jalr !== exp_jalr) $display("Test failed for instruction %b: Expected jalr = %b, got %b", inst, exp_jalr, jalr);
        if (l !== exp_l) $display("Test failed for instruction %b: Expected l = %b, got %b", inst, exp_l, l);
        if (s !== exp_s) $display("Test failed for instruction %b: Expected s = %b, got %b", inst, exp_s, s);
        if (alu !== exp_alu) $display("Test failed for instruction %b: Expected alu = %b, got %b", inst, exp_alu, alu);
        if (cad !== exp_cad) $display("Test failed for instruction %b: Expected cad = %b, got %b", inst, exp_cad, cad);
        if (sa !== exp_sa) $display("Test failed for instruction %b: Expected sa = %b, got %b", inst, exp_sa, sa);
        if (af !== exp_af) $display("Test failed for instruction %b: Expected af = %b, got %b", inst, exp_af, af);
        if (bf !== exp_bf) $display("Test failed for instruction %b: Expected bf = %b, got %b", inst, exp_bf, bf);
        if (sf !== exp_sf) $display("Test failed for instruction %b: Expected sf = %b, got %b", inst, exp_sf, sf);
        if (iindex !== exp_iindex) $display("Test failed for instruction %b: Expected iindex = %b, got %b", inst, exp_iindex, iindex);
        if (zxtimm !== exp_zxtimm) $display("Test failed for instruction %b: Expected zxtimm = %b, got %b", inst, exp_zxtimm, zxtimm);
        if (sxtimm !== exp_sxtimm) $display("Test failed for instruction %b: Expected sxtimm = %b, got %b", inst, exp_sxtimm, sxtimm);
        
        $display("Test passed for instruction %b", inst);  // If no mismatches
    end
endtask

// Initial block to run the tests
initial begin
    // opc = 001000 addi rt rs imm

    test_instruction(
        32'b001000_00001_00010_0000000000000001,  // instruction
        1, // itype
        0, // rtype
        1, // gprw
        0, // su
        0, // jump
        0, // b
        0, // j
        0, // jr
        0, // jal
        0, // jalr
        0, // l
        0, // s
        1, // alu
        5'b00010, // cad
        5'b00000, // sa
        4'b0000, // af
        4'b0000, // bf
        2'b01, // sf
        26'b00001_00010_0000000000000001, // iindex
        32'b00000000000000000000000000000001, // zxtimm
        32'b00000000000000000000000000000001
    );

       
end

endmodule
