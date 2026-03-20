`timescale 1ns / 1ps
/* 
Built-in MAC unit
Older version's separate MAC unit caused area constraints on the small FPGA (1120 LUTs),
so I switched to an inbuilt MAC implementation.
The older version used a parallel-prefix adder (Kogge-Stone 16-bit) and an 8-bit MAC.
*/
module perceptron_core(
    input clk, rst,
    input [7:0] spi_data,     // Byte arriving from SPI
    input spi_valid,          // Pulse when a new byte is ready
    input start,              // Pulse on CS falling edge
    output reg occupied,      // LED Output
    output reg done           // High for 1 cycle when 64th byte processed
);

    reg signed [23:0] accumulator;
    reg [5:0] count;

    // Weights 
    function signed [7:0] get_weight(input [5:0] idx);
        case(idx) // index == count
            6'd0:  get_weight =  8'sd42;  6'd1:  get_weight =  8'sd23;  6'd2:  get_weight =  8'sd17;  6'd3:  get_weight = -8'sd6;
            6'd4:  get_weight = -8'sd3;   6'd5:  get_weight =  8'sd26;  6'd6:  get_weight =  8'sd33;  6'd7:  get_weight = -8'sd87;
            6'd8:  get_weight = -8'sd10;  6'd9:  get_weight =  8'sd54;  6'd10: get_weight =  8'sd23;  6'd11: get_weight =  8'sd25;
            6'd12: get_weight =  8'sd37;  6'd13: get_weight =  8'sd20;  6'd14: get_weight = -8'sd4;   6'd15: get_weight = -8'sd121;
            6'd16: get_weight =  8'sd11;  6'd17: get_weight =  8'sd36;  6'd18: get_weight =  8'sd30;  6'd19: get_weight =  8'sd41;
            6'd20: get_weight =  8'sd36;  6'd21: get_weight =  8'sd47;  6'd22: get_weight =  8'sd14;  6'd23: get_weight = -8'sd127;
            6'd24: get_weight =  8'sd25;  6'd25: get_weight =  8'sd42;  6'd26: get_weight =  8'sd69;  6'd27: get_weight =  8'sd18;
            6'd28: get_weight =  8'sd37;  6'd29: get_weight =  8'sd30;  6'd30: get_weight =  8'sd9;   6'd31: get_weight = -8'sd101;
            6'd32: get_weight =  8'sd26;  6'd33: get_weight =  8'sd43;  6'd34: get_weight =  8'sd19;  6'd35: get_weight =  8'sd50;
            6'd36: get_weight =  8'sd39;  6'd37: get_weight =  8'sd25;  6'd38: get_weight =  8'sd39;  6'd39: get_weight = -8'sd103;
            6'd40: get_weight =  8'sd41;  6'd41: get_weight =  8'sd39;  6'd42: get_weight =  8'sd49;  6'd43: get_weight =  8'sd12;
            6'd44: get_weight =  8'sd36;  6'd45: get_weight =  8'sd53;  6'd46: get_weight =  8'sd18;  6'd47: get_weight = -8'sd95;
            6'd48: get_weight =  8'sd40;  6'd49: get_weight =  8'sd31;  6'd50: get_weight =  8'sd31;  6'd51: get_weight =  8'sd19;
            6'd52: get_weight =  8'sd70;  6'd53: get_weight =  8'sd0;   6'd54: get_weight =  8'sd49;  6'd55: get_weight = -8'sd85;
            6'd56: get_weight = -8'sd89;  6'd57: get_weight = -8'sd108; 6'd58: get_weight = -8'sd116; 6'd59: get_weight = -8'sd105;
            6'd60: get_weight = -8'sd74;  6'd61: get_weight = -8'sd120; 6'd62: get_weight = -8'sd41;  6'd63: get_weight = -8'sd85;
            default: get_weight = 8'sd0;
        endcase
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accumulator <= -24'sd2672; // Bias from trained model
            count       <= 6'd0;
            occupied    <= 1'b0;
            done        <= 1'b0;
        end else begin
            // Reset for a new SPI frame
            if (start) begin
                accumulator <= -24'sd2672; // Reset to Bias
                count       <= 6'd0;
                done        <= 1'b0;
            end 
            // Clear done one cycle after it was set
            else if (done) begin
                done <= 1'b0;
            end
            // Process data as it arrives via SPI
            else if (spi_valid) begin
                // Streaming Multiply-Accumulate
                accumulator <= accumulator + ($signed({1'b0, spi_data}) * get_weight(count));

                if (count == 6'd63) begin
                    occupied <= ( (accumulator + ($signed({1'b0, spi_data}) * get_weight(count))) > 24'sd0 );
                    done     <= 1'b1;
                end else begin
                    count    <= count + 1'b1;
                end
            end
        end
    end

endmodule