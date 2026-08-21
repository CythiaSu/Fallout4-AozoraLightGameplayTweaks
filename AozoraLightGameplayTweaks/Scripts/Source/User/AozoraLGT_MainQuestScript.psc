Scriptname AozoraLGT_MainQuestScript extends Quest

String ModFileName = "AozoraLightGameplayTweaks.esp"

Int FormEnableMod = 0x00000800
Int FormAPAssist = 0x00000802
Int FormUnlimitedCarryWeight = 0x00000803
Int FormNoFallDamage = 0x00000804
Int FormNonPAWaterBreathing = 0x00000809
Int FormCarryWeightAbility = 0x0000080A
Int FormWaterBreathingAbility = 0x0000080C

Int FormNoFallDamagePerk = 0x0002A6FC

Actor PlayerRef

Event OnQuestInit()
    PlayerRef = Game.GetPlayer()
    RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
    Utility.Wait(1.0)
    ApplySettings()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    PlayerRef = Game.GetPlayer()
    RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
    Utility.Wait(1.0)
    ApplySettings()
EndEvent

Function ApplySettings()
    EnsurePlayer()

    If !IsEnabled()
        RemoveAllEffects()
        Return
    EndIf

    ApplyCarryWeight()
    ApplyFallDamage()
    ApplyWaterBreathing()
EndFunction

Function EnsurePlayer()
    If PlayerRef == None
        PlayerRef = Game.GetPlayer()
    EndIf
EndFunction

Bool Function IsEnabled()
    Return IsGlobalOn(FormEnableMod, True)
EndFunction

Bool Function IsGlobalOn(Int aiFormID, Bool abDefault = False)
    GlobalVariable setting = Game.GetFormFromFile(aiFormID, ModFileName) as GlobalVariable
    If setting == None
        Return abDefault
    EndIf
    Return setting.GetValueInt() == 1
EndFunction

Function SetGlobalValue(Int aiFormID, Int aiValue)
    GlobalVariable setting = Game.GetFormFromFile(aiFormID, ModFileName) as GlobalVariable
    If setting
        setting.SetValue(aiValue)
    EndIf
EndFunction

Spell Function GetSpell(Int aiFormID)
    Return Game.GetFormFromFile(aiFormID, ModFileName) as Spell
EndFunction

Perk Function GetNoFallDamagePerk()
    Return Game.GetFormFromFile(FormNoFallDamagePerk, "Fallout4.esm") as Perk
EndFunction

Function ApplyCarryWeight()
    ApplySpellToggle(IsGlobalOn(FormUnlimitedCarryWeight), GetSpell(FormCarryWeightAbility))
EndFunction

Function ApplyFallDamage()
    Perk noFallPerk = GetNoFallDamagePerk()
    If noFallPerk == None
        Return
    EndIf

    If IsGlobalOn(FormNoFallDamage)
        If !PlayerRef.HasPerk(noFallPerk)
            PlayerRef.AddPerk(noFallPerk, False)
        EndIf
    Else
        If PlayerRef.HasPerk(noFallPerk)
            PlayerRef.RemovePerk(noFallPerk)
        EndIf
    EndIf
EndFunction

Function ApplyWaterBreathing()
    ApplySpellToggle(IsGlobalOn(FormNonPAWaterBreathing), GetSpell(FormWaterBreathingAbility))
EndFunction

Function ApplySpellToggle(Bool abEnabled, Spell akSpell)
    If akSpell == None
        Return
    EndIf

    If abEnabled
        If !PlayerRef.HasSpell(akSpell)
            PlayerRef.AddSpell(akSpell, False)
        EndIf
    Else
        RemoveSpellIfPresent(akSpell)
    EndIf
EndFunction

Function RemoveAllEffects()
    EnsurePlayer()
    RemoveSpellIfPresent(GetSpell(FormCarryWeightAbility))
    RemoveSpellIfPresent(GetSpell(FormWaterBreathingAbility))

    Perk noFallPerk = GetNoFallDamagePerk()
    If noFallPerk && PlayerRef.HasPerk(noFallPerk)
        PlayerRef.RemovePerk(noFallPerk)
    EndIf
EndFunction

Function RemoveSpellIfPresent(Spell akSpell)
    If akSpell
        If PlayerRef.HasSpell(akSpell)
            PlayerRef.RemoveSpell(akSpell)
        EndIf
        PlayerRef.DispelSpell(akSpell)
    EndIf
EndFunction

Function MCM_ReapplySettings()
    ApplySettings()
EndFunction

Function MCM_ResetSettings()
    SetGlobalValue(FormEnableMod, 1)
    SetGlobalValue(FormAPAssist, 0)
    SetGlobalValue(FormUnlimitedCarryWeight, 0)
    SetGlobalValue(FormNoFallDamage, 0)
    SetGlobalValue(FormNonPAWaterBreathing, 0)
    RemoveAllEffects()
    Debug.Notification("青空轻度娱乐调整：已恢复原版配置 / Vanilla settings restored.")
EndFunction
