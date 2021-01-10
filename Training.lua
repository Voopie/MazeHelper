local ADDON_NAME, MazeHelper = ...;
local L, E, M = MazeHelper.L, MazeHelper.E, MazeHelper.M;

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
        set = {
            [1] = MazeHelper.ButtonsData[1],
            [2] = MazeHelper.ButtonsData[7],
            [3] = MazeHelper.ButtonsData[3],
            [4] = MazeHelper.ButtonsData[2],
        },
    },
    [2] = {
        solutionIndex = 4,
        set = {
            [1] = MazeHelper.ButtonsData[5],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[6],
            [4] = MazeHelper.ButtonsData[3],
        },
    },
    [3] = {
        solutionIndex = 1,
        set = {
            [1] = MazeHelper.ButtonsData[5],
            [2] = MazeHelper.ButtonsData[2],
            [3] = MazeHelper.ButtonsData[8],
            [4] = MazeHelper.ButtonsData[4],
        },
    },
    [4] = {
        solutionIndex = 1,
        set = {
            [1] = MazeHelper.ButtonsData[5],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[4],
            [4] = MazeHelper.ButtonsData[3],
        },
    },
    [5] = {
        solutionIndex = 4,
        set = {
            [1] = MazeHelper.ButtonsData[7],
            [2] = MazeHelper.ButtonsData[1],
            [3] = MazeHelper.ButtonsData[5],
            [4] = MazeHelper.ButtonsData[4],
        },
    },
    [6] = {
        solutionIndex = 1,
        set = {
            [1] = MazeHelper.ButtonsData[3],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[6],
            [4] = MazeHelper.ButtonsData[5],
        },
    },
    [7] = {
        solutionIndex = 3,
        set = {
            [1] = MazeHelper.ButtonsData[3],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[2],
            [4] = MazeHelper.ButtonsData[7],
        },
    },
    [8] = {
        solutionIndex = 3,
        set = {
            [1] = MazeHelper.ButtonsData[7],
            [2] = MazeHelper.ButtonsData[5],
            [3] = MazeHelper.ButtonsData[4],
            [4] = MazeHelper.ButtonsData[6],
        },
    },
    [9] = {
        solutionIndex = 3,
        set = {
            [1] = MazeHelper.ButtonsData[6],
            [2] = MazeHelper.ButtonsData[8],
            [3] = MazeHelper.ButtonsData[3],
            [4] = MazeHelper.ButtonsData[5],
        },
    },
    [10] = {
        solutionIndex = 3,
        set = {
            [1] = MazeHelper.ButtonsData[2],
            [2] = MazeHelper.ButtonsData[6],
            [3] = MazeHelper.ButtonsData[7],
            [4] = MazeHelper.ButtonsData[1],
        },
    },
    [11] = {
        solutionIndex = 2,
        set = {
            [1] = MazeHelper.ButtonsData[7],
            [2] = MazeHelper.ButtonsData[6],
            [3] = MazeHelper.ButtonsData[3],
            [4] = MazeHelper.ButtonsData[1],
        },
    },
    [12] = {
        solutionIndex = 4,
        set = {
            [1] = MazeHelper.ButtonsData[2],
            [2] = MazeHelper.ButtonsData[4],
            [3] = MazeHelper.ButtonsData[6],
            [4] = MazeHelper.ButtonsData[7],
        },
    },
    [13] = {
        solutionIndex = 4,
        set = {
            [1] = MazeHelper.ButtonsData[2],
            [2] = MazeHelper.ButtonsData[3],
            [3] = MazeHelper.ButtonsData[4],
            [4] = MazeHelper.ButtonsData[7],
        },
    },
    [14] = {
        solutionIndex = 4,
        set = {
            [1] = MazeHelper.ButtonsData[1],
            [2] = MazeHelper.ButtonsData[3],
            [3] = MazeHelper.ButtonsData[5],
            [4] = MazeHelper.ButtonsData[6],
        },
    },
    [15] = {
        solutionIndex = 1,
        set = {
            [1] = MazeHelper.ButtonsData[1],
            [2] = MazeHelper.ButtonsData[6],
            [3] = MazeHelper.ButtonsData[7],
            [4] = MazeHelper.ButtonsData[8],
        },
    },
    [16] = {
        solutionIndex = 2,
        set = {
            [1] = MazeHelper.ButtonsData[2],
            [2] = MazeHelper.ButtonsData[3],
            [3] = MazeHelper.ButtonsData[5],
            [4] = MazeHelper.ButtonsData[6],
        },
    },
};
local SetsCount = #Sets;

local SuccessSounds = {
    [1] = 154206,
    [2] = 154207,
    [3] = 154216,
};
local SuccessSoundsCount = #SuccessSounds;

local ErrorSounds = {
    [1] = 154217,
    [2] = 154222,
    [3] = 154223,
};
local ErrorSoundsCount = #ErrorSounds;

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

    local set = Sets[GetMegaRandomIndex(1, SetsCount)];

    for i = 1, MAX_BUTTONS do
        buttons[i].isSolution = set.solutionIndex == i;

        if buttons[i].isSolution then
            solutionButtonIndex = i;
        end

        buttons[i].Icon:SetTexCoord(unpack(set.set[i].coords));
        buttons[i]:SetUnactive();
    end
end

local function PlayRandomSuccessSound()
    if not MazeHelper.TrainingFrame.NoSoundButton:GetChecked() then
        PlaySound(SuccessSounds[GetSoundRandomIndex(1, SuccessSoundsCount)], SOUND_CHANNEL);
    end
end

local function PlayRandomErrorSound()
    if not MazeHelper.TrainingFrame.NoSoundButton:GetChecked() then
        PlaySound(ErrorSounds[GetSoundRandomIndex(1, ErrorSoundsCount)], SOUND_CHANNEL);
    end
end

MazeHelper.TrainingFrame = CreateFrame('Frame', 'ST_Maze_Helper_Training', UIParent);
PixelUtil.SetPoint(MazeHelper.TrainingFrame, 'CENTER', UIParent, 'CENTER', 0, FRAME_SIZE * 1.5);
PixelUtil.SetSize(MazeHelper.TrainingFrame, FRAME_SIZE + X_OFFSET * (MAX_BUTTONS - 1), BUTTON_SIZE + X_OFFSET);
MazeHelper.TrainingFrame:SetShown(false);

do
    local AnimationFadeInGroup = MazeHelper.TrainingFrame:CreateAnimationGroup();
    local fadeIn = AnimationFadeInGroup:CreateAnimation('Alpha');
    fadeIn:SetDuration(0.3);
    fadeIn:SetFromAlpha(0);
    fadeIn:SetToAlpha(1);
    fadeIn:SetStartDelay(0);

    MazeHelper.TrainingFrame:HookScript('OnShow', function()
        AnimationFadeInGroup:Play();
    end);

    local AnimationFadeOutGroup = MazeHelper.TrainingFrame:CreateAnimationGroup();
    local fadeOut = AnimationFadeOutGroup:CreateAnimation('Alpha');
    fadeOut:SetDuration(0.2);
    fadeOut:SetFromAlpha(1);
    fadeOut:SetToAlpha(0);
    fadeOut:SetStartDelay(0);

    AnimationFadeOutGroup:SetScript('OnFinished', function()
        MazeHelper.TrainingFrame:HideDefault();
    end);

    MazeHelper.TrainingFrame.HideDefault = MazeHelper.TrainingFrame.Hide;
    MazeHelper.TrainingFrame.Hide = function()
        AnimationFadeOutGroup:Play();
    end

    MazeHelper.TrainingFrame.SetShown = function(self, state)
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

MazeHelper.TrainingFrame.background = MazeHelper.TrainingFrame:CreateTexture(nil, 'BACKGROUND');
PixelUtil.SetPoint(MazeHelper.TrainingFrame.background, 'TOPLEFT', MazeHelper.TrainingFrame, 'TOPLEFT', -15, 8);
PixelUtil.SetPoint(MazeHelper.TrainingFrame.background, 'BOTTOMRIGHT', MazeHelper.TrainingFrame, 'BOTTOMRIGHT', 15, -38);
MazeHelper.TrainingFrame.background:SetTexture(M.BACKGROUND_WHITE);
MazeHelper.TrainingFrame.background:SetVertexColor(0.05, 0.05, 0.05);
MazeHelper.TrainingFrame.background:SetAlpha(0.85);

MazeHelper.TrainingFrame.TitleText = MazeHelper.TrainingFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal');
PixelUtil.SetPoint(MazeHelper.TrainingFrame.TitleText, 'BOTTOM', MazeHelper.TrainingFrame, 'TOP', 0, 4);
MazeHelper.TrainingFrame.TitleText:SetText(L['MAZE_HELPER_TRAINING_TITLE']);

MazeHelper.TrainingFrame.CloseButton = CreateFrame('Button', nil, MazeHelper.TrainingFrame);
PixelUtil.SetPoint(MazeHelper.TrainingFrame.CloseButton, 'TOPRIGHT', MazeHelper.TrainingFrame, 'TOPRIGHT', -8, -4);
PixelUtil.SetSize(MazeHelper.TrainingFrame.CloseButton, 10, 10);
MazeHelper.TrainingFrame.CloseButton:SetNormalTexture(M.Icons.TEXTURE);
MazeHelper.TrainingFrame.CloseButton:GetNormalTexture():SetTexCoord(unpack(M.Icons.COORDS.CROSS_WHITE));
MazeHelper.TrainingFrame.CloseButton:GetNormalTexture():SetVertexColor(0.7, 0.7, 0.7, 1);
MazeHelper.TrainingFrame.CloseButton:SetHighlightTexture(M.Icons.TEXTURE, 'BLEND');
MazeHelper.TrainingFrame.CloseButton:GetHighlightTexture():SetTexCoord(unpack(M.Icons.COORDS.CROSS_WHITE));
MazeHelper.TrainingFrame.CloseButton:GetHighlightTexture():SetVertexColor(1, 0.85, 0, 1);
MazeHelper.TrainingFrame.CloseButton:SetScript('OnClick', function()
    UpdateButtons();
    MazeHelper.TrainingFrame.PlayAgainButton:SetShown(false);
    MazeHelper.TrainingFrame:SetShown(false);

    MazeHelper.frame:SetShown(true);
end);

MazeHelper.TrainingFrame.NoSoundButton = CreateFrame('CheckButton', nil, MazeHelper.TrainingFrame);
PixelUtil.SetPoint(MazeHelper.TrainingFrame.NoSoundButton, 'BOTTOMRIGHT', MazeHelper.TrainingFrame, 'BOTTOMRIGHT', -8, 4);
PixelUtil.SetSize(MazeHelper.TrainingFrame.NoSoundButton, 12, 12);
MazeHelper.TrainingFrame.NoSoundButton:SetNormalTexture(M.Icons.TEXTURE);
MazeHelper.TrainingFrame.NoSoundButton:GetNormalTexture():SetTexCoord(unpack(M.Icons.COORDS.MUSIC_NOTE));
MazeHelper.TrainingFrame.NoSoundButton:GetNormalTexture():SetVertexColor(0.2, 0.8, 0.4, 1);
MazeHelper.TrainingFrame.NoSoundButton:SetHighlightTexture(M.Icons.TEXTURE, 'BLEND');
MazeHelper.TrainingFrame.NoSoundButton:GetHighlightTexture():SetTexCoord(unpack(M.Icons.COORDS.MUSIC_NOTE));
MazeHelper.TrainingFrame.NoSoundButton:GetHighlightTexture():SetVertexColor(1, 0.85, 0, 1);
MazeHelper.TrainingFrame.NoSoundButton:SetScript('OnClick', function()
    MHMOTSConfig.TrainingNoSound = MazeHelper.TrainingFrame.NoSoundButton:GetChecked();

    if MHMOTSConfig.TrainingNoSound then
        MazeHelper.TrainingFrame.NoSoundButton:GetNormalTexture():SetVertexColor(0.8, 0.2, 0.4, 1);
    else
        MazeHelper.TrainingFrame.NoSoundButton:GetNormalTexture():SetVertexColor(0.2, 0.8, 0.4, 1);
    end
end);

MazeHelper.TrainingFrame.PlayAgainButton = CreateFrame('Button', nil, MazeHelper.TrainingFrame, 'SharedButtonSmallTemplate');
PixelUtil.SetPoint(MazeHelper.TrainingFrame.PlayAgainButton, 'TOP', MazeHelper.TrainingFrame, 'BOTTOM', 0, -4);
MazeHelper.TrainingFrame.PlayAgainButton:SetText(L['MAZE_HELPER_TRAINING_PLAY_AGAIN']);
PixelUtil.SetSize(MazeHelper.TrainingFrame.PlayAgainButton, tonumber(MazeHelper.TrainingFrame.PlayAgainButton:GetTextWidth()) + 20, 22);
MazeHelper.TrainingFrame.PlayAgainButton:SetScript('OnClick', function(self)
    UpdateButtons();
    self:SetShown(false);
end);
MazeHelper.TrainingFrame.PlayAgainButton:SetShown(false);

local function CreateButton(index)
    local button = CreateFrame('Button', nil, MazeHelper.TrainingFrame, 'BackdropTemplate');

    if index == 1 then
        PixelUtil.SetPoint(button, 'LEFT', MazeHelper.TrainingFrame, 'LEFT', 20, 0);
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

    button.SetActive = function(self)
        self:SetBackdropBorderColor(0.4, 0.52, 0.95, 1);
    end

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

        MazeHelper.TrainingFrame.PlayAgainButton:SetShown(true);
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