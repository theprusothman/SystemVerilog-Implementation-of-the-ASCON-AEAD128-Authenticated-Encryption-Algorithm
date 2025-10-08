// -----------------------------------------------------------------------------
// Module      : State_Mux
// Auteur      : Prusothman VIGNESWARAN
// Description : Sélecteur de source pour l’état interne S (choisit entre l'état d'initialisation et la sortie du Registre d'état State_Register)
// -----------------------------------------------------------------------------

//Importation des modules
import ascon_pack::*;

module State_Mux (
    input logic init_i,
    input type_state mux_in0_i,
    input type_state mux_in1_i,
    output type_state output_mux_o);

   assign output_mux_o = (init_i == 1'b1) ? mux_in1_i : mux_in0_i ;

endmodule : State_Mux
   
