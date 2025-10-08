// -----------------------------------------------------------------------------
// Module      : ascon_top
// Auteur      : Prusothman VIGNESWARAN
// Description : Module principal qui orchestre l’algorithme ASCON-AEAD128 complet (top-level)
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module ascon_top (
    input  logic clock_i,
    input  logic resetb_i,
    input  logic start_i,
    input  logic data_valid_i,
    input  logic [127:0] data_i,
    input  logic [127:0] key_i,
    input  logic [127:0] nonce_i,

    output logic [127:0] cipher_o,
    output logic cipher_valid_o,
    output logic [127:0] tag_o,
    output logic end_o,
    output logic end_init_s, 
    output logic end_da_s, 
    output logic end_tc_s,
    output logic end_final_s
);

    // Déclaration des signaux internes
    type_state state_s;
    logic [3:0] round_count_s;
    logic [319:0] iv_key_nonce_s;
   
    assign iv_key_nonce_s = {
    64'h00001000808C0001,     // IV
    key_i[63:0],              // K[63:0]
    key_i[127:64],            // K[127:64]
    nonce_i[63:0],            // N[63:0]
    nonce_i[127:64]           // N[127:64]
};

    // Signaux de la FSM 
    logic init_s;
    logic enable_p_s;
    logic enable_xor_b_s;
    logic [1:0] enable_xor_e_s;
    logic active_round_s;
    logic init_round_p12_s;
    logic init_round_p8_s;
    logic enable_tag_register_s;
    logic enable_cipher_register_s;
  

    // Instance du FSM
    FSM_Moore fsm (
        .start_i(start_i),
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .data_valid_i(data_valid_i),
        .round_i(round_count_s),

        .init_o(init_s),
        .enable_p_o(enable_p_s),
        .enable_xor_b_o(enable_xor_b_s),
        .enable_xor_e_o(enable_xor_e_s),
        .active_round_o(active_round_s),
        .init_round_p12_o(init_round_p12_s),
        .init_round_p8_o(init_round_p8_s),
        .enable_tag_register(enable_tag_register_s),
        .enable_cipher_register(enable_cipher_register_s),
        .cipher_valid_o(cipher_valid_o),
        .end_o(end_o),
        .end_init_o(end_init_s),
        .end_da_o(end_da_s),
        .end_tc_o(end_tc_s),
        .end_final_o(end_final_s)
    );

    // Instance du Compteur de Rondes
    Compteur_Double_Init compteur_rounds (
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .en_i(active_round_s),
        .init_a_i(init_round_p12_s),
        .init_b_i(init_round_p8_s),
        .cpt_o(round_count_s)
    );

    // Instance de la Permutation
    Permutation_XOR_Final_1 permutation_xor (
        .state_p_i(iv_key_nonce_s),
        .init_p_i(init_s),
        .clock_p_i(clock_i),
        .resetb_p_i(resetb_i),
        .round_p_i(round_count_s),
        .enable_p_i(enable_p_s),
        .enable_xor_b_i(enable_xor_b_s),
        .enable_xor_e_i(enable_xor_e_s), 
        .data_i(data_i),
        .key_i(key_i),
        .nonce_i(nonce_i),
        .enable_cipher_i(enable_cipher_register_s),
        .enable_tag_i(enable_tag_register_s),
        .state_p_o(state_s),
        .cipher_o(cipher_o),
        .tag_o(tag_o)
    );

endmodule : ascon_top

