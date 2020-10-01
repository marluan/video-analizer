turnos=0
InputBox,creatureFolder,,Digite o nome da criatura
turnoDir=%A_ScriptDir%\%creatureFolder%\Turnos
creatureDir=%A_ScriptDir%\%creatureFolder%
carregarMagicsNames()
if(!MagicName1) {
	InputBox,MagicName1,,Digite o nome da primeira magica
	IniWrite, %MagicName1%, %creatureDir%\creature.ini, magics,Magic1
}
if(!MagicName2) {
	InputBox,MagicName2,,Digite o nome da segunda magica
	IniWrite, %MagicName2%, %creatureDir%\creature.ini, magics,Magic2
}
if(!MagicName3) {
	InputBox,MagicName3,,Digite o nome da terceira magica
	IniWrite, %MagicName3%, %creatureDir%\creature.ini, magics,Magic3
}
if(!MagicName4) {
	InputBox,MagicName4,,Digite o nome da quarta magica
	IniWrite, %MagicName4%, %creatureDir%\creature.ini, magics,Magic4
}

Gui, Add, Picture, x1 y1 w780 h710 vTurnoImg, 
Gui, Add, Picture, x1 y581 w680 h108 vServerLogImg, 
Gui, Add, Picture, x621 y581 w60 h30 vTimeImg, 
Gui, Add, Text, x802 y39 w90 h20, Melee
Gui, Add, Edit, x952 y39 w50 h20 vMeleeDmg, 
Gui, Add, Text, x802 y69 w130 h20 vMagic1, 
Gui, Add, Edit, x952 y69 w50 h20 vMagicDmg1, 
Gui, Add, Text, x802 y99 w130 h20 vMagic2, 
Gui, Add, Edit, x952 y99 w50 h20 vMagicDmg2, 
Gui, Add, Text, x802 y129 w130 h20 vMagic3, 
Gui, Add, Edit, x952 y129 w50 h20 vMagicDmg3, 
Gui, Add, Text, x802 y159 w130 h20 vMagic4, 
Gui, Add, Edit, x952 y159 w50 h20 vMagicDmg4, 

Gui, Add, Button, x802 y619 w100 h30 gGerarRelatorio, Gera Relatório
Gui, Add, Button, x902 y619 w100 h30 gSubstituirImg, Substituir Imagem

Gui, Add, Button, x802 y649 w100 h30 gAnterior, Anterior
Gui, Add, Button, x902 y649 w60 h30 gExcluir, Excluir
Gui, Add, Button, default x962 y649 w110 h30 gProximo, Proximo

; Generated using SmartGUI Creator for SciTE
Gui, +Resize
Gui, Show, w1099 h700, Creature Analyzer

refreshTurnos()

if(turnos>0)
{
	TurnoIndex=0
	carregarDadosTurno(turnoIndex)
}

Loop
{
	IfWinExist, Tibia
	{
		MsgBox,,,Por motivos de segurança não utilize este programa junto com o Client do Tibia. Ele não executará
		ExitApp
	}
	Sleep, 50
}

return

refreshTurnos()
{
	global turnos, turnoDir
	turnos=0
	Loop, %turnoDir%\turno*.png
	{
		turnos++
	}
}

salvarDadosTurno(turnoIndex) {
	global MeleeDmg,MagicDmg1,MagicDmg2,MagicDmg3,MagicDmg4,creatureDir
	Gui, Submit, NoHide 
	dmgs=%MeleeDmg%,
	Loop, 3
	{
		dmgs:=dmgs . MagicDmg%A_Index% . ","
	}
		dmgs:=dmgs . MagicDmg4
	IniWrite, %dmgs%, %creatureDir%\creature.ini, hits, turno%turnoIndex%
}

carregarDadosTurno(turnoIndex) {
	global turnoDir,Magic1,Magic2,Magic3,Magic4,MagicName1,MagicName2,MagicName3,MagicName4
	GuiControl,, TurnoImg,%turnoDir%\turno-%TurnoIndex%.png
	GuiControl,, TimeImg,%turnoDir%\time-%TurnoIndex%.png
	GuiControl,, ServerLogImg,%turnoDir%\Serverlog-%TurnoIndex%.png
	GuiControl,, Magic1,%MagicName1%
	GuiControl,, Magic2,%MagicName2%
	GuiControl,, Magic3,%MagicName3%
	GuiControl,, Magic4,%MagicName4%
	carregarHits(turnoIndex)
}

carregarHits(turnoIndex){
	global creatureDir
	IniRead, dmgs, %creatureDir%\creature.ini, hits, turno%turnoIndex%
	if(dmgs!="ERROR") {
		StringSplit, dmg_,dmgs,`,
		GuiControl,, MeleeDmg,%dmg_1%
		GuiControl,, MagicDmg1,%dmg_2%
		GuiControl,, MagicDmg2,%dmg_3%
		GuiControl,, MagicDmg3,%dmg_4%
		GuiControl,, MagicDmg4,%dmg_5%
	} else {
		GuiControl,, MeleeDmg,
		GuiControl,, MagicDmg1,
		GuiControl,, MagicDmg2,
		GuiControl,, MagicDmg3,
		GuiControl,, MagicDmg4,
	}
}

carregarMagicsNames(){
	global creatureDir,MagicName1,MagicName2,MagicName3,MagicName4,DmgsMin,DmgsMax,DmgsTurnos,DmgsMedia,CurrentTurnos,MinTurnos
	IfExist, %creatureDir%\creature.ini
	{
		IniRead, MagicName1, %creatureDir%\creature.ini, magics, Magic1 
		IniRead, MagicName2, %creatureDir%\creature.ini, magics, Magic2
		IniRead, MagicName3, %creatureDir%\creature.ini, magics, Magic3
		IniRead, MagicName4, %creatureDir%\creature.ini, magics, Magic4
		DmgsMin:= {Melee: 0, (MagicName1): "", (MagicName2): "", (MagicName3): "", (MagicName4): ""}
		DmgsMax:= {Melee: 0, (MagicName1): 0, (MagicName2): 0, (MagicName3): 0, (MagicName4): 0}
		DmgsTurnos:= {Melee: 0, (MagicName1): 0, (MagicName2): 0, (MagicName3): 0, (MagicName4): 0}
		DmgsMedia:= {Melee: 0, (MagicName1): 0, (MagicName2): 0, (MagicName3): 0, (MagicName4): 0}
		CurrentTurnos:= {(MagicName1): 2, (MagicName2): 2, (MagicName3): 2, (MagicName4): 2}
		MinTurnos:= {(MagicName1): 10, (MagicName2): 10, (MagicName3): 10, (MagicName4): 10}
	}
}

excluirTurno(TurnoIndex){
	global turnoDir,turnos
	IfNotExist, %turnoDir%\Deletados
		FileCreateDir, %turnoDir%\Deletados
	seqExclusao:=sequenciaArquivoExistente(turnoDir . "\Deletados\turno-",TurnoIndex,"png")
	FileMove, %turnoDir%\turno-%TurnoIndex%.png,%turnoDir%\Deletados\turno-%seqExclusao%.png
	FileMove, %turnoDir%\time-%TurnoIndex%.png,%turnoDir%\Deletados\time-%seqExclusao%.png
	FileMove, %turnoDir%\Serverlog-%TurnoIndex%.png,%turnoDir%\Deletados\Serverlog-%seqExclusao%.png
	turnosRenomear:= turnos - TurnoIndex - 1
	Loop, %turnosRenomear%
	{
		turnoAtual:=TurnoIndex+A_Index
		turnoRenom:=turnoAtual-1
		FileMove, %turnoDir%\turno-%turnoAtual%.png,%turnoDir%\turno-%turnoRenom%.png
		FileMove, %turnoDir%\time-%turnoAtual%.png,%turnoDir%\time-%turnoRenom%.png
		FileMove, %turnoDir%\Serverlog-%turnoAtual%.png,%turnoDir%\Serverlog-%turnoRenom%.png
	}
	refreshTurnos()
	carregarDadosTurno(turnoIndex)
}

sequenciaArquivoExistente(diretorio,TurnoIndex,ext){
		IfExist, %diretorio%%turnoIndex%.%ext%
		{
			TurnoIndex++
			return sequenciaArquivoExistente(diretorio,TurnoIndex,ext)
		}
		return TurnoIndex
}


gerarDadosTurnoRel(turnoIndex) {
	global creatureDir,turnoDir,Magic1,Magic2,Magic3,Magic4,MagicName1,MagicName2,MagicName3,MagicName4,DmgsMin,DmgsMax
	txt=<td>%turnoIndex%</td>
	txt=%txt%<td><img src=`"Turnos\turno-%TurnoIndex%.png`"/></td>
	txt=%txt%<td><img src=`"Turnos\Serverlog-%TurnoIndex%.png`"/></td>
	txt=%txt%<td><img src=`"Turnos\time-%TurnoIndex%.png`"/></td>
	txt=%txt%<td>
	IniRead, dmgs, %creatureDir%\creature.ini, hits, turno%turnoIndex%
	if(dmgs!="ERROR") {
		StringSplit, dmg_,dmgs,`,
		gerarAnaliseDano(dmgs)
		txt=%txt%Melee: %dmg_1%<br>
		txt=%txt%%MagicName1%: %dmg_2%<br>
		txt=%txt%%MagicName2%:%dmg_3%<br>
		txt=%txt%%MagicName3%:%dmg_4%<br>
		txt=%txt%%MagicName4%:%dmg_5%<br>
	}
	txt=%txt%</td>
	return txt
}

gerarAnaliseDano(dmgs) {
	global MagicName1,MagicName2,MagicName3,MagicName4,DmgsMin,DmgsMax,DmgsTurnos,CurrentTurnos,MinTurnos,DmgsMedia
	StringSplit, dmg_,dmgs,`,
	
	if(dmg_2!="" and dmg_2>0){
		if(CurrentTurnos[(MagicName1)] < MinTurnos[(MagicName1)])
			MinTurnos[(MagicName1)]:=CurrentTurnos[(MagicName1)]
		
		CurrentTurnos[(MagicName1)]:=0
		DmgsTurnos[(MagicName1)]+=1
		
		currentMagic1Min:=DmgsMin[(MagicName1)]
		currentMagic1Max:=DmgsMax[(MagicName1)]
		if(currentMagic1Min>dmg_2 or currentMagic1Min = "")
			DmgsMin[(MagicName1)]:=dmg_2
		if(currentMagic1Max<dmg_2)
			DmgsMax[(MagicName1)]:=dmg_2
		DmgsMedia[(MagicName1)]+=dmg_2
	} else {
		CurrentTurnos[(MagicName1)]+=1
	}
	if(dmg_3!="" and dmg_3>0){
		if(CurrentTurnos[(MagicName2)] < MinTurnos[(MagicName2)])
			MinTurnos[(MagicName2)]:=CurrentTurnos[(MagicName2)]
		CurrentTurnos[(MagicName2)]:=0
		DmgsTurnos[(MagicName2)]+=1
		
		currentMagic2Min:=DmgsMin[(MagicName2)]
		currentMagic2Max:=DmgsMax[(MagicName2)]
		if(currentMagic2Min>dmg_3 or currentMagic2Min="")
			DmgsMin[(MagicName2)]:=dmg_3
		if(currentMagic2Max<dmg_3)
			DmgsMax[(MagicName2)]:=dmg_3
		DmgsMedia[(MagicName2)]+=dmg_3
	} else {
		CurrentTurnos[(MagicName2)]+=1
	}
	if(dmg_4!="" and dmg_4>0){		
		if(CurrentTurnos[(MagicName3)] < MinTurnos[(MagicName3)])
			MinTurnos[(MagicName3)]:=CurrentTurnos[(MagicName3)]
		CurrentTurnos[(MagicName3)]:=0
		DmgsTurnos[(MagicName3)]+=1
		currentMagic3Min:=DmgsMin[(MagicName3)]
		currentMagic3Max:=DmgsMax[(MagicName3)]
		if(currentMagic3Min>dmg_4 or currentMagic3Min="")
			DmgsMin[(MagicName3)]:=dmg_4
		if(currentMagic3Max<dmg_4)
			DmgsMax[(MagicName3)]:=dmg_4
		DmgsMedia[(MagicName3)]+= dmg_4
	} else {
		CurrentTurnos[(MagicName3)]+=1
	}
	if(dmg_5!="" and dmg_5>0){
		if(CurrentTurnos[(MagicName4)] < MinTurnos[(MagicName4)])
			MinTurnos[(MagicName4)]:=CurrentTurnos[(MagicName4)]
		CurrentTurnos[(MagicName4)]:=0
		DmgsTurnos[(MagicName4)]+=1
		currentMagic4Min:=DmgsMin[(MagicName4)]
		currentMagic4Max:=DmgsMax[(MagicName4)]
		if(currentMagic4Min>dmg_5 or currentMagic4Min="")
			DmgsMin[(MagicName4)]:=dmg_5
		if(currentMagic4Max<dmg_5)
			DmgsMax[(MagicName4)]:=dmg_5
		DmgsMedia[(MagicName4)]+= dmg_5
	} else {
		CurrentTurnos[(MagicName4)]+=1
	}
	
	currentMeleeMin:= DmgsMin["Melee"]
	if(currentMeleeMin>dmg_1 and dmg_1 <> "")
		DmgsMin["Melee"]:=dmg_1
	currentMeleeMax:= DmgsMax["Melee"]
	if(currentMeleeMax<dmg_1)
		DmgsMax["Melee"]:=dmg_1
	DmgsMedia["Melee"]+=dmg_1
	
}

Anterior:
	if(TurnoIndex>0) {
		salvarDadosTurno(turnoIndex)
		TurnoIndex--
		carregarDadosTurno(turnoIndex)
	}
return

Excluir:
	excluirTurno(TurnoIndex)
return

Proximo:
	if(TurnoIndex<turnos) {
		salvarDadosTurno(turnoIndex)
		TurnoIndex++
		carregarDadosTurno(turnoIndex)
		
	}
return

SubstituirImg:

return

GerarRelatorio:
headerSumary=<td>Tipo Dano</td><td>Dano Minimo</td><td>Dano Maximo</td><td>Dano Médio</td><td>Chance por turno</td><td>min turnos</td>
headerDetail=<td>Turno</td><td>Imagem</td><td>ServerLog</td><td>Min video</td><td>danos</td>
Loop, %turnos%
{
	linha:=gerarDadosTurnoRel(A_Index-1)
	bodyDetail=%bodyDetail%<tr>%linha%</tr>
}

currentMagic4Min:=DmgsMin[(MagicName4)]
currentMagic4Max:=DmgsMax[(MagicName4)]
currentMagic3Min:=DmgsMin[(MagicName3)]
currentMagic3Max:=DmgsMax[(MagicName3)]
currentMagic2Min:=DmgsMin[(MagicName2)]
currentMagic2Max:=DmgsMax[(MagicName2)]
currentMagic1Min:=DmgsMin[(MagicName1)]
currentMagic1Max:=DmgsMax[(MagicName1)]
currentMeleeMin:= DmgsMin["Melee"]
currentMeleeMax:= DmgsMax["Melee"]
turnosMagic1:=Format( "{:0.2f}" , (DmgsTurnos[(MagicName1)] / turnos)*100)
turnosMagic2:=Format( "{:0.2f}" , (DmgsTurnos[(MagicName2)] / turnos)*100)
turnosMagic3:=Format( "{:0.2f}" , (DmgsTurnos[(MagicName3)] / turnos)*100)
turnosMagic4:=Format( "{:0.2f}" , (DmgsTurnos[(MagicName4)] / turnos)*100)
turnosMin1:=MinTurnos[(MagicName1)]
turnosMin2:=MinTurnos[(MagicName2)]
turnosMin3:=MinTurnos[(MagicName3)]
turnosMin4:=MinTurnos[(MagicName4)]
DmgMedia:=Format( "{:i}" ,DmgsMedia["Melee"] / turnos)
DmgMedia1:=Format("{:i}",(DmgsMedia[(MagicName1)] / DmgsTurnos[(MagicName1)]))
DmgMedia2:=Format("{:i}",DmgsMedia[(MagicName2)] / DmgsTurnos[(MagicName2)])
DmgMedia3:=Format("{:i}",DmgsMedia[(MagicName3)] / DmgsTurnos[(MagicName3)])
DmgMedia4:=Format("{:i}",DmgsMedia[(MagicName4)] / DmgsTurnos[(MagicName4)])

bodySumary=<tr>
bodySumary=%bodySumary%<td>Melee:</td>
bodySumary=%bodySumary%<td>%currentMeleeMin%</td>
bodySumary=%bodySumary%<td>%currentMeleeMax%</td>
bodySumary=%bodySumary%<td>%DmgMedia%</td>
bodySumary=%bodySumary%<td>--</td>
bodySumary=%bodySumary%<td></td></tr><tr>

bodySumary=%bodySumary%<td>%MagicName1%</td>
bodySumary=%bodySumary%<td>%currentMagic1Min%</td>
bodySumary=%bodySumary%<td>%currentMagic1Max%</td>
bodySumary=%bodySumary%<td>%DmgMedia1%</td>
bodySumary=%bodySumary%<td>%turnosMagic1%</td>
bodySumary=%bodySumary%<td>%turnosMin1%</td></tr><tr>

bodySumary=%bodySumary%<td>%MagicName2%</td>
bodySumary=%bodySumary%<td>%currentMagic2Min%</td>
bodySumary=%bodySumary%<td>%currentMagic2Max%</td>
bodySumary=%bodySumary%<td>%DmgMedia2%</td>
bodySumary=%bodySumary%<td>%turnosMagic2%</td>
bodySumary=%bodySumary%<td>%turnosMin2%</td></tr><tr>

bodySumary=%bodySumary%<td>%MagicName3%</td>
bodySumary=%bodySumary%<td>%currentMagic3Min%</td>
bodySumary=%bodySumary%<td>%currentMagic3Max%</td>
bodySumary=%bodySumary%<td>%DmgMedia3%</td>
bodySumary=%bodySumary%<td>%turnosMagic3%</td>
bodySumary=%bodySumary%<td>%turnosMin3%</td></tr><tr>

bodySumary=%bodySumary%<td>%MagicName4%:</td>
bodySumary=%bodySumary%<td>%currentMagic4Min%</td>
bodySumary=%bodySumary%<td>%currentMagic4Max%</td>
bodySumary=%bodySumary%<td>%DmgMedia4%</td>
bodySumary=%bodySumary%<td>%turnosMagic4%</td>
bodySumary=%bodySumary%<td>%turnosMin4%</td></tr>

FileRead, template, %A_ScriptDir%\template.html
StringReplace, template,template, {CREATURE_NAME},%creatureFolder%
StringReplace, template,template, {HEADER_SUMARY},%headerSumary%
StringReplace, template,template, {BODY_SUMARY},%bodySumary%
StringReplace, template,template, {HEADER_DETAIL},%headerDetail%
StringReplace, template,template, {BODY_DETAIL},%bodyDetail%

IfExist, %creatureDir%\index.html
	FileDelete, %creatureDir%\index.html
FileAppend, %template%,%creatureDir%\index.html
MsgBox, Relatorio Gerado!
return



GuiClose:
ExitApp

