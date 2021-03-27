# Universidade Federal de Minas Gerais
# Escola de Engenharia
# Departamento de Engenharia Eletr�nica
# Autoria: Professor Ricardo de Oliveira Duarte
# Vers�o: v1-2016 
# Disciplina: ELT005 - Sistemas, Processadores e Perif�ricos
#
# Este arquivo � um script para compila��o e simula��o temporal de um DUT (Device Under Test) no ModelSim-Altera
# Antes de executar este script � necess�rio que voc� j� tenha executado o script de compila��o:
# processador_ciclo_unico_quartusII_temporal_sem_pinos.tcl
# O script acima gera os arquivos dut.vho e dut_vhd.sdo que ser�o necess�rios � simula��o temporal dentro do ModelSim-Altera.
# 
# O script processador_ciclo_unico_modelsim_temporal.do foi constru�do usando-se como base a referencia:
# ModelSim SE Command Reference Guide fornecido no conjunto de arquivos de refer�ncia.
#
# Para executar o script processador_ciclo_unico_modelsim_temporal.do abra o Modelsim e da janela transcript execute o comando:
# Modelsim> do processador_ciclo_unico_modelsim_temporal.do
#
# Mais algumas orienta��es de configura��o do seu ambiente de trabalho:
# Lembre-se de incluir a pasta bin do execut�vel do Quartus II na vari�vel de ambiente de seu sistema operacional Windows.

## ALTERE A VARI�VEL TCL A SEGUIR PARA ATENDER A CONFIGURA��O DO SEU COMPUTADOR
# Esta vari�vel guarda o Path (caminho) onde se encontra os arquivos dut.vho e dut_vhd.sdo gerados pelo compilador Quartus II
# para simula��o temporal no ModelSim
set meu_path D:/Pipeline/simulation/modelsim

## ALTERE A VARI�VEL TCL A SEGUIR PARA ATENDER A CONFIGURA��O DO SEU COMPUTADOR 
# Esta vari�vel guarda a pasta e o caminho completo (path) onde ser�o gerados os arquivos produzidos pelo simulador ModelSim
set meu_home_path D:/Pipeline/modelsim


# Path para gera��o da library. Uso o nome padr�o de library: work
set meu_work_path $meu_home_path/work

## ALTERE A VARI�VEL A SEGUIR PARA ATENDER O NOME DO DUT QUE VOC� VAI SIMULAR 
# The top level design name
set design processador_pipeline

# A linguagem TCL deve oferecer maneira mais adequada para se fazer a chamada do vsim, mas enquanto eu n�o encontro,
# segue abaixo a gambiarra de defini��o de uma vari�vel para guardar a extens�o de arquivo _vhd.sdo 
# Quem souber como fazer isso melhor me escreva :-) ricardoduarte@ufmg.br
# Adicionando uma variavel auxiliar para guardar a extens�o do arquivo a ser simulado
set auxiliar _vhd.sdo

# The source file(s), the last is the top
# Se precisar de v�rios arquivos, coloque um nome de arquivo por linha separado por um espa�o ao final do nome do arquivo,
# seguido de "\" sem aspas
set src_files $meu_path/$design.vho

# Comandos para criar um novo projeto de dentro da janela transcript do Modelsim
project new $meu_home_path $design work
project addfile $src_files

# Exemplo de linha de comando para disparar a compila��o do DUT dentro do Modelsim
# vcom -reportprogress 300 -work work C:/altera/90sp2/quartus/mux21/simulation/modelsim/mux21.vho
# Segue abaixo a linha que dispara a compila��o do projeto com todos os arquivos fonte para a simula��o temporal
vcom -reportprogress -error -warning 300 -work $meu_work_path $src_files

# Veja abaixo o modelo de chamada do simulador vsim do ModelSim
# vsim -t ps-sdf(typ) +transport_int_delays +transport_path_delays /=<design name>.sdo work.<top-level design entity>
# Segue abaixo a linha que dispara a simula��o do DUT no ModelSim
vsim -voptargs=+acc -sdftyp /=$meu_path/$design$auxiliar work.$design

# Defini��o das vari�veis que definem os nomes dos sinais de simula��o do DUT
## ALTERE AS VARI�VEIS OU INCLUA NOVAS VARI�VEIS A SEGUIR PARA ATENDER O NOME DO DUT QUE VOC� VAI SIMULAR
set entrada /$design/entrada
set enter /$design/enter
set reset /$design/reset
set Clock /$design/Clock
set saida /$design/saida
set opcode /$design/opcode
set state /$design/state
set opcode23 /$design/opcode23

# Os comandos abaixo configuram:
# 1) A base (o radix) que ser� exibido os sinais de entrada e sa�da do seu DUT durante a simula��o.
# 2) A janela Wave do ModelSim onde vai aparecer a waveform com o resultado da simula��o.
quietly WaveActivateNextPane {} 0

## ALTERE AS VARI�VEIS OU INCLUA NOVAS VARI�VEIS A SEGUIR PARA ATENDER O NOME DO DUT QUE VOC� VAI SIMULAR 
add wave -noupdate -radix hexadecimal $saida
add wave -noupdate -radix hexadecimal $enter
add wave -noupdate -radix hexadecimal $entrada
add wave -noupdate -radix hexadecimal $reset
add wave -noupdate -radix hexadecimal $Clock
add wave -noupdate -radix hexadecimal $opcode
add wave -noupdate -radix hexadecimal $state
add wave -noupdate -radix hexadecimal $opcode23

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 189
configure wave -valuecolwidth 137
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update

## ALTERE O VALOR DO TEMPO FINAL DA JANELA DE SIMULA��O DO DUT
WaveRestoreZoom {0 ns} {1000 ns}

# Abaixo segue a inicializa��o dos sinais de entrada do DUT
## INCLUA E/OU ALTERE O VALOR INICIAL DAS VARI�VEIS DA LISTA DE EST�MULOS A SER APLICADA AO DUT DURANTE A SIMULA��O 
# Usage: force [-freeze | -drive | -deposit] [-cancel <time>] [-repeat <time>] <object_name> {<value> [[@]<time>[<unit>]]}...

force $reset 	1 0
force $Clock 		0 0

# Alguns exemplos de formatos de representa��o de est�mulos de sinais de entrada:
# 	em hexadecimal: 16#FFC2 
# 	em bin�rio: 2#11111110
# 	em decimal: 10#-23749
# Alguns exemplos de uso do comando force para defini��o de est�mulos de sinais de entrada:
# Exemplo (1):
# force bus1 16#f @200
# 	Forces bus1 to 16#F at the absolute time 200 measured in the resolution units selected at
# 	simulation start-up.
# Exemplo (2):
# force input1 1 10, 0 20 -r 100
#	Forces input1 to 1 at 10 time units after the current simulation time and to 0 at 20 time
#	units after the current simulation time. This cycle repeats starting at 100 time units after
#	the current simulation time, so the next transition is to 1 at 100 time units after the current
#	simulation time.
# Exemplo (3):
# force input1 1 10 ns, 0 {20 ns} -r 100ns
#	Similar to the previous example, but also specifies the time units. Time unit expressions
#	preceding the "-r" must be placed in curly braces.
# Exemplo (4):
# when {/mydut/siga = 10#1} {
#	force -deposit /mydut/siga 10#85
# }
#	Forces siga to decimal value 85 whenever the value on the signal is 1.
# Exemplo (5):
# Se o seu DUT necessitar da gera��o de um sinal de clock, siga este exemplo a seguir:
# force clock 0 0 ns, 1 {20 ns} -r 40 ns
#	O exemplo acima gera um sinal de clock que come�a em 0 e alterna para 1 ap�s 20 ns e repete este comportamento ap�s
#	40 ns, ou seja, � um sinal de clock com per�odo de 40 ns e duty cycle de 50% come�ando em n�vel l�gico 0.
# Exemplo (6):
# Se o seu DUT necessitar da gera��o de est�mulos de uma forma repetitiva, voc� pode usar um comando for para programar
# a repeti��o dos est�mulos.
# ## faz um loop com 4 repeti��es
#	for {set num 0} {$num <= 3} {incr num 1} {
#		incr time 50
#		force $controle 1 $time
#		incr time 50
#		force $controle 0 $time
#		incr time 100
#		force $controle 1 $time
#		incr time 50
#		force $controle 0 $time
#		incr time 50
#	}

# Abaixo segue a sequencia de est�mulos que voc� deseja que seja aplicada as entradas do DUT a ser simulado.
# INCLUA E/OU ALTERE O VALOR DAS VARI�VEIS DA LISTA DE EST�MULOS A SER APLICADA AO DUT DURANTE A SIMULA��O 
force $reset 	1 0 ns, 0 {30 ns} -cancel 5000 ns
force $Clock 		0 0 ns, 1 {20 ns} -r 40 ns 
force $entrada   16#0003 0ns, 16#0005 300ns
force $enter	0 0 ns, 1 90 ns, 0 150 ns, 1 250 ns, 0 310 ns, 1 430 ns, 0 510 ns, 1 630 ns, 0 710 ns, 1 890 ns, 0 930 ns, 1 1070 ns, 0 1130 ns, 1 1210 ns, 0 1270 ns, 1 1410 ns, 0 1470 ns, 1 1610 ns, 0 1670 ns, 1 1830 ns, 0 1890 ns, 1 2010 ns, 0 2070 ns, 1 2250 ns, 0 2290 ns, 1 2410 ns, 0 2470 ns 
run 2600 ns

# A seguir segue uma lista de sinais de entrada e sa�da do DUT para escrever os 
# resultados da simula��o em um arquivo de sa�da que daremos o nome de $design.simulated.lst
# Listaremos no arquivo $design.simulated.lst todos os sinais abaixo na base (radix) hexadecimal 
# INCLUA E/OU ALTERE O VALOR DAS VARI�VEIS DA LISTA DE EST�MULOS A SER APLICADA AO DUT DURANTE A SIMULA��O 
add list -hexadecimal $entrada
add list -hexadecimal $enter
add list -hexadecimal $reset
add list -hexadecimal $Clock
add list -hexadecimal $saida
add list -hexadecimal $state
add list -hexadecimal $opcode
add list -hexadecimal $opcode23

# O arquivo abaixo cont�m os resultados simulados na forma textual
# O arquivo ser� gerado na pasta work
write list $design.simulated.lst

# Na mesma pasta work o Modelsim salvar� um arquivo de nome vsim.wlf
# Este arquivo cont�m a forma de onda completa da sua simula��o.
# Este arquivo pode ser aberto posteriormente dentro do Modelsim para exibir a forma de onda da simula��o.
# Para voc� abrir este arquivo vsim.wlf voc� dever� copiar a seguinte linha de comando na tela de Transcript do Modelsim e pressionar a tecla de enter
# vsim -view vsim.wlf
# Para que o comando acima seja executado h� necessidade de terminar todas as simula��es abertas com o comando quit -sim na janela Transcript

# Termina a simula��o
# Descomente a linha abaixo se desejar que o script finalize a simula��o sem que voc� observe o resultado na janela Wave
#quit -sim
