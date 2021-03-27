-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- unidade de controle
entity unidade_de_controle is
	generic 
	(
		INSTR_WIDTH 		: natural := 32;
		OPCODE_WIDTH		: natural := 4;
		ULA_CTRL_WIDTH 	: natural := 4
	);
	port(
		opcode		: in std_logic_vector(3 downto 0);			-- instrução 	
		opcode23		: in std_logic_vector(3 downto 0);
		w_ePC_fsm	: in std_logic; 
		w_eR_fsm		: in std_logic; 
		sel_R			: out std_logic_vector(1 downto 0);  -- Bits de selecao para o MUX ligado ao registrador de destino (01: saida da ula,
		-- 10: entrada externa, 11: saida deslocador)
		branch		: out std_logic;
		w_ePC			: out std_logic;
		w_eR 			: out std_logic;
		enderecoreg : out std_logic;
		w_eR12		: out std_logic;
		AluOp			: out std_logic_vector(3 downto 0)
	);
end unidade_de_controle;

architecture beh of unidade_de_controle is

signal inst_aux 	: std_logic_vector (31 downto 0);			-- instrucao

begin

	process (opcode, opcode23, w_ePC_fsm, w_eR_fsm)
    begin				
		case opcode is
			--ADD
			when "0000" =>
				sel_R <= "01";
				AluOp <= "0000";
				w_ePC <= '1';
				branch<='1';
				enderecoreg <='0';
				w_eR12 <='1';
			--SUB
			when "0001" =>
				sel_R <= "01";
				AluOp <= "0001";
				w_ePC <= '1';
				branch<='1';
				enderecoreg <='0';
				w_eR12 <='1';
			--ADDI
			when "0010" => -- 1 para imediato, 0 para B
				sel_R <= "01";
				branch<='1';
				w_ePC <= '1';
				enderecoreg <='0';
				AluOp <= "0010";
				w_eR12 <='1';
			--NOR
			when "0100" =>
				sel_R <= "01";
				AluOp <= "0100";
				w_ePC <= '1';
				branch<='1';
				enderecoreg <='0';
				w_eR12 <='1';
			--XOR
			when "0110" =>
				sel_R <= "01";
				AluOp <= "0110";
				w_ePC <= '1';
				branch<='1';
				enderecoreg <='0';
				w_eR12 <='1';
			--AND
			when "0111" =>
				sel_R <= "01";
				AluOp <= "0111";
				w_ePC <= '1';
				branch<='1';
				enderecoreg <='0';
				w_eR12 <='1';
			-- SHI
			when "1000" =>
				sel_R <= "10";
				w_ePC <= '1';
				branch<='0';
				enderecoreg <='0';
				AluOp <= "1000";
				w_eR12 <='1';
			-- INP
			when "1100" =>
				sel_R <= "11";
				w_ePC <= w_ePC_fsm;
				branch<='0';
				enderecoreg <='1';
				AluOp <= "1111";
				w_eR12 <=w_ePC_fsm;
			--OUT
			when "1101" =>
				sel_R <= "00";
				w_ePC <= w_ePC_fsm;
				branch<='0';
				enderecoreg <='1';
				AluOp <= "1111";
				w_eR12 <=w_ePC_fsm;
			--NOP
			when "1111" =>
				sel_R <= "00";
				w_ePC <= '1';
				branch<='0';
				enderecoreg <='0';
				AluOp <= "1111";
				w_eR12 <='1';
			when others =>	-- todas as outras instrucoes	
				sel_R <= "00";
				w_ePC <= '1';
				branch<='1';
				enderecoreg <='0';
				AluOp <="1111";
				w_eR12 <='1';
		end case;
		
		case opcode23 is
		--ADD
			when "0000" =>
				w_eR  <= '1';
			--SUB
			when "0001" =>
				w_eR  <= '1';
			--ADDI
			when "0010" => -- 1 para imediato, 0 para B
				w_eR  <= '1';
			--NOR
			when "0100" =>
				w_eR  <= '1';
			--XOR
			when "0110" =>
				w_eR  <= '1';
			--AND
			when "0111" =>
				w_eR  <= '1';
			-- SHI
			when "1000" =>
				w_eR  <= '1';
			-- INP
			when "1100" =>
				w_eR  <= w_eR_fsm;
			--OUT
			when "1101" =>
				w_eR  <= '0';
			--NOP
			when "1111" =>
				w_eR  <= '0';
			when others =>	-- todas as outras instrucoes	
				w_eR  <= '0';
		end case;
		
	end process;
		
end beh;
