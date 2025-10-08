// -----------------------------------------------------------------------------
// Module      : Permutation_XOR
// Auteur      : Prusothman VIGNESWARAN
// Description : Module combiné : applique Xor_Begin, permutation (Pc → Ps → Pl), puis Xor_End
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module Permutation_XOR  (
	
	input type_state state_p_i,	
	input logic init_p_i,
	input logic clock_p_i,
	input logic resetb_p_i,
	input logic [3:0] round_p_i,    	
	input logic enable_p_i,
	input logic enable_xor_b_i,
	input logic [1:0] enable_xor_e_i,
	input logic [127:0] data_xor_b_i,
	input logic [127:0] data_xor_e_i,
	output type_state state_p_o
);


//Déclaration des Variables

//type_state mux_in0_s, mux_in1_s;
type_state output_mux_s;
type_state output_pc_s;
type_state output_ps_s;
type_state output_pl_s;
type_state output_register_s;
type_state output_Xor_Begin_s;
type_state output_Xor_End_s;

//State Multiplexer Instance
State_Mux State_Mux1 (
	.init_i(init_p_i),
	.mux_in0_i(output_register_s),
        .mux_in1_i(state_p_i),
        .output_mux_o(output_mux_s));

//Xor Begin Instance
Xor_Begin Xor_Begin1 (
	.data_i(data_xor_b_i),
	.enable_xb_i(enable_xor_b_i),
	.state_i(output_mux_s),
	.output_mux_o(output_Xor_Begin_s));

//Pc Instance
Pc Pc1 (
	.Pc_in_i(output_Xor_Begin_s),
	.round_i(round_p_i),
	.Pc_out_o(output_pc_s));

//Ps Instance
Ps Ps1 (
	.Ps_in_i(output_pc_s),
	.Ps_out_o(output_ps_s));

//Pl Instance
Pl Pl1 (
	.Pl_in_i(output_ps_s),
	.Pl_out_o(output_pl_s));

//Xor End Instance
Xor_End Xor_End1 (
	.data_i(data_xor_e_i),
	.enable_xe_i(enable_xor_e_i),
	.state_i(output_pl_s), 
	.output_mux_o(output_Xor_End_s));

//State Register Instance
State_Register State_Register1 (
	.clock_i(clock_p_i),
	.resetb_i(resetb_p_i),
	.enable_i(enable_p_i),
	.D(output_Xor_End_s), 
	.Q(output_register_s)); 

assign state_p_o = output_register_s;


endmodule : Permutation_XOR
