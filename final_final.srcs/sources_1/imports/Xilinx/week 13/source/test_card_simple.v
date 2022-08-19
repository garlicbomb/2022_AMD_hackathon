`timescale 1ns / 1ps
`default_nettype none


module test_card_simple #(H_RES=1280) (
    input wire signed [15:0] i_x,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_bg_hit
    );

    localparam HW = H_RES ; // horizontal colour width = H_RES

    // Bands
    wire b0 = (i_x >= 0     ) & (i_x < HW    );

    // Colour Output
    assign o_red    = 8'b0;
    assign o_green  = 8'b0;
    assign o_blue   = 8'b0;
endmodule
