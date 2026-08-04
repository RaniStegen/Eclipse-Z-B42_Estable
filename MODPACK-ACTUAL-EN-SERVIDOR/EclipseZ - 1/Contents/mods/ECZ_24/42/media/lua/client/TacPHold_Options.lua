TacPHold = TacPHold or {}
TacPHold.options = TacPHold.options or {}

TacPHold.initOptions = function()
    if not PZAPI or not PZAPI.ModOptions then
        print("TacPHold warning: PZAPI ModOptions is not available. Using default settings.")
        TacPHold.options.PoseNormal = { value = true }
        TacPHold.options.PoseHighReady = { value = false }
        TacPHold.options.PoseLowReady = { value = false }
        TacPHold.options.PoseVanilla = { value = false }
        return
    end

    local options = PZAPI.ModOptions:create("TacPHold", "TacPHold")

    TacPHold.options.PoseNormal =
        options:addTickBox(
            "Tactical hold",
            "Tactical hold",
            true
        )

    TacPHold.options.PoseHighReady =
        options:addTickBox(
            "HighReady",
            "HighReady",
            false
        )
		
	TacPHold.options.PoseLowReady =
        options:addTickBox(
            "Low Ready",
            "Low Ready",
            false
        )
		
	TacPHold.options.PoseVanilla =
        options:addTickBox(
            "Vanilla",
            "Vanilla",
            false
        )
end

TacPHold.initOptions()
