$ModRoot = $PSScriptRoot
$CapricaRoot = 'Y:\Games\MODCreation\Workspace\Caprica'
$CapricaExe = Join-Path $CapricaRoot 'Caprica.exe'
$FlagsFile = Join-Path $CapricaRoot 'FO4_Papyrus_Flags.flg'
$Fo4Source = 'Y:\Games\Fallout 4\Data\Scripts\Source'
$F4seSource = Join-Path $CapricaRoot 'F4SE_Source'
$Source = Join-Path $ModRoot 'Scripts\Source\User'
$Output = Join-Path $ModRoot 'Scripts'
$Log = Join-Path $Output 'AozoraLGT_caprica_compile.log'
$BuildRoot = 'Y:\Workspace\_AozoraLGT_CapricaBuild'
$BuildSource = Join-Path $BuildRoot 'Source'
$BuildOutput = Join-Path $BuildRoot 'Output'

New-Item -ItemType Directory -Force -Path $Output | Out-Null
New-Item -ItemType Directory -Force -Path $BuildSource | Out-Null
New-Item -ItemType Directory -Force -Path $BuildOutput | Out-Null
Remove-Item -LiteralPath (Join-Path $Output 'AozoraLGT_MainQuestScript.pex') -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath (Join-Path $BuildSource '*.psc') -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath (Join-Path $BuildOutput '*.pex') -Force -ErrorAction SilentlyContinue
Copy-Item -LiteralPath (Join-Path $Source 'AozoraLGT_MainQuestScript.psc') -Destination $BuildSource -Force

# The installed Fallout 4 source bundle is incomplete. These temporary native
# declarations cover only the APIs used by this quest and are never packaged.
$stubSources = @{
    'ScriptObject.psc' = @'
Scriptname ScriptObject Native Hidden
Bool Function RegisterForRemoteEvent(ScriptObject akEventSource, String asEventName) native
'@
    'Form.psc' = @'
Scriptname Form extends ScriptObject Native Hidden
'@
    'Quest.psc' = @'
Scriptname Quest extends Form Native Hidden
'@
    'Actor.psc' = @'
Scriptname Actor extends Form Native Hidden
Bool Function HasSpell(Spell akSpell) native
Function AddSpell(Spell akSpell, Bool abVerbose = True) native
Function RemoveSpell(Spell akSpell) native
Function DispelSpell(Spell akSpell) native
Bool Function HasPerk(Perk akPerk) native
Function AddPerk(Perk akPerk, Bool abNotify = True) native
Function RemovePerk(Perk akPerk) native
'@
    'GlobalVariable.psc' = @'
Scriptname GlobalVariable extends Form Native Hidden
Float Function GetValue() native
Int Function GetValueInt() native
Function SetValue(Float afValue) native
'@
    'Spell.psc' = @'
Scriptname Spell extends Form Native Hidden
'@
    'Perk.psc' = @'
Scriptname Perk extends Form Native Hidden
'@
    'Game.psc' = @'
Scriptname Game Native Hidden
Actor Function GetPlayer() global native
Form Function GetFormFromFile(Int aiFormID, String asFileName) global native
'@
    'Utility.psc' = @'
Scriptname Utility Native Hidden
Function Wait(Float afHowLong) global native
'@
    'Debug.psc' = @'
Scriptname Debug Native Hidden
Function Notification(String asNotification, Bool abForce = False) global native
'@
}
foreach ($stub in $stubSources.GetEnumerator()) {
    Set-Content -LiteralPath (Join-Path $BuildSource $stub.Key) -Value $stub.Value -Encoding ASCII
}

$arguments = @($BuildSource, '-r', '-i', $BuildSource)
if (Test-Path -LiteralPath $Fo4Source) {
    $arguments += @('-i', $Fo4Source)
}
if (Test-Path -LiteralPath $F4seSource) {
    $arguments += @('-i', $F4seSource)
}
$arguments += @('-f', $FlagsFile, '-o', $BuildOutput)

& $CapricaExe @arguments *> $Log

if ($LASTEXITCODE -ne 0) {
    throw "Caprica failed with exit code $LASTEXITCODE."
}

Get-Content -LiteralPath $Log

if (!(Test-Path -LiteralPath (Join-Path $BuildOutput 'AozoraLGT_MainQuestScript.pex'))) {
    throw 'Compilation failed.'
}

Copy-Item -LiteralPath (Join-Path $BuildOutput 'AozoraLGT_MainQuestScript.pex') -Destination $Output -Force
'Compilation successful.'
