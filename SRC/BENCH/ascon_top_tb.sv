// -----------------------------------------------------------------------------
// Fichier     : ascon_top_tb.sv
// Auteur      : Prusothman VIGNESWARAN
// Description : Testbench principal pour valider l'intégration complète du module ASCON_TOP.
// -----------------------------------------------------------------------------

`timescale 1 ns / 1 ps
//Importation des modules

module ascon_top_tb;

  import ascon_pack::*;

  //Déclaration des Signaux
  logic clock_s;
  logic resetb_s;
  logic start_s;
  logic [127:0] key_s;
  logic [127:0] nonce_s;
  logic [127:0] data_s;
  logic data_valid_s;
  logic cipher_valid_s;
  logic [127:0] cipher_s;
  logic [127:0] tag_s;

  logic end_s;
  logic end_init_s;
  logic end_da_s;
  logic end_tc_s;
  logic end_final_s;

  // Instanciation du module ascon_top
  ascon_top DUT (
      .clock_i(clock_s),
      .resetb_i(resetb_s),
      .start_i(start_s),
      .key_i(key_s),
      .nonce_i(nonce_s),
      .data_i(data_s),
      .data_valid_i(data_valid_s),
      .cipher_o(cipher_s),
      .cipher_valid_o(cipher_valid_s),
      .tag_o(tag_s),
      .end_o(end_s),
      .end_init_s(end_init_s),
      .end_da_s(end_da_s),
      .end_tc_s(end_tc_s),
      .end_final_s(end_final_s)
  );

  // Horloge
  initial begin
    clock_s = 0;
    forever #10 clock_s = ~clock_s;
  end

  initial begin
    resetb_s = 0;
    key_s = 128'h691AED630E81901F6CB10AD9CA912F80;
    nonce_s = 128'h46487B3E06D9D7A80C4C36A20853217C;
    data_s = 128'h0;
    start_s = 0;
    data_valid_s = 0;
    
    #40;
    $display("==> Reset du circuit");
    resetb_s = 1;
    #100;

    $display("==> Début du chiffrement");
    start_s = 1;
    #20;
    start_s = 0;

    // Attente fin initialisation
    wait (end_init_s == 1'b1);
    $display("==> Fin de la phase d'initialisation");

    // Données associées
    data_s = 128'h00000001626F42206F74206563696C41;
    data_valid_s = 1;
    #20;
    data_valid_s = 0;

    wait (end_da_s == 1'b1);
    $display("==> Fin de la phase de données associées");

    // Bloc 1
    data_s = 128'h704F2065726964207475657620657551;
    data_valid_s = 1;
    #20;
    data_valid_s = 0;

    wait (end_tc_s == 1'b1);
    $display("==> Fin de la phase de traitement bloc 1");
	#50;
    // Bloc 2
    data_s = 128'h766E49206561727574614E2061747265;
    data_valid_s = 1;
    #20;
    data_valid_s = 0;

    wait (end_tc_s == 1'b1);
    $display("==> Fin de la phase de traitement bloc 2");
	
    // Bloc 3
    data_s = 128'h013F206172656E754D20746E75696E65;
    data_valid_s = 1;
    #20;
    data_valid_s = 0;

    wait (end_final_s == 1'b1);
    $display("==> Fin du chiffrement");

    $display("==> Cipher  = %h", cipher_s);
    $display("==> Tag     = %h", tag_s);
    #40;
    $stop();
  end

endmodule : ascon_top_tb

