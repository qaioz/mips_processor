// this include is only for my linting environment, must be removed
`include "GPRFile.v"

module GPRFileTB;
    reg clk;
    reg [31:0] sin;
    reg [4:0] sa, sb, sc;
    reg sw;
    wire [31:0] souta, soutb;

    // Instantiate the GPRFile module
    GPRFile uut (
        .clk(clk),
        .sin(sin),
        .sa(sa),
        .sb(sb),
        .sc(sc),
        .sw(sw),
        .souta(souta),
        .soutb(soutb)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns period
    end

    // Stimulus
    initial begin
        // Initialize inputs
        sin = 32'b0;
        sa = 5'b0;
        sb = 5'b0;
        sc = 5'b0;
        sw = 1'b0;
        
        // Monitor outputs
        $monitor("Time: %0t | sa = %d, sb = %d, sc = %d, sin = %b, sw = %b, souta = %b, soutb = %b", 
                  $time, sa, sb, sc, sin, sw, souta, soutb);

        // Reset regfile
        #10;

        // Test Case 1: Write to register 5, check sa and sb read correct values
        sin = 32'b10101010101010101010101010101010; // Data to write
        sc = 5'b00101; // Write to register 5
        sw = 1'b1;     // Write enable
        #10;
        sw = 1'b0;     // Disable write

        sa = 5'b00101; // Read from register 5
        sb = 5'b00000; // Read from register 0 (should always return 0)
        #10;

        // Expected Output:
        // souta = 10101010101010101010101010101010
        // soutb = 00000000000000000000000000000000
        if (souta !== 32'b10101010101010101010101010101010 || soutb !== 32'b00000000000000000000000000000000) begin
            $display("Test Case 1: FAILED!");
        end else begin
            $display("Test Case 1: PASSED!");
        end

        // Test Case 2: Write to register 0 (which should not happen)
        sin = 32'b11111111111111111111111111111111;
        sc = 5'b00000; // Attempt to write to register 0
        sw = 1'b1;     // Write enable
        #10;
        sw = 1'b0;     // Disable write

        sa = 5'b00000; // Read from register 0
        sb = 5'b00101; // Read from register 5 (should still hold previous value)
        #10;

        // Expected Output:
        // souta = 00000000000000000000000000000000 (register 0 should not change)
        // soutb = 10101010101010101010101010101010 (unchanged from previous write)
        if (souta !== 32'b00000000000000000000000000000000 || soutb !== 32'b10101010101010101010101010101010) begin
            $display("Test Case 2: FAILED!");
        end else begin
            $display("Test Case 2: PASSED!");
        end

        // Test Case 3: Write to register 10, check sa and sb read correct values
        sin = 32'b01010101010101010101010101010101; // Data to write
        sc = 5'b01010; // Write to register 10
        sw = 1'b1;     // Write enable
        #10;
        sw = 1'b0;     // Disable write

        sa = 5'b01010; // Read from register 10
        sb = 5'b00101; // Read from register 5
        #10;

        // Expected Output:
        // souta = 01010101010101010101010101010101 (new value in reg 10)
        // soutb = 10101010101010101010101010101010 (unchanged from previous write)
        if (souta !== 32'b01010101010101010101010101010101 || soutb !== 32'b10101010101010101010101010101010) begin
            $display("Test Case 3: FAILED!");
        end else begin
            $display("Test Case 3: PASSED!");
        end

        // Finish simulation
        #20;
        $finish;
    end

endmodule
