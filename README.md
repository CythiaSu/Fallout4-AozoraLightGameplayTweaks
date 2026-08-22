# Aozora Light Gameplay Tweaks

> Fallout 4 的玩家专属轻度便利调整，支持 MCM 配置，不修改全局游戏设置。  
> Lightweight player-only Fallout 4 gameplay tweaks with MCM control and no global game-setting edits.

**暂时不支持最新的 Fallout 4 AE 版本（1.11.240）。**
**The latest Fallout 4 AE version (1.11.240) is not supported at this time.**

[![Status](https://img.shields.io/badge/status-stable-2ea44f?style=for-the-badge)](RELEASE_NOTES_v1.1.0.md)
[![Release](https://img.shields.io/badge/release-v1.1.0-0969da?style=for-the-badge)](RELEASE_NOTES_v1.1.0.md)
[![Fallout 4](https://img.shields.io/badge/Fallout%204-1.10.163-4e73df?style=for-the-badge)](https://f4se.silverlock.org/)
[![Scope](https://img.shields.io/badge/scope-player--only-2da44e?style=for-the-badge)](#scope)
[![MCM](https://img.shields.io/badge/config-MCM-f0883e?style=for-the-badge)](#requirements)
[![License](https://img.shields.io/badge/license-Non--Commercial%20Open%20License-dc2626?style=for-the-badge)](LICENSE.md)

<p align="center">
  <b>[PLAYER] Player Only</b>&nbsp;&nbsp;·&nbsp;&nbsp;
  <b>[MCM] Save-Local Settings</b>&nbsp;&nbsp;·&nbsp;&nbsp;
  <b>[SAFE] No Global GMST Edits</b>
</p>

## 中文

青空轻度娱乐调整是一款轻量的 Fallout 4 玩家专属便利 MOD。所有功能通过 MCM 控制，配置跟随当前存档保存，不影响敌人或其他 NPC。

### 功能

| 标记 | 功能 |
|---|---|
| `[AP]` | 非战斗状态下阻止玩家 AP 消耗，进入战斗后恢复原版 AP 消耗 |
| `[OXYGEN]` | 玩家水下呼吸，动力甲和非动力甲状态都生效 |
| `[FALL]` | 玩家无跌落伤害 |
| `[WEIGHT]` | 玩家无限负重 |
| `[MCM]` | 随时开关功能并重新应用设置 |
| `[RESET]` | 一键关闭功能并移除本 MOD 添加的玩家效果 |

### 范围

- 只作用于玩家。
- 配置按当前存档保存。
- 不修改全局 GMST。
- 不改变敌人或其他 NPC。
- AP 功能只阻止玩家在非战斗状态下的负向 AP 修改。
- 进入战斗后，AP 消耗恢复原版行为。

### 前置要求

- Fallout 4。
- 与游戏版本匹配的 F4SE。
- Address Library for F4SE Plugins。
- Mod Configuration Menu，MCM。
- Microsoft Visual C++ x64 Redistributable。

不需要 GOE、Prisma UI Framework、LooksMenu 或任何 DLC。

### 仓库结构

```text
AozoraLightGameplayTweaks.esp          ESL-flagged plugin
AozoraLightGameplayTweaks/             MCM, Papyrus source, build notes
AozoraLightGameplayTweaksPlugin/       F4SE native plugin source and build files
tools/                                  ESP inspection and maintenance tools
```

### 构建

Papyrus 使用 Caprica 编译，原生插件使用 CommonLibF4、F4SE 和 xmake/MSVC 构建。构建脚本中的本机路径需要根据开发环境调整。

```text
AozoraLightGameplayTweaks/Compile_AozoraLGT.ps1
AozoraLightGameplayTweaksPlugin/build_dll.bat
```

ESP 是 ESL-flagged 插件。修改 ESP 记录或 FormID 后，需要同步检查 Papyrus、MCM 配置和构建说明。

### 版本

当前稳定基线为 `v1.1.0`。详细更新内容请查看 [RELEASE_NOTES_v1.1.0.md](RELEASE_NOTES_v1.1.0.md)。

## English

Aozora Light Gameplay Tweaks is a lightweight Fallout 4 convenience mod focused exclusively on the player. Every feature is controlled through MCM, settings are stored with the current save, and enemies or other NPCs are not affected.

### Features

| Marker | Feature |
|---|---|
| `[AP]` | Blocks negative player AP changes outside combat and restores vanilla AP costs in combat |
| `[OXYGEN]` | Gives the player water breathing in and out of power armor |
| `[FALL]` | Prevents fall damage for the player |
| `[WEIGHT]` | Provides unlimited carry weight for the player |
| `[MCM]` | Toggles and reapplies features at any time |
| `[RESET]` | Disables all features and removes effects added by this mod |

### Scope

- Player-only effects.
- Save-local configuration.
- No global GMST edits.
- No changes to enemies or other NPCs.
- AP assistance blocks only negative player AP changes outside combat.
- Vanilla AP behavior returns when combat begins.

### Requirements

- Fallout 4.
- F4SE matching the installed game runtime.
- Address Library for F4SE Plugins.
- Mod Configuration Menu, MCM.
- Microsoft Visual C++ x64 Redistributable.

GOE, Prisma UI Framework, LooksMenu, and any DLC are not required.

### Repository Layout

```text
AozoraLightGameplayTweaks.esp          ESL-flagged plugin
AozoraLightGameplayTweaks/             MCM, Papyrus source, and build notes
AozoraLightGameplayTweaksPlugin/       F4SE native plugin source and build files
tools/                                  ESP inspection and maintenance tools
```

### Build

Papyrus is compiled with Caprica. The native plugin uses CommonLibF4, F4SE, and an xmake/MSVC toolchain. The build scripts contain local paths that must be adjusted for each development environment.

```text
AozoraLightGameplayTweaks/Compile_AozoraLGT.ps1
AozoraLightGameplayTweaksPlugin/build_dll.bat
```

The ESP is ESL-flagged. After changing ESP records or FormIDs, re-check the Papyrus source, MCM configuration, and build notes together.

### Version

The current stable baseline is `v1.1.0`. See [RELEASE_NOTES_v1.1.0.md](RELEASE_NOTES_v1.1.0.md) for the release summary.

## License

This project uses a custom **Non-Commercial Open License**. Non-commercial use, modification, patches, forks, non-commercial mod packs, and redistribution are allowed with attribution. Commercial use, paid bundling, paid support, and selling modified or compiled versions require prior permission from the author.

本项目采用自定义的**非商业开放许可**。允许保留署名后的非商业使用、修改、补丁、分支、非商业整合包和再发布；商业使用、付费整合、付费支持以及销售修改版或编译版需要事先联系作者。

See [LICENSE.md](LICENSE.md) for the complete bilingual terms. / 完整双语条款请查看 [LICENSE.md](LICENSE.md)。

