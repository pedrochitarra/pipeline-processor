## Inclusão de comentários e instruções para modificar este arquivo:
## Todos os comentários iniciados com ## foram incluídos por mim.
##
## Universidade Federal de Minas Gerais
## Escola de Engenharia
## Departamento de Engenharia Eletrônica
## Autoria: Professor Ricardo de Oliveira Duarte
## Versão: v1.1-2016 
## Disciplina: ELT005 - Sistemas, Processadores e Periféricos
##
## Diferença da versão v1.1-2016 para a versão v1-2016:
## 1) Mudança do nome do package que o Quartus II deverá incluir para realizar os comandos TCL deste script
## na linha 67 deste script.
## antes: package require ::quartus::project
## agora: package require ::quartus::project_ui
##
## Para gerar este arquivo de dentro do Quartus II para um outro Projeto
## Vá para o Menu Project e selecione Generate Tcl File for Project
## Project->Generate Tcl File for Project
## Aguarde pela geração completa do script na pasta do seu projeto
##
## Este arquivo TCL script foi gerado para um Project de nome: mux21
## A síntese do dispositivo em VHDL foi gerada para um FPGA da Família (FAMILY): Cyclone II
## O part number do dispositivo (DEVICE) escolhido foi: EP2C35F672C6 
##
## Para executar este arquivo de script há duas opções:
## 	(1) A partir do Modelsim:
##		Na janela Transcript vá para a pasta onde o arquivo .tcl esta localizado.
##		Para fazer isso digite o comando:
##		ModelSim> cd c:/sua_pasta/processador_ciclo_unico
##		Em seguida digite o comando abaixo. Este comando faz com que o Modelsim execute o script processador_ciclo_unico_quartusII_sem_pinos.tcl
##		ModelSim> quartus_sh -t processador_ciclo_unico_quartusII_sem_pinos.tcl
##		Aguarde pela execução completa do script 
## 	(2) A partir do Quartus II:
##		Execute o script mux21_quartusII.tcl a partir do menu View->Utility Windows->Tcl Console
##		Uma janela chamada Quartus II Tcl Console se abrirá.
##		Nesta janela digite: source mux21_quartusII.tcl
##		Aguarde pela execução completa do script 
##
## Vários arquivos com extensão .rpt são gerados
## Estes arquivos são os relatórios (reports) de execução de cada ferramenta do Quartus II
##
## Mais algumas orientações de configuração do seu ambiente de trabalho:
## 	(1) Lembre-se de incluir a pasta bin do executável do Quartus II na variável de ambiente de seu sistema operacional Windows, do contrário
## 		você não conseguirá executar o script de dentro da janela Trascript do Modelsim, nem de uma janela do MS-DOS.
##		Após ter modificado a variável de sistema PATH, reinicie o Sistema Operacional MS-Windows para que a modificação seja reconhecida.
##
# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.

# Quartus II: Generate Tcl File for Project
# File: processador_ciclo_unico.tcl
# Generated on: Wed Aug 17 16:11:08 2016

# Load Quartus II Tcl Project package
package require ::quartus::project_ui

## A linha abaixo precisou ser incluída para transformar o TCL file gerado pelo Quartus II em um script executável por
## linha de comando pelo quartus_sh
package require ::quartus::flow

## As linhas abaixo foram incluídas para tornar o TCL file gerado pelo Quartus II em um script dependente somente
## das variáveis $design_quartusII e $design_quartusII_string
## ALTERE AS VARIÁVEIS A SEGUIR PARA QUE O QUARTUS II CONSTRUA UM PROJETO COM NOME QUE VOCÊ DEFINIU
## PARA SER A ENTIDADE top level  
set design_quartusII processador_pipeline
set design_quartusII_string "processador_pipeline"

## A linha abaixo foi incluída para tornar o TCL file gerado pelo Quartus II em um script dependente somente
## da variável $meu_path_src_file
## ALTERE O CAMINHO DO SEU PROJETO A SEGUIR PARA QUE O QUARTUS II ENCONTRE TODOS OS ARQUIVOS .vhd QUE IRÁ COMPILAR 
set meu_path_src_file "D:\Pipeline"

## Você deve incluir todos os arquivos que contém os componentes em VHDL do seu processador na lista abaixo.
## O último arquivo deverá ser a entidade top level da hierarquia.
## ALTERE A LISTA DE SOURCE FILES A SEGUIR PARA ATENDER AS NECESSIDADES DO SEU PROJETO 
set lista_src_files {
"somador_de_8bits.vhd"
"ula.vhd"
"pc.vhd"
"memi.vhd"
"extensor_de_sinal"
"fsm.vhd"
"mux21_4bits.vhd"
"mux21_16bits.vhd"
"mux41.vhd"
"mux21_8bits.vhd"
"deslocador.vhd"
"registrador_de_8bits.vhd"
"registrador_de_16bits.vhd"
"banco_de_registradores.vhd"
"via_de_dados_pipeline.vhd"
"unidade_de_controle.vhd"
"registrador_de_4bits.vhd"
"registrador_de_32bits.vhd"
"unidade_de_controle_hazard.vhd"
"processador_pipeline.vhd"
}

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) $design_quartusII_string]} {
		puts "Project is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists $design_quartusII]} {
		project_open -revision $design_quartusII $design_quartusII
	} else {
		project_new -revision $design_quartusII $design_quartusII
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone II"
	set_global_assignment -name DEVICE EP2C35F672C6
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION "13.0 SP1"
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "16:07:17  AUGUST 17, 2016"
	set_global_assignment -name LAST_QUARTUS_VERSION "13.0 SP1"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (VHDL)"
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	for {set indice 0} {$indice < [array size lista_src_files]} {incr indice 1} {
		set_global_assignment -name VHDL_FILE $meu_path_src_file/$lista_src_files($indice)
	}

	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top
	
# ATENÇÃO: SÓ USE ESPAÇO. EVITE O USO DE TABULAÇÃO NA EDIÇÃO DE COMANDOS TCL EM SCRIPT FILES.
	
# RETIRE O SINAL DE COMENTÁRIO # DA LINHA 140 ATÉ A LINHA 184 SE DESEJAR ATRIBUIR PINOS
# DO SEU PROCESSADOR CICLO ÚNICO ÀS CHAVES E LEDS DO KIT DE2.

# CORRESPONDÊNCIA ENTRE OS SINAIS DO PROJETO E OS COMPONENTES DO KIT DE2:
# Chaves_entrada[15..0] = SW[15..0]
# Clock = SW[17]
# Chave_reset = SW[16]
# Chave_enter = KEY[0]
# Leds_vermelhos_saida[15..0] = LEDR[15..0]
# Led_verde_negativo = LEDG[0]
# Led_verde_zero = LEDG[1]
#set_location_assignment PIN_U4 -to Chaves_entrada[15]
#set_location_assignment PIN_U3 -to Chaves_entrada[14]
#set_location_assignment PIN_T7 -to Chaves_entrada[13]
#set_location_assignment PIN_P2 -to Chaves_entrada[12]
#set_location_assignment PIN_P1 -to Chaves_entrada[11]
#set_location_assignment PIN_N1 -to Chaves_entrada[10]
#set_location_assignment PIN_A13 -to Chaves_entrada[9]
#set_location_assignment PIN_B13 -to Chaves_entrada[8]
#set_location_assignment PIN_C13 -to Chaves_entrada[7]
#set_location_assignment PIN_AC13 -to Chaves_entrada[6]
#set_location_assignment PIN_AD13 -to Chaves_entrada[5]
#set_location_assignment PIN_AF14 -to Chaves_entrada[4]
#set_location_assignment PIN_AE14 -to Chaves_entrada[3]
#set_location_assignment PIN_P25 -to Chaves_entrada[2]
#set_location_assignment PIN_N26 -to Chaves_entrada[1]
#set_location_assignment PIN_N25 -to Chaves_entrada[0]
#set_location_assignment PIN_V2 -to Clock
#set_location_assignment PIN_V1 -to Chave_reset
#set_location_assignment PIN_G26 -to Chave_enter
#set_location_assignment PIN_N2 -to Clock #CLOCK_27 sinal de clcok 27 MHz
#set_location_assignment PIN_AE13 -to Leds_vermelhos_saida[15]
#set_location_assignment PIN_AF13 -to Leds_vermelhos_saida[14]
#set_location_assignment PIN_AE15 -to Leds_vermelhos_saida[13]
#set_location_assignment PIN_AD15 -to Leds_vermelhos_saida[12]
#set_location_assignment PIN_AC14 -to Leds_vermelhos_saida[11]
#set_location_assignment PIN_AA13 -to Leds_vermelhos_saida[10]
#set_location_assignment PIN_Y13 -to Leds_vermelhos_saida[9]
#set_location_assignment PIN_AA14 -to Leds_vermelhos_saida[8]
#set_location_assignment PIN_AC21 -to Leds_vermelhos_saida[7]
#set_location_assignment PIN_AD21 -to Leds_vermelhos_saida[6]
#set_location_assignment PIN_AD23 -to Leds_vermelhos_saida[5]
#set_location_assignment PIN_AD22 -to Leds_vermelhos_saida[4]
#set_location_assignment PIN_AC22 -to Leds_vermelhos_saida[3]
#set_location_assignment PIN_AB21 -to Leds_vermelhos_saida[2]
#set_location_assignment PIN_AF23 -to Leds_vermelhos_saida[1]
#set_location_assignment PIN_AE23 -to Leds_vermelhos_saida[0]
#set_location_assignment PIN_AE22 -to Led_verde_negativo
#set_location_assignment PIN_AF22 -to Led_verde_zero

	# Commit assignments
	export_assignments
	
	## A linha a seguir precisou ser incluída para que o Quartus II execute a compilação do projeto na forma de um script.
	execute_flow -compile
	
	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
