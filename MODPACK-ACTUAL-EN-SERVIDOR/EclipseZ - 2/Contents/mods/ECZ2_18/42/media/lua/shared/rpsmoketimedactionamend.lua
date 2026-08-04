require "TimedActions/ISBaseTimedAction"
local hasRPSmokeTimedAction = pcall(require, "TimedActions/RPSmokeTimedAction")

if hasRPSmokeTimedAction and RPSmokeTimedAction then
    -- Backup the original start function
    local originalRPSmokeTimedActionStart = RPSmokeTimedAction.start

    -- Override the start function
    function RPSmokeTimedAction:start()
        if originalRPSmokeTimedActionStart then
            originalRPSmokeTimedActionStart(self)
        end
        self:setActionAnim("TTRPSmoke")
    end
else
    print("[TTRPPoses] RPActions smoke action not found; skipping optional animation override.")
end
