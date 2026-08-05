--Tables for any repeated checks. Just add more under FR_windowTable.
--Remember to add a comma behind the previous table!
local FR_tableStorage = {
FR_windowTable = {"Windshield", "WindshieldRear", "WindowFrontLeft", "WindowFrontRight", "WindowMiddleLeft", "WindowMiddleRight", "WindowRearLeft", "WindowRearRight"},
--Need to phase out FRCanvasRoof and FRConHardRoof, and maybe FRTTopRoof. Replace those with FRRemovableRoof.
FR_roofTypes = {"FRRoof", "FRConRoof"}
}
return FR_tableStorage