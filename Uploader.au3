#include "_HttpRequest.au3"

$sFile = FileOpenDialog('','','Files(*.*)')
If @error Then Exit
Uploader($sFile)

Func Uploader($PathFile)
Local $Error,$sData,$iSize = 0,$NameFile,$Size,$Size_,$hfile,$hTime,$Response
$NameFile = GetNameFileFromPath($PathFile)
$Size = FileGetSize($PathFile)
$Size_ = Fix_Size($Size)
$hfile = FileOpen($PathFile, 16)
ProgressOn('Upload File AutoIt To Php','',$NameFile,Default,Default,16)
$hTime = TimerInit()
While 1
	$sData = FileRead($hfile,4096*8)
	If @error Then ExitLoop
	$iSize += BinaryLen($sData)
	$sData = StringTrimLeft($sData,2)
	$Response = _PHP_POST("http://YourServer.com/Uploader.php","data="&$sData&"&File="&$NameFile&"&mode=a+b")
	ProgressSet($iSize*100/$Size,Round($iSize*100/$Size,2)&'% '&Fix_Size($iSize)&"/"&Fix_Size($Size)&"    "&Timer($hTime))
	If $Response <> 'OK' Then
		$Error = True
		ExitLoop
	EndIf
WEnd
ProgressOff()
FileClose($hfile)
If $Error Then Return False
Return True
EndFunc

Func GetNameFileFromPath($Dir)
	Local $iDir = StringSplit(StringReplace($Dir, '\', '/'), '/')
	Return $iDir[$iDir[0]]
EndFunc   ;==>NameFileFromDir
Func Timer($beg,$mi = 0)
	$dummy = (TimerDiff($beg)-$mi) / 1000

	$dummy2 = Mod($dummy, 3600)
	$hours = ($dummy - $dummy2) / 3600
	$dummy = $dummy2

	$dummy2 = Mod($dummy, 60)
	$minutes = ($dummy - $dummy2) / 60
	$dummy = $dummy2
	$seconds = Round($dummy)
	If $minutes < 10 Then $minutes = 0 & $minutes
	If $seconds < 10 Then $seconds = 0 & $seconds
	If $hours < 10 Then $hours = 0 & $hours
	Return $hours & ":" & $minutes & ":" & $seconds
EndFunc   ;==>Timer
Func Fix_Size($ki)
	If $ki < 1024 Then
		Return Round($ki,2)&" B"
	ElseIf $ki < 1024*1024 Then
		Return Round($ki/1024,2)&" KB"
	ElseIf $ki < 1024*1024*1024 Then
		Return Round($ki/1024/1024,2)&" MB"
	ElseIf $ki < 1024*1024*1024*1024 Then
		Return Round($ki/1024/1024/1024,2)&" GB"
	EndIf
EndFunc