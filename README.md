# Aozora Light Gameplay Tweaks

青空轻度娱乐调整是一个面向 Fallout 4 的轻量玩法便利 MOD，效果以玩家为目标，并通过 MCM 保存配置。

## Current scope

The repository contains the Fallout 4 plugin source, Papyrus source, MCM configuration, and build scripts.

仓库包含 Fallout 4 插件源代码、Papyrus 源码、MCM 配置和构建脚本。

The repository follows the official v1.1.0 feature set. Later input experiments are intentionally excluded from the source repository.

仓库只对应正式 v1.1.0 功能集，后续输入实验已明确排除，不会上传。

## Features

- Fast AP recovery outside combat, with vanilla AP costs restored in combat.
- 非战斗状态 AP 快速回复，进入战斗后恢复原版 AP 消耗。
- Water breathing for the player.
- 玩家水下呼吸。
- No fall damage for the player.
- 玩家无跌落伤害。
- Unlimited carry weight for the player.
- 玩家无限负重。

## Requirements

- Fallout 4
- Fallout 4 Script Extender (F4SE)
- Address Library for F4SE Plugins
- Mod Configuration Menu (MCM)

GOE, Prisma UI Framework, LooksMenu, and DLC are not required by this project.

本项目不需要 GOE、Prisma UI Framework、LooksMenu 或任何 DLC。

## Build layout

```text
AozoraLightGameplayTweaksPlugin/  Native F4SE plugin source
AozoraLightGameplayTweaks/         Papyrus source and MCM configuration
tools/                              ESP/default-value helper scripts
```

The native plugin uses CommonLibF4 and xmake. Papyrus scripts are compiled with Caprica through `Compile_AozoraLGT.ps1`.

原生插件使用 CommonLibF4 和 xmake 构建，Papyrus 脚本通过 `Compile_AozoraLGT.ps1` 调用 Caprica 编译。

## Scope and compatibility

The intended behavior is player-only and save-local. The project avoids global GMST edits for gameplay effects.

设计目标是仅作用于玩家，并按存档保存配置；玩法功能不会通过全局 GMST 修改世界规则。

Runtime compatibility depends on the Fallout 4 runtime, F4SE, Address Library, and MCM versions installed by the user.

实际兼容性取决于用户安装的 Fallout 4、F4SE、Address Library 和 MCM 版本组合。

Release archives and generated binaries are intentionally excluded from the source repository. The official v1.1.0 bilingual packages are prepared locally for manual release.

发布压缩包和生成的二进制文件不会提交到源码仓库；v1.1.0 中英双语包已在本地准备好，可手动发布。
