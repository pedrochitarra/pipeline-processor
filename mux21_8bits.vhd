-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletr�nica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Vers�o: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Perif�ricos

library ieee;
use ieee.std_logic_1164.all;

entity mux21_8bits  is
	generic
	(
		MUX21_DATA_WIDTH	: natural := 8		-- tamanho em bits das entradas e da sa�da de dados
	);
	port(
		controle	: in std_logic;
		entrada0	: in std_logic_vector(MUX21_DATA_WIDTH-1 downto 0);
		entrada1	: in std_logic_vector(MUX21_DATA_WIDTH-1 downto 0);
		saida		: out std_logic_vector(MUX21_DATA_WIDTH-1 downto 0)
	);
end entity;

architecture behav of mux21_8bits is
begin
	process (controle, entrada0, entrada1) is
	begin
		if (controle = '0') then
			saida <= entrada0;
		else
			saida <= entrada1;
		end if;
	end process;
end behav;