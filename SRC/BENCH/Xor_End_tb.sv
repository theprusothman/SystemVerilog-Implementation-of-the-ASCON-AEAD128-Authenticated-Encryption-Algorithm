// -----------------------------------------------------------------------------
// Fichier     : Xor_End_tb.sv
// Auteur      : Prusothman VIGNESWARAN
// Description : Testbench du module XOR_END
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

//Importation des modules
module Xor_End_tb 
import ascon_pack::*;
(
);

//Déclaration des Signaux
logic [127:0]data_s;
logic enable_xe_s;
type_state state_s;
type_state output_mux_s;


Xor_End DUT (
	.data_i(data_s),
	.enable_xe_i(enable_xe_s),
	.state_i(state_s),
	.output_mux_o(output_mux_s));

initial begin
	enable_xe_s = 2'b01;
	data_s = 128'h691AED630E81901F6CB10AD9CA912F80;
	state_s[0] = 64'h82bf91294ba5808d;
	state_s[1] = 64'hd81eeca694136f8a;
	state_s[2] = 64'h0217bc9ebd9fff02;
	state_s[3] = 64'h4dd2c87c59c2fb48;
	state_s[4] = 64'h4e2b20c3e9eb3044;
	
#10;

end

endmodule : Xor_End_tb



