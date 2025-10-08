// -----------------------------------------------------------------------------
// Module      : Tag_Register
// Auteur      : Prusothman VIGNESWARAN
// Description : Registre de sortie pour stocker le tag T
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module Tag_Register (
    input logic clock_i,
    input logic resetb_i,
    input logic enable_i,
    input type_state state_i,        
    output logic [127:0] tag_o        
);
    
    // Déclaration des signaux internes
    logic [127:0] tag_s;

    always_ff @(posedge clock_i or negedge resetb_i) 
	begin
        if (resetb_i==1'b0) begin
            tag_s <= 128'b0;
        end
	else begin
		if (enable_i == 1'b1) 
	     begin
		tag_s <= {state_i[4], state_i[3]};
	     end
	   else tag_s <= tag_s;
	end
     end
	
    assign tag_o = tag_s;

endmodule : Tag_Register

