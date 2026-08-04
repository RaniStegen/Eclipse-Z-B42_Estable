require "ISUI/ISPanel"
require "Entity/ISUI/Controls/ISTableLayout"
require "Project_Cook/EvolvedRecipePanel/PJCK_EvoPanel"


PJCK_Window = ISPanel:derive("PJCK_Window")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

-- ------------------------------------------------------ --
-- Update Items
-- ------------------------------------------------------ --

function PJCK_Window:needUpdate()
    local currentMovingState = self.player:isPlayerMoving()
    local currentInventoryWeight = self.player:getInventoryWeight()
    
    -- Weight Change
    if self.lastInventoryWeight ~= currentInventoryWeight then
        self.lastInventoryWeight = currentInventoryWeight
        return true
    end
    
    -- Moving Change
    local needUpdate = (self.lastPlayerMovingState == true and currentMovingState == false)
    self.lastPlayerMovingState = currentMovingState
    
    return needUpdate
end

function PJCK_Window:updateData()
    if self:needUpdate() then
        if self.EvoPanel then
            local containers = ISInventoryPaneContextMenu.getContainers(self.player)
            self.EvoPanel:setContainers(containers)
        end
    end
end

-- ----------------------------------------------------------------------------------------------------- --
-- initialise
-- ----------------------------------------------------------------------------------------------------- --
function PJCK_Window:initialise()
    ISPanel.initialise(self)
end

function PJCK_Window:new(x, y, width, height, player)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    
    o.player = player
    o.playerNum = player:getPlayerNum()
    o.moveWithMouse = true
    o.lastPlayerMovingState = nil
    o.lastInventoryWeight = nil
    o.headerHeight = math.floor(FONT_HGT_MEDIUM * 1.5)
    o.padding = math.floor(FONT_HGT_SMALL * 0.4)

    o.buttonTex = {
        bg = getTexture("media/ui/NeatUI/Button/Background.png"),
        border = getTexture("media/ui/NeatUI/Button/Boarder.png")
    }

    return o
end
-- ----------------------------------------------------------------------------------------------------- --
-- createChildren
-- ----------------------------------------------------------------------------------------------------- --
function PJCK_Window:createChildren()
    self:createHeader()
    self:createEvoPanel()
    
    self:updateData()
end

function PJCK_Window:createHeader()
    --Close Button
    self.closeButton = ISButton:new(0, 0, 50, 50, "", self, self.onCloseClick)
    self.closeButton:initialise()
    self.closeButton.prerender = function(btn)
        local color = btn:isMouseOver() and {r = 0.85, g = 0.25, b = 0.25} or {r = 0.8, g = 0.2, b = 0.2}
        btn:drawTextureScaled(self.buttonTex.bg, 0, 0, btn.width, btn.height, 0.8, color.r, color.g, color.b)
        btn:drawTextureScaled(self.buttonTex.border, 0, 0, btn.width, btn.height, 1, 0.4, 0.4, 0.4)
        btn:drawTextureScaled(getTexture("media/ui/Project_Cook/ICON/Icon_close.png"), 0, 0, btn.width, btn.height, 1, 0.8, 0.8, 0.8)

    end
    self:addChild(self.closeButton)
end

function PJCK_Window:createEvoPanel()
    if not PJCK_EvoPanel then
        require "Project_Cook/EvolvedRecipePanel/PJCK_EvoPanel"
    end
    if not PJCK_EvoPanel then
        require "Project_Cook/Cell/PJCK_BaseItemColumn"
        require "Project_Cook/Cell/PJCK_InputColumn"
        require "Project_Cook/EvolvedRecipePanel/PJCK_BaseItem"
        require "Project_Cook/EvolvedRecipePanel/PJCK_CookingInfo"
        require "Project_Cook/EvolvedRecipePanel/PJCK_InputPanel"
        require "Project_Cook/EvolvedRecipePanel/PJCK_InputToolbar"
        require "Project_Cook/EvolvedRecipePanel/PJCK_ItemSlot"
        require "Project_Cook/EvolvedRecipePanel/PJCK_BaseItemSlot"
        require "Project_Cook/EvolvedRecipePanel/PJCK_NutritionBlock"
        require "Project_Cook/EvolvedRecipePanel/PJCK_EvoPanel"
    end

    self.EvoPanel = PJCK_EvoPanel:new(0, 0, 50, 50, self)
    self.EvoPanel:initialise()
    self:addChild(self.EvoPanel)
end

function PJCK_Window:calculateLayout(_preferredWidth, _preferredHeight)
    local width = math.max(_preferredWidth,self.width)
    local height = math.max(_preferredHeight,self.height)

    local buttonSize = FONT_HGT_MEDIUM
    if self.EvoPanel then
        self.EvoPanel:setX(0)
        self.EvoPanel:setY(self.headerHeight)
        self.EvoPanel:calculateLayout(width,height)
    end

    width = math.max(width, self.EvoPanel:getWidth())
    height = math.max(height, self.EvoPanel:getHeight() + self.headerHeight)

    if self.closeButton then
        self.closeButton:setX(width - buttonSize - FONT_HGT_SMALL/2)
        self.closeButton:setY(math.floor((self.headerHeight - buttonSize) / 2))
        self.closeButton:setWidth(buttonSize)
        self.closeButton:setHeight(buttonSize)
    end
    
    self:setWidth(width)
    self:setHeight(height)
end

-- ----------------------------------------------------------------------------------------------------- --
-- Mouse Function
-- ----------------------------------------------------------------------------------------------------- --
function PJCK_Window:onMouseMove(dx, dy)
    if self.moving then
        self:setX(self.x + dx)
        self:setY(self.y + dy)
        return true
    end
    return false
end

function PJCK_Window:onMouseMove(dx, dy)
    if self.moving then
        self:setX(self.x + dx)
        self:setY(self.y + dy)
        return true
    end
    return false
end

function PJCK_Window:onMouseMoveOutside(dx, dy)
    if self.moving then
        self:setX(self.x + dx)
        self:setY(self.y + dy)
        return true
    end
    return false
end

function PJCK_Window:onMouseUp(x, y)
    if self.moving then
        self.moving = false
        return true
    end
    return false
end

function PJCK_Window:onMouseUpOutside(x, y)
    if self.moving then
        self.moving = false
        return true
    end
    return false
end

function PJCK_Window:onCloseClick()

    PJCK_CookingUI.OnCloseWindow(self)

    self:setVisible(false)
    self:removeFromUIManager()
end

function PJCK_Window:update()
    ISPanel.update(self)
    self:updateData()
end

-- ----------------------------------------------------------------------------------------------------- --
-- Render
-- ----------------------------------------------------------------------------------------------------- --
function PJCK_Window:prerender()
    local contentBG = NinePatchTexture.getSharedTexture("media/ui/NeatUI/DefaultPanel/MainPanelBG_FlatTop.png")
    local TitleBG = NinePatchTexture.getSharedTexture("media/ui/NeatUI/DefaultPanel/MainTitle_BG.png")
    if contentBG and TitleBG then
        contentBG:render(self:getAbsoluteX(), self:getAbsoluteY() + self.headerHeight, self.width, self.height - self.headerHeight, 0.15, 0.15, 0.15, 1)
        TitleBG:render(self:getAbsoluteX(), self:getAbsoluteY(), self.width, self.headerHeight, 0.08, 0.08, 0.08, 1)
    end
    self:drawRect(0, self.headerHeight - 1, self.width, 1, 1, 0, 0, 0)

    -- Header Render
    local iconSize = math.floor(FONT_HGT_MEDIUM / 16) * 16
    self:drawTextureScaled(getTexture("media/ui/Project_Cook/ICON/Icon_Option.png"), self.padding, math.floor((self.headerHeight - iconSize) / 2), iconSize, iconSize, 1, 1, 1, 1)
    self:drawText("Project Cook",self.padding + iconSize + self.padding, math.floor((self.headerHeight - FONT_HGT_MEDIUM) / 2), 1, 1, 1, 1, UIFont.Medium)
end

return PJCK_Window