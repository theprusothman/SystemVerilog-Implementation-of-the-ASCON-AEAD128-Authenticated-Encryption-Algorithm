// -----------------------------------------------------------------------------
// Module      : Compteur_Double_Init
// Auteur      : Prusothman VIGNESWARAN
// Description : Compteur de rondes pour les permutations ASCON (p^12 ou p^8).
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module Compteur_Double_Init import ascon_pack::*;
   (
    input logic 	clock_i,
    input logic 	resetb_i,
    input logic 	en_i,
    input logic 	init_a_i,
    input logic 	init_b_i,
    output logic [3 : 0] cpt_o      
    ) ;

// Déclaration des signaux internes
   logic [3:0] cpt_s;
   
   always_ff @(posedge clock_i or negedge resetb_i)
     begin
	if (resetb_i == 1'b0) begin
	   cpt_s <= '0;
	end
	else begin 
	   if (en_i == 1'b1) 
	     begin
		if (init_a_i==1'b1) begin
		   cpt_s<=0;
		end 
		else if (init_b_i==1'b1) begin
		   cpt_s<=4;	
		end 
		else cpt_s <= cpt_s+1;
	     end
	end
     end

   assign cpt_o = cpt_s;
   
endmodule: Compteur_Double_Init

