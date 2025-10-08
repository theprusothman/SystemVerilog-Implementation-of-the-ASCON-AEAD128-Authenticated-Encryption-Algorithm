//FSM Moore to drive ASCON cryptographic algorithm
import ascon_pack::*;

module FSM_Moore (
	input logic start_i,	
	input logic clock_i,
	input logic resetb_i,
	input logic data_valid_i,
	input logic [3:0] round_i,
	//input logic [1:0] bloc_i,

	output logic init_o, //State Mux
	output logic enable_p_o,
	output logic enable_xor_b_o,	
	output logic [1:0] enable_xor_e_o,

	output logic active_round_o, //Signal activant le compteur round
	//output logic reset_compteur_o,	
	output logic init_round_p12_o,
	output logic init_round_p8_o,

	output logic enable_tag_register,
	output logic enable_cipher_register,
	output logic cipher_valid_o,

	output logic end_o,
	output logic end_init_o,
	output logic end_da_o,
	output logic end_tc_o,
	output logic end_final_o
	

);

// TBC : States definition
typedef enum {
	//Initialisation
	idle, conf_init, end_conf_init, init, end_init, 
	//Données Associés
	idle_da, conf_da, end_conf_da, da, end_da,
	//Texte Clair
	idle_tc, conf_tc1, end_conf_tc1, tc1, end_tc1, idle_tc2, conf_tc2, end_conf_tc2, tc2, end_tc,
	//Finalisation
	idle_fin, conf_fin, end_conf_fin, fin, end_fin

} state_t; 

state_t Ep, Ef;
// Ep : Etat present, Ef : Etat futur

//reset actif à l'état bas
// TODO : sequential process
always_ff @(posedge clock_i or negedge resetb_i) begin : seq0 ;
	if (resetb_i == 1'b0)
		Ep <= idle;
	else
		Ep <= Ef; 
end : seq0; 

//TODO : Comb0 process
always_comb begin : comb0
case (Ep)
	idle : 
		if (start_i == 1'b1)
			Ef = conf_init;
		else
			Ef = idle;
	
	conf_init :
		Ef = end_conf_init;

	end_conf_init : 
		Ef = init;
	
	init : 
		if (round_i == 4'ha) //Round 10
			Ef = end_init;
		else 
			Ef = init;
	
	end_init : 
		Ef = idle_da;	
	
	idle_da :
		if (data_valid_i == 1'b1)
			Ef = conf_da;
		else
			Ef = idle_da;

	conf_da :
		Ef = end_conf_da;
		
	end_conf_da : 	
		Ef = da;	
	
	da : 
		if (round_i == 4'ha) //Round 10
			Ef = end_da;
		else 
			Ef = da;
	
	end_da : 
		Ef = idle_tc;

	idle_tc : 
		if (data_valid_i == 1'b1)
			Ef = conf_tc1;
		else
			Ef = idle_tc;

	conf_tc1 : 
		Ef = end_conf_tc1;

	end_conf_tc1 : 
		Ef = tc1;

	tc1 : 
		if (round_i == 4'ha)
			Ef = end_tc1;
		else 
			Ef = tc1;
	
	end_tc1 : 
		Ef = idle_tc2;	

	idle_tc2 : 
		if (data_valid_i == 1'b1)
			Ef = conf_tc2;
		else
			Ef = idle_tc2;
	
	conf_tc2 : 
		Ef = end_conf_tc2;

	end_conf_tc2 : 
		Ef = tc2;

	tc2 : 
		if (round_i == 4'ha) //Round 10
			Ef = end_tc;
		else 
			Ef = tc2;

	end_tc : 
		Ef = idle_fin;

	idle_fin : 
		if (data_valid_i == 1'b1)
			Ef = conf_fin;
		else
			Ef = idle_fin;

	conf_fin : 
		Ef = end_conf_fin;

	end_conf_fin : 
		Ef = fin;

	fin : 
		if (round_i == 4'ha) //Round 10
			Ef = end_fin;
		else 
			Ef = fin;
	
	end_fin : 
		Ef = idle;


default : Ef = idle; 

endcase
end : comb0

//TODO : Comb1
always_comb begin : comb1
case (Ep)
	
	idle : begin
		init_o = 1'b0; 
		enable_p_o = 1'b0;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b0; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;

	end 


	conf_init : begin 
		init_o = 1'b1; 
		enable_p_o = 1'b0;  
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00;
		active_round_o = 1'b0; 
		init_round_p12_o = 1'b1;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	end_conf_init : begin 
		init_o = 1'b1; 
		enable_p_o = 1'b1;  
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00;
		active_round_o = 1'b1; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end
	
	init : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	end_init : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b01; 
		active_round_o = 1'b0; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	idle_da : begin 
		init_o = 1'b0;
		enable_p_o = 1'b0;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b0; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b1;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	conf_da : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b0;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b1;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0; 
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	end_conf_da : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b1;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1;	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	da : begin 
		init_o = 1'b0;
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00;
		active_round_o = 1'b1; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	end_da : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b10; 
		active_round_o = 1'b0;
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	idle_tc : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b0;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b0;	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b1;
		end_tc_o = 1'b0; 
		end_final_o = 1'b0;
	end

	conf_tc1 : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b0; 
		enable_xor_b_o = 1'b0; 
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1;	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b1;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0; 
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end	

	end_conf_tc1 : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b1;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1;	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b1;
		cipher_valid_o = 1'b1;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0; 
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	tc1 : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	end_tc1 : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b0; 
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end


	idle_tc2 : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b0;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b0;
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0; 
		end_tc_o = 1'b1;
		end_final_o = 1'b0;
	end

	conf_tc2 : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b0; 
		enable_xor_b_o = 1'b0; 
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1;	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b1;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0; 
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end	

	end_conf_tc2 : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b1;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1;
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b1;
		cipher_valid_o = 1'b1;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0; 
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	tc2 : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

	end_tc : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b11; 
		active_round_o = 1'b0; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end	

	idle_fin : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b0;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b0; 	
		init_round_p12_o = 1'b0; 
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b1;   
		end_final_o = 1'b0;
	end

	conf_fin : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b0;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1; 	
		init_round_p12_o = 1'b1;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0; 
		end_final_o = 1'b0;
	end

	end_conf_fin : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b1;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1;	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b1;
		cipher_valid_o = 1'b1;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0; 
		end_final_o = 1'b0;
	end

	fin : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b1; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end	

	end_fin : begin 
		init_o = 1'b0; 
		enable_p_o = 1'b1;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b01; 
		active_round_o = 1'b0;	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b1; 
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b1;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b1;
	end

	default : begin
		init_o = 1'b0; 
		enable_p_o = 1'b0;
		enable_xor_b_o = 1'b0;	
		enable_xor_e_o = 2'b00; 
		active_round_o = 1'b0; 	
		init_round_p12_o = 1'b0;
		init_round_p8_o = 1'b0;
		enable_tag_register = 1'b0;
		enable_cipher_register = 1'b0;
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		end_init_o = 1'b0;
		end_da_o = 1'b0;
		end_tc_o = 1'b0;
		end_final_o = 1'b0;
	end

endcase
end : comb1

endmodule : FSM_Moore


