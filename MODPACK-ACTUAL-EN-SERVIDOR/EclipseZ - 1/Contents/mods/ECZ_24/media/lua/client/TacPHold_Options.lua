TacPHold = TacPHold or {}

TacPHold.options = {
    PoseNormal = true,
    PoseHighReady = false,
	PoseLowReady = false,
    PoseVanilla = false
}

if ModOptions and ModOptions.getInstance then
    ModOptions:getInstance(TacPHold.options, "TacPHold", "TacPHold")
end