#include <cstddef>
#include <fstream>
#include <memory>
#include <string_view>

#include "RE/Fallout.h"
#include "F4SE/F4SE.h"
#include "F4SE/API.h"

#define AOZORALGT_EXPORT extern "C" [[maybe_unused]] __declspec(dllexport)

namespace
{
    constexpr auto MOD_FILE = "AozoraLightGameplayTweaks.esp";
    constexpr RE::TESFormID FORM_ENABLE_MOD = 0x00000800;
    constexpr RE::TESFormID FORM_AP_ASSIST = 0x00000802;
    constexpr std::size_t ACTOR_VALUE_OWNER_VTABLE_INDEX = 7;

    using ModActorValue_t = void(RE::ActorValueOwner*, RE::ACTOR_VALUE_MODIFIER, const RE::ActorValueInfo&, float);
    using RestoreActorValue_t = void(RE::ActorValueOwner*, const RE::ActorValueInfo&, float);

    std::unique_ptr<REL::THookVFT<ModActorValue_t>> g_playerModActorValueHook;
    std::unique_ptr<REL::THookVFT<RestoreActorValue_t>> g_playerRestoreActorValueHook;
    std::unique_ptr<REL::THookVFT<ModActorValue_t>> g_actorModActorValueHook;
    std::unique_ptr<REL::THookVFT<RestoreActorValue_t>> g_actorRestoreActorValueHook;
    std::unique_ptr<REL::THookVFT<ModActorValue_t>> g_refrModActorValueHook;
    std::unique_ptr<REL::THookVFT<RestoreActorValue_t>> g_refrRestoreActorValueHook;

    void Log(std::string_view a_message)
    {
        std::ofstream file("Data/F4SE/Plugins/AozoraLightGameplayTweaks.log", std::ios::app);
        if (file.is_open()) {
            file << a_message << '\n';
        }
    }

    RE::TESGlobal* LookupGlobal(RE::TESFormID a_formID)
    {
        auto* data = RE::TESDataHandler::GetSingleton();
        return data ? data->LookupForm<RE::TESGlobal>(a_formID, MOD_FILE) : nullptr;
    }

    float GetGlobalValue(RE::TESFormID a_formID, float a_defaultValue)
    {
        auto* global = LookupGlobal(a_formID);
        return global ? global->GetValue() : a_defaultValue;
    }

    bool IsGlobalOn(RE::TESFormID a_formID, bool a_defaultValue = false)
    {
        return GetGlobalValue(a_formID, a_defaultValue ? 1.0F : 0.0F) >= 0.5F;
    }

    bool IsCombatBlocked()
    {
        const auto* player = RE::PlayerCharacter::GetSingleton();
        return !player || player->playerInCombat;
    }

    bool ShouldBlockPlayerAPDrain(RE::ActorValueOwner* a_owner, const RE::ActorValueInfo& a_info, float a_delta)
    {
        if (a_delta >= 0.0F || !a_owner) {
            return false;
        }

        const auto* av = RE::ActorValue::GetSingleton();
        if (!av || &a_info != av->actionPoints) {
            return false;
        }

        if (!a_owner->GetIsPlayerOwner()) {
            return false;
        }

        return IsGlobalOn(FORM_ENABLE_MOD, true) && IsGlobalOn(FORM_AP_ASSIST, false) && !IsCombatBlocked();
    }

    void PlayerModActorValueHook(
        RE::ActorValueOwner* a_owner,
        RE::ACTOR_VALUE_MODIFIER a_modifier,
        const RE::ActorValueInfo& a_info,
        float a_delta)
    {
        if (ShouldBlockPlayerAPDrain(a_owner, a_info, a_delta)) {
            return;
        }

        return (*g_playerModActorValueHook)(a_owner, a_modifier, a_info, a_delta);
    }

    void ActorModActorValueHook(
        RE::ActorValueOwner* a_owner,
        RE::ACTOR_VALUE_MODIFIER a_modifier,
        const RE::ActorValueInfo& a_info,
        float a_delta)
    {
        if (ShouldBlockPlayerAPDrain(a_owner, a_info, a_delta)) {
            return;
        }

        return (*g_actorModActorValueHook)(a_owner, a_modifier, a_info, a_delta);
    }

    void RefrModActorValueHook(
        RE::ActorValueOwner* a_owner,
        RE::ACTOR_VALUE_MODIFIER a_modifier,
        const RE::ActorValueInfo& a_info,
        float a_delta)
    {
        if (ShouldBlockPlayerAPDrain(a_owner, a_info, a_delta)) {
            return;
        }

        return (*g_refrModActorValueHook)(a_owner, a_modifier, a_info, a_delta);
    }

    void PlayerRestoreActorValueHook(RE::ActorValueOwner* a_owner, const RE::ActorValueInfo& a_info, float a_amount)
    {
        if (ShouldBlockPlayerAPDrain(a_owner, a_info, a_amount)) {
            return;
        }

        return (*g_playerRestoreActorValueHook)(a_owner, a_info, a_amount);
    }

    void ActorRestoreActorValueHook(RE::ActorValueOwner* a_owner, const RE::ActorValueInfo& a_info, float a_amount)
    {
        if (ShouldBlockPlayerAPDrain(a_owner, a_info, a_amount)) {
            return;
        }

        return (*g_actorRestoreActorValueHook)(a_owner, a_info, a_amount);
    }

    void RefrRestoreActorValueHook(RE::ActorValueOwner* a_owner, const RE::ActorValueInfo& a_info, float a_amount)
    {
        if (ShouldBlockPlayerAPDrain(a_owner, a_info, a_amount)) {
            return;
        }

        return (*g_refrRestoreActorValueHook)(a_owner, a_info, a_amount);
    }

    void InstallHooks()
    {
        if (g_playerModActorValueHook) {
            return;
        }

        g_playerModActorValueHook = std::make_unique<REL::THookVFT<ModActorValue_t>>(
            "AozoraLGT PlayerCharacter ModActorValue",
            RE::VTABLE::PlayerCharacter[ACTOR_VALUE_OWNER_VTABLE_INDEX],
            6,
            PlayerModActorValueHook);
        g_playerModActorValueHook->Enable();

        g_playerRestoreActorValueHook = std::make_unique<REL::THookVFT<RestoreActorValue_t>>(
            "AozoraLGT PlayerCharacter RestoreActorValue",
            RE::VTABLE::PlayerCharacter[ACTOR_VALUE_OWNER_VTABLE_INDEX],
            8,
            PlayerRestoreActorValueHook);
        g_playerRestoreActorValueHook->Enable();

        g_actorModActorValueHook = std::make_unique<REL::THookVFT<ModActorValue_t>>(
            "AozoraLGT Actor ModActorValue",
            RE::VTABLE::Actor[ACTOR_VALUE_OWNER_VTABLE_INDEX],
            6,
            ActorModActorValueHook);
        g_actorModActorValueHook->Enable();

        g_actorRestoreActorValueHook = std::make_unique<REL::THookVFT<RestoreActorValue_t>>(
            "AozoraLGT Actor RestoreActorValue",
            RE::VTABLE::Actor[ACTOR_VALUE_OWNER_VTABLE_INDEX],
            8,
            ActorRestoreActorValueHook);
        g_actorRestoreActorValueHook->Enable();

        g_refrModActorValueHook = std::make_unique<REL::THookVFT<ModActorValue_t>>(
            "AozoraLGT TESObjectREFR ModActorValue",
            RE::VTABLE::TESObjectREFR[ACTOR_VALUE_OWNER_VTABLE_INDEX],
            6,
            RefrModActorValueHook);
        g_refrModActorValueHook->Enable();

        g_refrRestoreActorValueHook = std::make_unique<REL::THookVFT<RestoreActorValue_t>>(
            "AozoraLGT TESObjectREFR RestoreActorValue",
            RE::VTABLE::TESObjectREFR[ACTOR_VALUE_OWNER_VTABLE_INDEX],
            8,
            RefrRestoreActorValueHook);
        g_refrRestoreActorValueHook->Enable();
        Log("Installed AP hooks");
    }
}

AOZORALGT_EXPORT F4SE::PluginVersionData F4SEPlugin_Version = []() noexcept {
    F4SE::PluginVersionData v{};
    v.PluginVersion({ 1, 1, 0, 0 });
    v.PluginName("AozoraLightGameplayTweaks");
    v.AuthorName("Aozora");
    v.UsesAddressLibrary(true);
    v.UsesAddressLibraryNG(true);
    v.UsesSigScanning(false);
    v.IsLayoutDependent(true);
    v.IsLayoutDependentNG(true);
    v.HasNoStructUse(false);
    v.CompatibleVersions({
        F4SE::RUNTIME_1_10_162, F4SE::RUNTIME_1_10_163,
        F4SE::RUNTIME_1_10_980, F4SE::RUNTIME_1_10_984,
        F4SE::RUNTIME_1_11_137, F4SE::RUNTIME_1_11_159,
        F4SE::RUNTIME_1_11_169, F4SE::RUNTIME_1_11_191,
        F4SE::RUNTIME_1_11_221
    });
    return v;
}();

F4SE_PLUGIN_LOAD(const F4SE::LoadInterface* a_intfc)
{
    F4SE::Init(a_intfc, { .log = false, .hook = false });
    Log("Plugin load v1.1.0");
    InstallHooks();
    return true;
}

AOZORALGT_EXPORT bool F4SEPlugin_Query(const F4SE::QueryInterface* a_f4se, F4SE::PluginInfo* a_info)
{
    a_info->infoVersion = F4SE::PluginInfo::kVersion;
    a_info->name = "AozoraLightGameplayTweaks";
    a_info->version = 1;
    if (a_f4se->IsEditor()) {
        return false;
    }
    return a_f4se->RuntimeVersion() >= F4SE::RUNTIME_1_10_162;
}
