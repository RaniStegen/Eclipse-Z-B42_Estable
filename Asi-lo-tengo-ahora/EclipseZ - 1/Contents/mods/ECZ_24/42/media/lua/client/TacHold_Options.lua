TacHold = TacHold or {}
TacHold.options = TacHold.options or {}

TacHold.initOptions = function()
    if not PZAPI or not PZAPI.ModOptions then
        print("TacHold warning: PZAPI ModOptions is not available. Using default settings.")
        TacHold.options.PoseNormal = { value = true }
        TacHold.options.PoseHighReady = { value = false }
        TacHold.options.PoseLowReady = { value = false }
        TacHold.options.PoseGunResting = { value = false }
        TacHold.options.PoseVanilla = { value = false }
        return
    end

    local options = PZAPI.ModOptions:create("TacHold", "TacHold")

    TacHold.options.PoseNormal =
        options:addTickBox("Tactical hold", "Tactical hold", true)

    TacHold.options.PoseHighReady =
        options:addTickBox("HighReady", "HighReady", false)

    TacHold.options.PoseLowReady =
        options:addTickBox("LowReady", "LowReady", false)

    TacHold.options.PoseGunResting =
        options:addTickBox("GunResting", "GunResting", false)

    TacHold.options.PoseVanilla =
        options:addTickBox("Vanilla", "Vanilla", false)

    TacHold.options.CycleKey =
        options:addKeyBind(
            "Cycle animation Key",
            "Cycle animation Key",
            Keyboard.KEY_U
        )
end

TacHold.initOptions()