local TTRPBridge = {}

print("[TTRPPoses] Server bridge loaded")

TTRPBridge.doEmote = function(player, args)
    player:setVariable("TTRPEmote", args.emote)
    
    sendServerCommand("TTRP", "doEmote", {
        id = player:getOnlineID(),
        emote = args.emote
    })
end

TTRPBridge.cancelEmote = function(player, args)
    player:setVariable("TTRPEmote", args.emote)
    
    sendServerCommand("TTRP", "cancelEmote", {
        id = player:getOnlineID(),
        emote = args.emote
    })
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module == "TTRP" and TTRPBridge[command] then
        TTRPBridge[command](player, args)
    end
end)
