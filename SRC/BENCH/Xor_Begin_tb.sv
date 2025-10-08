// -----------------------------------------------------------------------------
// Fichier     : Xor_Begin_tb.sv
// Auteur      : Prusothman VIGNESWARAN
// Description : Testbench du module XOR_BEGIN
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

//Importation des modules
module Xor_Begin_tb 
import ascon_pack::*;
(
);

//Déclaration des Signaux
logic [127:0]data_s;
logic enable_xb_s;
type_state state_s;
type_state output_mux_s;

Xor_Begin DUT (
	.data_i(data_s),
	.enable_xb_i(enable_xb_s),
	.state_i(state_s),
	.output_mux_o(output_mux_s));

initial begin
	enable_xb_s = 1'b1;
	data_s = 128'h0000626F42206F74206563696C41;
	state_s[0] = 64'h82bf91294ba5808d;
	state_s[1] = 64'hd81eeca694136f8a;
	state_s[2] = 64'h0217bc9ebd9fff02;
	state_s[3] = 64'h2163c2a59353d4c8;
	state_s[4] = 64'h2731cda0e76aa05b;

#10;

end

endmodule : Xor_Begin_tb
