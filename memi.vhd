-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memi is
	generic 
	(
		INSTR_WIDTH : natural := 32;	-- tamanho da instrução em número de bits
		MI_ADDR_WIDTH : natural := 8	-- tamanho do endereço da memória de instruções em número de bits
	);
	port(
		Endereco	: in std_logic_vector(MI_ADDR_WIDTH-1 downto 0);
		Instrucao	: out std_logic_vector(INSTR_WIDTH-1 downto 0)
	);
end entity;

architecture rtl of memi is
type rom_type is array (0 to 2**MI_ADDR_WIDTH-1) of std_logic_vector(INSTR_WIDTH-1 downto 0);
constant rom: rom_type := (
		0 => X"c1000000", -- INP $R1 /1000
		1 => X"d1000000", -- OUT $R1 /1000
		2 => X"c2000000", -- INP $R2 /111
		3 => X"d2000000", -- OUT $R2 / 111
		4 => X"23100000", -- ADDI $R3, $R1, 0, 0, 0
		5 => X"d3000000", -- OUT $R3    /1000
		6 => X"04100000", -- ADD $R4, $R1, $R0, 0, 0, 0 
		7 => X"14420000", -- SUB $R4, $R4, $R2, 0, 0, 0 
		8 => X"d4000000", -- OUT $R4 /1
		9 => X"85422000", -- SHI $R5, $R4, 2, 2 
		10 => X"d5000000", -- OUT $R5 /1000
		11 => X"1132800e", -- SUB $R1, $R3, $R2, 8, 0, else (R3>R2)
		12 => X"d3000000", -- OUT $R3 
		13 => X"2500F010", -- ADDI $R5, $0, $0, 15, 0, endif 
		14 => X"d2000000", -- else: OUT $2 /111
		15 => X"75540000", -- AND $R5, $R5, $R4, 0, 0, 0 
		16 => X"d5000000", -- OUT $R5 /1
		17 => X"65340000", -- XOR $R5, $R3 $R4, 0, 0, 0
		18 => X"d5000000", -- OUT $R5 / 1001
		19 => X"f0000000", --  NOP
		others => X"f0000000" -- Para todo o resto nao executa nada (NOP)
);
begin
    Instrucao <= rom(to_integer(unsigned(Endereco)));
end rtl;