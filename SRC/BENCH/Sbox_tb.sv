// -----------------------------------------------------------------------------
// Fichier     : Sbox_tb.sv
// Auteur      : Prusothman VIGNESWARAN
// Description : Testbench de la boîte S (S-box) utilisée dans la permutation.
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

//Importation des modules
module Sbox_tb
import ascon_pack::*;
(
);
//Déclaration des Signaux
logic[4:0] Sbox_in_s;
logic [4:0] Sbox_out_s;

Sbox DUT (
	.Sbox_in_i(Sbox_in_s),
	.Sbox_out_o(Sbox_out_s)
	);

initial begin 
	Sbox_in_s= 5'h00;
	#10;	
	Sbox_in_s= 5'h05;
	#10;	
	Sbox_in_s= 5'h08;
	#10;	
	Sbox_in_s= 5'h0B;
	#10;	
	Sbox_in_s= 5'h1F;
	#10;


end

endmodule : Sbox_tb
