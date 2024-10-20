// This include is only linter to not show errors in my environment, must be removed
`include "ShiftUnit.v"

module ShiftUnitTB;
    reg  [31:0] a;
    reg  [ 4:0] sdist;
    reg  [ 1:0] sf;
    wire [31:0] sres;
    
    // Instantiate the ShiftUnit module
    ShiftUnit uut (
        .a(a),
        .sdist(sdist),
        .sf(sf),
        .sres(sres)
    );
    
    // Task to check and display test results
    task check;
        input [31:0] expected;
        begin
            if (sres !== expected) begin
                $display("Test failed! a = %b, sdist = %d, sf = %b | Expected: %b, Got: %b", 
                         a, sdist, sf, expected, sres);
            end else begin
                $display("Test passed! a = %b, sdist = %d, sf = %b | Result: %b", 
                         a, sdist, sf, sres);
            end
        end
    endtask
    
    initial begin
        // Test Case 1: Logical Shift Left (SLL)
        a = 32'b00000000000000000000000000000001;
        sdist = 5'd2;
        sf = 2'b00;
        #10 check(32'b00000000000000000000000000000100);  // Expected result after shift left

        // Test Case 2: Logical Shift Right (SRL)
        a = 32'b00000000000000000000000000010000;
        sdist = 5'd3;
        sf = 2'b01;
        #10 check(32'b00000000000000000000000000000010);  // Expected result after shift right

        // Test Case 3: Arithmetic Shift Right (SRA) (Negative number)
        a = 32'b11111111111111111111111111100000;  // -32 in two's complement
        sdist = 5'd3;
        sf = 2'b11;
        #10 check(32'b11111111111111111111111111111100);  // Expected result after arithmetic shift right

        // Test Case 4: Arithmetic Shift Right (SRA) (Positive number)
        a = 32'b00000000000000000000000000010000;
        sdist = 5'd2;
        sf = 2'b11;
        #10 check(32'b00000000000000000000000000000100);  // Expected result after arithmetic shift right

        // Test Case 5: Logical Shift Right (SRL) with 0
        a = 32'b00000000000000000000000000000000;
        sdist = 5'd1;
        sf = 2'b01;
        #10 check(32'b00000000000000000000000000000000);  // Expected result is 0

        // Add more cases as needed
        
        // Finish simulation
        $finish;
    end
endmodule
