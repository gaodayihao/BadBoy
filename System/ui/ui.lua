-- local DiesalTools = LibStub("DiesalTools-1.0")
-- local DiesalStyle = LibStub("DiesalStyle-1.0") 
local DiesalGUI = LibStub("DiesalGUI-1.0")
-- local DiesalMenu = LibStub("DiesalMenu-1.0")
-- local SharedMedia = LibStub("LibSharedMedia-3.0")

-- Global setup
br.ui = {}
br.ui.window = {}
br.ui.window.config = {}
br.ui.window.debug = {}
br.ui.window.help = {}
br.ui.window.profile = {}
br.spacing = 15

--[[ FROM PE ]]--

DiesalGUI:RegisterObjectConstructor("FontString", function()
    local self      = DiesalGUI:CreateObjectBase(Type)
    local frame     = CreateFrame('Frame',nil,UIParent)
    local fontString = frame:CreateFontString(nil, "OVERLAY", 'DiesalFontNormal')
    self.frame      = frame
    self.fontString = fontString
    self.SetParent = function(self, parent)
        self.frame:SetParent(parent)
    end
    self.OnRelease = function(self)
        self.fontString:SetText('')
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "FontString"
    return self
end, 1)

DiesalGUI:RegisterObjectConstructor("Rule", function()
    local self      = DiesalGUI:CreateObjectBase(Type)
    local frame     = CreateFrame('Frame',nil,UIParent)
    self.frame      = frame
    frame:SetHeight(1)
    frame.texture = frame:CreateTexture()
    frame.texture:SetTexture(0,0,0,0.5)
    frame.texture:SetAllPoints(frame)
    self.SetParent = function(self, parent)
        self.frame:SetParent(parent)
    end
    self.OnRelease = function(self)
        self:Hide()
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "Rule"
    return self
end, 1)

local statusBarStylesheet = {
    ['frame-texture'] = {
        type        = 'texture',
        layer       = 'BORDER',
        gradient    = 'VERTICAL',
        color       = '000000',
        alpha       = 0.7,
        alphaEnd    = 0.1,
        offset      = 0,
    }
}

DiesalGUI:RegisterObjectConstructor("StatusBar", function()
    local self  = DiesalGUI:CreateObjectBase(Type)
    local frame = CreateFrame('StatusBar',nil,UIParent)
    self.frame  = frame

    self:AddStyleSheet(statusBarStylesheet)

    frame.Left = frame:CreateFontString()
    frame.Left:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
    frame.Left:SetShadowColor(0,0,0, 0)
    frame.Left:SetShadowOffset(-1,-1)
    frame.Left:SetPoint("LEFT", frame)

    frame.Right = frame:CreateFontString()
    frame.Right:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
    frame.Right:SetShadowColor(0,0,0, 0)
    frame.Right:SetShadowOffset(-1,-1)

    frame:SetStatusBarTexture(1,1,1,0.8)
    frame:GetStatusBarTexture():SetHorizTile(false)
    frame:SetMinMaxValues(0, 100)
    frame:SetHeight(15)

    self.SetValue = function(self, value)
        self.frame:SetValue(value)
    end
    self.SetParent = function(self, parent)
        self.parent = parent
        self.frame:SetParent(parent)
        self.frame:SetPoint("LEFT", parent, "LEFT")
        self.frame:SetPoint("RIGHT", parent, "RIGHT")
        self.frame.Right:SetPoint("RIGHT", self.frame, "RIGHT", -2, 2)
        self.frame.Left:SetPoint("LEFT", self.frame, "LEFT", 2, 2)
    end
    self.OnRelease = function(self)
        self:Hide()
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "Rule"
    return self
end, 1)

-- Styles
local buttonStyleSheet = {
    ['frame-color'] = {
        type			= 'texture',
        layer			= 'BACKGROUND',
        color			= '2f353b',
        offset		= 0,
    },
    ['frame-highlight'] = {
        type			= 'texture',
        layer			= 'BORDER',
        gradient	= 'VERTICAL',
        color			= 'FFFFFF',
        alpha 		= 0,
        alphaEnd	= .1,
        offset		= -1,
    },
    ['frame-outline'] = {
        type			= 'outline',
        layer			= 'BORDER',
        color			= '000000',
        offset		= 0,
    },
    ['frame-inline'] = {
        type			= 'outline',
        layer			= 'BORDER',
        gradient	= 'VERTICAL',
        color			= 'ffffff',
        alpha 		= .02,
        alphaEnd	= .09,
        offset		= -1,
    },
    ['frame-hover'] = {
        type			= 'texture',
        layer			= 'HIGHLIGHT',
        color			= 'ffffff',
        alpha			= .1,
        offset		= 0,
    },
    ['text-color'] = {
        type			= 'Font',
        color			= 'b8c2cc',
    },
}
local arrowRight = {
    type            = 'texture',
    offset     = {-2,nil,-2,nil},
    height    = 16,
    width        = 16,
    alpha         = .7,
    texFile    = 'DiesalGUIcons',
    --texColor    = 'ffff00',
    texCoord    = {7,5,16,256,128},
}
local arrowLeft =    {
    type            = 'texture',
    offset     = {-2,nil,-2,nil},
    height    = 16,
    width        = 16,
    alpha         = .7,
    texFile    = 'DiesalGUIcons',
    --texColor    = 'ffff00',
    texCoord    = {8,5,16,256,128},
}