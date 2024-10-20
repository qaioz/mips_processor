
// adressed by bytes, retreives 4 bytes at a time starting from the sa address
module RAM (
    input clk,
    input [31:0] sin,
    input [31:0] sa,
    input sw,
    output reg [31:0] sout
);


  // 128 32-bit registers
  reg [7:0] mem[15:0];

  // read from the instructions.txt file
  initial begin
    // add file is 8 bits strings in programs/
    $readmemb("programs/add.txt", mem);
  end

  always @(posedge clk) begin
    if (sw) begin
      mem[sa]   <= sin[31:24];
      mem[sa+1] <= sin[23:16];
      mem[sa+2] <= sin[15:8];
      mem[sa+3] <= sin[7:0];
    end else begin
      mem[sa]   <= mem[sa];
      mem[sa+1] <= mem[sa+1];
      mem[sa+2] <= mem[sa+2];
      mem[sa+3] <= mem[sa+3];
    end

    sout <= {mem[sa], mem[sa+1], mem[sa+2], mem[sa+3]};
  end


endmodule
