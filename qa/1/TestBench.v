`timescale 1ns / 1ps `default_nettype none

module TestBench;

  Cache #(
      .LINE_IX_BITWIDTH(10)
  ) cache (
      .clk(clk),
      .rst_n(sys_rst_n),
      .address(address),
      .data_out(data_out),
      .data_out_valid(data_out_valid),
      .data_in(data_in),
      .write_enable(write_enable)
  );

  reg clk = 1;
  reg sys_rst_n = 0;
  reg write_enable;
  reg [31:0] address;
  reg [31:0] data_in;
  wire [31:0] data_out;
  wire data_out_valid;

  localparam clk_tk = 4;
  always #(clk_tk / 2) clk = ~clk;

  integer i;

  initial begin
    $dumpfile("log.vcd");
    $dumpvars(0, TestBench);

    // clear the cache
    for (i = 0; i < 2 ** 10; i = i + 1) begin
      cache.tag.data[i]   = 0;
      cache.data0.data[i] = 0;
      cache.data1.data[i] = 0;
      cache.data2.data[i] = 0;
      cache.data3.data[i] = 0;
    end

    #clk_tk;
    sys_rst_n <= 1;
    #clk_tk;

    // write
    address <= 4;
    data_in <= 32'habcd_ef12;
    write_enable <= 1;
    #clk_tk;

    // // dump the cache
    // for (i = 0; i < 8; i = i + 1) begin
    //   $display("1). %h : %h  %h  %h  %h", cache.tag.data[i], cache.data0.data[i],
    //            cache.data1.data[i], cache.data2.data[i], cache.data3.data[i]);
    // end

    // write
    address <= 8;
    data_in <= 32'habcd_1234;
    write_enable <= 1;
    #clk_tk;

    // one cycle delay. value for address 4
    if (data_out == 32'habcd_ef12 && data_out_valid) $display("Test 1 passed");
    else $display("Test 1 FAILED");

    // read; cache hit
    address <= 4;
    write_enable <= 0;
    #clk_tk;

    // read; cache hit
    address <= 8;
    write_enable <= 0;
    #clk_tk;

    // read; not valid
    address <= 16;
    write_enable <= 0;
    #clk_tk;

    if (data_out == 32'habcd_1234 && data_out_valid) $display("Test 2 passed");
    else $display("Test 2 FAILED");

    if (!data_out_valid) $display("Test 3 passed");
    else $display("Test 3 FAILED");

    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;

    $finish;
  end

endmodule

`default_nettype wire
