EBFCopyPasteServer = EBFCopyPasteServer or {}
EBFCopyPasteServer.FidelityAudit = EBFCopyPasteServer.FidelityAudit or {}

EBFCopyPasteServer.FidelityAudit.version = 1

EBFCopyPasteServer.FidelityAudit.compareFields = {
    "objectClass",
    "objectName",
    "sprite",
    "isoType",
    "floor",
    "north",
    "index",
    "objectLayer",
    "needsSupportBeforePaste",
    "pasteStrategy",
    "category",
    "family",
    "subtype",
    "containerCount",
    "itemCount",
    "hasDeviceData",
    "hasWaterState",
    "hasFluid",
    "hasLightState",
    "hasLightSource",
    "controlledLightSourceCount",
    "hasModData",
    "modDataKeyCount",
    "hasOverlay",
    "attachedSpriteCount",
    "worldItemFullType",
    "worldItemOffX",
    "worldItemOffY",
    "worldItemOffZ",
    "lightActivated",
    "stateMethodCount",
    "spritePropertyCount",
}

function EBFCopyPasteServer.FidelityAudit.getCompareFields()
    return EBFCopyPasteServer.FidelityAudit.compareFields
end

