require "ISUI/ISPanel"
require "ISUI/Building/ISBuildWindowHeader"

function ISBuildWindowHeader:createChildren()
    ISPanel.createChildren(self);

    if self.enableIcon then
        --local iconTex = self.entityStyle and self.entityStyle:getIcon();
        local style = self.styleIcon or "S_Image_BuildWindowHeaderIcon";
        self.icon = ISXuiSkin.build(self.xuiSkin, style, ISImage, 0, 0, 32, 32, iconTex);
        --self.icon.scaledWidth = self.iconSize;
        --self.icon.scaledHeight = self.iconSize;
        --self.icon.texture = self.entityStyle:getIcon();
        self.icon:initialise();
        self.icon:instantiate();
        self:addChild(self.icon);

        self.iconSize = self.icon:getHeight();
    else
        self.iconSize = 32;
    end

    local titleStr = getText("IGUI_Building");
    if self.titleStr then
        titleStr = self.titleStr;
    end

    local fontHeight = -1; -- <=0 sets label initial height to font
    local style = self.styleLabel or "S_Label_EntityHeaderTitle";
    self.title = ISXuiSkin.build(self.xuiSkin, style, ISLabel, 0, 0, fontHeight, titleStr, 1, 1, 1, 1, UIFont.Medium, true);
    self.title.origTitleStr = titleStr;
    self.title:initialise();
    self.title:instantiate();
    self:addChild(self.title);

    if self.enableInfoButton then --todo: and self.entityStyle and self.entityStyle:getDescription() then
        local style = self.styleButton or "S_Button_EntityHeaderInfo"
        self.buttonInfo = ISXuiSkin.build(self.xuiSkin, style, ISButton, 0, 0, 24, 24, "");
        --self.buttonInfo.image = self.iconInfo;
        self.buttonInfo.target = self;
        self.buttonInfo.onclick = ISBuildWindowHeader.onButtonClick;
        self.buttonInfo.enable = true;
        self.buttonInfo:initialise();
        self.buttonInfo:instantiate();
        self:addChild(self.buttonInfo);
    end
end
