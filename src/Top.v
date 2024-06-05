`default_nettype none

module Top (
    input wire sys_clk,
    input wire sys_rst_n,
    output reg [5:0] led,
    input wire uart_rx,
    output wire uart_tx,
    input wire btn1
);

  Cache cache (
      .clk(sys_clk),
      .rst_n(sys_rst_n),
      .address(address),
      .data_out(data_out),
      .data_out_valid(data_out_valid),
      .data_in(data_in),
      .write_enable(write_enable)
  );

  reg [31:0] address = 0;
  wire [31:0] data_out;
  wire data_out_valid;
  reg [31:0] data_in;
  reg write_enable;

  reg [3:0] state = 0;

  always @(posedge sys_clk) begin
    case (state)
      0: begin
        data_in <= 32'h1234_5678;
        write_enable <= 1;
        state <= 1;
      end
      1: begin
        led <= data_out[5:0];
        write_enable <= 0;
        address <= address + 4;
        state <= 0;
      end
    endcase
  end

endmodule

`default_nettype wire
