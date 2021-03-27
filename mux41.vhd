-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library ieee;
use ieee.std_logic_1164.all;

entity mux41 is
	generic
	(
		CTRL_WIDTH 	: natural := 2;		-- entrada de controle do mux41 em quantidade de bits
		MUX41_WIDTH : natural := 16		-- tamanho em bits das entradas e da saída de dados
	);
	port(
		controle	: in std_logic_vector(CTRL_WIDTH-1 downto 0);
		entrada0	: in std_logic_vector(MUX41_WIDTH-1 downto 0);
		entrada1	: in std_logic_vector(MUX41_WIDTH-1 downto 0);
		entrada2	: in std_logic_vector(MUX41_WIDTH-1 downto 0);
		entrada3	: in std_logic_vector(MUX41_WIDTH-1 downto 0);
		saida		: out std_logic_vector(MUX41_WIDTH-1 downto 0)
	);
end entity;

architecture rtl of mux41 is
begin
	process (controle, entrada0, entrada1, entrada2, entrada3) is
    begin
		case controle is
			when "00"=> 
			   	saida <= entrada0;
			when "01" =>
			   	saida <= entrada1;
			when "10"=> 
			   	saida <= entrada2;
			when "11" =>
			   	saida <= entrada3;
		end case;
	end process;				
end rtl;