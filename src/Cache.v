`default_nettype none

module Cache #(
    parameter LINE_IX_BITWIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire [31:0] address,
    output reg [31:0] data_out,
    output reg data_out_valid,
    input wire [31:0] data_in,
    input wire write_enable
);
  // 4 column cache line
  localparam ZEROS_BITWIDTH = 2;
  localparam COLUMN_IX_BITWIDTH = 2;  // 4 SPBRAMs
  localparam LINE_COUNT = 2 ** LINE_IX_BITWIDTH;
  localparam TAG_BITWIDTH = 32 - LINE_IX_BITWIDTH - COLUMN_IX_BITWIDTH - ZEROS_BITWIDTH;

  wire [COLUMN_IX_BITWIDTH-1:0] column_ix = address[COLUMN_IX_BITWIDTH+ZEROS_BITWIDTH-1-:COLUMN_IX_BITWIDTH];
  wire [LINE_IX_BITWIDTH-1:0] line_ix =  address[LINE_IX_BITWIDTH+COLUMN_IX_BITWIDTH+ZEROS_BITWIDTH-1-:LINE_IX_BITWIDTH];
  wire [TAG_BITWIDTH-1:0] line_tag_in = address[TAG_BITWIDTH+LINE_IX_BITWIDTH+COLUMN_IX_BITWIDTH+ZEROS_BITWIDTH-1-:TAG_BITWIDTH];

  SPBRAM #(
      .ADDRESS_BITWIDTH(LINE_IX_BITWIDTH)
  ) tag (
      .clk(clk),
      .write_enable(write_enable_tag),
      .address(line_ix),
      .data_in({1, 0, line_tag_in}),  // 1: valid, 0: dirty
      .data_out(line_tag)
  );

  SPBRAM #(
      .ADDRESS_BITWIDTH(LINE_IX_BITWIDTH)
  ) data0 (
      .clk(clk),
      .write_enable(write_enable_0),
      .address(line_ix),
      .data_in(data_in),
      .data_out(data0_out)
  );

  SPBRAM #(
      .ADDRESS_BITWIDTH(LINE_IX_BITWIDTH)
  ) data1 (
      .clk(clk),
      .write_enable(write_enable_1),
      .address(line_ix),
      .data_in(data_in),
      .data_out(data1_out)
  );

  SPBRAM #(
      .ADDRESS_BITWIDTH(LINE_IX_BITWIDTH)
  ) data2 (
      .clk(clk),
      .write_enable(write_enable_2),
      .address(line_ix),
      .data_in(data_in),
      .data_out(data2_out)
  );

  SPBRAM #(
      .ADDRESS_BITWIDTH(LINE_IX_BITWIDTH)
  ) data3 (
      .clk(clk),
      .write_enable(write_enable_3),
      .address(address),
      .data_in(data_in),
      .data_out(data3_out)
  );

  wire [TAG_BITWIDTH-1:0] line_tag;
  wire [31:0] data0_out;
  wire [31:0] data1_out;
  wire [31:0] data2_out;
  wire [31:0] data3_out;
  reg write_enable_tag;
  reg write_enable_0;
  reg write_enable_1;
  reg write_enable_2;
  reg write_enable_3;

  always @(*) begin
    case (column_ix)
      0: data_out = data0_out;
      1: data_out = data1_out;
      2: data_out = data2_out;
      3: data_out = data3_out;
    endcase
  end

  always @(*) begin
    data_out_valid = line_tag_in == line_tag;
  end


  always @(*) begin
    write_enable_0   = 0;
    write_enable_1   = 0;
    write_enable_2   = 0;
    write_enable_3   = 0;
    write_enable_tag = 0;
    if (write_enable) begin
      write_enable_tag = 1;
      case (column_ix)
        0: write_enable_0 = 1;
        1: write_enable_1 = 1;
        2: write_enable_2 = 1;
        3: write_enable_3 = 1;
      endcase
    end

  end

  always @(posedge clk) begin

  end

  reg [3:0] state;

  always @(posedge clk) begin
    case (state)
      default: ;

    endcase
  end

endmodule

`default_nettype wire
