-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Este somador soma uma entrada do tipo std_logic_vector
-- de tamanho igual a 8 bits com o valor 1 em decimal

entity somador_de_8bits is	
	generic
	(
		PC_WIDTH 	: natural := 8		-- tamanho do somador em número de bits
	);
	port(
		entrada1	: in std_logic_vector (PC_WIDTH-1 downto 0);
		saida 		: out std_logic_vector (PC_WIDTH-1 downto 0)
	);
end entity;

architecture behav of somador_de_8bits is
begin
	saida <= std_logic_vector(unsigned(entrada1) + to_unsigned(1,PC_WIDTH));
end behav;