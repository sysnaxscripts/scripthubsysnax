-- Sysnax ScriptHub
-- By RonixHub_Owner
-- Discord: https://discord.gg/xadh9mPGaN
-- Logo: 122198206955790
-- UI: Xeno‑inspired (dark, smooth, purple accent)
-- Features: Welcome animation, Home (avatar + info), ScriptHub (scriptblox.com top scripts, execute, details)

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==================== AC BYPASS ====================
pcall(function()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") then
            local name = obj.Name:lower()
            if name:find("anticheat") or name:find("antihack") or name:find("detection") or name:find("ac") or obj.Name == "LocalScript" then
                obj.Disabled = true
            end
        end
    end
    if LocalPlayer.PlayerGui then
        for _, obj in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if obj:IsA("LocalScript") then
                local name = obj.Name:lower()
                if name:find("anticheat") or name:find("antihack") or name:find("detection") or name:find("ac") or obj.Name == "LocalScript" then
                    obj.Disabled = true
                end
            end
        end
    end
end)

-- ==================== THEME ====================
local BG = Color3.fromRGB(18, 18, 20)
local ACCENT = Color3.fromRGB(120, 86, 255)   -- Xeno purple
local SECONDARY = Color3.fromRGB(28, 28, 32)
local ELEMENT = Color3.fromRGB(33, 33, 38)
local TEXT = Color3.fromRGB(240, 240, 240)
local SUBTEXT = Color3.fromRGB(160, 160, 170)
local DANGER = Color3.fromRGB(255, 70, 70)

-- ==================== CREATE MAIN GUI ====================
local SysnaxGui = Instance.new("ScreenGui")
SysnaxGui.Name = "Sysnax"
SysnaxGui.ResetOnSpawn = false
SysnaxGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== WELCOME ANIMATION ====================
local WelcomeFrame = Instance.new("Frame")
WelcomeFrame.Size = UDim2.new(1, 0, 1, 0)
WelcomeFrame.BackgroundColor3 = BG
WelcomeFrame.BorderSizePixel = 0
WelcomeFrame.Parent = SysnaxGui

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 100, 0, 100)
Logo.Position = UDim2.new(0.5, -50, 0.4, -50)
Logo.Image = "rbxassetid://122198206955790"
Logo.BackgroundTransparency = 1
Logo.Parent = WelcomeFrame

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, 0, 0, 30)
WelcomeText.Position = UDim2.new(0, 0, 0.55, 0)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Welcome, " .. LocalPlayer.DisplayName
WelcomeText.TextColor3 = TEXT
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.TextSize = 24
WelcomeText.Parent = WelcomeFrame

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, 0, 0, 20)
SubText.Position = UDim2.new(0, 0, 0.6, 0)
SubText.BackgroundTransparency = 1
SubText.Text = "Sysnax ScriptHub"
SubText.TextColor3 = SUBTEXT
SubText.Font = Enum.Font.Gotham
SubText.TextSize = 16
SubText.Parent = WelcomeFrame

-- Fade in
WelcomeFrame.BackgroundTransparency = 1
Logo.ImageTransparency = 1
WelcomeText.TextTransparency = 1
SubText.TextTransparency = 1
TweenService:Create(WelcomeFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
TweenService:Create(Logo, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
TweenService:Create(WelcomeText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
TweenService:Create(SubText, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

-- Remove welcome after 2.5 seconds and reveal main UI
task.delay(2.5, function()
    TweenService:Create(WelcomeFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    WelcomeFrame:Destroy()
    -- Now open the main interface
    loadMainUI()
end)

-- ==================== MAIN UI ====================
local MainFrame, HomeTab, ScriptHubTab
local currentTab = "Home"

function loadMainUI()
    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 800, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    MainFrame.BackgroundColor3 = SECONDARY
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = SysnaxGui

    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = MainFrame

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = ELEMENT
    TitleBar.BorderSizePixel = 0
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = TitleBar
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Sysnax ScriptHub"
    TitleLabel.TextColor3 = TEXT
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = DANGER
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = TEXT
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = CloseBtn
    CloseBtn.Parent = TitleBar
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame:Destroy()
    end)

    -- Navigation bar (Home / ScriptHub)
    local NavBar = Instance.new("Frame")
    NavBar.Size = UDim2.new(0, 160, 1, -40)
    NavBar.Position = UDim2.new(0, 0, 0, 40)
    NavBar.BackgroundColor3 = ELEMENT
    NavBar.BorderSizePixel = 0
    NavBar.Parent = MainFrame

    local HomeBtn = createNavButton("Home", 10)
    HomeBtn.Parent = NavBar
    local ScriptHubBtn = createNavButton("ScriptHub", 50)
    ScriptHubBtn.Parent = NavBar

    -- Discord button at bottom of nav
    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Size = UDim2.new(1, -20, 0, 30)
    DiscordBtn.Position = UDim2.new(0, 10, 1, -40)
    DiscordBtn.BackgroundColor3 = ACCENT
    DiscordBtn.Text = "Discord"
    DiscordBtn.TextColor3 = TEXT
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.TextSize = 14
    local dCorner = Instance.new("UICorner")
    dCorner.CornerRadius = UDim.new(0, 8)
    dCorner.Parent = DiscordBtn
    DiscordBtn.Parent = NavBar
    DiscordBtn.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/xadh9mPGaN")
        StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Discord invite copied!", Duration = 3})
    end)

    -- Content area
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -160, 1, -40)
    Content.Position = UDim2.new(0, 160, 0, 40)
    Content.BackgroundColor3 = SECONDARY
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame

    -- Home tab content
    HomeTab = Instance.new("Frame")
    HomeTab.Size = UDim2.new(1, 0, 1, 0)
    HomeTab.BackgroundTransparency = 1
    HomeTab.Visible = true
    HomeTab.Parent = Content
    buildHomeTab()

    -- ScriptHub tab content (initially hidden)
    ScriptHubTab = Instance.new("Frame")
    ScriptHubTab.Size = UDim2.new(1, 0, 1, 0)
    ScriptHubTab.BackgroundTransparency = 1
    ScriptHubTab.Visible = false
    ScriptHubTab.Parent = Content
    buildScriptHubTab()

    -- Navigation logic
    function switchTab(tab)
        if tab == "Home" then
            HomeTab.Visible = true
            ScriptHubTab.Visible = false
            HomeBtn.BackgroundColor3 = ACCENT
            ScriptHubBtn.BackgroundColor3 = ELEMENT
        else
            HomeTab.Visible = false
            ScriptHubTab.Visible = true
            HomeBtn.BackgroundColor3 = ELEMENT
            ScriptHubBtn.BackgroundColor3 = ACCENT
        end
    end

    HomeBtn.MouseButton1Click:Connect(function() switchTab("Home") end)
    ScriptHubBtn.MouseButton1Click:Connect(function() switchTab("ScriptHub") end)

    -- Initial highlight
    HomeBtn.BackgroundColor3 = ACCENT
    ScriptHubBtn.BackgroundColor3 = ELEMENT
end

function createNavButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = ELEMENT
    btn.Text = text
    btn.TextColor3 = TEXT
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.TextXAlignment = Enum.TextXAlignment.Left
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

-- ==================== HOME TAB ====================
function buildHomeTab()
    -- Avatar
    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 80, 0, 80)
    Avatar.Position = UDim2.new(0, 20, 0, 20)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(0, 40)
    avCorner.Parent = Avatar
    Avatar.Parent = HomeTab

    -- Username
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0, 300, 0, 30)
    NameLabel.Position = UDim2.new(0, 120, 0, 25)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = LocalPlayer.DisplayName
    NameLabel.TextColor3 = TEXT
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 22
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = HomeTab

    -- Info
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(0, 300, 0, 40)
    InfoLabel.Position = UDim2.new(0, 120, 0, 60)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "Welcome to Sysnax ScriptHub\nBrowse and execute top scripts from ScriptBlox"
    InfoLabel.TextColor3 = SUBTEXT
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 14
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.TextWrapped = true
    InfoLabel.Parent = HomeTab

    -- Server info section
    local ServerInfo = Instance.new("Frame")
    ServerInfo.Size = UDim2.new(0, 350, 0, 100)
    ServerInfo.Position = UDim2.new(0, 20, 0, 130)
    ServerInfo.BackgroundColor3 = ELEMENT
    ServerInfo.BorderSizePixel = 0
    local servCorner = Instance.new("UICorner")
    servCorner.CornerRadius = UDim.new(0, 10)
    servCorner.Parent = ServerInfo
    ServerInfo.Parent = HomeTab

    local ServerTitle = Instance.new("TextLabel")
    ServerTitle.Size = UDim2.new(1, -20, 0, 20)
    ServerTitle.Position = UDim2.new(0, 10, 0, 10)
    ServerTitle.BackgroundTransparency = 1
    ServerTitle.Text = "Server"
    ServerTitle.TextColor3 = ACCENT
    ServerTitle.Font = Enum.Font.GothamBold
    ServerTitle.TextSize = 16
    ServerTitle.TextXAlignment = Enum.TextXAlignment.Left
    ServerTitle.Parent = ServerInfo

    local PlayersOnline = Instance.new("TextLabel")
    PlayersOnline.Size = UDim2.new(1, -20, 0, 16)
    PlayersOnline.Position = UDim2.new(0, 10, 0, 35)
    PlayersOnline.BackgroundTransparency = 1
    PlayersOnline.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
    PlayersOnline.TextColor3 = TEXT
    PlayersOnline.Font = Enum.Font.Gotham
    PlayersOnline.TextSize = 14
    PlayersOnline.TextXAlignment = Enum.TextXAlignment.Left
    PlayersOnline.Parent = ServerInfo

    local PlaceName = Instance.new("TextLabel")
    PlaceName.Size = UDim2.new(1, -20, 0, 16)
    PlaceName.Position = UDim2.new(0, 10, 0, 55)
    PlaceName.BackgroundTransparency = 1
    PlaceName.Text = "Place: " .. game.PlaceId
    PlaceName.TextColor3 = TEXT
    PlaceName.Font = Enum.Font.Gotham
    PlaceName.TextSize = 14
    PlaceName.TextXAlignment = Enum.TextXAlignment.Left
    PlaceName.Parent = ServerInfo

    local ClientInfo = Instance.new("TextLabel")
    ClientInfo.Size = UDim2.new(1, -20, 0, 16)
    ClientInfo.Position = UDim2.new(0, 10, 0, 75)
    ClientInfo.BackgroundTransparency = 1
    ClientInfo.Text = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown")
    ClientInfo.TextColor3 = TEXT
    ClientInfo.Font = Enum.Font.Gotham
    ClientInfo.TextSize = 14
    ClientInfo.TextXAlignment = Enum.TextXAlignment.Left
    ClientInfo.Parent = ServerInfo
end

-- ==================== SCRIPTHUB TAB ====================
local ScriptsData = {}
local ScriptListFrame

function buildScriptHubTab()
    local SearchBar = Instance.new("TextBox")
    SearchBar.Size = UDim2.new(1, -20, 0, 35)
    SearchBar.Position = UDim2.new(0, 10, 0, 10)
    SearchBar.BackgroundColor3 = ELEMENT
    SearchBar.BorderSizePixel = 0
    SearchBar.Text = ""
    SearchBar.PlaceholderText = "Search scripts..."
    SearchBar.TextColor3 = TEXT
    SearchBar.PlaceholderColor3 = SUBTEXT
    SearchBar.Font = Enum.Font.Gotham
    SearchBar.TextSize = 15
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 10)
    searchCorner.Parent = SearchBar
    SearchBar.Parent = ScriptHubTab

    ScriptListFrame = Instance.new("ScrollingFrame")
    ScriptListFrame.Size = UDim2.new(1, -20, 1, -55)
    ScriptListFrame.Position = UDim2.new(0, 10, 0, 55)
    ScriptListFrame.BackgroundTransparency = 1
    ScriptListFrame.BorderSizePixel = 0
    ScriptListFrame.ScrollBarThickness = 4
    ScriptListFrame.ScrollBarImageColor3 = ACCENT
    ScriptListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScriptListFrame.Parent = ScriptHubTab

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingRight = UDim.new(0, 4)
    UIPadding.Parent = ScriptListFrame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScriptListFrame

    -- Fetch top scripts from scriptblox.com
    loadScripts()
end

function loadScripts()
    ScriptListFrame:ClearAllChildren()
    local success, data = pcall(function()
        -- ScriptBlox public API: get top scripts (sorted by downloads)
        local response = HttpService:JSONDecode(
            game:HttpGet("https://scriptblox.com/api/scripts?sort=top&limit=30")
        )
        return response.scripts or {}
    end)
    if not success or #data == 0 then
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(1, 0, 0, 30)
        errorLabel.BackgroundTransparency = 1
        errorLabel.Text = "Failed to load scripts. Check your internet."
        errorLabel.TextColor3 = SUBTEXT
        errorLabel.Font = Enum.Font.Gotham
        errorLabel.TextSize = 16
        errorLabel.Parent = ScriptListFrame
        return
    end
    ScriptsData = data
    displayScripts(data)
end

function displayScripts(scripts)
    ScriptListFrame.CanvasSize = UDim2.new(0, 0, 0, #scripts * 110 + 20)
    for i, script in ipairs(scripts) do
        local card = createScriptCard(script, i)
        card.Parent = ScriptListFrame
    end
end

function createScriptCard(scriptData, index)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 100)
    card.BackgroundColor3 = ELEMENT
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    -- Thumbnail
    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(0, 80, 0, 80)
    thumb.Position = UDim2.new(0, 10, 0, 10)
    thumb.BackgroundColor3 = SECONDARY
    thumb.Image = scriptData.image or "rbxassetid://122198206955790"
    thumb.ScaleType = Enum.ScaleType.Fit
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 8)
    thumbCorner.Parent = thumb
    thumb.Parent = card

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -110, 0, 25)
    titleLabel.Position = UDim2.new(0, 100, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = scriptData.title or "Untitled"
    titleLabel.TextColor3 = TEXT
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 17
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = card

    -- Description (short)
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -110, 0, 30)
    descLabel.Position = UDim2.new(0, 100, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = scriptData.description or "No description"
    descLabel.TextColor3 = SUBTEXT
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 13
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = card

    -- Buttons area
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0, 200, 0, 30)
    btnFrame.Position = UDim2.new(0, 100, 0, 65)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = card

    -- Execute button
    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0, 80, 1, 0)
    execBtn.BackgroundColor3 = ACCENT
    execBtn.Text = "Execute"
    execBtn.TextColor3 = TEXT
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 14
    local execCorner = Instance.new("UICorner")
    execCorner.CornerRadius = UDim.new(0, 6)
    execCorner.Parent = execBtn
    execBtn.Parent = btnFrame

    execBtn.MouseButton1Click:Connect(function()
        -- Fetch and execute the script
        local scriptUrl = scriptData.script  -- raw URL from API
        if not scriptUrl or scriptUrl == "" then
            StarterGui:SetCore("SendNotification", {Title = "Error", Text = "No script URL found.", Duration = 3})
            return
        end
        execBtn.Text = "Loading..."
        execBtn.BackgroundColor3 = SUBTEXT
        spawn(function()
            local success, scriptContent = pcall(function() return game:HttpGet(scriptUrl) end)
            if success and scriptContent then
                local executeSuccess, err = pcall(function() loadstring(scriptContent)() end)
                if not executeSuccess then
                    StarterGui:SetCore("SendNotification", {Title = "Execution Error", Text = tostring(err), Duration = 5})
                end
            else
                StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Failed to download script.", Duration = 3})
            end
            execBtn.Text = "Execute"
            execBtn.BackgroundColor3 = ACCENT
        end)
    end)

    -- Info button (three dots)
    local infoBtn = Instance.new("TextButton")
    infoBtn.Size = UDim2.new(0, 30, 1, 0)
    infoBtn.Position = UDim2.new(0, 85, 0, 0)
    infoBtn.BackgroundColor3 = SECONDARY
    infoBtn.Text = "⋯"
    infoBtn.TextColor3 = TEXT
    infoBtn.Font = Enum.Font.GothamBold
    infoBtn.TextSize = 18
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoBtn
    infoBtn.Parent = btnFrame

    infoBtn.MouseButton1Click:Connect(function()
        showScriptInfo(scriptData)
    end)

    return card
end

function showScriptInfo(scriptData)
    -- Popup with full description, author, downloads, etc.
    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 400, 0, 300)
    popup.Position = UDim2.new(0.5, -200, 0.5, -150)
    popup.BackgroundColor3 = SECONDARY
    popup.BorderSizePixel = 0
    popup.ZIndex = 10
    local popupCorner = Instance.new("UICorner")
    popupCorner.CornerRadius = UDim.new(0, 12)
    popupCorner.Parent = popup
    popup.Parent = SysnaxGui

    -- Title
    local popTitle = Instance.new("TextLabel")
    popTitle.Size = UDim2.new(1, -20, 0, 30)
    popTitle.Position = UDim2.new(0, 10, 0, 10)
    popTitle.BackgroundTransparency = 1
    popTitle.Text = scriptData.title or "Script Info"
    popTitle.TextColor3 = TEXT
    popTitle.Font = Enum.Font.GothamBold
    popTitle.TextSize = 20
    popTitle.TextXAlignment = Enum.TextXAlignment.Left
    popTitle.Parent = popup

    -- Description scroll
    local descFrame = Instance.new("ScrollingFrame")
    descFrame.Size = UDim2.new(1, -20, 0, 180)
    descFrame.Position = UDim2.new(0, 10, 0, 50)
    descFrame.BackgroundTransparency = 1
    descFrame.ScrollBarThickness = 4
    descFrame.ScrollBarImageColor3 = ACCENT
    descFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    descFrame.Parent = popup

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, 0, 0, 0)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = "Description:\n" .. (scriptData.description or "No description") .. 
                     "\n\nAuthor: " .. (scriptData.author or "Unknown") ..
                     "\nDownloads: " .. (scriptData.downloads or "N/A") ..
                     "\nVersion: " .. (scriptData.version or "N/A")
    descLabel.TextColor3 = TEXT
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 14
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Size = UDim2.new(1, 0, 0, TextService:GetTextSize(descLabel.Text, 14, Enum.Font.Gotham, Vector2.new(380, math.huge)).Y)
    descLabel.Parent = descFrame
    descFrame.CanvasSize = UDim2.new(0, 0, 0, descLabel.Size.Y.Offset + 10)

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 80, 0, 30)
    closeBtn.Position = UDim2.new(1, -90, 1, -40)
    closeBtn.BackgroundColor3 = DANGER
    closeBtn.Text = "Close"
    closeBtn.TextColor3 = TEXT
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    closeBtn.Parent = popup
    closeBtn.MouseButton1Click:Connect(function() popup:Destroy() end)

    -- Backdrop to close on outside click
    local backdrop = Instance.new("TextButton")
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
    backdrop.BackgroundTransparency = 0.7
    backdrop.ZIndex = 9
    backdrop.Text = ""
    backdrop.Parent = SysnaxGui
    backdrop.MouseButton1Click:Connect(function()
        popup:Destroy()
        backdrop:Destroy()
    end)
    popup.Backdrop = backdrop  -- keep reference to clean up later
end

-- ==================== FINAL INIT ====================
-- Hide the MainFrame initially; it will be created after welcome animation
SysnaxGui.Enabled = true

-- Notify user
StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "ScriptHub loaded! Press Right Shift to toggle.", Duration = 5})

-- Simple toggle with Right Shift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if MainFrame then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)