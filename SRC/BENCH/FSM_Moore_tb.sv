// -----------------------------------------------------------------------------
// Fichier     : FSM_Moore_tb.sv
// Auteur      : Prusothman VIGNESWARAN
// Description : Testbench de la machine d'état (FSM) contrôlant les différentes phases de l'algorithme ASCON.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module FSM_Moore_tb();

  logic clock_i;
  logic resetb_i;
  logic start_i;
  logic data_valid_i;
  logic [3:0] round_i;

  logic init_o;
  logic enable_p_o;
  logic enable_xor_b_o;
  logic [1:0] enable_xor_e_o;
  logic active_round_o;
  logic init_round_p12_o;
  logic init_round_p8_o;
  logic enable_tag_register;
  logic enable_cipher_register;
  logic cipher_valid_o;
  logic end_o;
  logic end_init_o;
  logic end_da_o;
  logic end_tc_o;
  logic end_final_o;

  // Instance du module FSM_Moore
  FSM_Moore dut (
    .start_i(start_i),
    .clock_i(clock_i),
    .resetb_i(resetb_i),
    .data_valid_i(data_valid_i),
    .round_i(round_i),
    .init_o(init_o),
    .enable_p_o(enable_p_o),
    .enable_xor_b_o(enable_xor_b_o),
    .enable_xor_e_o(enable_xor_e_o),
    .active_round_o(active_round_o),
    .init_round_p12_o(init_round_p12_o),
    .init_round_p8_o(init_round_p8_o),
    .enable_tag_register(enable_tag_register),
    .enable_cipher_register(enable_cipher_register),
    .cipher_valid_o(cipher_valid_o),
    .end_o(end_o),
    .end_init_o(end_init_o),
    .end_da_o(end_da_o),
    .end_tc_o(end_tc_o),
    .end_final_o(end_final_o)
  );

  // Horloge
  always #5 clock_i = ~clock_i;


  initial begin

    clock_i = 0;
    resetb_i = 0;
    start_i = 0;
    data_valid_i = 0;
    round_i = 0;

    // Reset
    #10 resetb_i = 1;

    // Initialisation
    #10 start_i = 1;
    #10 start_i = 0;

    // Phase INIT avec 12 rounds 
    repeat (11) begin
      #10;
      round_i++;
    end
    #10 round_i = 0;

    // Phase Données associées (DA)
    #10 data_valid_i = 1;
    #10 data_valid_i = 0;

    repeat (11) begin
      #10;
      round_i++;
    end
    #10 round_i = 0;

    // Phase Texte Clair 1 (TC1)
    #10 data_valid_i = 1;
    #10 data_valid_i = 0;

    repeat (11) begin
      #10;
      round_i++;
    end
    #10 round_i = 0;

    // Phase Texte Clair 2 (TC2)
    #10 data_valid_i = 1;
    #10 data_valid_i = 0;

    repeat (11) begin
      #10;
      round_i++;
    end
    #10 round_i = 0;

    // Phase Finalisation 
    #10 data_valid_i = 1;
    #10 data_valid_i = 0;

    repeat (11) begin
      #10;
      round_i++;
    end

    #20;
  
  end

endmodule

