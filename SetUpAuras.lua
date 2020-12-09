local KHMRaidFrames = LibStub("AceAddon-3.0"):GetAddon("KHMRaidFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("KHMRaidFrames")

local positions = {
    ["TOPLEFT"] = L["TOPLEFT"],
    ["LEFT"] = L["LEFT"],
    ["BOTTOMLEFT"] = L["BOTTOMLEFT"],
    ["BOTTOM"] = L["BOTTOM"],
    ["BOTTOMRIGHT"] = L["BOTTOMRIGHT"],
    ["RIGHT"] = L["RIGHT"],
    ["TOPRIGHT"] = L["TOPRIGHT"],
    ["TOP"] = L["TOP"],
    ["CENTER"] = L["CENTER"],
}

local grow_positions = {
    ["LEFT"] = L["LEFT"],
    ["BOTTOM"] = L["BOTTOM"],
    ["RIGHT"] = L["RIGHT"],
    ["TOP"] = L["TOP"],
}

function KHMRaidFrames:SetupBuffFrames(db, groupType)
    local options = {
        ["num"] = {
            name = L["Num"],
            desc = "",
            width = "normal",
            type = "range",
            min = 0,
            max = 10,
            step = 1,
            order = 1,
            set = function(info,val)
                db.num = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.num end
        },
        ["size"] = {
            name = L["Size"],
            desc = "",
            width = "double",
            type = "range",
            min = 1,
            max = 100,
            step = 1,
            order = 1,
            set = function(info,val)
                db.size = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.size end
        },
        ["numInRow"] = {
            name = L["Num In Row"],
            desc = "",
            width = "normal",
            type = "range",
            min = 1,
            max = 10,
            step = 1,
            order = 2,
            set = function(info,val)
                db.numInRow = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.numInRow end
        },
        ["xOffset"] = {
            name = L["X Offset"],
            desc = "",
            width = "normal",
            type = "range",
            min = -200,
            max = 200,
            step = 1,
            order = 2,
            set = function(info,val)
                db.xOffset = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.xOffset end
        },
        ["yOffset"] = {
            name = L["Y Offset"],
            desc = "",
            width = "normal",
            type = "range",
            min = -200,
            max = 200,
            step = 1,
            order = 2,
            set = function(info,val)
                db.yOffset = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.yOffset end
        },
        ["AnchorPoint"] = {
            name = L["Anchor Point"],
            desc = "",
            width = "normal",
            type = "select",
            values = positions,
            order = 3,
            set = function(info,val)
                db.anchorPoint = val
                db.rowsGrowDirection = self.rowsGrows[val][db.growDirection]
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.anchorPoint end
        },
        ["GrowDirection"] = {
            name = L["Grow Direction"],
            desc = "",
            width = "normal",
            type = "select",
            values = grow_positions,
            order = 3,
            set = function(info,val)
                db.growDirection = val
                db.rowsGrowDirection = self.rowsGrows[db.anchorPoint][val]
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.growDirection end
        },
        ["alpha"] = {
            name = L["Transparency"],
            desc = "",
            width = "normal",
            type = "range",
            min = 0.1,
            max = 1.0,
            step = 0.1,
            order = 4,
            set = function(info,val)
                db.alpha = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.alpha end
        },
        ["Reskin"] = {
            name = L["Masque Reskin"],
            desc = "",
            width = "normal",
            type = "execute",
            order = 5,
            hidden = function() return not self.Masque end,
            func = function(info,val)
                self.Masque.buffFrames:ReSkin()
            end,
        },
        ["Skip3"] = {
            type = "header",
            name = L["Block List"],
            order = 6,
        },
        ["exclude"] = {
            name = L["Exclude"],
            desc = L["Exclude auras"],
            usage = self:TrackingHelpText(),
            width = "full",
            type = "input",
            multiline = 5,
            order = 7,
            set = function(info,val)
                db.exclude = self:SanitizeStrings(val)
                db.excludeStr = val

                self:SafeRefresh(groupType)
            end,
            get = function(info)
                return db.excludeStr
            end
        },
        ["Copy"] = {
            name = L["Copy settings to |cFFffd100<text>|r"]:gsub("<text>", groupType == "party" and L["Raid"] or L["Party"]),
            desc = L["Copy settings to |cFFffd100<text>|r"]:gsub("<text>", groupType == "party" and L["Raid"] or L["Party"]),
            width = "normal",
            type = "execute",
            order = 8,
            confirm = true,
            func = function(info,val)
                self:CopySettings(db, self.db.profile[self.ReverseGroupType(groupType)].buffFrames)
            end,
        },
        ["Reset"] = {
            name = L["Reset to Default"],
            desc = "",
            width = "double",
            type = "execute",
            order = 8,
            confirm = true,
            func = function(info,val)
                self:RestoreDefaults(groupType, "buffFrames")
            end,
        },
    }
    return options
end

function KHMRaidFrames:SetupDebuffFrames(db, groupType)

    local options = {
        ["num"] = {
            name = L["Num"],
            desc = "",
            width = "normal",
            type = "range",
            min = 0,
            max = 10,
            step = 1,
            order = 1,
            set = function(info,val)
                db.num = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.num end
        },
        ["size"] = {
            name = L["Size"],
            desc = "",
            width = "double",
            type = "range",
            min = 1,
            max = 100,
            step = 1,
            order = 1,
            set = function(info,val)
                db.size = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.size end
        },
        ["numInRow"] = {
            name = L["Num In Row"],
            desc = "",
            width = "normal",
            type = "range",
            min = 1,
            max = 10,
            step = 1,
            order = 2,
            set = function(info,val)
                db.numInRow = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.numInRow end
        },
        ["xOffset"] = {
            name = L["X Offset"],
            desc = "",
            width = "normal",
            type = "range",
            min = -200,
            max = 200,
            step = 1,
            order = 2,
            set = function(info,val)
                db.xOffset = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.xOffset end
        },
        ["yOffset"] = {
            name = L["Y Offset"],
            desc = "",
            width = "normal",
            type = "range",
            min = -200,
            max = 200,
            step = 1,
            order = 2,
            set = function(info,val)
                db.yOffset = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.yOffset end
        },
        ["AnchorPoint"] = {
            name = L["Anchor Point"],
            desc = "",
            width = "normal",
            type = "select",
            values = positions,
            order = 3,
            set = function(info,val)
                db.anchorPoint = val
                db.rowsGrowDirection = self.rowsGrows[val][db.growDirection]
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.anchorPoint end
        },
        ["GrowDirection"] = {
            name = L["Grow Direction"],
            desc = "",
            width = "normal",
            type = "select",
            values = grow_positions,
            order = 3,
            set = function(info,val)
                db.growDirection = val
                db.rowsGrowDirection = self.rowsGrows[db.anchorPoint][val]
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.growDirection end
        },
        ["alpha"] = {
            name = L["Transparency"],
            desc = "",
            width = "normal",
            type = "range",
            min = 0.1,
            max = 1.0,
            step = 0.1,
            order = 4,
            set = function(info,val)
                db.alpha = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.alpha end
        },
        ["Reskin"] = {
            name = L["Masque Reskin"],
            desc = "",
            width = "normal",
            type = "execute",
            order = 5,
            hidden = function() return not self.Masque end,
            func = function(info,val)
                self.Masque.debuffFrames:ReSkin()
            end,
        },
        ["Skip2"] = {
            type = "header",
            name = L["Big Debuffs"],
            order = 6,
        },
        ["Show Big Debuffs"] = {
            name = L["Show Big Debuffs"],
            desc = "",
            width = "normal",
            type = "toggle",
            order = 7,
            set = function(info,val)
                db.showBigDebuffs = val
                self:SafeRefresh(groupType)
            end,
            get = function(info)
                return db.showBigDebuffs
            end
        },
        ["Smart Anchoring"] = {
            name = L["Align Big Debuffs"],
            desc = L["Align Big Debuffs Desc"],
            width = "normal",
            type = "toggle",
            order = 8,
            disabled = function(info)
                return not db.showBigDebuffs
            end,
            set = function(info,val)
                db.smartAnchoring = val
                self:SafeRefresh(groupType)
            end,
            get = function(info)
                return db.smartAnchoring
            end
        },
        ["bigDebuffSize"] = {
            name = L["Size"],
            desc = "",
            width = "normal",
            type = "range",
            min = 1,
            max = 100,
            step = 1,
            order = 9,
            disabled = function(info)
                return not db.showBigDebuffs or db.smartAnchoring
            end,
            set = function(info,val)
                db.bigDebuffSize = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.bigDebuffSize end
        },
        ["Skip3"] = {
            type = "header",
            name = L["Block List"],
            order = 10,
        },
        ["exclude"] = {
            name = L["Exclude"],
            desc = L["Exclude auras"],
            usage = self:TrackingHelpText(),
            width = "full",
            type = "input",
            multiline = 5,
            order = 11,
            set = function(info,val)
                db.exclude = self:SanitizeStrings(val)
                db.excludeStr = val

                self:SafeRefresh(groupType)
            end,
            get = function(info)
                return db.excludeStr
            end
        },
        ["Copy"] = {
            name = L["Copy settings to |cFFffd100<text>|r"]:gsub("<text>", groupType == "party" and L["Raid"] or L["Party"]),
            desc = L["Copy settings to |cFFffd100<text>|r"]:gsub("<text>", groupType == "party" and L["Raid"] or L["Party"]),
            width = "normal",
            type = "execute",
            order = 12,
            confirm = true,
            func = function(info,val)
                self:CopySettings(db, self.db.profile[self.ReverseGroupType(groupType)].debuffFrames)
            end,
        },
        ["Reset"] = {
            name = L["Reset to Default"],
            desc = "",
            width = "double",
            type = "execute",
            order = 13,
            confirm = true,
            func = function(info,val)
                self:RestoreDefaults(groupType, "debuffFrames")
            end,
        },
    }
    return options
end

function KHMRaidFrames:SetupDispelldebuffFrames(db, groupType)

    local options = {
        ["num"] = {
            name = L["Num"],
            desc = "",
            width = "normal",
            type = "range",
            min = 0,
            max = 4,
            step = 1,
            order = 1,
            set = function(info,val)
                db.num = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.num end
        },
        ["size"] = {
            name = L["Size"],
            desc = "",
            width = "double",
            type = "range",
            min = 1,
            max = 100,
            step = 1,
            order = 1,
            set = function(info,val)
                db.size = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.size end
        },
        ["numInRow"] = {
            name = L["Num In Row"],
            desc = "",
            width = "normal",
            type = "range",
            min = 1,
            max = 4,
            step = 1,
            order = 2,
            set = function(info,val)
                db.numInRow = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.numInRow end
        },
        ["xOffset"] = {
            name = L["X Offset"],
            desc = "",
            width = "normal",
            type = "range",
            min = -200,
            max = 200,
            step = 1,
            order = 2,
            set = function(info,val)
                db.xOffset = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.xOffset end
        },
        ["yOffset"] = {
            name = L["Y Offset"],
            desc = "",
            width = "normal",
            type = "range",
            min = -200,
            max = 200,
            step = 1,
            order = 2,
            set = function(info,val)
                db.yOffset = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.yOffset end
        },
        ["AnchorPoint"] = {
            name = L["Anchor Point"],
            desc = "",
            width = "normal",
            type = "select",
            values = positions,
            order = 3,
            set = function(info,val)
                db.anchorPoint = val
                db.rowsGrowDirection = self.rowsGrows[val][db.growDirection]
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.anchorPoint end
        },
        ["GrowDirection"] = {
            name = L["Grow Direction"],
            desc = "",
            width = "normal",
            type = "select",
            values = grow_positions,
            order = 3,
            set = function(info,val)
                db.growDirection = val
                db.rowsGrowDirection = self.rowsGrows[db.anchorPoint][val]
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.growDirection end
        },
        ["alpha"] = {
            name = L["Transparency"],
            desc = "",
            width = "normal",
            type = "range",
            min = 0.1,
            max = 1.0,
            step = 0.1,
            order = 4,
            set = function(info,val)
                db.alpha = val
                self:SafeRefresh(groupType)
            end,
            get = function(info) return db.alpha end
        },
        ["Skip3"] = {
            type = "header",
            name = L["Block List"],
            order = 5,
        },
        ["exclude"] = {
            name = L["Exclude"],
            desc = L["Exclude auras"],
            usage = self:TrackingHelpText(),
            width = "full",
            type = "input",
            multiline = 5,
            order = 6,
            set = function(info,val)
                db.exclude = self:SanitizeStrings(val)
                db.excludeStr = val

                self:SafeRefresh(groupType)
            end,
            get = function(info)
                return db.excludeStr
            end
        },
        ["Copy"] = {
            name = L["Copy settings to |cFFffd100<text>|r"]:gsub("<text>", groupType == "party" and L["Raid"] or L["Party"]),
            desc = L["Copy settings to |cFFffd100<text>|r"]:gsub("<text>", groupType == "party" and L["Raid"] or L["Party"]),
            width = "normal",
            type = "execute",
            order = 7,
            confirm = true,
            func = function(info,val)
                self:CopySettings(db, self.db.profile[self.ReverseGroupType(groupType)].dispelDebuffFrames)
            end,
        },
        ["Reset"] = {
            name = L["Reset to Default"],
            desc = "",
            width = "double",
            type = "execute",
            order = 8,
            confirm = true,
            func = function(info,val)
                self:RestoreDefaults(groupType, "dispelDebuffFrames")
            end,
        },
    }
    return options
end