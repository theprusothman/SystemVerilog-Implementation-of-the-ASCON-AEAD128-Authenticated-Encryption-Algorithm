// -----------------------------------------------------------------------------
// Fichier     : Ps_tb.sv
// Auteur      : Prusothman VIGNESWARAN
// Description : Testbench du module Ps 
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

//Importation des modules
module Ps_tb 
import ascon_pack::*;
(
);
//Déclaration des Signaux de Sortie
type_state Ps_in_s;
type_state Ps_out_s;

Ps DUT (
	.Ps_in_i(Ps_in_s),
	.Ps_out_o(Ps_out_s));

initial begin
	Ps_in_s[0] = 64'h00001000808C0001;
	Ps_in_s[1] = 64'h6CB10AD9CA912F80;
	Ps_in_s[2] = 64'h691AED630E8190EF;
	Ps_in_s[3] = 64'h0C4C36A20853217C;
	Ps_in_s[4] = 64'h46487B3E06D9D7A8;


#10;
end

endmodule : Ps_tb
