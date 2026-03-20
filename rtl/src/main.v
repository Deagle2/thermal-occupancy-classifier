
`timescale 1ns / 1ps
(* top *)
module main (
(* iopad_external_pin, clkbuf_inhibit *) input clk,
(* iopad_external_pin *) output clk_en,
(* iopad_external_pin *) input rst_n,

(* iopad_external_pin *) input spi_ss_n,
(* iopad_external_pin *) input spi_sck,
(* iopad_external_pin *) input spi_mosi,
(* iopad_external_pin *) output spi_miso,
(* iopad_external_pin *) output spi_miso_en,

(* iopad_external_pin *) output led,
(* iopad_external_pin *) output led_en
);

assign clk_en = 1'b1;
assign led_en = 1'b1;
wire [7:0] rx_data_wire;
wire rx_valid_pulse;
wire occupied_wire;
wire done_wire;
reg [7:0] tx_data_reg;

// SPI echo
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    tx_data_reg <= 8'h00;
    else if(rx_valid_pulse)
    tx_data_reg <= rx_data_wire;
end

spi_target #(
.CPOL(1'b0),
.CPHA(1'b0),
.WIDTH(8),
.LSB(1'b0)
) u_spi_target (

.i_clk(clk),
.i_rst_n(rst_n),
.i_enable(1'b1),

.i_ss_n(spi_ss_n),
.i_sck(spi_sck),
.i_mosi(spi_mosi),
.o_miso(spi_miso),
.o_miso_oe(spi_miso_en),

.o_rx_data(rx_data_wire),
.o_rx_data_valid(rx_valid_pulse),

.i_tx_data(tx_data_reg),
.o_tx_data_hold()
);

// 2-stage synchronizer - CREATE START PULSE FROM CS
 
reg ss_sync0, ss_sync1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ss_sync0 <= 1'b1;
        ss_sync1 <= 1'b1;
    end else begin
        ss_sync0 <= spi_ss_n;
        ss_sync1 <= ss_sync0;
    end
end

wire start_pulse = (ss_sync1 == 1'b1 && ss_sync0 == 1'b0);

perceptron_core core_inst (

.clk(clk),
.rst(~rst_n),
.spi_data(rx_data_wire),
.spi_valid(rx_valid_pulse),
.start(start_pulse),

.occupied(occupied_wire),
.done(done_wire)
);

assign led = occupied_wire;

endmodule