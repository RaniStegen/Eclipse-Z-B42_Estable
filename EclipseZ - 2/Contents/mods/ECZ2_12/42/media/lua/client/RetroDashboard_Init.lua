-- RetroDashboard: client entry point.
RetroDashboard = RetroDashboard or {}

require "RetroDashboard/State"
require "RetroDashboard/Dashboard"

Events.OnGameStart.Add(function()
    RetroDashboard.scale = RetroDashboard.State.load().scale or 1.0
    print("[RetroDashboard] client loaded (v0.1.0) scale=" .. tostring(RetroDashboard.scale))
end)
