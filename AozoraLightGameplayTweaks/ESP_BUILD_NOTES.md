# ESP Build Notes

目标插件：AozoraLightGameplayTweaks.esp

目标格式：.esp + ESL flag，也就是 ESPFE。

## 原则

不要使用 GMST 全局覆盖。所有功能都应只作用于玩家，配置由 MCM 写入当前存档使用的 Global。

## 固定 FormID 表

脚本和 MCM 使用下面的 compact FormID：

| FormID | EditorID | 类型 | 默认值/用途 |
| --- | --- | --- | --- |
| xx000800 | AozoraLGT_Global_EnableMod | GLOB | 1 |
| xx000802 | AozoraLGT_Global_NoCombatAP | GLOB | 0 |
| xx000803 | AozoraLGT_Global_UnlimitedCarryWeight | GLOB | 0 |
| xx000804 | AozoraLGT_Global_NoFallDamage | GLOB | 0 |
| xx000805 | AozoraLGT_MainQuest | QUST | Start Game Enabled，挂脚本 |
| xx000809 | AozoraLGT_Global_NonPAWaterBreathing | GLOB | 0 |
| xx00080A | AozoraLGT_UnlimitedCarryWeight_Ability | SPEL | 玩家负重 Ability |
| xx00080C | AozoraLGT_WaterBreathing_Ability | SPEL | 玩家水下呼吸 Ability |

脚本读取以下原版表单，不需要作为 Papyrus 属性绑定：

- Fallout4.esm|2A6FC crNoFallDamage

DLL 读取以下表单：

- AozoraLightGameplayTweaks.esp|800 总启用状态
- AozoraLightGameplayTweaks.esp|802 非战斗状态 AP 不消耗

## Quest

AozoraLGT_MainQuest

- Start Game Enabled：开
- 挂脚本：AozoraLGT_MainQuestScript
- 不需要填 Papyrus 属性

## Unlimited Carry Weight

AozoraLGT_UnlimitedCarryWeight_Ability

- Spell Type：Ability
- 常驻、无 UI 提示
- 使用 Value Modifier / Peak Value Modifier
- Actor Value：CarryWeight
- Magnitude：1000000000

## Water Breathing

AozoraLGT_WaterBreathing_Ability

- Spell Type：Ability
- 常驻、无 UI 提示
- 效果引用原版 AbWaterbreathing [MGEF:000E36FA]

## 行为说明

- AP 功能由 F4SE\Plugins\AozoraLightGameplayTweaks.dll 处理。
- 开启后，只阻止玩家在非战斗状态下的 ActionPoints 负向扣减。
- 进入战斗后恢复原版 AP 消耗。
- 水下呼吸、无跌落伤害、无限负重由 Papyrus 给玩家添加或移除对应效果。
