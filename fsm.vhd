library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
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
end fsm;

architecture be of fsm is

type estado is (Aguarda, IN1, IN2, OUT1, OUT2,Retorna);
signal estado_atual, proximo_estado : estado:= Aguarda;

begin

--REGISTRADOR DE ESTADO
process (reset,clk) 
		begin
			if(reset='1') then
				estado_atual<=Aguarda;
			elsif (rising_edge(clk)) then
				estado_atual<=proximo_estado;
			end if;
		end process;
		
--PROCESSO COMBINACIONAL
	process(opcode,estado_atual,enter)
		begin
		
			w_ePC <= '0';
			outp<='0';
			w_eR<='0';
			proximo_estado<=Aguarda;
			
				case estado_atual is
					when Aguarda=>
							w_ePC <= '0';
							w_eR <= '1';
							outp<='0';
							state <="000";
						if(opcode="1100")then
							proximo_estado<=IN1;
						elsif(opcode="1101")then
							proximo_estado<=OUT1;
						else
							proximo_estado<=Aguarda;
						end if;
		
					when IN1 =>
							w_ePC <= '0';
							outp<='0';
							w_eR <= '0';
							state <="001";
						if(enter = '1')then
							proximo_estado<=IN2;
						else
							proximo_estado<=IN1;
						end if;
						
					when OUT1 =>
							w_ePC <= '0';
							outp<='0';
							w_eR <= '0';
							state <="010";
						if(enter = '1')then
							proximo_estado<=OUT2;
						else
							proximo_estado<=OUT1;
						end if;
						
					when IN2 =>
							w_ePC <= '0';
							w_eR <= '1';
							outp<='0';
							state <="011";
						if(enter='1')then
							proximo_estado<=IN2;
						else
							proximo_estado<=Retorna;
						end if;
						
					when OUT2 =>
							w_ePC <='0';
							outp	<='1';
							w_eR <= '0';
							state <="100";
						if(enter='0')then
							proximo_estado<=Retorna;
						else
							proximo_estado<=OUT2;
						end if;
						
					when Retorna =>
							w_ePC <='1';
							outp<='0';
							w_eR <= '0';
							state <="101";
							proximo_estado <= Aguarda;
							
					when others =>
							w_ePC <='1';
							outp<='0';
							w_eR <= '0';
							state <="111";
							proximo_estado <= Aguarda;
							
					end case;
			end process;
		end be;