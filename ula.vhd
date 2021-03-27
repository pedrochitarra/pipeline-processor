-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	generic 
	(
		DATA_WIDTH : natural := 16;			-- tamanho das entradas e da saída de dados da ULA em bits
		ADDR_WIDTH : natural := 4			-- tamanho da entrada de controle da ULA em bits
	);
	port(
		A, B		 	: in std_logic_vector (DATA_WIDTH-1 downto 0);		-- Barramentos A e B
		AluOp 		: in std_logic_vector (3 downto 0);		-- Controle da ULA
		saidaula 	: out std_logic_vector (DATA_WIDTH-1 downto 0);		-- Saída da ULA
		flag        : in std_logic_vector(3 downto 0);
		flagsaida	: out std_logic		-- flag resultado maior que zero
	);
end ula;

architecture beh of ula is 

signal saida: std_logic_vector(15 downto 0);
signal zero : std_logic_vector(15 downto 0);
signal auxflagsaida,fgre,fovw,fzero,fneg: std_logic; -- Sinais auxiliares para o flag
signal f0,f1,f2,f3: std_logic;

begin
	
	f3<=flag(3);f2<=flag(2);f1<=flag(1);f0<=flag(0);
	zero  <= X"0000";
	
	process (A, B, AluOp,flag,fgre,fovw,fneg,fzero)
    begin
		case AluOp is
			when "0000" => -- ADD
			   saida <= std_logic_vector (signed (A) + signed (B));
			when "0001" => -- SUB
				saida <= std_logic_vector (signed (A) - signed (B));
			when "0010" => -- ADDI
			   saida <= std_logic_vector (signed (A) + signed (B));
			when "0100" => -- NOR
			   saida <= A nor B;
			when "0110" => -- XOR
			   saida <= A xor B;
			when "0111" => -- AND
				saida <= A and B;
			when others => saida <= x"0000";
		end case;
	end process;
	
	process(f0,f1,f2,f3,fgre,fovw,fneg,fzero,saida,zero,A,B,flag)
	begin
		case f3 is
			when '1' =>
				if(signed(saida)>signed(zero))then
					fgre<='1';
				else
					fgre<='0';
				end if;
			when others =>
					fgre<='0';
		end case;
			
		case f2 is
			when '1' =>
				if((A(15)='1' and B(15)='1') or (A(15)='0' and B(15)='0'))then
					fovw<='1';
				else
					fovw<='0';
				end if;
			when others =>
					fovw<='0';
		end case;
					
		case f1 is
			when '1' =>
				if(fgre='1')then
					fneg<='0';
				else
					fneg<='1';
				end if;
			when others =>
					fneg<='0';
		end case;
			
		case f0 is
			when '1' =>
				if(fgre='1' or fneg='1')then
					fzero<='0';
				else
					fzero<='1';
				end if;
			when others =>
					fzero<='0';
		end case;
				
		auxflagsaida <= (flag(3) and fgre) or (flag(2) and fovw) or (flag(1) and fneg) or (flag(0) and fzero);
	
	end process;
	
	flagsaida <= auxflagsaida;
	saidaula <= saida;
	
end beh; 
