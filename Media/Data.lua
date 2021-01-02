local ADDON_NAME, MazeHelper = ...;
MazeHelper.M = {};
local M = MazeHelper.M;

local MEDIA_PATH = 'Interface\\AddOns\\' .. ADDON_NAME .. '\\Media\\';

M.Path = MEDIA_PATH;

M.INLINE_LEADER_ICON   = '|TInterface\\GroupFrame\\UI-Group-LeaderIcon:16|t';
M.INLINE_TANK_ICON     = _G.INLINE_TANK_ICON;
M.INLINE_HEALER_ICON   = _G.INLINE_HEALER_ICON;
M.INLINE_INFINITY_ICON = '|T' .. MEDIA_PATH .. 'icons32.blp:14:14:0:0:128:64:64:96:32:64|t';

M.INLINE_ENTRANCE_ICON = '|T' .. MEDIA_PATH .. 'icons32.blp:12:12:-1:1:128:64:96:128:32:64|t';

M.BACKGROUND_WHITE = MEDIA_PATH .. 'background-white.blp';
M.BBH = MEDIA_PATH .. 'bbh.blp';

M.Icons = {
    TEXTURE = MEDIA_PATH .. 'icons32.blp', -- 128x64

    COORDS = {
        MEGAPHONE_WHITE = {  0, 1/4,   0, 1/2},
        CROSS_WHITE     = {1/4, 2/4,   0, 1/2},
        SPANNER_WHITE   = {2/4, 3/4,   0, 1/2},
        GEAR_WHITE      = {3/4, 4/4,   0, 1/2},
        INFINITY_WHITE  = {2/4, 3/4, 1/2, 2/2},
        ENTRANCE        = {3/4, 4/4, 1/2, 2/2},

        CHECKBUTTON_CHECKED = {  0, 1/4, 1/2, 2/2},
        CHECKBUTTON_NORMAL  = {1/4, 2/4, 1/2, 2/2},
    },
};

M.Symbols = {
    TEXTURE = MEDIA_PATH .. 'symbols.blp', -- 256x256

    COORDS_WHITE = {
        LEAF_CIRCLE_FILL     = {0, 1/4, 0, 1/4},
        LEAF_CIRCLE_NOFILL   = {1/4, 2/4, 0, 1/4},
        LEAF_NOCIRCLE_FILL   = {0, 1/4, 1/4, 2/4},
        LEAF_NOCIRCLE_NOFILL = {1/4, 2/4, 1/4, 2/4},

        FLOWER_CIRCLE_FILL     = {2/4, 3/4, 0, 1/4},
        FLOWER_CIRCLE_NOFILL   = {3/4, 1, 0, 1/4},
        FLOWER_NOCIRCLE_FILL   = {2/4, 3/4, 1/4, 2/4},
        FLOWER_NOCIRCLE_NOFILL = {3/4, 1, 1/4, 2/4},
    },

    COORDS_COLOR = {
        LEAF_CIRCLE_FILL     = {0, 1/4, 2/4, 3/4},
        LEAF_CIRCLE_NOFILL   = {1/4, 2/4, 2/4, 3/4},
        LEAF_NOCIRCLE_FILL   = {0, 1/4, 3/4, 4/4},
        LEAF_NOCIRCLE_NOFILL = {1/4, 2/4, 3/4, 4/4},

        FLOWER_CIRCLE_FILL     = {2/4, 3/4, 2/4, 3/4},
        FLOWER_CIRCLE_NOFILL   = {3/4, 4/4, 2/4, 3/4},
        FLOWER_NOCIRCLE_FILL   = {2/4, 3/4, 3/4, 4/4},
        FLOWER_NOCIRCLE_NOFILL = {3/4, 1, 3/4, 4/4},
    },
};