// -----------------------------------------------------------------------------
// Module      : Xor_End
// Auteur      : Prusothman VIGNESWARAN
// Description : Réalise le XOR sur les états S2, S3, S4
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module Xor_End (

	input logic [127:0] data_i, 
	input logic [1:0] enable_xe_i,
	input type_state state_i, 
	output type_state output_mux_o);

// Déclaration des signaux internes
        type_state data_2_i;
        type_state mux_in1_i;	

always_comb begin
case (enable_xe_i) 

	2'b00 : begin
		data_2_i[0] = 64'h0000000000000000; 
		data_2_i[1] = 64'h0000000000000000; 
		data_2_i[2] = 64'h0000000000000000; 
		data_2_i[3] = 64'h0000000000000000; 
		data_2_i[4] = 64'h0000000000000000; 
	end

	2'b01 : begin 
		data_2_i[0] = 64'h0000000000000000; 
		data_2_i[1] = 64'h0000000000000000; 
		data_2_i[2] = 64'h0000000000000000; 
		data_2_i[3] = data_i[63:0]; 
		data_2_i[4] = data_i[127:64]; 	
	end

	2'b10 : begin 
		data_2_i[0] = 64'h0000000000000000; 
		data_2_i[1] = 64'h0000000000000000; 
		data_2_i[2] = 64'h0000000000000000; 
		data_2_i[3] = 64'h0000000000000000; 
		data_2_i[4] = 64'h8000000000000000; 	
	end

	2'b11 : begin 
		data_2_i[0] = 64'h0000000000000000; 
		data_2_i[1] = 64'h0000000000000000; 
		data_2_i[2] = data_i[63:0]; 
		data_2_i[3] = data_i[127:64]; 
		data_2_i[4] = 64'h0000000000000000; 
	end
	
	default : begin
		data_2_i[0] = 64'h0000000000000000; 
		data_2_i[1] = 64'h0000000000000000; 
		data_2_i[2] = 64'h0000000000000000; 
		data_2_i[3] = 64'h0000000000000000; 
		data_2_i[4] = 64'h0000000000000000;
	end 

endcase
assign mux_in1_i = (state_i)^(data_2_i);
assign output_mux_o = (enable_xe_i == 2'b00) ? state_i : mux_in1_i  ;

end 

endmodule : Xor_End
