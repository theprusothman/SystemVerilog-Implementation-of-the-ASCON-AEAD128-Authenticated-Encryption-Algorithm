// -----------------------------------------------------------------------------
// Module      : Xor_Begin
// Auteur      : Prusothman VIGNESWARAN
// Description : Réalise le XOR sur les états S0, S1
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module Xor_Begin (
	input logic [127:0] data_i,
	input logic enable_xb_i,
	input type_state state_i,
	output type_state output_mux_o);

// Déclaration des signaux internes
   assign output_mux_o[0] = (enable_xb_i == 1'b1) ? state_i[0] ^ data_i[63:0] : state_i[0];
   assign output_mux_o[1] = (enable_xb_i == 1'b1) ? state_i[1] ^ data_i[127:64] : state_i[1];
   assign output_mux_o[2] = state_i[2];
   assign output_mux_o[3] = state_i[3];
   assign output_mux_o[4] = state_i[4];

endmodule : Xor_Begin
