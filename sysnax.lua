-- Sysnax ScriptHub
-- Manual script adding, categories, movable, smooth welcome
-- AC bypass included
-- UI matches Xeno‑style (dark, purple accent)

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

-- ==================== CONSTANTS ====================
local BG = Color3.fromRGB(18, 18, 20)
local SECONDARY = Color3.fromRGB(28, 28, 32)
local ELEMENT = Color3.fromRGB(33, 33, 38)
local ACCENT = Color3.fromRGB(120, 86, 255)
local TEXT = Color3.fromRGB(240, 240, 240)
local SUBTEXT = Color3.fromRGB(160, 160, 170)
local DANGER = Color3.fromRGB(255, 70, 70)

-- ==================== MAIN GUI ====================
local SysnaxGui = Instance.new("ScreenGui")
SysnaxGui.Name = "Sysnax"
SysnaxGui.ResetOnSpawn = false
SysnaxGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== WELCOME SCREEN (inside main frame) ====================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 800, 0, 500)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
MainFrame.BackgroundColor3 = SECONDARY
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = SysnaxGui

-- rounded corners for the whole frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

-- ==================== MOVABLE WINDOW ====================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = ELEMENT
titleBar.BorderSizePixel = 0
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar
titleBar.Parent = MainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Sysnax ScriptHub"
titleText.TextColor3 = TEXT
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = DANGER
closeBtn.Text = "X"
closeBtn.TextColor3 = TEXT
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
local cClose = Instance.new("UICorner"); cClose.CornerRadius = UDim.new(0, 8); cClose.Parent = closeBtn
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() MainFrame:Destroy() end)

-- dragging logic
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== NAVIGATION BAR ====================
local NavBar = Instance.new("Frame")
NavBar.Size = UDim2.new(0, 160, 1, -40)
NavBar.Position = UDim2.new(0, 0, 0, 40)
NavBar.BackgroundColor3 = ELEMENT
NavBar.BorderSizePixel = 0
NavBar.Parent = MainFrame

local HomeBtn = Instance.new("TextButton")
HomeBtn.Size = UDim2.new(1, -20, 0, 30)
HomeBtn.Position = UDim2.new(0, 10, 0, 10)
HomeBtn.BackgroundColor3 = ACCENT
HomeBtn.Text = "Home"
HomeBtn.TextColor3 = TEXT
HomeBtn.Font = Enum.Font.Gotham
HomeBtn.TextSize = 15
HomeBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", HomeBtn).CornerRadius = UDim.new(0, 8)
HomeBtn.Parent = NavBar

local ScriptHubBtn = Instance.new("TextButton")
ScriptHubBtn.Size = UDim2.new(1, -20, 0, 30)
ScriptHubBtn.Position = UDim2.new(0, 10, 0, 50)
ScriptHubBtn.BackgroundColor3 = ELEMENT
ScriptHubBtn.Text = "ScriptHub"
ScriptHubBtn.TextColor3 = TEXT
ScriptHubBtn.Font = Enum.Font.Gotham
ScriptHubBtn.TextSize = 15
ScriptHubBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", ScriptHubBtn).CornerRadius = UDim.new(0, 8)
ScriptHubBtn.Parent = NavBar

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, -20, 0, 30)
DiscordBtn.Position = UDim2.new(0, 10, 1, -40)
DiscordBtn.BackgroundColor3 = ACCENT
DiscordBtn.Text = "Discord"
DiscordBtn.TextColor3 = TEXT
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 14
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)
DiscordBtn.Parent = NavBar
DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/xadh9mPGaN")
    StarterGui:SetCore("SendNotification", { Title = "Sysnax", Text = "Discord invite copied!", Duration = 3 })
end)

-- ==================== CONTENT AREA ====================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -160, 1, -40)
Content.Position = UDim2.new(0, 160, 0, 40)
Content.BackgroundColor3 = SECONDARY
Content.BorderSizePixel = 0
Content.Parent = MainFrame

-- ==================== HOME TAB ====================
local HomeTab = Instance.new("Frame")
HomeTab.Size = UDim2.new(1, 0, 1, 0)
HomeTab.BackgroundTransparency = 1
HomeTab.Visible = true
HomeTab.Parent = Content

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 80, 0, 80)
Avatar.Position = UDim2.new(0, 20, 0, 20)
Avatar.BackgroundTransparency = 1
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(0, 40)
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

-- Server info frame
local ServerFrame = Instance.new("Frame")
ServerFrame.Size = UDim2.new(0, 350, 0, 100)
ServerFrame.Position = UDim2.new(0, 20, 0, 130)
ServerFrame.BackgroundColor3 = ELEMENT
ServerFrame.BorderSizePixel = 0
Instance.new("UICorner", ServerFrame).CornerRadius = UDim.new(0, 10)
ServerFrame.Parent = HomeTab

local ServerTitle = Instance.new("TextLabel")
ServerTitle.Size = UDim2.new(1, -20, 0, 20)
ServerTitle.Position = UDim2.new(0, 10, 0, 10)
ServerTitle.BackgroundTransparency = 1
ServerTitle.Text = "Server"
ServerTitle.TextColor3 = ACCENT
ServerTitle.Font = Enum.Font.GothamBold
ServerTitle.TextSize = 16
ServerTitle.TextXAlignment = Enum.TextXAlignment.Left
ServerTitle.Parent = ServerFrame

local PlayersOnline = Instance.new("TextLabel")
PlayersOnline.Size = UDim2.new(1, -20, 0, 16)
PlayersOnline.Position = UDim2.new(0, 10, 0, 35)
PlayersOnline.BackgroundTransparency = 1
PlayersOnline.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
PlayersOnline.TextColor3 = TEXT
PlayersOnline.Font = Enum.Font.Gotham
PlayersOnline.TextSize = 14
PlayersOnline.TextXAlignment = Enum.TextXAlignment.Left
PlayersOnline.Parent = ServerFrame

local PlaceText = Instance.new("TextLabel")
PlaceText.Size = UDim2.new(1, -20, 0, 16)
PlaceText.Position = UDim2.new(0, 10, 0, 55)
PlaceText.BackgroundTransparency = 1
PlaceText.Text = "Place: " .. game.PlaceId
PlaceText.TextColor3 = TEXT
PlaceText.Font = Enum.Font.Gotham
PlaceText.TextSize = 14
PlaceText.TextXAlignment = Enum.TextXAlignment.Left
PlaceText.Parent = ServerFrame

local ExecutorText = Instance.new("TextLabel")
ExecutorText.Size = UDim2.new(1, -20, 0, 16)
ExecutorText.Position = UDim2.new(0, 10, 0, 75)
ExecutorText.BackgroundTransparency = 1
ExecutorText.Text = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown")
ExecutorText.TextColor3 = TEXT
ExecutorText.Font = Enum.Font.Gotham
ExecutorText.TextSize = 14
ExecutorText.TextXAlignment = Enum.TextXAlignment.Left
ExecutorText.Parent = ServerFrame

-- ==================== SCRIPTHUB TAB ====================
local ScriptHubTab = Instance.new("Frame")
ScriptHubTab.Size = UDim2.new(1, 0, 1, 0)
ScriptHubTab.BackgroundTransparency = 1
ScriptHubTab.Visible = false
ScriptHubTab.Parent = Content

-- Search bar
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
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 10)
SearchBar.Parent = ScriptHubTab

-- Tag filter (dropdown from a list)
local Tags = {"#all", "#rivals", "#arsenal", "#hypershot", "#fps", "#utility", "#misc"}
local TagFilter = Instance.new("Frame")
TagFilter.Size = UDim2.new(1, -20, 0, 30)
TagFilter.Position = UDim2.new(0, 10, 0, 50)
TagFilter.BackgroundTransparency = 1
TagFilter.Parent = ScriptHubTab

local selectedTag = "#all"
for i, tag in ipairs(Tags) do
    local tagBtn = Instance.new("TextButton")
    tagBtn.Size = UDim2.new(0, 70, 0, 25)
    tagBtn.Position = UDim2.new(0, (i-1)*75, 0, 0)
    tagBtn.BackgroundColor3 = tag == selectedTag and ACCENT or ELEMENT
    tagBtn.Text = tag
    tagBtn.TextColor3 = TEXT
    tagBtn.Font = Enum.Font.Gotham
    tagBtn.TextSize = 13
    Instance.new("UICorner", tagBtn).CornerRadius = UDim.new(0, 8)
    tagBtn.Parent = TagFilter
    tagBtn.MouseButton1Click:Connect(function()
        selectedTag = tag
        for _, b in ipairs(TagFilter:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = b.Text == tag and ACCENT or ELEMENT
            end
        end
        loadScripts()  -- reload with tag filter
    end)
end

-- Script list frame
local ScriptList = Instance.new("ScrollingFrame")
ScriptList.Size = UDim2.new(1, -20, 1, -135)
ScriptList.Position = UDim2.new(0, 10, 0, 85)
ScriptList.BackgroundTransparency = 1
ScriptList.BorderSizePixel = 0
ScriptList.ScrollBarThickness = 4
ScriptList.ScrollBarImageColor3 = ACCENT
ScriptList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptList.Parent = ScriptHubTab

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScriptList

-- Manual script input at bottom
local ManualFrame = Instance.new("Frame")
ManualFrame.Size = UDim2.new(1, -20, 0, 40)
ManualFrame.Position = UDim2.new(0, 10, 1, -45)
ManualFrame.BackgroundColor3 = ELEMENT
ManualFrame.BorderSizePixel = 0
Instance.new("UICorner", ManualFrame).CornerRadius = UDim.new(0, 10)
ManualFrame.Parent = ScriptHubTab

local ManualInput = Instance.new("TextBox")
ManualInput.Size = UDim2.new(0, 250, 0, 30)
ManualInput.Position = UDim2.new(0, 5, 0, 5)
ManualInput.BackgroundColor3 = SECONDARY
ManualInput.BorderSizePixel = 0
ManualInput.Text = ""
ManualInput.PlaceholderText = "Script URL..."
ManualInput.TextColor3 = TEXT
ManualInput.PlaceholderColor3 = SUBTEXT
ManualInput.Font = Enum.Font.Gotham
ManualInput.TextSize = 14
Instance.new("UICorner", ManualInput).CornerRadius = UDim.new(0, 6)
ManualInput.Parent = ManualFrame

local ManualNameInput = Instance.new("TextBox")
ManualNameInput.Size = UDim2.new(0, 120, 0, 30)
ManualNameInput.Position = UDim2.new(0, 265, 0, 5)
ManualNameInput.BackgroundColor3 = SECONDARY
ManualNameInput.BorderSizePixel = 0
ManualNameInput.Text = ""
ManualNameInput.PlaceholderText = "Name"
ManualNameInput.TextColor3 = TEXT
ManualNameInput.PlaceholderColor3 = SUBTEXT
ManualNameInput.Font = Enum.Font.Gotham
ManualNameInput.TextSize = 14
Instance.new("UICorner", ManualNameInput).CornerRadius = UDim.new(0, 6)
ManualNameInput.Parent = ManualFrame

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0, 60, 0, 30)
AddBtn.Position = UDim2.new(0, 395, 0, 5)
AddBtn.BackgroundColor3 = ACCENT
AddBtn.Text = "Add"
AddBtn.TextColor3 = TEXT
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 14
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 6)
AddBtn.Parent = ManualFrame

AddBtn.MouseButton1Click:Connect(function()
    local url = ManualInput.Text
    local name = ManualNameInput.Text
    if url ~= "" then
        addManualScript(name ~= "" and name or "Custom Script", url)
        ManualInput.Text = ""
        ManualNameInput.Text = ""
    end
end)

-- ==================== SCRIPT LOADING FUNCTIONS ====================
local ScriptsCache = {}

function loadScripts()
    ScriptList:ClearAllChildren()
    local success, data = pcall(function()
        local url = "https://scriptblox.com/api/scripts?sort=top&limit=50"
        if selectedTag ~= "#all" then
            local tag = selectedTag:gsub("#", "")
            url = url .. "&category=" .. tag
        end
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if success and data and data.scripts then
        ScriptsCache = data.scripts
        displayScripts(ScriptsCache)
    else
        local errLabel = Instance.new("TextLabel")
        errLabel.Size = UDim2.new(1, 0, 0, 30)
        errLabel.BackgroundTransparency = 1
        errLabel.Text = "Failed to load scripts. Check internet."
        errLabel.TextColor3 = SUBTEXT
        errLabel.Font = Enum.Font.Gotham
        errLabel.TextSize = 16
        errLabel.Parent = ScriptList
    end
end

function displayScripts(scripts)
    ScriptList.CanvasSize = UDim2.new(0, 0, 0, #scripts * 110 + 20)
    for i, script in ipairs(scripts) do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 100)
        card.BackgroundColor3 = ELEMENT
        card.BorderSizePixel = 0
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        card.Parent = ScriptList

        local thumb = Instance.new("ImageLabel")
        thumb.Size = UDim2.new(0, 80, 0, 80)
        thumb.Position = UDim2.new(0, 10, 0, 10)
        thumb.BackgroundColor3 = SECONDARY
        thumb.Image = script.image or "rbxassetid://122198206955790"
        thumb.ScaleType = Enum.ScaleType.Fit
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 8)
        thumb.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -110, 0, 25)
        title.Position = UDim2.new(0, 100, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = script.title or "Untitled"
        title.TextColor3 = TEXT
        title.Font = Enum.Font.GothamBold
        title.TextSize = 17
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.Parent = card

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -110, 0, 30)
        desc.Position = UDim2.new(0, 100, 0, 35)
        desc.BackgroundTransparency = 1
        desc.Text = script.description or "No description"
        desc.TextColor3 = SUBTEXT
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 13
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.Parent = card

        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(0, 200, 0, 30)
        btnFrame.Position = UDim2.new(0, 100, 0, 65)
        btnFrame.BackgroundTransparency = 1
        btnFrame.Parent = card

        local execBtn = Instance.new("TextButton")
        execBtn.Size = UDim2.new(0, 80, 1, 0)
        execBtn.BackgroundColor3 = ACCENT
        execBtn.Text = "Execute"
        execBtn.TextColor3 = TEXT
        execBtn.Font = Enum.Font.GothamBold
        execBtn.TextSize = 14
        Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 6)
        execBtn.Parent = btnFrame
        execBtn.MouseButton1Click:Connect(function()
            execScriptCard(script)
        end)

        local infoBtn = Instance.new("TextButton")
        infoBtn.Size = UDim2.new(0, 30, 1, 0)
        infoBtn.Position = UDim2.new(0, 85, 0, 0)
        infoBtn.BackgroundColor3 = SECONDARY
        infoBtn.Text = "⋯"
        infoBtn.TextColor3 = TEXT
        infoBtn.Font = Enum.Font.GothamBold
        infoBtn.TextSize = 18
        Instance.new("UICorner", infoBtn).CornerRadius = UDim.new(0, 6)
        infoBtn.Parent = btnFrame
        infoBtn.MouseButton1Click:Connect(function()
            showScriptDetailPopup(script)
        end)
    end
end

function execScriptCard(scriptData)
    local url = scriptData.script
    if not url or url == "" then return end
    StarterGui:SetCore("SendNotification", { Title = "Sysnax", Text = "Loading script...", Duration = 2 })
    spawn(function()
        local success, content = pcall(function() return game:HttpGet(url) end)
        if success and content then
            loadstring(content)()
        else
            StarterGui:SetCore("SendNotification", { Title = "Error", Text = "Failed to load script.", Duration = 3 })
        end
    end)
end

function addManualScript(name, url)
    local manual = { title = name, description = "Manually added script", script = url, image = "rbxassetid://122198206955790", author = "User", downloads = "N/A" }
    table.insert(ScriptsCache, 1, manual)
    -- refresh display
    ScriptList:ClearAllChildren()
    displayScripts(ScriptsCache)
end

function showScriptDetailPopup(scriptData)
    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 400, 0, 300)
    popup.Position = UDim2.new(0.5, -200, 0.5, -150)
    popup.BackgroundColor3 = SECONDARY
    popup.BorderSizePixel = 0
    popup.ZIndex = 10
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 12)
    popup.Parent = SysnaxGui

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
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextWrapped = true
    local textSize = TextService:GetTextSize(descLabel.Text, 14, Enum.Font.Gotham, Vector2.new(380, math.huge))
    descLabel.Size = UDim2.new(1, 0, 0, textSize.Y)
    descLabel.Parent = descFrame
    descFrame.CanvasSize = UDim2.new(0, 0, 0, textSize.Y + 10)

    local closePopup = Instance.new("TextButton")
    closePopup.Size = UDim2.new(0, 80, 0, 30)
    closePopup.Position = UDim2.new(1, -90, 1, -40)
    closePopup.BackgroundColor3 = DANGER
    closePopup.Text = "Close"
    closePopup.TextColor3 = TEXT
    closePopup.Font = Enum.Font.GothamBold
    closePopup.TextSize = 14
    Instance.new("UICorner", closePopup).CornerRadius = UDim.new(0, 8)
    closePopup.Parent = popup
    closePopup.MouseButton1Click:Connect(function() popup:Destroy() end)

    -- backdrop
    local backdrop = Instance.new("TextButton")
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.new(0,0,0)
    backdrop.BackgroundTransparency = 0.7
    backdrop.ZIndex = 9
    backdrop.Text = ""
    backdrop.Parent = SysnaxGui
    backdrop.MouseButton1Click:Connect(function()
        popup:Destroy()
        backdrop:Destroy()
    end)
end

-- ==================== WELCOME ANIMATION ON MAIN FRAME ====================
local WelcomeFrame = Instance.new("Frame")
WelcomeFrame.Size = UDim2.new(1, 0, 1, -40)
WelcomeFrame.Position = UDim2.new(0, 0, 0, 40)
WelcomeFrame.BackgroundColor3 = SECONDARY
WelcomeFrame.BorderSizePixel = 0
WelcomeFrame.ZIndex = 2
WelcomeFrame.Parent = MainFrame

local weldLogo = Instance.new("ImageLabel")
weldLogo.Size = UDim2.new(0, 80, 0, 80)
weldLogo.Position = UDim2.new(0.5, -40, 0.35, -40)
weldLogo.Image = "rbxassetid://122198206955790"
weldLogo.BackgroundTransparency = 1
weldLogo.Parent = WelcomeFrame

local weldTitle = Instance.new("TextLabel")
weldTitle.Size = UDim2.new(1, 0, 0, 30)
weldTitle.Position = UDim2.new(0, 0, 0.5, 0)
weldTitle.BackgroundTransparency = 1
weldTitle.Text = "Welcome, " .. LocalPlayer.DisplayName
weldTitle.TextColor3 = TEXT
weldTitle.Font = Enum.Font.GothamBold
weldTitle.TextSize = 24
weldTitle.Parent = WelcomeFrame

local weldSub = Instance.new("TextLabel")
weldSub.Size = UDim2.new(1, 0, 0, 20)
weldSub.Position = UDim2.new(0, 0, 0.55, 0)
weldSub.BackgroundTransparency = 1
weldSub.Text = "Sysnax ScriptHub"
weldSub.TextColor3 = SUBTEXT
weldSub.Font = Enum.Font.Gotham
weldSub.TextSize = 16
weldSub.Parent = WelcomeFrame

-- animate fade out
spawn(function()
    wait(2.2)
    TweenService:Create(WelcomeFrame, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(weldLogo, TweenInfo.new(0.4), { ImageTransparency = 1 }):Play()
    TweenService:Create(weldTitle, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(weldSub, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    wait(0.5)
    WelcomeFrame:Destroy()
end)

-- ==================== TAB SWITCHING ====================
HomeBtn.MouseButton1Click:Connect(function()
    HomeTab.Visible = true
    ScriptHubTab.Visible = false
    HomeBtn.BackgroundColor3 = ACCENT
    ScriptHubBtn.BackgroundColor3 = ELEMENT
end)
ScriptHubBtn.MouseButton1Click:Connect(function()
    HomeTab.Visible = false
    ScriptHubTab.Visible = true
    ScriptHubBtn.BackgroundColor3 = ACCENT
    HomeBtn.BackgroundColor3 = ELEMENT
    if ScriptsCache and #ScriptsCache == 0 then
        loadScripts()  -- first load
    end
end)

-- initial script load
loadScripts()

-- ==================== TOGGLE WINDOW WITH RIGHT SHIFT ====================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ==================== FINAL NOTIFICATION ====================
StarterGui:SetCore("SendNotification", { Title = "Sysnax", Text = "ScriptHub ready! Right Shift to toggle.", Duration = 5 })