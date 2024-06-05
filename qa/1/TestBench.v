`timescale 1ns / 1ps `default_nettype none

module TestBench;

  SPBRAM #(
      .ADDRESS_BITWIDTH(16)
  ) data (
      .clk(clk),
      .write_enable(write_enable),
      .address(address),
      .data_in(data_in),
      .data_out(data_out)
  );
  reg write_enable = 0;
  reg [31:0] address = 0;
  reg [31:0] data_in = 0;
  wire [31:0] data_out;

  localparam clk_tk = 4;
  reg clk = 1;
  always #(clk_tk / 2) clk = ~clk;

  initial begin
    $dumpfile("log.vcd");
    $dumpvars(0, TestBench);

    #clk_tk;
    write_enable <= 1;
    data_in <= 32'habcd_ef12;
    #clk_tk;
    write_enable <= 0;
    #clk_tk;

    #clk_tk;
    #clk_tk;
    $finish;
  end

endmodule

`default_nettype wire
