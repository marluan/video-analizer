#Include lib.ahk

SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

InputBox,creatureFolder,,Digite o nome da criatura
InputBox,timerRecord,,Digite o tempo de gravação em minutos
timerRecord:=timerRecord*60*1000
IfNotExist, %A_ScriptDir%\%creatureFolder%\Turnos
	FileCreateDir, %A_ScriptDir%\%creatureFolder%\Turnos

personagemRadius=200
tempoRadius=30
currentTurno=0
start:=false

Loop,
{
	if(start and Timer("coldownHit"))
	{
		Gdip_Startup()
		updateFastPixelGetColor()
		
		
		;corPersonagem:=fastPixelGetColor(personagemX,personagemY)
		;PixelGetColor, corPersonagem,personagemX,personagemY
		corPersonagem:=getPixelColorAVG(personagemX,personagemY)
		diffCores:=  corPersonagemOld - corPersonagem
		if((corPersonagemOld != "") and (diffCores>5 or diffCores<-5))
		{
			newPath=%A_ScriptDir%\%creatureFolder%\Turnos\turno-%currentTurno%.png
			xIni:=personagemX-personagemRadius
			yIni:=personagemY-personagemRadius
			w:=personagemRadius*2
			h:=personagemRadius*2
			
			newPathTime=%A_ScriptDir%\%creatureFolder%\Turnos\time-%currentTurno%.png
			xTempoIni:=tempoX
			yTempoIni:=tempoY
			wTempo:=tempoRadius*2
			hTempo:=tempoRadius
			newPathServerLog=%A_ScriptDir%\%creatureFolder%\Turnos\Serverlog-%currentTurno%.png
			
			saveScreen(xIni,yIni,w,h,newPath)
			saveScreen(xTempoIni,yTempoIni,wTempo,hTempo,newPathTime)
			saveScreen(serverLogX,serverLogY-75,500,80,newPathServerLog)
			
			;FileAppend, corAntiga	%corPersonagemOld%	corNova	%corPersonagem%	diffCores	%diffCores%	turno:	%currentTurno%`n,%A_ScriptDir%\%creatureFolder%\Cores.txt
			currentTurno++
			Timer("coldownHit",500)
			
			if(Timer("timerRecord"))
				ExitApp
		}
	}
	Sleep, 10
	IfWinExist, Tibia
	{
		;MsgBox,,,Por motivos de segurança não utilize este programa junto com o Client do Tibia. Ele não executará
		;ExitApp
	}
}


^t::
MouseGetPos, tempoX,tempoY
MsgBox, coord tempo %tempoX% %tempoY%
return

^p::
updateFastPixelGetColor()
MouseGetPos, personagemX,personagemY
;PixelGetColor, corPersonagemOld,personagemX,personagemY
;corPersonagemOld:=fastPixelGetColor(personagemX,personagemY)
StartTime := A_TickCount
corPersonagemOld:=getPixelColorAVG(personagemX,personagemY)
ElapsedTime := A_TickCount - StartTime
MsgBox, coord personagem %personagemX% %personagemY% cor: %corPersonagemOld% tempoProc: %ElapsedTime%
return

^l::
MouseGetPos, serverLogX,serverLogY
MsgBox, coord tempo %serverLogX% %serverLogY%
return


^s::
if(start)
	start:=false
else {
	start:=true
	Timer("timerRecord",timerRecord)
	}
return

saveScreen(x,y,w,h,filePath) {
	coord=%x%|%y%|%w%|%h%
	snap := Gdip_BitmapFromScreen(coord)
	Gdip_SaveBitmapToFile(snap, filePath)
}


getPixelColorAVG(xPos,yPos){
	xPos-=2
	yPos-=2
	Loop,5
	{
		Loop,5
		{
				;PixelGetColor, cor,xPos,yPos
				cor:=getPixelColorR(xPos,yPos)
				corSomada+=cor
				yPos++
		}		
		xPos++
		yPos-=5
	}
	return (corSomada/25)
}

getPixelColorR(xPos,yPos){
	;PixelGetColor, cor,xPos,yPos
	cor:=fastPixelGetColor(xPos,yPos)
	grayvl:=(Format("{:i}",SubStr(cor,3,2)) + Format("{:i}",SubStr(cor,5,2)) + Format("{:i}",SubStr(cor,7,2)))/3
	return grayvl
}
