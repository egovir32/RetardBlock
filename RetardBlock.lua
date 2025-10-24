RETDB = RETDB or {}
RETDB.filterMode = RETDB.filterMode or 1
RETDB.filteredCount = RETDB.filteredCount or 0
RETDB.wordGroups = RETDB.wordGroups or {
    General = {},
    Resellers = {},
    Recruitment = {},
    Reservists = {},
    Retards = {}
}
RETDB.enabledChannels = RETDB.enabledChannels or {}
RETDB.history = RETDB.history or {}

local function isNonLatin(str)
    for i = 1, #str do
        if str:byte(i) > 127 then
            return true
        end
    end
    return false
end

local function escape_pattern(str)
    return str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local tempFrame = CreateFrame("Frame", nil, UIParent)
tempFrame:Hide()
local tempFs = tempFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tempFs:SetWidth(190)
tempFs:SetJustifyH("LEFT")

local function GetTextHeight(text)
    tempFs:SetText(text)
    return tempFs:GetStringHeight()
end

local defaults = {
    General = {
        {word = "0ffer", exact = false, enabled = true},
        {word = "b00st", exact = false, enabled = true},
        {word = "paypal", exact = false, enabled = true},
        {word = "www", exact = false, enabled = true},
    },
    Resellers = {
        {word = "all your", exact = true, enabled = true},
        {word = "bulk", exact = true, enabled = true},
        {word = "c.o.d", exact = true, enabled = true},
        {word = "cod", exact = true, enabled = true},
        {word = "coins", exact = false, enabled = true},
        {word = "cuts", exact = false, enabled = true},
        {word = "delivery", exact = false, enabled = true},
        {word = "greenies", exact = false, enabled = true},
        {word = "greens", exact = false, enabled = true},
        {word = "nobles deck", exact = false, enabled = true},
        {word = "north herbs", exact = false, enabled = true},
        {word = "northern herbs", exact = false, enabled = true},
        {word = "surge needle ring", exact = true, enabled = true},
        {word = "unlimited", exact = false, enabled = true},
        {word = "valor bracer", exact = true, enabled = true},
        {word = "valor wrist", exact = true, enabled = true},
    },
    Recruitment = {
        {word = "active guild", exact = false, enabled = true},
        {word = "arma", exact = true, enabled = true},
        {word = "balkan", exact = false, enabled = true},
        {word = "bulgar", exact = false, enabled = true},
        {word = "busc", exact = false, enabled = true},
        {word = "council", exact = false, enabled = true},
        {word = "cuadrado", exact = false, enabled = true},
        {word = "cz/sk", exact = false, enabled = true},
        {word = "daigo", exact = false, enabled = true},
        {word = "dedicated", exact = false, enabled = true},
        {word = "epgp", exact = false, enabled = true},
        {word = "estrella", exact = false, enabled = true},
        {word = "german", exact = false, enabled = true},
        {word = "guilde", exact = true, enabled = true},
        {word = "hispanic", exact = false, enabled = true},
        {word = "hungar", exact = false, enabled = true},
        {word = "iran", exact = false, enabled = true},
        {word = "italian", exact = false, enabled = true},
        {word = "latin", exact = false, enabled = true},
        {word = "latam", exact = false, enabled = true},
        {word = "msk", exact = true, enabled = true},
        {word = "nabira", exact = false, enabled = true},
        {word = "partner", exact = true, enabled = true},
        {word = "polish", exact = true, enabled = true},
        {word = "polska", exact = false, enabled = true},
        {word = "portuguese", exact = false, enabled = true},
        {word = "recluta", exact = false, enabled = true},
        {word = "recruit", exact = false, enabled = true},
        {word = "seek", exact = true, enabled = true},
        {word = "shivtr", exact = false, enabled = true},
        {word = "skilled", exact = false, enabled = true},
        {word = "spanish", exact = false, enabled = false},
    },
    Reservists = {
        {word = "rees", exact = true, enabled = false},
        {word = "res", exact = true, enabled = false},
        {word = "reser", exact = true, enabled = false},
        {word = "ress", exact = true, enabled = false},
        {word = "ressed", exact = false, enabled = false},
        {word = "resseved", exact = false, enabled = false},
        {word = "ressved", exact = false, enabled = false},
        {word = "rez", exact = true, enabled = false},
        {word = "rezerv", exact = false, enabled = false},
        {word = "rezz", exact = false, enabled = false},
        {word = "rs", exact = true, enabled = false},
        {word = "rss", exact = true, enabled = false},
        {word = "resereved", exact = false, enabled = false},
        {word = "reserv", exact = false, enabled = false},
        {word = "resv", exact = false, enabled = false},
    },
    Retards = {
        {word = ".save", exact = true, enabled = true},
        {word = "anal", exact = true, enabled = true},
        {word = "asz", exact = false, enabled = false},
        {word = "atkrues", exact = false, enabled = true},
        {word = "atkreus", exact = false, enabled = true},
        {word = "chaman", exact = false, enabled = true},
        {word = "chami", exact = true, enabled = true},
        {word = "collares", exact = true, enabled = true},
        {word = "dad", exact = true, enabled = true},
        {word = "dirge", exact = false, enabled = true},
        {word = "f", exact = true, enabled = true},
        {word = "gangsh", exact = false, enabled = true},
        {word = "gm", exact = true, enabled = false},
        {word = "gus", exact = true, enabled = true},
        {word = "heler", exact = true, enabled = true},
        {word = "jcz", exact = false, enabled = true},
        {word = "jiler", exact = true, enabled = true},
        {word = "kodzak", exact = false, enabled = true},
        {word = "lagi", exact = true, enabled = true},
        {word = "log", exact = true, enabled = true},
        {word = "mez", exact = true, enabled = true},
        {word = "mile", exact = true, enabled = true},
        {word = "mom", exact = true, enabled = true},
        {word = "ned", exact = true, enabled = true},
        {word = "nedd", exact = true, enabled = true},
        {word = "no answer", exact = true, enabled = true},
        {word = "nobels", exact = true, enabled = true},
        {word = "no inv", exact = true, enabled = true},
        {word = "no reply", exact = true, enabled = true},
        {word = "noreply", exact = false, enabled = true},
        {word = "noneed", exact = false, enabled = true},
        {word = "pepeg", exact = false, enabled = true},
        {word = "pog", exact = true, enabled = true},
        {word = "pogg", exact = false, enabled = true},
        {word = "poger", exact = false, enabled = true},
        {word = "preg", exact = true, enabled = true},
        {word = "que", exact = true, enabled = true},
        {word = "queue", exact = true, enabled = false},
        {word = "snape", exact = true, enabled = true},
        {word = "sneed", exact = false, enabled = true},
        {word = "soloq", exact = false, enabled = true},
        {word = "som", exact = true, enabled = true},
        {word = "tag", exact = true, enabled = true},
        {word = "thunderfury", exact = false, enabled = true},
        {word = "twitch.tv", exact = false, enabled = true},
    }
}

for group, defaultWords in pairs(defaults) do
    if not RETDB.wordGroups[group] or #RETDB.wordGroups[group] == 0 then
        RETDB.wordGroups[group] = defaultWords
    end
end

local channels = {
    {event = "CHAT_MSG_ADDON", name = "Addon"},
    {event = "CHAT_MSG_CHANNEL", name = "Channels"},
    {event = "CHAT_MSG_EMOTE", name = "Emote"},
    {event = "CHAT_MSG_GUILD", name = "Guild"},
    {event = "CHAT_MSG_MONSTER_SAY", name = "NPC Say"},
    {event = "CHAT_MSG_MONSTER_YELL", name = "NPC Yell"},
    {event = "CHAT_MSG_PARTY", name = "Party"},
    {event = "CHAT_MSG_RAID", name = "Raid"},
    {event = "CHAT_MSG_SAY", name = "Say"},
    {event = "CHAT_MSG_SYSTEM", name = "System"},
    {event = "CHAT_MSG_WHISPER", name = "Whisper"},
    {event = "CHAT_MSG_YELL", name = "Yell"},
}

table.sort(channels, function(a, b) return a.name:lower() < b.name:lower() end)

local function CreateMainFrame()
    local frame = CreateFrame("Frame", "RetardBlockFrame", UIParent)
    frame:SetSize(420, 500)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetScript("OnHide", function() frame:StopMovingOrSizing() end)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    frame:SetFrameLevel(1)
    local title = frame:CreateFontString(nil, "OVERLAY", "DialogButtonHighlightText")
    title:SetPoint("TOP", 0, -16)
    frame.title = title
    frame.UpdateTitle = function(self)
        local modeText = RETDB.filterMode == 0 and "KEYWORD FILTERING IS DISABLED" or
                         RETDB.filterMode == 1 and "KEYWORDS ARE NOW BEING RECOLORED" or
                         "KEYWORDS ARE NOW BEING HIDDEN"
        title:SetText("" .. modeText)
    end
    frame:UpdateTitle()
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -8, -8)
    closeBtn:SetSize(20, 20)
    local filterBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    filterBtn:SetPoint("BOTTOMLEFT", 9, 9)
    filterBtn:SetSize(90, 22)
    local filterText = filterBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    filterText:SetPoint("CENTER")
    filterText:SetText("Mode Switch")
    filterBtn.Text = filterText
    filterBtn:SetScript("OnClick", function()
    RETDB.filterMode = (RETDB.filterMode + 1) % 3
    frame:UpdateTitle()
    end)
    frame.UpdateWordList = function(self)
        if not self.currentTab or not self.tabPanels[self.currentTab] or not self.tabPanels[self.currentTab].content then return end
        local content = self.tabPanels[self.currentTab].content
        for _, child in ipairs({content:GetChildren()}) do
            child:Hide()
            child:SetParent(nil)
        end
        RETDB.wordGroups = RETDB.wordGroups or {
            General = {},
            Resellers = {},
            Recruitment = {},
            Reservists = {},
            Retards = {}
        }
        local words = RETDB.wordGroups[self.currentTab] or {}
        table.sort(words, function(a, b) return a.word:lower() < b.word:lower() end)
        for i, wordInfo in ipairs(words) do
            if wordInfo.enabled == nil then
                wordInfo.enabled = true
            end
            local button = CreateFrame("Button", nil, content)
            button:SetSize(220, 20)
            button:SetPoint("TOPLEFT", 0, -20 * (i-1))
            local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetPoint("LEFT", 5, 0)
            text:SetTextColor(wordInfo.enabled and (wordInfo.exact and 0.72 or 1) or 0.41, 
                             wordInfo.enabled and (wordInfo.exact and 0.53 or 1) or 0.41, 
                             wordInfo.enabled and (wordInfo.exact and 0.04 or 1) or 0.41)
            text:SetText(wordInfo.word .. (wordInfo.exact and " (Exact)" or " (Partial)") .. 
                        (wordInfo.enabled and "" or " (Disabled)"))
            local disableBtn = CreateFrame("Button", nil, button, "UIPanelButtonTemplate")
            disableBtn:SetSize(60, 20)
            disableBtn:SetPoint("RIGHT", button, "RIGHT", 161, 0)
            local disableText = disableBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            disableText:SetPoint("CENTER")
            disableText:SetText("ON/OFF")
            disableBtn.Text = disableText
            disableBtn:SetScript("OnClick", function()
                wordInfo.enabled = not wordInfo.enabled
                self:UpdateWordList()
            end)
            local removeBtn = CreateFrame("Button", nil, button, "UIPanelButtonTemplate")
            removeBtn:SetSize(60, 20)
            removeBtn:SetPoint("RIGHT", button, "RIGHT", 100, 0)
            local removeText = removeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            removeText:SetPoint("CENTER")
            removeText:SetText("Remove")
            removeBtn.Text = removeText
            removeBtn:SetScript("OnClick", function()
                table.remove(RETDB.wordGroups[self.currentTab], i)
                self:UpdateWordList()
            end)
        end
        content:SetHeight(math.max(400, #words * 20 + 10))
    end
    return frame
end

local function CreateTabs(frame)
    local tabs = {
        {name = "General", title = "General"},
        {name = "Resellers", title = "Resellers"},
        {name = "Recruitment", title = "Recruitment"},
        {name = "Reservists", title = "Reservists"},
        {name = "Retards", title = "Retards"}
    }
    frame.tabButtons = {}
    frame.tabPanels = {}
    for i, tabInfo in ipairs(tabs) do
        local tab = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        tab:SetSize(80, 22)
        tab:SetPoint("TOPLEFT", 10 + (i-1)*80, -35)
        local tabText = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tabText:SetPoint("CENTER")
        tabText:SetText(tabInfo.title)
        tab.Text = tabText
        local panel = CreateFrame("Frame", nil, frame)
        panel:SetPoint("TOPLEFT", 10, -65)
        panel:SetPoint("BOTTOMRIGHT", -10, 40)
        panel:Hide()
        local scrollFrame = CreateFrame("ScrollFrame", "RetardBlockScrollFrame_" .. tabInfo.name, panel, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 0, -10)
        scrollFrame:SetPoint("BOTTOMRIGHT", -10, 10)
        local content = CreateFrame("Frame", nil, scrollFrame)
        scrollFrame:SetScrollChild(content)
        content:SetSize(340, 400)
        content:SetWidth(340)
        content:SetHeight(400)
        panel.content = content
        local scrollBarName = scrollFrame:GetName() .. "ScrollBar"
        local scrollBar = _G[scrollBarName] or CreateFrame("Slider", scrollBarName, scrollFrame, "UIPanelScrollBarTemplate")
        scrollBar:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -15, -10)
        scrollBar:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -15, 10)
        scrollBar:SetMinMaxValues(0, 0)
        scrollBar:SetValue(0)
        scrollBar:Show()
        scrollFrame:UpdateScrollChildRect()
        frame.tabButtons[tabInfo.name] = tab
        frame.tabPanels[tabInfo.name] = panel
        tab:SetScript("OnClick", function()
            for _, p in pairs(frame.tabPanels) do p:Hide() end
            panel:Show()
            frame.currentTab = tabInfo.name
            frame:UpdateWordList()
        end)
    end
end

local function CreateWordControls(frame)
    local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox:SetSize(128, 25)
    editBox:SetPoint("BOTTOMLEFT", 108, 8)
    editBox:SetAutoFocus(false)
    editBox:SetFrameLevel(frame:GetFrameLevel() + 5)
    local exactMatch = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    exactMatch:SetPoint("LEFT", editBox, "RIGHT", 0, -1)
    local checkText = exactMatch:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    checkText:SetPoint("LEFT", exactMatch, "RIGHT", 0, 1)
    checkText:SetText("Exact Match")
    local addButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    addButton:SetSize(75, 22)
    addButton:SetPoint("LEFT", checkText, "RIGHT", 5, 1)
    local buttonText = addButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    buttonText:SetPoint("CENTER")
    buttonText:SetText("Add Word")
    addButton.Text = buttonText
    addButton:SetScript("OnClick", function()
        local word = editBox:GetText()
        if word ~= "" and frame.currentTab then
            RETDB.wordGroups = RETDB.wordGroups or {
                General = {},
                Resellers = {},
                Recruitment = {},
                Reservists = {},
                Retards = {}
            }
            local words = RETDB.wordGroups[frame.currentTab]
            local insertIndex = 1
            for i, wordInfo in ipairs(words) do
                if wordInfo.word:lower() > word:lower() then
                    break
                end
                insertIndex = i + 1
            end
            table.insert(RETDB.wordGroups[frame.currentTab], insertIndex, {
                word = word,
                exact = exactMatch:GetChecked(),
                enabled = true
            })
            editBox:SetText("")
            editBox:ClearFocus()
            frame:UpdateWordList()
        end
    end)
    editBox:SetScript("OnEnterPressed", function(self)
        addButton:Click()
    end)
    frame.editBox = editBox
    frame.exactMatch = exactMatch
end

local function CreateHistoryFrame(parent)
    local historyFrame = CreateFrame("Frame", "RetardBlockHistoryFrame", parent)
    historyFrame:SetSize(210, 500)
    historyFrame:SetPoint("TOPRIGHT", RetardBlockOptionsFrame, "TOPLEFT", 0, 0)
    historyFrame:SetPoint("BOTTOMRIGHT", RetardBlockOptionsFrame, "BOTTOMLEFT", 0, 0)
    historyFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    historyFrame:SetBackdropColor(0, 0, 0, 1)
    local title = historyFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", 0, -17)
    title:SetText("HISTORY:")
    local content = CreateFrame("Frame", nil, historyFrame)
    content:SetPoint("TOPLEFT", 1, -40)
    content:SetPoint("BOTTOMRIGHT", -10, 10)
    content:SetWidth(190)
    content:SetHeight(450)
    historyFrame.content = content
    historyFrame.logStrings = {}
    historyFrame:Hide()
    return historyFrame
end

local function UpdateHistoryFrame()
    if not RetardBlockHistoryFrame then return end
    for _, fs in ipairs(RetardBlockHistoryFrame.logStrings or {}) do
        fs:Hide()
    end
    RetardBlockHistoryFrame.logStrings = {}
    RETDB.history = RETDB.history or {}
    local content = RetardBlockHistoryFrame.content
    local yOffset = 0
    for i = #RETDB.history, 1, -1 do
        local entry = RETDB.history[i]
        if type(entry) == "table" and entry.text then
            local fs = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            fs:SetPoint("TOPLEFT", 13, yOffset)
            fs:SetWidth(190)
            fs:SetJustifyH("LEFT")
            fs:SetTextColor(1, 1, 1)
            fs:SetText(entry.text)
            local h = fs:GetStringHeight()
            yOffset = yOffset - h - 5
            table.insert(RetardBlockHistoryFrame.logStrings, fs)
        end
    end
    content:SetHeight(math.max(450, -yOffset))
end

local function CreateOptionsFrame(parent)
    local optionsFrame = CreateFrame("Frame", "RetardBlockOptionsFrame", parent)
    optionsFrame:SetSize(110, 500)
    optionsFrame:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
    optionsFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT", 0, 0)
    optionsFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    optionsFrame:SetBackdropColor(0, 0, 0, 1)
    local title = optionsFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormalYellow")
    title:SetPoint("TOP", 0, -17)
    title:SetText("CHANNELS:")
    optionsFrame.channelChecks = {}
    for i, chan in ipairs(channels) do
        local check = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
        check:SetPoint("TOPLEFT", 10, -40 - (i-1)*25)
        local label = check:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("LEFT", check, "RIGHT", 5, 1)
        label:SetText(chan.name)
        check.event = chan.event
        check:SetScript("OnClick", function(self)
            RETDB.enabledChannels[self.event] = self:GetChecked()
            if RETDB.enabledChannels[self.event] then
                ChatFrame_AddMessageEventFilter(self.event, RETFilter_ChannelMsgFilter)
            else
                ChatFrame_RemoveMessageEventFilter(self.event, RETFilter_ChannelMsgFilter)
            end
        end)
        optionsFrame.channelChecks[chan.event] = check
    end
    local historyBtn = CreateFrame("Button", nil, optionsFrame, "UIPanelButtonTemplate")
    historyBtn:SetSize(90, 22)
    historyBtn:SetPoint("BOTTOM", 0, 31)
    local historyText = historyBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    historyText:SetPoint("CENTER")
    historyText:SetText("History")
    historyBtn.Text = historyText
    historyBtn:SetScript("OnClick", function()
        if RetardBlockHistoryFrame:IsShown() then
            RetardBlockHistoryFrame:Hide()
        else
            RetardBlockHistoryFrame:Show()
            UpdateHistoryFrame()
        end
    end)
    local refreshBtn = CreateFrame("Button", nil, optionsFrame, "UIPanelButtonTemplate")
    refreshBtn:SetSize(90, 22)
    refreshBtn:SetPoint("BOTTOM", 0, 89)
    local refreshText = refreshBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    refreshText:SetPoint("CENTER")
    refreshText:SetText("Reload DB")
    refreshBtn.Text = refreshText
    refreshBtn:SetScript("OnClick", function()
        RetardBlockFrame:UpdateWordList()
    end)
    local reloadBtn = CreateFrame("Button", nil, optionsFrame, "UIPanelButtonTemplate")
    reloadBtn:SetSize(90, 22)
    reloadBtn:SetPoint("BOTTOM", 0, 67)
    local reloadText = reloadBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    reloadText:SetPoint("CENTER")
    reloadText:SetText("Reload UI")
    reloadBtn.Text = reloadText
    reloadBtn:SetScript("OnClick", function()
        ReloadUI()
    end)
    local aboutBtn = CreateFrame("Button", nil, optionsFrame, "UIPanelButtonTemplate")
    aboutBtn:SetSize(90, 22)
    aboutBtn:SetPoint("BOTTOM", 0, 9)
    local aboutText = aboutBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    aboutText:SetPoint("CENTER")
    aboutText:SetText("About")
    aboutBtn.Text = aboutText
    aboutBtn:SetScript("OnClick", function()
        DEFAULT_CHAT_FRAME:AddMessage("RetardBlock v3.3.5 by egovir. Send all your gold to \"Bloodboner\"!")
        DEFAULT_CHAT_FRAME:AddMessage("Honor and Glory to Yewbacca and his ASSFilter!")
    end)
    optionsFrame.UpdateChannels = function(self)
        for event, check in pairs(self.channelChecks) do
            check:SetChecked(RETDB.enabledChannels[event] or false)
        end
    end
end

function RETFilter_ChannelMsgFilter(self, event, ...)
    local msg = select(1, ...)
    local author = select(2, ...) or ""
    if RETDB.filterMode ~= 0 and author ~= UnitName("player") and RETDB.enabledChannels[event] then
        local cleanmsg = msg:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h(.-)|h", "%1")
        local lcmsg = string.lower(cleanmsg)
        RETDB.wordGroups = RETDB.wordGroups or {
            General = {},
            Resellers = {},
            Recruitment = {},
            Reservists = {},
            Retards = {}
        }
        if not RETDB.wordGroups or type(RETDB.wordGroups) ~= "table" then
            return false
        end
        local filtered = false
        for group, words in pairs(RETDB.wordGroups) do
            if type(words) == "table" then
                for _, wordInfo in ipairs(words) do
                    if wordInfo.enabled then
                        local searchWord = isNonLatin(wordInfo.word) and wordInfo.word or wordInfo.word:lower()
                        local escapedWord = escape_pattern(searchWord)
                        local pattern = wordInfo.exact and ("%f[%w]" .. escapedWord .. "%f[%W]") or escapedWord
                        if string.find(lcmsg, pattern) then
                            filtered = true
                            break
                        end
                    end
                end
                if filtered then break end
            end
        end
        if filtered then
            RETDB.filteredCount = RETDB.filteredCount + 1
            RETDB.history = RETDB.history or {}
            local entry = {author = author, msg = msg}
            entry.text = author .. ": " .. msg
            entry.height = GetTextHeight(entry.text) + 5
            local addEntry = true
            if #RETDB.history > 0 and RETDB.history[#RETDB.history].text == entry.text then
                addEntry = false
            end
            if addEntry then
                local total = entry.height or 0
                for _, e in ipairs(RETDB.history) do
                    if type(e) == "table" and type(e.height) == "number" then
                        total = total + e.height
                    end
                end
                local frameH = 450
                while total > frameH and #RETDB.history > 0 do
                    table.remove(RETDB.history, 1)
                    total = entry.height or 0
                    for _, e in ipairs(RETDB.history) do
                        if type(e) == "table" and type(e.height) == "number" then
                            total = total + e.height
                        end
                    end
                end
                table.insert(RETDB.history, entry)
            end
            if RetardBlockHistoryFrame and RetardBlockHistoryFrame:IsShown() then
                UpdateHistoryFrame()
            end
            if RETDB.filterMode == 1 then
                local cleantext = msg:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h", ""):gsub("|h", "")
                return false, ("|cFF5C5C5C" .. cleantext .. "|r"), select(2, ...)
            else
                return true
            end
        end
    end
    return false
end

local frame = CreateMainFrame()
CreateTabs(frame)
CreateWordControls(frame)
CreateOptionsFrame(frame)
CreateHistoryFrame(frame)
frame:Hide()

frame:SetScript("OnShow", function(self)
    self:UpdateTitle()
    if not self.currentTab then
        self.tabButtons.General:Click()
    else
        self:UpdateWordList()
    end
    RetardBlockOptionsFrame:UpdateChannels()
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "RetardBlock" then
        if type(RETDB) ~= "table" then RETDB = {} end
        if type(RETDB.wordGroups) ~= "table" then
            RETDB.wordGroups = {
                General = {},
                Resellers = {},
                Recruitment = {},
                Reservists = {},
                Retards = {}
            }
        end
        if type(RETDB.history) ~= "table" then RETDB.history = {} end
        if type(RETDB.enabledChannels) ~= "table" then RETDB.enabledChannels = {} end
        if type(RETDB.filterMode) ~= "number" then RETDB.filterMode = 1 end
        if type(RETDB.filteredCount) ~= "number" then RETDB.filteredCount = 0 end
        for group, defaultWords in pairs(defaults) do
            local currentGroup = RETDB.wordGroups[group]
            if type(currentGroup) ~= "table" or #currentGroup == 0 then
                RETDB.wordGroups[group] = defaultWords
            end
        end
        local toRemove = {}
        for i, entry in ipairs(RETDB.history) do
            if type(entry) ~= "table" or not entry.text or type(entry.text) ~= "string" then
                table.insert(toRemove, i)
            else
                entry.height = GetTextHeight(entry.text) + 5
            end
        end
        table.sort(toRemove, function(a, b) return a > b end)
        for _, idx in ipairs(toRemove) do
            table.remove(RETDB.history, idx)
        end
        for _, chan in ipairs(channels) do
            if RETDB.enabledChannels[chan.event] == nil then
                RETDB.enabledChannels[chan.event] = (chan.event == "CHAT_MSG_CHANNEL" or chan.event == "CHAT_MSG_EMOTE" or chan.event == "CHAT_MSG_SAY" or chan.event == "CHAT_MSG_YELL")
            end
        end
        for _, chan in ipairs(channels) do
            local event = chan.event
            ChatFrame_RemoveMessageEventFilter(event, RETFilter_ChannelMsgFilter)
            if RETDB.enabledChannels[event] then
                ChatFrame_AddMessageEventFilter(event, RETFilter_ChannelMsgFilter)
            end
        end
        if frame:IsShown() then
            RetardBlockOptionsFrame:UpdateChannels()
        end
    end
end)

SlashCmdList["RETFLTR"] = function(msg)
    if msg and msg ~= "" then
        local _, _, cmd, arg1 = string.find(string.upper(msg), "([%w]+)%s*(.*)$")
        if cmd == "COUNT" then
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00BEFFRetardBlock has filtered " .. RETDB.filteredCount .. " messages|cFF00BEFF.")
        else
            local badCmd = 'Unknown command "' .. msg .. '".'
            local helpMsg = '|cFFFFFFFF/retard: ' .. badCmd .. "\n" ..
                "No arguments: Opens the configuration GUI.\n" ..
                "count: Shows the number of filtered messages."
            DEFAULT_CHAT_FRAME:AddMessage(helpMsg)
        end
    else
        frame:Show()
    end
end


SLASH_RETFLTR1 = "/retard"
