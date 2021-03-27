-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library ieee;
use ieee.std_logic_1164.all;

entity registrador_de_16bits is
	generic
	(
		DATA_WIDTH : natural := 16
	);
	port(
		entrada	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		saida	: out std_logic_vector(DATA_WIDTH-1 downto 0);
		clk		: in std_logic;
		we		: in std_logic;
		reset	: in std_logic
	);
end entity;

architecture rtl11 of registrador_de_16bits is
begin	
	process (clk, we, reset) is
	begin
		if (reset = '1') then
			saida <= (others => '0');
		elsif (rising_edge(clk)) then
			if (we = '1') then
				saida <= entrada;
			end if;
		end if;
	end process;
end rtl11;
