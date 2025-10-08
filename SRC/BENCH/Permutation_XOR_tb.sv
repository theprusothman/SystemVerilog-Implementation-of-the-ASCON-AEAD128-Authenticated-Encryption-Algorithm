// -----------------------------------------------------------------------------
// Fichier     : Permutation_XOR_Final_tb.sv
// Auteur      : Prusothman VIGNESWARAN
// Description : Testbench du module combiné Permutation + XOR
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

//Importation des modules
import ascon_pack::*;
module Permutation_XOR_tb 
(
);
	
// Déclaration des signaux
type_state state_p_i_s;	
logic init_s;
logic clock_s;
logic resetb_s;
logic enable_p_s;
logic enable_xor_b_s;
logic [1:0] enable_xor_e_s;
logic [3:0] round_s;
type_state state_p_o_s;
logic [127:0] data_xor_b_s;
logic [127:0] data_xor_e_s;

// Instanciation du DUT (Design Under Test)
Permutation_XOR DUT (
	.state_p_i(state_p_i_s),	
	.init_p_i(init_s),
	.clock_p_i(clock_s),
	.resetb_p_i(resetb_s),
	.round_p_i(round_s),    	
	.enable_p_i(enable_p_s),
	.enable_xor_b_i(enable_xor_b_s),
	.enable_xor_e_i(enable_xor_e_s),
	.data_xor_b_i(data_xor_b_s),
	.data_xor_e_i(data_xor_e_s),
	.state_p_o(state_p_o_s)
);


// Horloge
initial begin
	clock_s=1'b0;
forever #10 clock_s = ~clock_s;
end

initial begin

	state_p_i_s[0] = 64'h00001000808C0001;
	state_p_i_s[1] = 64'h6CB10AD9CA912F80;
	state_p_i_s[2] = 64'h691AED630E81901F;
	state_p_i_s[3] = 64'h0C4C36A20853217C;
	state_p_i_s[4] = 64'h46487B3E06D9D7A8;
	data_xor_b_s = 128'h0000626F42206F74206563696C41;
	data_xor_e_s = 128'h691AED630E81901F6CB10AD9CA912F80;

	resetb_s = 1'b0;
	init_s = 1'b1;
	enable_xor_b_s =1'b0; 
	enable_xor_e_s =2'b0;
 
	enable_p_s = 1'b1;
	round_s = 4'b0000;
	#25;
	
	resetb_s = 1'b1;
	#20;

	init_s = 1'b0;
	round_s = 4'b0001;
	#20;

	round_s = 4'b0010;
	#20;

	round_s = 4'b0011;
	#20;

	round_s = 4'b0100;
	#20;

	round_s = 4'b0101;
	#20;

	round_s = 4'b0110;
	#20;

	round_s = 4'b0111;
	#20;

	round_s = 4'b1000;
	#20;

	round_s = 4'b1001;
	#20;

	round_s = 4'b1010;
	#20;

	round_s = 4'b1011;
	enable_xor_e_s =2'b1;
	#20;
	enable_p_s = 1'b0;

end

endmodule : Permutation_XOR_tb
