local _, MazeHelper = ...;
MazeHelper.E = {};

local E = MazeHelper.E;
local M = MazeHelper.M;

E.CreateRoundedCheckButton = function(parent)
    local b = CreateFrame('CheckButton', nil, parent);

    b:SetNormalTexture(M.Icons.TEXTURE);
    b:GetNormalTexture():SetTexCoord(unpack(M.Icons.COORDS.CHECKBUTTON_NORMAL));
    b:SetCheckedTexture(M.Icons.TEXTURE);
    b:GetCheckedTexture():SetTexCoord(unpack(M.Icons.COORDS.CHECKBUTTON_CHECKED));
    b:SetHighlightTexture(M.Icons.TEXTURE);
    b:GetHighlightTexture():SetTexCoord(unpack(M.Icons.COORDS.CHECKBUTTON_NORMAL));

    b.Label = b:CreateFontString(nil, 'ARTWORK', 'GameFontNormal');
    PixelUtil.SetPoint(b.Label, 'LEFT', b, 'RIGHT', 6, 0);
    PixelUtil.SetSize(b.Label, 238, 12);
    b.Label:SetJustifyH('LEFT');

    b.SetLabel = function(self, label)
        self.Label:SetText(label);
        self:SetHitRectInsets(0, -1 * math.max(100, self.Label:GetStringWidth() + 4), 0, 0);
    end

    b.SetTooltip = function(self, tooltip)
        self.tooltip = tooltip;
    end

    b.SetPosition = function(self, point, relativeTo, relativePoint, offsetX, offsetY, minOffsetXPixels, minOffsetYPixels)
        PixelUtil.SetPoint(self, point, relativeTo, relativePoint, offsetX, offsetY, minOffsetXPixels, minOffsetYPixels);
    end

    b.SetSize = function(self, width, height)
        PixelUtil.SetSize(self, width, height);
    end

    b:HookScript('OnEnter', function(self)
        if not self.tooltip then
            return;
        end

        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT');
        GameTooltip:AddLine(self.tooltip, 1, 0.85, 0, true);
        GameTooltip:Show();
    end);

    b:HookScript('OnLeave', GameTooltip_Hide);

    b:SetSize(26, 26);

    return b;
end

E.CreateCheckButton = function(name, parent)
    local b = CreateFrame('CheckButton', name, parent, 'ChatConfigCheckButtonTemplate');

    b.Label = _G[b:GetName() .. 'Text'];
    PixelUtil.SetPoint(b.Label, 'LEFT', b, 'RIGHT', 4, 0);

    b.SetLabel = function(self, label)
        self.Label:SetText(label);
        self:SetHitRectInsets(0, -(self.Label:GetWidth() + 8), 0, 0);
    end

    b.SetPosition = function(self, point, relativeTo, relativePoint, offsetX, offsetY)
        PixelUtil.SetPoint(self, point, relativeTo, relativePoint, offsetX, offsetY);
    end

    b.SetTooltip = function(self, tooltip)
        self.tooltip = tooltip;
    end

    b:HookScript('OnEnter', function(self)
        if not self.tooltip then
            return;
        end

        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT');
        GameTooltip:AddLine(self.tooltip, 1, 0.85, 0, true);
        GameTooltip:Show();
    end);

    b:HookScript('OnLeave', GameTooltip_Hide);

    hooksecurefunc(b, 'SetEnabled', function(self, state)
        if state then
            self.Label:SetTextColor(1, 1, 1);
        else
            self.Label:SetTextColor(0.35, 0.35, 0.35);
        end
    end);

    hooksecurefunc(b, 'Enable', function(self)
        self.Label:SetTextColor(1, 1, 1);
    end);

    hooksecurefunc(b, 'Disable', function(self)
        self.Label:SetTextColor(0.35, 0.35, 0.35);
    end);

    return b;
end

E.CreateScrollFrame = function(parent, scrollStep)
    local scrollChild = CreateFrame('Frame', nil, parent);
    scrollChild.Data = {};

    local scrollArea = CreateFrame('ScrollFrame', '$parentScrollFrame', parent, 'UIPanelScrollFrameTemplate');
    PixelUtil.SetPoint(scrollArea, 'TOPLEFT', parent, 'TOPLEFT', 0, -8);
    PixelUtil.SetPoint(scrollArea, 'BOTTOMRIGHT', parent, 'BOTTOMRIGHT', -27, 20);

    scrollArea:SetScrollChild(scrollChild);

    PixelUtil.SetSize(scrollChild, scrollArea:GetWidth(), scrollArea:GetHeight() - scrollStep);

    scrollArea.scrollBarHideable = true;
    scrollArea.noScrollThumb     = false;

    local scrollbarName    = scrollArea:GetName();
    local scrollBar        = _G[scrollbarName .. 'ScrollBar'];
    local scrollUpButton   = _G[scrollbarName .. 'ScrollBarScrollUpButton'];
    local scrollDownButton = _G[scrollbarName .. 'ScrollBarScrollDownButton'];
    local scrollThumb      = _G[scrollbarName .. 'ScrollBarThumbTexture'];

    PixelUtil.SetPoint(scrollBar, 'TOPLEFT', scrollArea, 'TOPRIGHT', 6, -20);
    PixelUtil.SetPoint(scrollBar, 'BOTTOMLEFT', scrollArea, 'BOTTOMRIGHT', 6, 24);

    scrollBar.scrollStep = scrollStep;

    scrollUpButton:SetSize(1, 1);
    scrollUpButton:SetAlpha(0);

    scrollDownButton:SetSize(1, 1);
    scrollDownButton:SetAlpha(0);

    scrollThumb:SetTexture('Interface\\Buttons\\WHITE8x8');
    scrollThumb:SetSize(2, 64);
    scrollThumb:SetVertexColor(0.7, 0.7, 0.7, 1);

    scrollBar.isMouseIsDown = false;
    scrollBar.isMouseIsOver = false;

    scrollBar:HookScript('OnEnter', function(self)
        self.isMouseIsOver = true;
        C_Timer.After(0.1, function()
            if scrollBar:IsMouseOver() then
                scrollThumb:SetSize(6, 64)
                scrollThumb:SetVertexColor(1, 0.85, 0, 1);
            end
        end);
    end);

    scrollBar:HookScript('OnLeave', function(self)
        self.isMouseIsOver = false;
        if not self.isMouseIsDown then
            C_Timer.After(0.25, function()
                if not scrollBar:IsMouseOver() then
                    scrollThumb:SetSize(2, 64);
                    scrollThumb:SetVertexColor(0.7, 0.7, 0.7, 1);
                end
            end);
        end
    end);

    scrollBar:HookScript('OnMouseDown', function(self)
        self.isMouseIsDown = true;
        scrollThumb:SetSize(6, 64)
        scrollThumb:SetVertexColor(1, 0.85, 0, 1);
    end);

    scrollBar:HookScript('OnMouseUp', function(self)
        self.isMouseIsDown = false;
        if not self.isMouseIsOver then
            C_Timer.After(0.25, function()
                scrollThumb:SetSize(2, 64);
                scrollThumb:SetVertexColor(0.7, 0.7, 0.7, 1);
            end);
        end
    end);

    scrollBar:EnableMouse(true);
    scrollBar:HookScript('OnMouseWheel', function(self, value)
        ScrollFrameTemplate_OnMouseWheel(self, value, self);
    end);

    ScrollFrame_OnLoad(scrollArea);

    return scrollChild, scrollArea;
end

E.CreateAnimation = function(frame)
    if not frame then
        return;
    end

    local AnimationFadeInGroup = frame:CreateAnimationGroup();
    local fadeIn = AnimationFadeInGroup:CreateAnimation('Alpha');
    fadeIn:SetDuration(0.3);
    fadeIn:SetFromAlpha(0);
    fadeIn:SetToAlpha(1);
    fadeIn:SetStartDelay(0);

    frame:HookScript('OnShow', function()
        AnimationFadeInGroup:Play();
    end);

    local AnimationFadeOutGroup = frame:CreateAnimationGroup();
    local fadeOut = AnimationFadeOutGroup:CreateAnimation('Alpha');
    fadeOut:SetDuration(0.2);
    fadeOut:SetFromAlpha(1);
    fadeOut:SetToAlpha(0);
    fadeOut:SetStartDelay(0);

    AnimationFadeOutGroup:SetScript('OnFinished', function()
        frame:HideDefault();
    end);

    frame.HideDefault = frame.Hide;
    frame.Hide = function()
        AnimationFadeOutGroup:Play();
    end

    frame.SetShown = function(self, state)
        if not state then
            if self:IsShown() then
                self:Hide();
            end
        else
            if not self:IsShown() then
                self:Show();
            end
        end
    end
end

local function SliderRound(val, minVal, valueStep)
    return math.floor((val - minVal) / valueStep + 0.5) * valueStep + minVal;
end

E.CreateSlider = function(name, parent)
    local slider  = CreateFrame('Slider', 'MazeHelper_Settings_' .. name .. 'Slider', parent, 'OptionsSliderTemplate');
    local editbox = CreateFrame('EditBox', '$parentEditBox', slider, 'InputBoxTemplate');

    slider:SetOrientation('HORIZONTAL');

    PixelUtil.SetPoint(slider.Low, 'TOPLEFT', slider, 'BOTTOMLEFT', 1, -1);
    PixelUtil.SetPoint(slider.High, 'TOPRIGHT', slider, 'BOTTOMRIGHT', -1, -1);
    PixelUtil.SetPoint(slider.Text, 'BOTTOMLEFT', slider, 'TOPLEFT', 1, 0);

    slider.Text:SetFontObject(GameFontNormal);

    slider.Thumb:SetSize(26, 26);
    slider.Thumb:SetTexture(M.Icons.TEXTURE);
    slider.Thumb:SetTexCoord(unpack(M.Icons.COORDS.CIRCLE_NORMAL));

    slider:HookScript('OnEnter', function(self)
        self.Thumb:SetTexCoord(unpack(M.Icons.COORDS.CIRCLE_HIGHLIGHT));
    end);

    slider:HookScript('OnLeave', function(self)
        self.Thumb:SetTexCoord(unpack(M.Icons.COORDS.CIRCLE_NORMAL));
    end);

    slider:SetBackdrop({
        bgFile   = 'Interface\\Buttons\\UI-SliderBar-Background',
        edgeFile = M.SLIDER_BORDER,
        tile     = true,
        tileEdge = true,
        tileSize = 8,
        edgeSize = 8,
        insets   = { left = 3, right = 3, top = 6, bottom = 6 },
    });

    slider.SetPosition = function(self, point, relativeTo, relativePoint, offsetX, offsetY)
        PixelUtil.SetPoint(self, point, relativeTo, relativePoint, offsetX, offsetY);
    end

    hooksecurefunc(slider, 'SetValue', function(self, value)
        self.currentValue = value;
    end);

    slider.SetTooltip = function(self, tooltip)
        self.tooltipText = tooltip;
    end

    slider.SetLabel = function(self, label)
        self.Text:SetText(label);
    end

    slider.SetValues = function(self, currentValue, minValue, maxValue, stepValue)
        self.currentValue = currentValue or 0;
        self.minValue     = minValue or 0;
        self.maxValue     = maxValue or 100;
        self.stepValue    = stepValue or 1;

        self:SetMinMaxValues(self.minValue, self.maxValue);
        self:SetStepsPerPage(self.stepValue);
        self:SetValueStep(self.stepValue);
        self:SetValue(SliderRound(self.currentValue, self.minValue, self.stepValue));

        self.Low:SetText(self.minValue);
        self.High:SetText(self.maxValue);

        self.editbox:SetText(SliderRound(self.currentValue, self.minValue, self.stepValue));
    end

    slider:SetScript('OnValueChanged', function(self, value)
        value = SliderRound(value, self.minValue, self.stepValue);
        self.currentValue = value;

        self.editbox:SetText(self.currentValue);

        if slider:IsDraggingThumb() and self.editbox:HasFocus() then
            self.editbox:ClearFocus();
        end

        if self.OnValueChangedCallback then
            self:OnValueChangedCallback(self.currentValue);
        end
    end);

    slider:SetScript('OnMouseUp', function(self)
        if self.OnMouseUpCallback then
            self:OnMouseUpCallback(self.currentValue);
        end
    end);

    editbox:ClearAllPoints();
    PixelUtil.SetPoint(editbox, 'TOP', slider, 'BOTTOM', 4, 2);
    PixelUtil.SetSize(editbox, 40, 30);

    editbox:SetFontObject(GameFontHighlight);
    editbox:SetAutoFocus(false);

    editbox.Left:Hide();
    editbox.Middle:Hide();
    editbox.Right:Hide();

    editbox.Background = CreateFrame('Frame', '$parentBackground', editbox, 'BackdropTemplate');
    PixelUtil.SetPoint(editbox.Background, 'TOPLEFT', editbox, 'TOPLEFT', -5, -4);
    PixelUtil.SetSize(editbox.Background, 41, 21);
    editbox.Background:SetFrameLevel(editbox:GetFrameLevel() - 1);
    editbox.Background:SetBackdrop({
        bgFile   = 'Interface\\Buttons\\WHITE8x8',
        insets   = { top = 1, left = 1, bottom = 1, right = 1 },
        edgeFile = 'Interface\\Buttons\\WHITE8x8',
        edgeSize = 1,
    });

    editbox.Background:SetBackdropColor(0.05, 0.05, 0.05, 1);
    editbox.Background:SetBackdropBorderColor(0.3, 0.3, 0.3, 1);

    editbox:SetScript('OnEnterPressed', function(self)
        self.lastValue = nil;
        self:ClearFocus();

        local value = tonumber(self:GetText());
        if value then
            value = math.min(value, self:GetParent().maxValue);
            value = math.max(value, self:GetParent().minValue);
        else
            value = self:GetParent().currentValue;
        end

        self:GetParent():SetValue(SliderRound(value, self:GetParent().minValue, self:GetParent().stepValue));
        if self:GetParent().Callback then
            self:GetParent():Callback(self:GetParent().currentValue);
        end

        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    end);

    editbox:SetScript('OnEditFocusGained', function(self)
        self.isFocused = true;
        self.lastValue = tonumber(self:GetNumber());
        self:HighlightText();
        self.Background:SetBackdropBorderColor(0.8, 0.8, 0.8, 1);
    end);

    editbox:SetScript('OnEditFocusLost', function(self)
        self.isFocused = false;
        if self.lastValue then
            self:SetText(SliderRound(self.lastValue, self:GetParent().minValue, self:GetParent().stepValue));
        end

        EditBox_ClearHighlight(self);
        self.Background:SetBackdropBorderColor(0.3, 0.3, 0.3, 1);
    end);

    editbox:HookScript('OnEnter', function(self)
        if not self.isFocused then
            self.Background:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
        end

        if not self:GetParent().tooltipText then
            return;
        end

        GameTooltip:SetOwner(self:GetParent(), 'ANCHOR_RIGHT');
        GameTooltip:AddLine(self:GetParent().tooltipText, 1, 0.85, 0, true);
        GameTooltip:Show();
    end);

    editbox:HookScript('OnLeave', function(self)
        if not self.isFocused then
            self.Background:SetBackdropBorderColor(0.3, 0.3, 0.3, 1);
        end

        GameTooltip_Hide();
    end);


    slider.editbox = editbox;

    slider:Show();

    return slider;
end