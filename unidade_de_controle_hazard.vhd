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
entity unidade_de_controle_hazard is
	generic 
	(
		INSTR_WIDTH 		: natural := 32;
		OPCODE_WIDTH		: natural := 4;
		ULA_CTRL_WIDTH 	: natural := 4
	);
	
	port(
		addrop1_r12	: in std_logic_vector(3 downto 0);
		addrop2_r12 : in std_logic_vector(3 downto 0);
		addrdes_r23	: in std_logic_vector(3 downto 0);
		opcode23	 	: in std_logic_vector(3 downto 0);
		opcode		: in std_logic_vector(3 downto 0);
		branch		: in std_logic;
		clear			: out std_logic;
		sel_ula1 	: out std_logic;
		sel_ula2		: out std_logic_vector(1 downto 0)
	);
end unidade_de_controle_hazard;

architecture beh of unidade_de_controle_hazard is

begin

	process (opcode,opcode23, branch,addrop1_r12,addrop2_r12,addrdes_r23)
		begin
			case opcode is
				when "0010" => --ADDI
					case opcode23 is
						when "1100" => -- INPUT
							sel_ula1 <= '0';
							sel_ula2 <= "01";
							
						when "1101" => -- OUTPUT
							sel_ula1 <= '0';
							sel_ula2 <= "01";
							
						when others =>
							if(addrop1_r12=addrdes_r23) then
								sel_ula1 <= '1';
								sel_ula2 <= "01";
							else
								sel_ula1 <= '0';
								sel_ula2 <= "01";
							end if;
					end case;
				when others =>
					case opcode23 is
						when "1100" => -- INPUT
							sel_ula1 <= '0';
							sel_ula2 <= "00";
							
						when "1101" => -- OUTPUT
							sel_ula1 <= '0';
							sel_ula2 <= "00";
							
						when others =>
							if (addrop1_r12=addrdes_r23 and addrop2_r12=addrdes_r23) then
								sel_ula1 <= '1';
								sel_ula2 <= "10";
							elsif(addrop1_r12=addrdes_r23) then
								sel_ula1 <= '1';
								sel_ula2 <= "00";
							elsif (addrop2_r12=addrdes_r23) then
								sel_ula1 <= '0';
								sel_ula2 <= "10";
							else
								sel_ula1 <= '0';
								sel_ula2 <= "00";
							end if;
						end case;
				end case;			
			clear <= branch;
			
	end process;
		
end beh;
