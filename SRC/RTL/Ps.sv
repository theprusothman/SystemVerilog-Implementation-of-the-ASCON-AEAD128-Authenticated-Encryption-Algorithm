// -----------------------------------------------------------------------------
// Module      : Ps
// Auteur      : Prusothman VIGNESWARAN
// Description : Applique la substitution S-box colonne par colonne sur l'état S 
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module Ps (
	input type_state Ps_in_i,
	output type_state Ps_out_o
);

genvar i;
	
generate
for (i=0;i<64;i++) 
	begin : sbox_gen
	Sbox Sbox_inst (
	.Sbox_in_i({Ps_in_i[0][i],Ps_in_i[1][i],Ps_in_i[2][i],Ps_in_i[3][i],Ps_in_i[4][i]}),
	.Sbox_out_o({Ps_out_o[0][i],Ps_out_o[1][i],Ps_out_o[2][i],Ps_out_o[3][i],Ps_out_o[4][i]})
	)
;

end 
endgenerate

endmodule : Ps 
