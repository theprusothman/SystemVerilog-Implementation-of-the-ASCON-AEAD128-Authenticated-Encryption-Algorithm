// -----------------------------------------------------------------------------
// Module      : Permutation
// Auteur      : Prusothman VIGNESWARAN
// Description : Exécute pC, pS, pL sans XOR 
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module Permutation  (
	input type_state state_p_i,	
	input logic init_p_i,
	input logic clock_p_i,
	input logic resetb_p_i,
    	input logic enable_p_i,
	input logic [3:0] round_p_i,
	output type_state state_p_o);


//Déclaration des Variables Internes
type_state output_mux_s;
type_state output_pc_s;
type_state output_ps_s;
type_state output_pl_s;
type_state output_register_s;

//State Multiplexer Instance
State_Mux U0 (
	.init_i(init_p_i),
	.mux_in0_i(output_register_s),
        .mux_in1_i(state_p_i),
        .output_mux_o(output_mux_s));

//Pc Instance
Pc U1 (
	.Pc_in_i(output_mux_s),
	.round_i(round_p_i),
	.Pc_out_o(output_pc_s));

//Ps Instance
Ps U2 (
	.Ps_in_i(output_pc_s),
	.Ps_out_o(output_ps_s));

//Pl Instance
Pl U3 (
	.Pl_in_i(output_ps_s),
	.Pl_out_o(output_pl_s));

//State Register Instance
State_Register U4 (
	.clock_i(clock_p_i),
	.resetb_i(resetb_p_i),
	.enable_i(enable_p_i),
	.D(output_pl_s), 
	.Q(output_register_s)); 

assign state_p_o = output_register_s;


endmodule 
