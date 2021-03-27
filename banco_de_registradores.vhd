-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_de_registradores is
	generic 
	(
		DATA_WIDTH 			: natural := 16;	-- tamanho de cada registrador do banco de registradores em bits
		QTY_REGISTERS		: natural := 16;	-- quantidade de registradores dentro do banco de registradores
		FR_ADDR_WIDTH		: natural := 4		-- tamanho da linha de endereços do banco de registradores em bits
	);
	port(
		clk 		: in std_logic;										-- Relógio
		read_regrs	: in std_logic_vector(FR_ADDR_WIDTH-1 downto 0); 	-- Índice do registrador rs
		read_regrt	: in std_logic_vector(FR_ADDR_WIDTH-1 downto 0); 	-- Índice do registrador rt
		write_regrd	: in std_logic_vector(FR_ADDR_WIDTH-1 downto 0); 	-- Índice no registrador rd
		data_in		: in std_logic_vector(DATA_WIDTH-1 downto 0);		-- entrada de dados para escrita
		data_outrs	: out std_logic_vector(DATA_WIDTH-1 downto 0);		-- saída de dados do registrador rs
		data_outrt	: out std_logic_vector(DATA_WIDTH-1 downto 0);		-- saída de dados do registrador rt
		reg_write	: in std_logic										-- sinal de controle de escrita
	);
end banco_de_registradores;

architecture beh of banco_de_registradores is

subtype	regType   is std_logic_vector(DATA_WIDTH-1 downto 0) ;			-- registrador de 32 bits
type 	regsType  is array (QTY_REGISTERS-1 downto 0) of regType ;		-- vetor/banco de registradores com 32 elementos
signal  registradores : regsType;

begin
	escrever_rd:											-- processo de escrita no regitrador
	process (clk, reg_write) 
	begin
		if (reg_write = '1') then
			if (rising_edge(clk)) then
				registradores(to_integer(unsigned(write_regrd))) <= data_in;  -- escrever dado em banco_de_registradores(rd)
			end if;
		end if;
	end process;

	data_outrs <= X"0000" when (read_regrs = "0000")  -- ler conteúdo de banco_de_registradores(rs)
		else registradores(to_integer(unsigned(read_regrs)));
	data_outrt <= X"0000" when (read_regrt = "0000")  -- ler conteúdo de banco_de_registradores(rt)
		else registradores(to_integer(unsigned(read_regrt)));
end beh;
