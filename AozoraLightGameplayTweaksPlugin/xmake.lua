set_xmakever("3.0.0")

set_project("AozoraLightGameplayTweaks")
set_version("1.1.0")
set_arch("x64")
set_languages("c++23")
set_warnings("allextra")
set_encodings("utf-8")

add_rules("mode.debug", "mode.releasedbg", "mode.release")

includes("Y:/Games/MODCreation/Workspace/commonlibf4-frakkin64")

target("AozoraLightGameplayTweaks", function()
    add_rules("commonlibf4.plugin", {
        name = "AozoraLightGameplayTweaks",
        author = "Aozora",
        plugin_template = "commonlibf4-plugin.cpp.in"
    })

    add_files("src/**.cpp")
    add_includedirs("src")
end)
