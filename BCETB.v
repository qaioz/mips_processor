// include is for linter in my environment, must be removed
`include "BCE.v"

module BCETB;

    // Inputs
    reg [31:0] a, b;
    reg [3:0] bf;

    // Output
    wire [31:0] bcres;

    // Instantiate the Unit Under Test (UUT)
    BCE uut (
        .a(a), 
        .b(b), 
        .bf(bf), 
        .bcres(bcres)
    );

    // Test variables
    reg [31:0] expected_bcres;

    // Tasks to display pass/fail results
    task check_result;
        input [31:0] a_in, b_in;
        input [3:0] bf_in;
        input [31:0] expected;
        input [31:0] actual;
        
        begin
            $display("a = %b, b = %b, bf = %b | Expected: %b, Got: %b", 
                      a_in, b_in, bf_in, expected, actual);
            if (actual === expected) begin
                $display("Test Passed!");
            end else begin
                $display("Test Failed!");
            end
        end
    endtask

    initial begin
        // Test case 1: Signed less than 0 (bf = 0010) => $signed(a) < 0
        a = 32'b11111111111111111111111111111000;  // -8 in two's complement
        b = 32'b00000000000000000000000000000000;  // 0
        bf = 4'b0010;  // Check if $signed(a) < 0
        expected_bcres = 32'b1;  // True, -8 is less than 0
        #10 check_result(a, b, bf, expected_bcres, bcres);

        // Test case 2: Signed greater than or equal to 0 (bf = 0011) => $signed(a) >= 0
        a = 32'b00000000000000000000000000000100;  // 4
        b = 32'b00000000000000000000000000000000;  // 0
        bf = 4'b0011;  // Check if $signed(a) >= 0
        expected_bcres = 32'b1;  // True, 4 is greater than or equal to 0
        #10 check_result(a, b, bf, expected_bcres, bcres);

        // Test case 3: a == b (bf = 1000) => a == b
        a = 32'b00000000000000000000000000000100;  // 4
        b = 32'b00000000000000000000000000000100;  // 4
        bf = 4'b1000;  // Check if a == b
        expected_bcres = 32'b1;  // True, a equals b
        #10 check_result(a, b, bf, expected_bcres, bcres);

        // Test case 4: a != b (bf = 1010) => a != b
        a = 32'b00000000000000000000000000000100;  // 4
        b = 32'b00000000000000000000000000000011;  // 3
        bf = 4'b1010;  // Check if a != b
        expected_bcres = 32'b1;  // True, a does not equal b
        #10 check_result(a, b, bf, expected_bcres, bcres);

        // Test case 5: Signed less than or equal to 0 (bf = 1100) => $signed(a) <= 0
        a = 32'b00000000000000000000000000000000;  // 0
        b = 32'b00000000000000000000000000000000;  // 0
        bf = 4'b1100;  // Check if $signed(a) <= 0
        expected_bcres = 32'b1;  // True, 0 is less than or equal to 0
        #10 check_result(a, b, bf, expected_bcres, bcres);

        // Test case 6: Signed greater than 0 (bf = 1110) => $signed(a) > 0
        a = 32'b00000000000000000000000000000011;  // 3
        b = 32'b00000000000000000000000000000000;  // 0
        bf = 4'b1110;  // Check if $signed(a) > 0
        expected_bcres = 32'b1;  // True, 3 is greater than 0
        #10 check_result(a, b, bf, expected_bcres, bcres);

        // Test case 7: Signed less than 0, but check failure (bf = 0010) => $signed(a) < 0
        a = 32'b00000000000000000000000000000100;  // 4
        b = 32'b00000000000000000000000000000000;  // 0
        bf = 4'b0010;  // Check if $signed(a) < 0
        expected_bcres = 32'b0;  // False, 4 is not less than 0
        #10 check_result(a, b, bf, expected_bcres, bcres);

        $stop;
    end
endmodule
