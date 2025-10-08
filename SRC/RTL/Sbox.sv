// -----------------------------------------------------------------------------
// Module      : Sbox
// Auteur      : Prusothman VIGNESWARAN
// Description : Implémente la boîte S (substitution) utilisée dans l’étape Ps
// -----------------------------------------------------------------------------

//Importation du module
import ascon_pack::*;

module Sbox (
	input logic[4:0] Sbox_in_i,
	output logic[4:0] Sbox_out_o
);


always_comb begin 
case (Sbox_in_i)
5'h00: Sbox_out_o = 5'h04;

5'h01: Sbox_out_o = 5'h0B;

5'h02: Sbox_out_o = 5'h1F;

5'h03:Sbox_out_o = 5'h14;

5'h04:Sbox_out_o = 5'h1A;

5'h05: Sbox_out_o = 5'h15;

5'h06: Sbox_out_o = 5'h09;

5'h07: Sbox_out_o = 5'h02;

5'h08: Sbox_out_o = 5'h1B;

5'h09: Sbox_out_o = 5'h05;

5'h0A: Sbox_out_o = 5'h08;

5'h0B: Sbox_out_o = 5'h12;

5'h0C: Sbox_out_o = 5'h1D;

5'h0D: Sbox_out_o = 5'h03;

5'h0E: Sbox_out_o = 5'h06;

5'h0F: Sbox_out_o = 5'h1C;

5'h10: Sbox_out_o = 5'h1E;

5'h11: Sbox_out_o = 5'h13;

5'h12: Sbox_out_o = 5'h07;

5'h13: Sbox_out_o = 5'h0E;

5'h14:Sbox_out_o = 5'h00;

5'h15: Sbox_out_o = 5'h0D;

5'h16: Sbox_out_o = 5'h11;

5'h17: Sbox_out_o = 5'h18;

5'h18: Sbox_out_o = 5'h10;

5'h19: Sbox_out_o = 5'h0C;

5'h1A: Sbox_out_o = 5'h01;

5'h1B: Sbox_out_o = 5'h19;

5'h1C: Sbox_out_o = 5'h16;

5'h1D: Sbox_out_o = 5'h0A;

5'h1E: Sbox_out_o = 5'h0F;

5'h1F: Sbox_out_o = 5'h17;


endcase
end 

endmodule : Sbox
