// -----------------------------------------------------------------------------
// Module      : Permutation_XOR_Final
// Auteur      : Prusothman VIGNESWARAN
// Description : Module combiné effectuant successivement :
//               - un xor_begin (si activé),
//               - la permutation complète (Ps → Ps → Pl),
//               - un xor_end (si activé),
//               - l’enregistrement des valeurs de sortie dans les registres cipher ou tag selon la phase.
// -----------------------------------------------------------------------------

// Importation du package
import ascon_pack::*;

module Permutation_XOR_Final_1 (
    input type_state state_p_i,
    input logic init_p_i,
    input logic clock_p_i,
    input logic resetb_p_i,
    input logic [3:0] round_p_i,    	
    input logic enable_p_i,
    input logic enable_xor_b_i,
    input logic [1:0] enable_xor_e_i,
    input logic [127:0] data_i, 
    input logic [127:0] key_i, 
    input logic [127:0] nonce_i, 
    input logic enable_cipher_i,
    input logic enable_tag_i,
    output type_state state_p_o,
    output logic [127:0] cipher_o,
    output logic [127:0] tag_o
);

    // Déclaration des signaux internes
    type_state output_mux_s;
    type_state output_pc_s;
    type_state output_ps_s;
    type_state output_pl_s;
    type_state output_register_s;
    type_state output_Xor_Begin_s;
    type_state output_Xor_End_s;

    // Instance du multiplexeur d'état
    State_Mux State_Mux1 (
        .init_i(init_p_i),
        .mux_in0_i(output_register_s),
        .mux_in1_i(state_p_i),
        .output_mux_o(output_mux_s)
    );

    // Instance du Xor_Begin
    Xor_Begin Xor_Begin1 (
        .data_i(data_i),
        .enable_xb_i(enable_xor_b_i),
        .state_i(output_mux_s),
        .output_mux_o(output_Xor_Begin_s)
    );

    // Instance du Cipher_Register pour récupérer cipher_o
    Cipher_Register Cipher_Register1 (
        .clock_i(clock_p_i),
        .resetb_i(resetb_p_i),
        .enable_i(enable_cipher_i),
        .state_i(output_Xor_Begin_s),
        .cipher_o(cipher_o)
    );

    // Addition de constante (Pc)
    Pc Pc1 (
        .Pc_in_i(output_Xor_Begin_s),
        .round_i(round_p_i),
        .Pc_out_o(output_pc_s)
    );

    // Substitution layer (Ps)
    Ps Ps1 (
        .Ps_in_i(output_pc_s),
        .Ps_out_o(output_ps_s)
    );

    // Diffusion layer (Pl)
    Pl Pl1 (
        .Pl_in_i(output_ps_s),
        .Pl_out_o(output_pl_s)
    );

    // Instance du Xor_End
    Xor_End Xor_End1 (
        .data_i(key_i),
        .enable_xe_i(enable_xor_e_i),
        .state_i(output_pl_s),
        .output_mux_o(output_Xor_End_s)
    );

    // Instance du Tag_Register pour récupérer tag_o
    
    Tag_Register Tag_Register1 (
        .clock_i(clock_p_i),
        .resetb_i(resetb_p_i),
        .enable_i(enable_tag_i),
        .state_i(output_Xor_End_s),  
        .tag_o(tag_o)
    );

    // Registre de l'état global
    State_Register State_Register1 (
        .clock_i(clock_p_i),
        .resetb_i(resetb_p_i),
        .enable_i(enable_p_i),
        .D(output_Xor_End_s), 
        .Q(output_register_s)
    );

    assign state_p_o = output_register_s;

endmodule : Permutation_XOR_Final_1

