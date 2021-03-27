-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Versão: v1-2016 
-- Disciplina: ELT005 - Sistemas, Processadores e Periféricos

library IEEE;
use IEEE.std_logic_1164.all;

entity processador_pipeline is
	generic
	(
		DATA_WIDTH				: natural := 16;  	-- tamanho do barramento de dados em bits
		PROC_INSTR_WIDTH		: natural := 32;	-- tamanho da instrução do processador em bits
		PROC_ADDR_WIDTH		: natural := 8		-- tamanho do endereço da memória de programa do processador em bits
	);
	
	port(
		entrada			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		clock 			: in std_logic;
		enter				: in std_logic;
		reset				: in std_logic;
		saida				: out std_logic_vector(DATA_WIDTH-1 downto 0);
		opcode			: out std_logic_vector(3 downto 0);
		opcode23			: out std_logic_vector(3 downto 0);
		state				: out std_logic_vector(2 downto 0);
		displaysaida0	: out std_logic_vector(0 to 6);
		displaysaida1	: out std_logic_vector(0 to 6);
		displaysaida2	: out std_logic_vector(0 to 6);
		displaysaida3	: out std_logic_vector(0 to 6);
		displayopcode	: out std_logic_vector(0 to 6);
		displayopcode23: out std_logic_vector(0 to 6)
	);
end processador_pipeline;

architecture comportamento of processador_pipeline is
-- declare todos os componentes que serão necessários no seu processador_ciclo_unico a partir deste comentário

component via_de_dados_pipeline is
	generic
	(
		-- declare todos os tamanhos dos barramentos (sinais) das portas da sua via_dados_ciclo_unico aqui.
		DATA_WIDTH			: natural := 16;	-- tamanho do dado em bits
		PC_WIDTH				: natural := 8;		-- tamanho da entrada de endereços da MI ou MP em bits (memi.vhd)
		FR_ADDR_WIDTH		: natural := 4;		-- tamanho da linha de endereços do banco de registradores em bits
		INSTR_WIDTH			: natural := 32		-- tamanho da instrução em bits
	);
	port(
		clock								: in std_logic;
		reset								: in std_logic;
		w_eR								: in std_logic;
		w_ePC								: in std_logic;
		branch							: in std_logic;
		outp								: in std_logic;
		w_er12							: in std_logic;
		clear								: in std_logic;
		enderecoreg						: in std_logic;
		sel_ula1							: in std_logic;
		instrucaoin 					: in std_logic_vector(INSTR_WIDTH-1 downto 0);
		entrada   						: in std_logic_vector(DATA_WIDTH-1 downto 0);
		sel_R								: in std_logic_vector(1 downto 0);
		sel_ula2							: in std_logic_vector(1 downto 0);
		AluOp								: in std_logic_vector(3 downto 0);
		opcode							: out std_logic_vector (3 downto 0);
		opcode23							: out std_logic_vector (3 downto 0);
		addhazard1						: out std_logic_vector (3 downto 0);
		addhazard2						: out std_logic_vector (3 downto 0);
		addrdes							: out std_logic_vector (3 downto 0);
		saida		 						: out std_logic_vector (DATA_WIDTH-1 downto 0);
		saidapc							: out std_logic_vector(PC_WIDTH-1 downto 0);
		branchout						: out std_logic
	);
end component;

component unidade_de_controle is
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
end component;

component memi is
	generic 
	(
		INSTR_WIDTH : natural := 32;	-- tamanho da instrução em número de bits
		MI_ADDR_WIDTH : natural := 8	-- tamanho do endereço da memória de instruções em número de bits
	);
	port(
		Endereco	: in std_logic_vector(MI_ADDR_WIDTH-1 downto 0);
		Instrucao: out std_logic_vector(INSTR_WIDTH-1 downto 0)
	);
end component;

component fsm is
	port(
		clk		: in std_logic;
		opcode	: in std_logic_vector(3	downto 0);			-- instrução		
		reset    : in  std_logic;
		enter 	: in std_logic;
		w_eR		: out std_logic; -- Habilita a escrita no registrador de destino 												
		w_ePC		: out std_logic; -- Habilita a escrita em PC
		outp		: out std_logic; -- Habilita escrever na saida do processador
		state		: out std_logic_vector(2 downto 0)
	);
end component;

component unidade_de_controle_hazard is
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
end component;

component display7 is
	port(
		entrada      : in std_logic_vector(3 downto 0);
		saida        : out std_logic_vector(0 to 6)
		);
end component;

signal aux_instrucao 		: std_logic_vector(31 downto 0);
signal aux_w_eR				: std_logic;
signal aux_sel_R				: std_logic_vector(1 downto 0);
signal aux_w_ePC				: std_logic;
signal aux_w_ePC_fsm			: std_logic;
signal aux_w_eR_fsm			: std_logic;
signal aux_outp				: std_logic;
signal aux_pc_out				: std_logic_vector(7 downto 0);
signal aux_branch				: std_logic;
signal aux_enderecoreg		: std_logic;
signal aux_saida				: std_logic_vector(15 downto 0);
signal aux_aluop				: std_logic_vector(3 downto 0);
signal aux_opcode				: std_logic_vector(3 downto 0);
signal aux_sel_ula1			: std_logic;
signal aux_sel_ula2			: std_logic_vector(1 downto 0);
signal aux_w_er12				: std_logic;
signal aux_w_er23				: std_logic;
signal aux_enable_r			: std_logic;	
signal aux_addhazard1		: std_logic_vector(3 downto 0);
signal aux_addhazard2		: std_logic_vector(3 downto 0);
signal aux_addrdes			: std_logic_vector(3 downto 0);
signal aux_branchout			: std_logic;
signal aux_clear				: std_logic;
signal aux_opcode23			: std_logic_vector(3 downto 0);

begin 

	instancia_memi : memi
	port map(
		Endereco		=> aux_pc_out,
		Instrucao	=> aux_instrucao
	);
	
	instancia_unidadecontrole : unidade_de_controle
	port map(
		opcode  	 	 => aux_opcode,
		opcode23		 => aux_opcode23,
		w_ePC_fsm	 => aux_w_ePC_fsm,
		w_ePC			 => aux_w_ePC,
		w_eR_fsm	 	 => aux_w_eR_fsm,
		w_eR			 => aux_w_eR,
		sel_R			 => aux_sel_R,
		branch		 => aux_branch,
		enderecoreg  => aux_enderecoreg,
		AluOp 		 => aux_aluop,
		w_eR12		 => aux_w_er12
		);
	
	instancia_via_de_dados_pipeline : via_de_dados_pipeline
	port map(
		-- declare todas as portas da sua via_dados_ciclo_unico aqui.
		clock     	=> clock,
		reset			=> reset,
		instrucaoin	=> aux_instrucao,
		entrada     => entrada,
		saida			=> aux_saida,
		saidapc		=> aux_pc_out,
		w_eR			=> aux_w_eR,
		sel_R			=> aux_sel_R,
		w_ePC			=> aux_w_ePC,
		outp			=> aux_outp,
		branch		=> aux_branch,
		AluOp 		=> aux_aluop,
		opcode		=> aux_opcode,
		opcode23		=> aux_opcode23,
		enderecoreg => aux_enderecoreg,
		sel_ula1		=> aux_sel_ula1,
		sel_ula2		=> aux_sel_ula2,
		w_er12		=> aux_w_er12,
		clear       => aux_clear,
		addhazard1	=> aux_addhazard1,
		addhazard2	=> aux_addhazard2,
		addrdes		=> aux_addrdes,
		branchout	=> aux_branchout
	);
	
	instancia_fsm : fsm
	port map(
		clk 		 => clock,
		opcode	 => aux_opcode,
		w_eR		 => aux_w_eR_fsm,												
		w_ePC		 => aux_w_ePC_fsm,
		outp		 => aux_outp,
		reset     => reset,
		enter 	 => enter,
		state     => state
	);
	
	
	instancia_hazard : unidade_de_controle_hazard
	port map(
		addrop1_r12	=> aux_addhazard1,
		addrop2_r12 => aux_addhazard2,
		addrdes_r23	=> aux_addrdes,
		opcode23	 	=> aux_opcode23,
		opcode 		=> aux_opcode,
		branch		=>	aux_branchout,
		clear			=>	aux_clear,
		sel_ula1 	=>	aux_sel_ula1,
		sel_ula2		=> aux_sel_ula2
		);
		
	instancia_displaysaida0 : display7
	port map(
		entrada => aux_saida(3 downto 0),
		saida   => displaysaida0
		);
	
	instancia_displaysaida1 : display7
	port map(
		entrada => aux_saida(7 downto 4),
		saida   => displaysaida1
		);
	
	instancia_displaysaida2 : display7
	port map(
		entrada => aux_saida(11 downto 8),
		saida   => displaysaida2
		);
	
	instancia_displaysaida3 : display7
	port map(
		entrada => aux_saida(15 downto 12),
		saida   => displaysaida3
		);

	instancia_displayopcode : display7
	port map(
		entrada => aux_opcode,
		saida   => displayopcode
		);	
	
	instancia_displayopcode23 : display7
	port map(
		entrada => aux_opcode23,
		saida   => displayopcode23
		);	
	
	opcode <= aux_opcode;
	saida <= aux_saida;
	opcode23	 <= aux_opcode23;
	
end comportamento;
