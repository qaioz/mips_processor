`include "RAM.v"
module RAM_tb;

  reg clk;
  reg [31:0] sa;
  reg [31:0] sin;  // You might not need sin for just reading
    reg sw;
  wire [31:0] sout;

  // Instantiate the RAM module
  RAM uut (
      .clk (clk),
      .sin (sin),
      .sa  (sa),
      .sout(sout),
      .sw(sw)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Clock period = 10 time units
  end

  initial begin
    // Initialize the inputs
    sin = 0;  // For now, just focus on reading
    sa  = 0;

    // I am writing this test in reference to add.txt

    // Test Case 1: Read from address 0, should return 10001100000001110000000000111000
    sa = 0;
    #10;
    if (sout !== 32'b10001100000001110000000000111000) begin
      $display("Test Case 1: FAILED! Expected: 10001100000001110000000000111000, Got: %b", sout);
    end else begin
      $display("Test Case 1: PASSED!");
    end

    // Test Case 2: read from adress 12, should return -7
    sa = 12;
    #10;
    if (sout !== -7) begin
      $display("Test Case 2: FAILED! Expected: -7, Got: %d", sout);
    end else begin
      $display("Test Case 2: PASSED!");
    end

    // Test Case 3: Write to adress 12 without sw, should not change the value
    sa = 12;
    sin = 69;
    #10;
    #10;
    if (sout !== -7) begin
      $display("Test Case 3: FAILED! Expected: -7, Got: %d", sout);
    end else begin
      $display("Test Case 3: PASSED!");
    end

    // Test Case 4: Write to adress 12 with sw, should change the value
    sa = 12;
    sin = 69;
    sw = 1;
    #10;
    #10;
    if (sout !== 69) begin
      $display("Test Case 4: FAILED! Expected: 69, Got: %b", sout);
    end else begin
      $display("Test Case 4: PASSED!");
    end


    $finish;
  end

endmodule
