-- Sysnax ScriptHub – Custom UI, No External Libraries
-- Discord: https://discord.gg/xadh9mPGaN
-- Features: Welcome, Home, ScriptHub, Manual save, AC bypass

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==================== AC BYPASS ====================
pcall(function()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") then
            local n = obj.Name:lower()
            if n:find("anticheat") or n:find("antihack") or n:find("detection") or n:find("ac") or obj.Name == "LocalScript" then
                obj.Disabled = true
            end
        end
    end
end)

-- ==================== CONSTANTS ====================
local BG = Color3.fromRGB(18, 18, 20)
local ACCENT = Color3.fromRGB(120, 86, 255)
local SECONDARY = Color3.fromRGB(28, 28, 32)
local ELEMENT = Color3.fromRGB(33, 33, 38)
local TEXT_PRIMARY = Color3.fromRGB(240, 240, 240)
local TEXT_SECONDARY = Color3.fromRGB(160, 160, 170)
local DANGER = Color3.fromRGB(255, 70, 70)

-- ==================== MAIN GUI ====================
local Gui = Instance.new("ScreenGui")
Gui.Name = "Sysnax"
Gui.ResetOnSpawn = false
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 780, 0, 480)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -240)
MainFrame.BackgroundColor3 = SECONDARY
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = Gui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- ==================== WELCOME OVERLAY ====================
local Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(1, 0, 1, 0)
Welcome.BackgroundColor3 = SECONDARY
Welcome.BorderSizePixel = 0
Welcome.ZIndex = 10
Welcome.Parent = MainFrame

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 80, 0, 80)
Logo.Position = UDim2.new(0.5, -40, 0.4, -40)
Logo.Image = "rbxassetid://122198206955790"
Logo.BackgroundTransparency = 1
Logo.Parent = Welcome

local WelcomeTitle = Instance.new("TextLabel", Welcome)
WelcomeTitle.Size = UDim2.new(1, 0, 0, 30)
WelcomeTitle.Position = UDim2.new(0, 0, 0.52, 0)
WelcomeTitle.Text = "Welcome, " .. LocalPlayer.DisplayName
WelcomeTitle.TextColor3 = TEXT_PRIMARY
WelcomeTitle.Font = Enum.Font.GothamBold
WelcomeTitle.TextSize = 24
WelcomeTitle.BackgroundTransparency = 1

local WelcomeSub = Instance.new("TextLabel", Welcome)
WelcomeSub.Size = UDim2.new(1, 0, 0, 20)
WelcomeSub.Position = UDim2.new(0, 0, 0.58, 0)
WelcomeSub.Text = "Sysnax ScriptHub"
WelcomeSub.TextColor3 = TEXT_SECONDARY
WelcomeSub.Font = Enum.Font.Gotham
WelcomeSub.TextSize = 16
WelcomeSub.BackgroundTransparency = 1

spawn(function()
    wait(2)
    TweenService:Create(Welcome, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(WelcomeTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(WelcomeSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    wait(0.5)
    Welcome:Destroy()
end)

-- ==================== TITLE BAR (DRAGGABLE) ====================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = ELEMENT
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.Text = "Sysnax"
TitleText.TextColor3 = TEXT_PRIMARY
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 4)
CloseBtn.BackgroundColor3 = DANGER
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = TEXT_PRIMARY
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

-- Drag to move
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== NAVIGATION BAR ====================
local NavBar = Instance.new("Frame")
NavBar.Size = UDim2.new(0, 150, 1, -35)
NavBar.Position = UDim2.new(0, 0, 0, 35)
NavBar.BackgroundColor3 = ELEMENT
NavBar.BorderSizePixel = 0
NavBar.Parent = MainFrame

local HomeBtn = Instance.new("TextButton")
HomeBtn.Size = UDim2.new(1, -20, 0, 30)
HomeBtn.Position = UDim2.new(0, 10, 0, 10)
HomeBtn.BackgroundColor3 = ACCENT
HomeBtn.Text = "🏠  Home"
HomeBtn.TextColor3 = TEXT_PRIMARY
HomeBtn.Font = Enum.Font.Gotham
HomeBtn.TextSize = 14
HomeBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", HomeBtn).CornerRadius = UDim.new(0, 8)
HomeBtn.Parent = NavBar

local HubBtn = Instance.new("TextButton")
HubBtn.Size = UDim2.new(1, -20, 0, 30)
HubBtn.Position = UDim2.new(0, 10, 0, 50)
HubBtn.BackgroundColor3 = ELEMENT
HubBtn.Text = "📜  ScriptHub"
HubBtn.TextColor3 = TEXT_PRIMARY
HubBtn.Font = Enum.Font.Gotham
HubBtn.TextSize = 14
HubBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", HubBtn).CornerRadius = UDim.new(0, 8)
HubBtn.Parent = NavBar

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, -20, 0, 30)
DiscordBtn.Position = UDim2.new(0, 10, 1, -40)
DiscordBtn.BackgroundColor3 = ACCENT
DiscordBtn.Text = "💬  Discord"
DiscordBtn.TextColor3 = TEXT_PRIMARY
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 14
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)
DiscordBtn.Parent = NavBar
DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/xadh9mPGaN")
    StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Discord invite copied!", Duration = 3})
end)

-- ==================== CONTENT AREA ====================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -150, 1, -35)
Content.Position = UDim2.new(0, 150, 0, 35)
Content.BackgroundColor3 = SECONDARY
Content.BorderSizePixel = 0
Content.Parent = MainFrame

-- ==================== HOME TAB ====================
local HomeFrame = Instance.new("Frame")
HomeFrame.Size = UDim2.new(1, 0, 1, 0)
HomeFrame.BackgroundTransparency = 1
HomeFrame.Visible = true
HomeFrame.Parent = Content

-- Avatar
local AvatarFrame = Instance.new("Frame")
AvatarFrame.Size = UDim2.new(0, 80, 0, 80)
AvatarFrame.Position = UDim2.new(0, 20, 0, 20)
AvatarFrame.BackgroundTransparency = 1
AvatarFrame.Parent = HomeFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(1, 0, 1, 0)
AvatarImg.BackgroundTransparency = 1
AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(0, 40)
AvatarImg.Parent = AvatarFrame

-- Name labels
local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0, 300, 0, 24)
NameLabel.Position = UDim2.new(0, 120, 0, 20)
NameLabel.Text = "@" .. LocalPlayer.Name
NameLabel.TextColor3 = TEXT_PRIMARY
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 20
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.BackgroundTransparency = 1
NameLabel.Parent = HomeFrame

local DisplayLabel = Instance.new("TextLabel")
DisplayLabel.Size = UDim2.new(0, 300, 0, 18)
DisplayLabel.Position = UDim2.new(0, 120, 0, 48)
DisplayLabel.Text = LocalPlayer.DisplayName
DisplayLabel.TextColor3 = TEXT_SECONDARY
DisplayLabel.Font = Enum.Font.Gotham
DisplayLabel.TextSize = 14
DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
DisplayLabel.BackgroundTransparency = 1
DisplayLabel.Parent = HomeFrame

local ExecLabel = Instance.new("TextLabel")
ExecLabel.Size = UDim2.new(0, 300, 0, 18)
ExecLabel.Position = UDim2.new(0, 120, 0, 70)
ExecLabel.Text = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown")
ExecLabel.TextColor3 = TEXT_SECONDARY
ExecLabel.Font = Enum.Font.Gotham
ExecLabel.TextSize = 14
ExecLabel.TextXAlignment = Enum.TextXAlignment.Left
ExecLabel.BackgroundTransparency = 1
ExecLabel.Parent = HomeFrame

-- Server info (simple frame)
local ServerFrame = Instance.new("Frame")
ServerFrame.Size = UDim2.new(0, 350, 0, 90)
ServerFrame.Position = UDim2.new(0, 20, 0, 120)
ServerFrame.BackgroundColor3 = ELEMENT
ServerFrame.BorderSizePixel = 0
Instance.new("UICorner", ServerFrame).CornerRadius = UDim.new(0, 10)
ServerFrame.Parent = HomeFrame

local ServerTitle = Instance.new("TextLabel")
ServerTitle.Size = UDim2.new(1, -20, 0, 20)
ServerTitle.Position = UDim2.new(0, 10, 0, 8)
ServerTitle.Text = "Server Information"
ServerTitle.TextColor3 = ACCENT
ServerTitle.Font = Enum.Font.GothamBold
ServerTitle.TextSize = 14
ServerTitle.TextXAlignment = Enum.TextXAlignment.Left
ServerTitle.BackgroundTransparency = 1
ServerTitle.Parent = ServerFrame

local function addServerLine(text, yOffset)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, yOffset)
    lbl.Text = text
    lbl.TextColor3 = TEXT_PRIMARY
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = ServerFrame
end

addServerLine("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers, 32)
addServerLine("Place ID: " .. game.PlaceId, 52)
addServerLine("Region: " .. (game:GetService("LocalizationService").RobloxLocaleId or "N/A"), 72)

-- ==================== SCRIPTHUB TAB ====================
local HubFrame = Instance.new("Frame")
HubFrame.Size = UDim2.new(1, 0, 1, 0)
HubFrame.BackgroundTransparency = 1
HubFrame.Visible = false
HubFrame.Parent = Content

-- Data cache & save
local cache = { scripts = {}, searchTerm = "", category = "All" }
local hubFolder = "sysnax/hub"
if not isfolder(hubFolder) then makefolder(hubFolder) end
local savedFile = hubFolder .. "/user_scripts.json"

local function loadUserScripts()
    local ok, data = pcall(function()
        if isfile(savedFile) then return HttpService:JSONDecode(readfile(savedFile)) end
        return {}
    end)
    return ok and data or {}
end
local function saveUserScripts(scripts)
    pcall(function() writefile(savedFile, HttpService:JSONEncode(scripts)) end)
end
local function mergeScripts(fetched)
    local user = loadUserScripts()
    cache.scripts = {}
    for _, s in ipairs(user) do table.insert(cache.scripts, s) end
    for _, s in ipairs(fetched or {}) do
        local dup = false
        for _, us in ipairs(user) do if us.script == s.script then dup = true break end end
        if not dup then table.insert(cache.scripts, s) end
    end
end

-- Search box
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 250, 0, 30)
SearchBox.Position = UDim2.new(0, 15, 0, 15)
SearchBox.BackgroundColor3 = ELEMENT
SearchBox.BorderSizePixel = 0
SearchBox.Text = ""
SearchBox.PlaceholderText = "Search scripts..."
SearchBox.TextColor3 = TEXT_PRIMARY
SearchBox.PlaceholderColor3 = TEXT_SECONDARY
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 8)
SearchBox.Parent = HubFrame
SearchBox.Changed:Connect(function()
    cache.searchTerm = SearchBox.Text:lower()
    displayScripts()
end)

-- Category tags
local tags = {"All", "Rivals", "Arsenal", "HyperShot", "FPS", "Utility", "Misc"}
local selectedTag = "All"
for i, tag in ipairs(tags) do
    local tagBtn = Instance.new("TextButton")
    tagBtn.Size = UDim2.new(0, 70, 0, 26)
    tagBtn.Position = UDim2.new(0, 15 + ((i-1) * 75), 0, 55)
    tagBtn.BackgroundColor3 = tag == selectedTag and ACCENT or ELEMENT
    tagBtn.Text = tag
    tagBtn.TextColor3 = TEXT_PRIMARY
    tagBtn.Font = Enum.Font.Gotham
    tagBtn.TextSize = 13
    Instance.new("UICorner", tagBtn).CornerRadius = UDim.new(0, 8)
    tagBtn.Parent = HubFrame
    tagBtn.MouseButton1Click:Connect(function()
        selectedTag = tag
        for _, b in ipairs(HubFrame:GetChildren()) do
            if b:IsA("TextButton") and table.find(tags, b.Text) then
                b.BackgroundColor3 = b.Text == tag and ACCENT or ELEMENT
            end
        end
        cache.category = tag
        fetchScripts(tag)
    end)
end

-- Refresh button
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 80, 0, 26)
RefreshBtn.Position = UDim2.new(0, 440, 0, 55)
RefreshBtn.BackgroundColor3 = ELEMENT
RefreshBtn.Text = "Refresh"
RefreshBtn.TextColor3 = TEXT_PRIMARY
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 13
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 8)
RefreshBtn.Parent = HubFrame
RefreshBtn.MouseButton1Click:Connect(function() fetchScripts(selectedTag) end)

-- Manual add
local URLInput = Instance.new("TextBox")
URLInput.Size = UDim2.new(0, 280, 0, 30)
URLInput.Position = UDim2.new(0, 15, 0, 395)
URLInput.BackgroundColor3 = ELEMENT
URLInput.BorderSizePixel = 0
URLInput.Text = ""
URLInput.PlaceholderText = "Raw script URL (pastebin.com/raw/...)"
URLInput.TextColor3 = TEXT_PRIMARY
URLInput.PlaceholderColor3 = TEXT_SECONDARY
URLInput.Font = Enum.Font.Gotham
URLInput.TextSize = 14
Instance.new("UICorner", URLInput).CornerRadius = UDim.new(0, 8)
URLInput.Parent = HubFrame

local NameInput = Instance.new("TextBox")
NameInput.Size = UDim2.new(0, 120, 0, 30)
NameInput.Position = UDim2.new(0, 305, 0, 395)
NameInput.BackgroundColor3 = ELEMENT
NameInput.BorderSizePixel = 0
NameInput.Text = ""
NameInput.PlaceholderText = "Script name"
NameInput.TextColor3 = TEXT_PRIMARY
NameInput.PlaceholderColor3 = TEXT_SECONDARY
NameInput.Font = Enum.Font.Gotham
NameInput.TextSize = 14
Instance.new("UICorner", NameInput).CornerRadius = UDim.new(0, 8)
NameInput.Parent = HubFrame

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0, 60, 0, 30)
AddBtn.Position = UDim2.new(0, 435, 0, 395)
AddBtn.BackgroundColor3 = ACCENT
AddBtn.Text = "Add"
AddBtn.TextColor3 = TEXT_PRIMARY
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 14
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 8)
AddBtn.Parent = HubFrame
AddBtn.MouseButton1Click:Connect(function()
    local url = URLInput.Text
    local name = NameInput.Text
    if url ~= "" then
        local newScript = {
            title = (name ~= "" and name) or "Custom Script",
            script = url,
            image = "rbxassetid://122198206955790",
            description = "Manually added",
            author = "You",
            downloads = 0,
            isUserScript = true,
        }
        local user = loadUserScripts()
        local dup = false
        for _, s in ipairs(user) do if s.script == url then dup = true break end end
        if not dup then
            table.insert(user, 1, newScript)
            saveUserScripts(user)
            mergeScripts()
            displayScripts()
            URLInput.Text = ""
            NameInput.Text = ""
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Script added!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Already in your hub.", Duration = 3})
        end
    end
end)

-- Script list (ScrollingFrame)
local ScriptList = Instance.new("ScrollingFrame")
ScriptList.Size = UDim2.new(1, -30, 0, 290)
ScriptList.Position = UDim2.new(0, 15, 0, 95)
ScriptList.BackgroundTransparency = 1
ScriptList.ScrollBarThickness = 4
ScriptList.ScrollBarImageColor3 = ACCENT
ScriptList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptList.Parent = HubFrame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScriptList

local function createScriptCard(script)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 80)
    card.BackgroundColor3 = ELEMENT
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(0, 60, 0, 60)
    thumb.Position = UDim2.new(0, 8, 0, 10)
    thumb.Image = script.image or "rbxassetid://122198206955790"
    thumb.ScaleType = Enum.ScaleType.Fit
    thumb.BackgroundColor3 = SECONDARY
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 6)
    thumb.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 0, 20)
    titleLabel.Position = UDim2.new(0, 80, 0, 8)
    titleLabel.Text = script.title or "Untitled"
    titleLabel.TextColor3 = TEXT_PRIMARY
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -80, 0, 22)
    descLabel.Position = UDim2.new(0, 80, 0, 30)
    descLabel.Text = script.description or "No description"
    descLabel.TextColor3 = TEXT_SECONDARY
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.BackgroundTransparency = 1
    descLabel.Parent = card

    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0, 130, 0, 22)
    btnFrame.Position = UDim2.new(1, -140, 0, 52)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = card

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0, 55, 1, 0)
    execBtn.Position = UDim2.new(0, 0, 0, 0)
    execBtn.BackgroundColor3 = ACCENT
    execBtn.Text = "Execute"
    execBtn.TextColor3 = TEXT_PRIMARY
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 12
    Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 4)
    execBtn.Parent = btnFrame
    execBtn.MouseButton1Click:Connect(function()
        execBtn.Text = "Loading..."
        execBtn.BackgroundColor3 = TEXT_SECONDARY
        spawn(function()
            local ok, content = pcall(game.HttpGet, game, script.script)
            if ok and content then
                pcall(function() loadstring(content)() end)
            else
                StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Failed to load script.", Duration = 3})
            end
            execBtn.Text = "Execute"
            execBtn.BackgroundColor3 = ACCENT
        end)
    end)

    local infoBtn = Instance.new("TextButton")
    infoBtn.Size = UDim2.new(0, 22, 1, 0)
    infoBtn.Position = UDim2.new(0, 60, 0, 0)
    infoBtn.BackgroundColor3 = ELEMENT
    infoBtn.Text = "⋯"
    infoBtn.TextColor3 = TEXT_PRIMARY
    infoBtn.Font = Enum.Font.GothamBold
    infoBtn.TextSize = 14
    Instance.new("UICorner", infoBtn).CornerRadius = UDim.new(0, 4)
    infoBtn.Parent = btnFrame
    infoBtn.MouseButton1Click:Connect(function()
        -- Simple info popup
        local popup = Instance.new("Frame")
        popup.Size = UDim2.new(0, 300, 0, 200)
        popup.Position = UDim2.new(0.5, -150, 0.5, -100)
        popup.BackgroundColor3 = SECONDARY
        popup.BorderSizePixel = 0
        popup.ZIndex = 20
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 10)
        popup.Parent = Gui

        local popTitle = Instance.new("TextLabel")
        popTitle.Size = UDim2.new(1, -20, 0, 25)
        popTitle.Position = UDim2.new(0, 10, 0, 10)
        popTitle.Text = script.title or "Script Info"
        popTitle.TextColor3 = TEXT_PRIMARY
        popTitle.Font = Enum.Font.GothamBold
        popTitle.TextSize = 16
        popTitle.BackgroundTransparency = 1
        popTitle.TextXAlignment = Enum.TextXAlignment.Left
        popTitle.Parent = popup

        local popDesc = Instance.new("TextLabel")
        popDesc.Size = UDim2.new(1, -20, 0, 130)
        popDesc.Position = UDim2.new(0, 10, 0, 40)
        popDesc.Text = "Author: " .. (script.author or "Unknown") .. "\nDownloads: " .. (script.downloads or "N/A") .. "\n\n" .. (script.description or "No description")
        popDesc.TextColor3 = TEXT_PRIMARY
        popDesc.Font = Enum.Font.Gotham
        popDesc.TextSize = 13
        popDesc.BackgroundTransparency = 1
        popDesc.TextXAlignment = Enum.TextXAlignment.Left
        popDesc.TextYAlignment = Enum.TextYAlignment.Top
        popDesc.Parent = popup

        local popClose = Instance.new("TextButton")
        popClose.Size = UDim2.new(0, 60, 0, 25)
        popClose.Position = UDim2.new(1, -70, 1, -35)
        popClose.BackgroundColor3 = DANGER
        popClose.Text = "Close"
        popClose.TextColor3 = TEXT_PRIMARY
        popClose.Font = Enum.Font.GothamBold
        popClose.TextSize = 13
        Instance.new("UICorner", popClose).CornerRadius = UDim.new(0, 6)
        popClose.Parent = popup
        popClose.MouseButton1Click:Connect(function() popup:Destroy() end)

        local backdrop = Instance.new("TextButton")
        backdrop.Size = UDim2.new(1, 0, 1, 0)
        backdrop.BackgroundColor3 = Color3.new(0,0,0)
        backdrop.BackgroundTransparency = 0.7
        backdrop.ZIndex = 19
        backdrop.Text = ""
        backdrop.Parent = Gui
        backdrop.MouseButton1Click:Connect(function() popup:Destroy() backdrop:Destroy() end)
    end)

    if script.isUserScript then
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 22, 1, 0)
        delBtn.Position = UDim2.new(0, 85, 0, 0)
        delBtn.BackgroundColor3 = DANGER
        delBtn.Text = "🗑"
        delBtn.TextColor3 = TEXT_PRIMARY
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
        delBtn.Parent = btnFrame
        delBtn.MouseButton1Click:Connect(function()
            local user = loadUserScripts()
            for i, s in ipairs(user) do
                if s.script == script.script then
                    table.remove(user, i)
                    break
                end
            end
            saveUserScripts(user)
            mergeScripts()
            displayScripts()
        end)
    end

    return card
end

local function displayScripts()
    -- Clear cards
    for _, child in ipairs(ScriptList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local filtered = {}
    local search = cache.searchTerm or ""
    local cat = cache.category:lower()
    for _, script in ipairs(cache.scripts) do
        if search ~= "" and not script.title:lower():find(search) then continue end
        if cat ~= "all" then
            local txt = (script.title .. " " .. (script.description or "")):lower()
            if not txt:find(cat) then continue end
        end
        table.insert(filtered, script)
    end
    if #filtered == 0 then
        local noLabel = Instance.new("TextLabel")
        noLabel.Size = UDim2.new(1, 0, 0, 30)
        noLabel.BackgroundTransparency = 1
        noLabel.Text = "No scripts found."
        noLabel.TextColor3 = TEXT_SECONDARY
        noLabel.Font = Enum.Font.Gotham
        noLabel.TextSize = 14
        noLabel.Parent = ScriptList
    else
        for _, script in ipairs(filtered) do
            createScriptCard(script).Parent = ScriptList
        end
    end
    ScriptList.CanvasSize = UDim2.new(0, 0, 0, #filtered * 88 + 20)
end

-- Fetch from scriptblox
local function fetchScripts(category)
    local url = "https://scriptblox.com/api/scripts?sort=top&limit=40"
    if category and category:lower() ~= "all" then
        url = url .. "&search=" .. category:lower()
    end
    local ok, json = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    local fetched = {}
    if ok and json and json.scripts then
        fetched = json.scripts
    else
        StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Could not fetch scripts.", Duration = 3})
    end
    mergeScripts(fetched)
    displayScripts()
end

-- Initial fetch
fetchScripts("All")

-- ==================== TAB SWITCHING ====================
HomeBtn.MouseButton1Click:Connect(function()
    HomeFrame.Visible = true
    HubFrame.Visible = false
    HomeBtn.BackgroundColor3 = ACCENT
    HubBtn.BackgroundColor3 = ELEMENT
end)
HubBtn.MouseButton1Click:Connect(function()
    HomeFrame.Visible = false
    HubFrame.Visible = true
    HubBtn.BackgroundColor3 = ACCENT
    HomeBtn.BackgroundColor3 = ELEMENT
end)

-- ==================== TOGGLE WITH RIGHT SHIFT ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ==================== DONE ====================
StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "ScriptHub loaded! Right Shift to toggle.", Duration = 5})