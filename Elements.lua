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

    -- Area - because i don't want to touch the original SetSize and it's just a synonym for Size and nothing else
    b.SetArea = function(self, width, height)
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

    PixelUtil.SetSize(scrollChild, scrollArea:GetWidth(),  scrollArea:GetHeight() - scrollStep);

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

E.CreateAnimation = function(frame, mode)
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