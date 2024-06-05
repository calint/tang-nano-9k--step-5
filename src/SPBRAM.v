//
// verilog that synthesizes to Single Port RAM
//

`default_nettype none
`define DBG
`define INFO

module SPBRAM #(
    parameter DATA_FILE = "",
    parameter ADDRESS_BITWIDTH = 16,
    parameter DATA_BITWIDTH = 32
) (
    input wire clk,
    input wire write_enable,
    input wire [ADDRESS_BITWIDTH-1:0] address,
    output reg [DATA_BITWIDTH-1:0] data_out,
    input wire [DATA_BITWIDTH-1:0] data_in
);

  initial begin
    if (DATA_FILE != "") begin
      $readmemh(DATA_FILE, data, 0, 2 ** ADDRESS_BITWIDTH - 1);
    end
  end

  reg [DATA_BITWIDTH-1:0] data[2**ADDRESS_BITWIDTH-1:0];

  always @(posedge clk) begin
    // $display("RAM: write_enable: %d  address: %h  data_in: %h", write_enable, address, data_in);
    if (write_enable == 1) begin
      data[address] <= data_in;
    end
    data_out <= data[address];
  end

endmodule

`undef DBG
`undef INFO
`default_nettype wire
