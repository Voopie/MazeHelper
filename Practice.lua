local _, MazeHelper = ...;
local L, M = MazeHelper.L, MazeHelper.M;

local FRAME_SIZE = 300;
local X_OFFSET = 6;
local MAX_BUTTONS = 4;
local BUTTON_SIZE = 64;

local buttons = {};
local solutionButtonIndex;
local isLocked = false;

local SOUND_CHANNEL = 'Dialog';

local Sets = {
    [1] = {
        solutionIndex = 2,
        buttons = {
            [1] = MazeHelper.ButtonsData[1],
            [2] = MazeHelper.ButtonsData[7],
            [3] = MazeHelper.ButtonsData[3],
            [4] = MazeHelper.ButtonsData[2],
        },
    },
    [2] = {
        solutionIndex = 4,
        buttons = {
            [1] = MazeHelper.ButtonsData[5],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[6],
            [4] = MazeHelper.ButtonsData[3],
        },
    },
    [3] = {
        solutionIndex = 1,
        buttons = {
            [1] = MazeHelper.ButtonsData[5],
            [2] = MazeHelper.ButtonsData[2],
            [3] = MazeHelper.ButtonsData[8],
            [4] = MazeHelper.ButtonsData[4],
        },
    },
    [4] = {
        solutionIndex = 1,
        buttons = {
            [1] = MazeHelper.ButtonsData[5],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[4],
            [4] = MazeHelper.ButtonsData[3],
        },
    },
    [5] = {
        solutionIndex = 4,
        buttons = {
            [1] = MazeHelper.ButtonsData[7],
            [2] = MazeHelper.ButtonsData[1],
            [3] = MazeHelper.ButtonsData[5],
            [4] = MazeHelper.ButtonsData[4],
        },
    },
    [6] = {
        solutionIndex = 1,
        buttons = {
            [1] = MazeHelper.ButtonsData[3],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[6],
            [4] = MazeHelper.ButtonsData[5],
        },
    },
    [7] = {
        solutionIndex = 3,
        buttons = {
            [1] = MazeHelper.ButtonsData[3],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[2],
            [4] = MazeHelper.ButtonsData[7],
        },
    },
    [8] = {
        solutionIndex = 3,
        buttons = {
            [1] = MazeHelper.ButtonsData[7],
            [2] = MazeHelper.ButtonsData[5],
            [3] = MazeHelper.ButtonsData[4],
            [4] = MazeHelper.ButtonsData[6],
        },
    },
    [9] = {
        solutionIndex = 3,
        buttons = {
            [1] = MazeHelper.ButtonsData[6],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[3],
            [4] = MazeHelper.ButtonsData[5],
        },
    },
    [10] = {
        solutionIndex = 3,
        buttons = {
            [1] = MazeHelper.ButtonsData[2],
            [2] = MazeHelper.ButtonsData[6],
            [3] = MazeHelper.ButtonsData[7],
            [4] = MazeHelper.ButtonsData[1],
        },
    },
    [11] = {
        solutionIndex = 2,
        buttons = {
            [1] = MazeHelper.ButtonsData[7],
            [2] = MazeHelper.ButtonsData[6],
            [3] = MazeHelper.ButtonsData[3],
            [4] = MazeHelper.ButtonsData[1],
        },
    },
    [12] = {
        solutionIndex = 4,
        buttons = {
            [1] = MazeHelper.ButtonsData[2],
            [2] = MazeHelper.ButtonsData[4],
            [3] = MazeHelper.ButtonsData[6],
            [4] = MazeHelper.ButtonsData[7],
        },
    },
    [13] = {
        solutionIndex = 4,
        buttons = {
            [1] = MazeHelper.ButtonsData[2],
            [2] = MazeHelper.ButtonsData[3],
            [3] = MazeHelper.ButtonsData[4],
            [4] = MazeHelper.ButtonsData[7],
        },
    },
    [14] = {
        solutionIndex = 4,
        buttons = {
            [1] = MazeHelper.ButtonsData[1],
            [2] = MazeHelper.ButtonsData[3],
            [3] = MazeHelper.ButtonsData[5],
            [4] = MazeHelper.ButtonsData[6],
        },
    },
    [15] = {
        solutionIndex = 1,
        buttons = {
            [1] = MazeHelper.ButtonsData[1],
            [2] = MazeHelper.ButtonsData[6],
            [3] = MazeHelper.ButtonsData[7],
            [4] = MazeHelper.ButtonsData[8],
        },
    },
    [16] = {
        solutionIndex = 2,
        buttons = {
            [1] = MazeHelper.ButtonsData[2],
            [2] = MazeHelper.ButtonsData[3],
            [3] = MazeHelper.ButtonsData[5],
            [4] = MazeHelper.ButtonsData[6],
        },
    },
};
local SetsCount          = #Sets;
local SuccessSoundsCount = #M.Sounds.Mistcaller.Success;
local ErrorSoundsCount   = #M.Sounds.Mistcaller.Error;

local lastSoundIndex = 0;
local function GetSoundRandomIndex(m, n)
    local randomIndex = math.random(m, n);

    if randomIndex == lastSoundIndex then
        return GetSoundRandomIndex(m, n);
    end

    lastSoundIndex = randomIndex;

    return randomIndex;
end

local lastIndex = 0;
local function GetMegaRandomIndex(m, n)
    local randomIndex = math.random(m, n);

    if randomIndex == lastIndex then
        return GetMegaRandomIndex(m, n);
    end

    lastIndex = randomIndex;

    return randomIndex;
end

local function UpdateButtons()
    isLocked = false;
    solutionButtonIndex = nil;

    local set = Sets[GetMegaRandomIndex(1, SetsCount)];

    for i = 1, MAX_BUTTONS do
        buttons[i].isSolution = set.solutionIndex == i;

        if buttons[i].isSolution then
            solutionButtonIndex = i;
        end

        buttons[i].Icon:SetTexCoord(unpack(set.buttons[i].coords));
        buttons[i]:SetUnactive();
    end

    MazeHelper.PracticeFrame.PlayAgainButton:SetShown(false);
end

local function PlayRandomSuccessSound()
    if MHMOTSConfig.PracticeNoSound then
        return;
    end

    PlaySound(M.Sounds.Mistcaller.Success[GetSoundRandomIndex(1, SuccessSoundsCount)], SOUND_CHANNEL);
end

local function PlayRandomErrorSound()
    if MHMOTSConfig.PracticeNoSound then
        return;
    end

    PlaySound(M.Sounds.Mistcaller.Error[GetSoundRandomIndex(1, ErrorSoundsCount)], SOUND_CHANNEL);
end

MazeHelper.PracticeFrame = CreateFrame('Frame', 'ST_Maze_Helper_Practice', UIParent);
PixelUtil.SetPoint(MazeHelper.PracticeFrame, 'CENTER', UIParent, 'CENTER', 0, FRAME_SIZE * 1.5);
PixelUtil.SetSize(MazeHelper.PracticeFrame, FRAME_SIZE + X_OFFSET * (MAX_BUTTONS - 1), BUTTON_SIZE + X_OFFSET);
MazeHelper.PracticeFrame:SetShown(false);

-- Animation Show/Hide Fade
do
    local AnimationFadeInGroup = MazeHelper.PracticeFrame:CreateAnimationGroup();
    local fadeIn = AnimationFadeInGroup:CreateAnimation('Alpha');
    fadeIn:SetDuration(0.3);
    fadeIn:SetFromAlpha(0);
    fadeIn:SetToAlpha(1);
    fadeIn:SetStartDelay(0);

    MazeHelper.PracticeFrame:HookScript('OnShow', function()
        UpdateButtons();
        AnimationFadeInGroup:Play();
    end);

    local AnimationFadeOutGroup = MazeHelper.PracticeFrame:CreateAnimationGroup();
    local fadeOut = AnimationFadeOutGroup:CreateAnimation('Alpha');
    fadeOut:SetDuration(0.2);
    fadeOut:SetFromAlpha(1);
    fadeOut:SetToAlpha(0);
    fadeOut:SetStartDelay(0);

    AnimationFadeOutGroup:SetScript('OnFinished', function()
        MazeHelper.PracticeFrame:HideDefault();
    end);

    MazeHelper.PracticeFrame.HideDefault = MazeHelper.PracticeFrame.Hide;
    MazeHelper.PracticeFrame.Hide = function()
        AnimationFadeOutGroup:Play();
    end

    MazeHelper.PracticeFrame.SetShown = function(self, state)
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

MazeHelper.PracticeFrame.Background = MazeHelper.PracticeFrame:CreateTexture(nil, 'BACKGROUND');
PixelUtil.SetPoint(MazeHelper.PracticeFrame.Background, 'TOPLEFT', MazeHelper.PracticeFrame, 'TOPLEFT', -15, 8);
PixelUtil.SetPoint(MazeHelper.PracticeFrame.Background, 'BOTTOMRIGHT', MazeHelper.PracticeFrame, 'BOTTOMRIGHT', 15, -38);
MazeHelper.PracticeFrame.Background:SetTexture(M.BACKGROUND_WHITE);
MazeHelper.PracticeFrame.Background:SetVertexColor(0.05, 0.05, 0.05);
MazeHelper.PracticeFrame.Background:SetAlpha(0.85);

MazeHelper.PracticeFrame.TitleText = MazeHelper.PracticeFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal');
PixelUtil.SetPoint(MazeHelper.PracticeFrame.TitleText, 'BOTTOM', MazeHelper.PracticeFrame, 'TOP', 0, 4);
MazeHelper.PracticeFrame.TitleText:SetText(L['MAZE_HELPER_PRACTICE_TITLE']);

MazeHelper.PracticeFrame.CloseButton = CreateFrame('Button', nil, MazeHelper.PracticeFrame);
PixelUtil.SetPoint(MazeHelper.PracticeFrame.CloseButton, 'TOPRIGHT', MazeHelper.PracticeFrame, 'TOPRIGHT', -8, -4);
PixelUtil.SetSize(MazeHelper.PracticeFrame.CloseButton, 10, 10);
MazeHelper.PracticeFrame.CloseButton:SetNormalTexture(M.Icons.TEXTURE);
MazeHelper.PracticeFrame.CloseButton:GetNormalTexture():SetTexCoord(unpack(M.Icons.COORDS.CROSS_WHITE));
MazeHelper.PracticeFrame.CloseButton:GetNormalTexture():SetVertexColor(0.7, 0.7, 0.7, 1);
MazeHelper.PracticeFrame.CloseButton:SetHighlightTexture(M.Icons.TEXTURE, 'BLEND');
MazeHelper.PracticeFrame.CloseButton:GetHighlightTexture():SetTexCoord(unpack(M.Icons.COORDS.CROSS_WHITE));
MazeHelper.PracticeFrame.CloseButton:GetHighlightTexture():SetVertexColor(1, 0.85, 0, 1);
MazeHelper.PracticeFrame.CloseButton:SetScript('OnClick', function()
    MazeHelper.PracticeFrame:SetShown(false);
    MazeHelper.frame:SetShown(true);
end);

local function GameTooltip_NoSoundButton_Show(self)
    GameTooltip:SetOwner(self, 'ANCHOR_RIGHT');
    GameTooltip:AddLine(MHMOTSConfig.PracticeNoSound and SOUND_EFFECTS_DISABLED or SOUND_EFFECTS_ENABLED, 1, 0.85, 0, true);
    GameTooltip:Show();
end

MazeHelper.PracticeFrame.NoSoundButton = CreateFrame('CheckButton', nil, MazeHelper.PracticeFrame);
PixelUtil.SetPoint(MazeHelper.PracticeFrame.NoSoundButton, 'BOTTOMRIGHT', MazeHelper.PracticeFrame, 'BOTTOMRIGHT', -8, 4);
PixelUtil.SetSize(MazeHelper.PracticeFrame.NoSoundButton, 12, 12);
MazeHelper.PracticeFrame.NoSoundButton:SetNormalTexture(M.Icons.TEXTURE);
MazeHelper.PracticeFrame.NoSoundButton:GetNormalTexture():SetTexCoord(unpack(M.Icons.COORDS.MUSIC_NOTE));
MazeHelper.PracticeFrame.NoSoundButton:GetNormalTexture():SetVertexColor(0.2, 0.8, 0.4, 1);
MazeHelper.PracticeFrame.NoSoundButton:SetScript('OnClick', function(self)
    MHMOTSConfig.PracticeNoSound = MazeHelper.PracticeFrame.NoSoundButton:GetChecked();

    if MHMOTSConfig.PracticeNoSound then
        MazeHelper.PracticeFrame.NoSoundButton:GetNormalTexture():SetVertexColor(0.8, 0.2, 0.4, 1);
    else
        MazeHelper.PracticeFrame.NoSoundButton:GetNormalTexture():SetVertexColor(0.2, 0.8, 0.4, 1);
    end

    if GameTooltip:IsOwned(self) then
        GameTooltip_NoSoundButton_Show(self)
    end
end);
MazeHelper.PracticeFrame.NoSoundButton:HookScript('OnEnter', GameTooltip_NoSoundButton_Show);
MazeHelper.PracticeFrame.NoSoundButton:HookScript('OnLeave', GameTooltip_Hide);

MazeHelper.PracticeFrame.PlayAgainButton = CreateFrame('Button', nil, MazeHelper.PracticeFrame, 'SharedButtonSmallTemplate');
PixelUtil.SetPoint(MazeHelper.PracticeFrame.PlayAgainButton, 'TOP', MazeHelper.PracticeFrame, 'BOTTOM', 0, -4);
MazeHelper.PracticeFrame.PlayAgainButton:SetText(L['MAZE_HELPER_PRACTICE_PLAY_AGAIN']);
PixelUtil.SetSize(MazeHelper.PracticeFrame.PlayAgainButton, tonumber(MazeHelper.PracticeFrame.PlayAgainButton:GetTextWidth()) + 20, 22);
MazeHelper.PracticeFrame.PlayAgainButton:SetShown(false);
MazeHelper.PracticeFrame.PlayAgainButton:SetScript('OnClick', UpdateButtons);

local function CreateButton(index)
    local button = CreateFrame('Button', nil, MazeHelper.PracticeFrame, 'BackdropTemplate');

    if index == 1 then
        PixelUtil.SetPoint(button, 'LEFT', MazeHelper.PracticeFrame, 'LEFT', 20, 0);
    else
        PixelUtil.SetPoint(button, 'LEFT', buttons[index - 1], 'RIGHT', X_OFFSET, 0);
    end

    PixelUtil.SetSize(button, BUTTON_SIZE, BUTTON_SIZE);

    button.Icon = button:CreateTexture(nil, 'ARTWORK');
    PixelUtil.SetPoint(button.Icon, 'TOPLEFT', button, 'TOPLEFT', 4, -4);
    PixelUtil.SetPoint(button.Icon, 'BOTTOMRIGHT', button, 'BOTTOMRIGHT', -4, 4);
    button.Icon:SetTexture(M.Symbols.TEXTURE);

    button:SetBackdrop({
        insets   = { top = 1, left = 1, bottom = 1, right = 1 },
        edgeFile = 'Interface\\Buttons\\WHITE8x8',
        edgeSize = 2,
    });

    button.SetUnactive = function(self)
        self:SetBackdropBorderColor(0, 0, 0, 0);
    end

    button.SetError = function(self)
        self:SetBackdropBorderColor(0.8, 0.2, 0.4, 1);
    end

    button.SetSolution = function(self)
        self:SetBackdropBorderColor(0.2, 0.8, 0.4, 1);
    end

    button:SetUnactive();
    button:RegisterForClicks('LeftButtonUp');

    button:SetScript('OnClick', function(self)
        if isLocked then
            return;
        end

        isLocked = true;

        if self.isSolution then
            self:SetSolution();
            PlayRandomSuccessSound();
        else
            self:SetError();
            PlayRandomErrorSound();

            buttons[solutionButtonIndex]:SetSolution();
        end

        MazeHelper.PracticeFrame.PlayAgainButton:SetShown(true);
    end);

    table.insert(buttons, index, button);
end

local function CreateButtons()
    for i = 1, MAX_BUTTONS do
        CreateButton(i);
    end
end

CreateButtons();
UpdateButtons();