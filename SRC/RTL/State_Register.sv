// -----------------------------------------------------------------------------
// Module      : State_Register
// Auteur      : Prusothman VIGNESWARAN
// Description : Registre principal contenant l’état S
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module State_Register 
(
 	input logic clock_i,
 	input logic resetb_i,
 	input logic enable_i,
 	input type_state D,
	output type_state Q      
 ) ;

	// Déclaration des signaux internes
	type_state data_s;
   
   always_ff @(posedge clock_i or negedge resetb_i)
     begin
	if (resetb_i == 1'b0) begin
	   data_s <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
	end
	else begin 
	   if (enable_i == 1'b1) 
	     begin
		data_s <= D;
	     end
	   else data_s <= data_s;
	end
     end

   assign Q = data_s;
   
endmodule: State_Register
