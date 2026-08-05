require "CutThatTree/CTT_Core"

local MODULE = "CutThatTree"

function CutThatTree.sendTreeState(playerObj, tree, fallbackArgs)
    if not isServer() or not playerObj then return end

    local args = CutThatTree.getTreeStateArgs(tree, fallbackArgs)
    if not args then return end

    local tool = playerObj:getPrimaryHandItem()
    if tool then
        args.toolSharpness = CutThatTree.getToolSharpness(tool)
        args.toolCondition = CutThatTree.getToolConditionFraction(tool)
    end
    args.endurance = CutThatTree.getEndurance(playerObj)

    sendServerCommand(playerObj, MODULE, "TreeState", args)
end

local function onRequestTreeState(playerObj, args)
    local tree = CutThatTree.findTreeAt(args)
    CutThatTree.sendTreeState(playerObj, tree, args)
end

local function onClientCommand(module, command, playerObj, args)
    if module ~= MODULE then return end

    if command == "RequestTreeState" then
        onRequestTreeState(playerObj, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)
