TacHold = TacHold or {}

TacHold.options = {
    PoseNormal = true,
    PoseHighReady = false,
    PoseLowReady = false,
	PoseGunResting = false,
    PoseVanilla = false
}

if ModOptions and ModOptions.getInstance then
    ModOptions:getInstance(TacHold.options, "TacHold", "TacHold")
end