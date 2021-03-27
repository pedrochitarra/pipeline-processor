-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity deslocador is
    generic
    (
      DATA_SIZE	: natural := 16; 	-- tamanho do dado a ser deslocado em bits
		SHTY_SIZE	: natural := 4;		-- tamanho do campo shty em bits
		SHMT_SIZE	: natural := 4 		-- tamanho do campo shmt em bits
    );
    port(
        Entrada_Dados		:in std_logic_vector(DATA_SIZE-1 downto 0);
        Entrada_Shty 	 	:in std_logic_vector(SHTY_SIZE-1 downto 0);
		  Entrada_Shmt 	 	:in std_logic_vector(SHMT_SIZE-1 downto 0);
        Saida	 				:out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end deslocador;

architecture comportamento of deslocador is			
signal SaidaAux: std_logic_vector(DATA_SIZE-1 downto 0);
begin
	desloc: process(Entrada_Dados, Entrada_Shty , Entrada_Shmt)
	begin
		case Entrada_Shty is
		when "1000" => SaidaAux <= std_logic_vector(SHIFT_RIGHT(signed(Entrada_Dados),to_integer(unsigned(Entrada_Shmt)+to_unsigned(1,SHMT_SIZE))));
		when "0100" => SaidaAux <= std_logic_vector(SHIFT_RIGHT(unsigned(Entrada_Dados),to_integer(unsigned(Entrada_Shmt)+to_unsigned(1,SHMT_SIZE))));
		when "0010" => SaidaAux <= std_logic_vector(SHIFT_LEFT(unsigned(Entrada_Dados),to_integer(unsigned(Entrada_Shmt)+to_unsigned(1,SHMT_SIZE))));
		when "0001" => SaidaAux <= std_logic_vector(ROTATE_RIGHT(unsigned(Entrada_Dados),to_integer(unsigned(Entrada_Shmt)+to_unsigned(1,SHMT_SIZE))));
		when others => SaidaAux <= x"0000";
		end case;	
	end process desloc;		
	Saida <= SaidaAux;
end comportamento;
