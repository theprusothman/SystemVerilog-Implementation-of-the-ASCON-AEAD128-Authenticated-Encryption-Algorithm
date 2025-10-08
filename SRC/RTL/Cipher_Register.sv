// -----------------------------------------------------------------------------
// Module      : Cipher_Register
// Auteur      : Prusothman VIGNESWARAN
// Description : Registre de sortie pour stocker les blocs chiffrés C
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module Cipher_Register (
    input logic clock_i,
    input logic resetb_i,
    input logic enable_i,
    input type_state state_i,        
    output logic [127:0] cipher_o     
);

    // Déclaration des signaux internes
    logic [127:0] cipher_s;

    always_ff @(posedge clock_i or negedge resetb_i) 
	begin
        if (resetb_i == 1'b0) begin
            cipher_s <= 128'b0;
        end 
	else begin
		if (enable_i == 1'b1) 
	     begin
		cipher_s <= {state_i[1], state_i[0]};
	     end
	   else cipher_s <= cipher_s;
	end
     end

    assign cipher_o = cipher_s;

endmodule : Cipher_Register

