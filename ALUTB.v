// this include statement is only for linting not to show errors on my environment
`include "ALU.v"

module ALUTB;

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] af;
    reg itype;
    wire [31:0] alures;
    wire ovfalu;

    // Instantiate the ALU
    ALU uut (
        .a(a),
        .b(b),
        .af(af),
        .itype(itype),
        .alures(alures),
        .ovfalu(ovfalu)
    );

    // Counter for the number of times the verify_output task is called
    integer call_count = 0;

    // Function to verify ALU output
    task verify_output;
        input [31:0] input_a;
        input [31:0] input_b;
        input itype;
        input [3:0] input_af;
        input [31:0] expected_result;
        input expected_ovfalu;
        
        begin
            call_count = call_count + 1; // Increment call count

            // Check actual output against expected output
            if (alures !== expected_result || ovfalu !== expected_ovfalu) begin
                $display("FAIL (Task ID: %0d): ALU operation with a=%h, b=%h, af=%b, itype=%b", call_count, input_a, input_b, input_af, itype);
                $display("Expected: alures=%h, ovfalu=%b", expected_result, expected_ovfalu);
                $display("Actual: alures=%h, ovfalu=%b", alures, ovfalu);
            end else begin
                $display("PASS (Task ID: %0d): ALU operation with a=%h, b=%h, af=%b, itype=%b", call_count, input_a, input_b, input_af, itype);
            end
        end
    endtask

    initial begin

        // Test 1: Addition
        a = 32'h00000002; // 2
        b = 32'b11111111111111111111111111111100; // -4
        af = 4'b0000; // Add
        itype = 0; // Not an immediate
        #10; // Wait for a moment
        verify_output(a, b, itype, af, 32'b11111111111111111111111111111110, 1'b0); // Expected result and overflow

        // Test 2: Addition with overflow
        a = 32'h7FFFFFFF; // 2^31 - 1
        b = 32'h00000001; // 1
        af = 4'b0000; // Add
        itype = 0; // Not an immediate
        #10; // Wait for a moment
        verify_output(a, b, itype, af, 32'b10000000000000000000000000000000, 1'b1); // Expected result and overflow

        // Test 3: Addition with unsigned (addu) and overflow
        a = 4;
        b = 123;
        af = 4'b0001; // Addu
        itype = 1;
        #10;
        verify_output(a, b, itype, af, 127, 1'b0); // Expected result and overflow

        // Test 4: Addition with unsigned (addu) and overflow but not verify detected
        a = 32'hFFFFFFFF; // 2^32 - 1
        b = 32'h00000001; // 1
        af = 4'b0001; // Addu
        itype = 0; 
        #10;
        verify_output(a, b, itype, af, 32'h00000000, 1'b0); // Expected result and overflow


        // Test 5: Subtraction
        a = 32'h00000005; // 5
        b = 32'h00000003; // 3
        af = 4'b0010; // Subtract
        itype = 0;
        #10;
        verify_output(a, b, itype, af, 32'h00000002, 1'b0); // Expected result and overflow

        // Test 6: Subtraction with unsigned (subu)
        a = 32'h00000002; // 2
        b = 32'h00000003; // 3
        af = 4'b0011; // Subu
        itype = 0; 
        #10;
        verify_output(a, b, itype, af, 32'hFFFFFFFF, 1'b0); // Expected result and overflow

        // Test 7: AND operation
        a = 32'hFFFFFFFF; // -1
        b = 32'h00000000; // 0
        af = 4'b0100; // AND
        itype = 0; 
        #10;
        verify_output(a, b, itype, af, 32'h00000000, 1'b0); // Expected result and overflow

        // Test 8: OR operation
        a = 32'h00000000; // 0
        b = 32'hFFFFFFFF; // -1
        af = 4'b0101; // OR
        itype = 0; 
        #10;
        verify_output(a, b, itype, af, 32'hFFFFFFFF, 1'b0); // Expected result and overflow

        // Test 9: XOR operation
        a = 32'hAAAAAAAA; // 0xAA
        b = 32'h55555555; // 0x55
        af = 4'b0110; // XOR
        itype = 0; 
        #10;
        verify_output(a, b, itype, af, 32'hFFFFFFFF, 1'b0); // Expected result and overflow

        // Test 10: LUI operation
        a = 32'b11111111111111111111111101111001; // -1
        b = 32'b11001111111111111000101111111000; // -8
        af = 4'b0111; // LUI or NOR
        itype = 0; // NOR
        #10;
        verify_output(a, b, itype, af, 32'b00000000000000000000000000000110, 1'b0); // Expected result and overflow

        // Test 11: SLT operation
        a = 32'h00000001; // 1
        b = 32'h00000002; // 2
        af = 4'b1010; // SLT
        itype = 0; 
        #10;
        verify_output(a, b, itype, af, 32'h00000001, 1'b0); // Expected result and overflow

        // Test 12: SLTU operation
        a = 32'hFFFFFFFF; // -1
        b = 32'h00000000; // 0
        af = 4'b1011; // SLTU
        itype = 0; 
        #10;
        verify_output(a, b, itype, af, 32'h00000000, 1'b0); // Expected result and overflow
        
        // Finish simulation
        $finish;
    end

endmodule
