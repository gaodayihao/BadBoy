-- creates a fontstring with current UI settings at location within parent
function createTextString(parent,value,x,y,heigth,width)
	local scale = br.data.BadRotationsUI.optionsFrame.scale or 1
	_G[parent..value.."TextFrame"] = CreateFrame("Frame", _G[parent..value.."TextFrame"], _G[parent.."Frame"])
	_G[parent..value.."TextFrame"]:SetWidth(150*scale)
	_G[parent..value.."TextFrame"]:SetHeight(24*scale)
	_G[parent..value.."TextFrame"]:SetPoint("TOPLEFT",x*scale,y*scale)
	_G[parent..value.."TextFrame"]:SetAlpha(br.data.BadRotationsUI.alpha)
	--_G[parent..value.."TextFrame"]:Hide()
	_G[parent..value.."Text"] = _G[parent..value.."TextFrame"]:CreateFontString(_G[parent.."Frame"],"ARTWORK")
	_G[parent..value.."Text"]:SetWidth(width)
	_G[parent..value.."Text"]:SetHeight(heigth)
	_G[parent..value.."Text"]:SetPoint("TOPLEFT",0,0)
	_G[parent..value.."Text"]:SetAlpha(br.data.BadRotationsUI.alpha)
	_G[parent..value.."Text"]:SetJustifyH("LEFT")
	_G[parent..value.."Text"]:SetFont(br.data.BadRotationsUI.font,br.data.BadRotationsUI.fontsize*scale,"THICKOUTLINE")
	_G[parent..value.."Text"]:SetText(value, 1, 1, 1, 0.7)
end
-- creates a fontstring with current UI settings at location within parent
function createTitleString(parent,value,x,y)
	local scale = br.data.BadRotationsUI.optionsFrame.scale or 1
	_G[parent..value.."TitleFrame"] = CreateFrame("Frame", _G[parent..value.."TitleFrame"], _G[parent.."Frame"])
	_G[parent..value.."TitleFrame"]:SetWidth(257*scale)
	_G[parent..value.."TitleFrame"]:SetHeight(24*scale)
	_G[parent..value.."TitleFrame"]:SetPoint("TOPLEFT",x*scale,y*scale)
	_G[parent..value.."TitleFrame"]:SetAlpha(br.data.BadRotationsUI.alpha)
	--_G[parent..value.."TextFrame"]:Hide()
	_G[parent..value.."Text"] = _G[parent..value.."TitleFrame"]:CreateFontString(_G[parent.."Frame"],"ARTWORK")
	_G[parent..value.."Text"]:SetWidth(257*scale)
	_G[parent..value.."Text"]:SetHeight(24*scale)
	_G[parent..value.."Text"]:SetPoint("TOPLEFT",0,0)
	_G[parent..value.."Text"]:SetAlpha(br.data.BadRotationsUI.alpha)
	_G[parent..value.."Text"]:SetFont(br.data.BadRotationsUI.font,(br.data.BadRotationsUI.fontsize+2)*scale,"THICKOUTLINE")
	_G[parent..value.."Text"]:SetJustifyH("CENTER")
	_G[parent..value.."Text"]:SetText(value, 1, 1, 1, 0.7)
end
