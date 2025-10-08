// -----------------------------------------------------------------------------
// Fichier     : Pl_tb.sv
// Auteur      : Prusothman VIGNESWARAN
// Description : Testbench du module Pl 
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

//Importation des modules
module Pl_tb 
import ascon_pack::*;
(
);
//Déclaration des Signaux de Sortie
type_state Pl_in_s;
type_state Pl_out_s;

Pl DUT (
	.Pl_in_i(Pl_in_s),
	.Pl_out_o(Pl_out_s));

initial begin
	Pl_in_s[0] = 64'h25f7c341c45f9912;
	Pl_in_s[1] = 64'h23b794c540876856;
	Pl_in_s[2] = 64'hb85451593d679610;
	Pl_in_s[3] = 64'h4fafba264a9e49ba;
	Pl_in_s[4] = 64'h62b54d5d460aded4;


#10;
end

endmodule : Pl_tb
