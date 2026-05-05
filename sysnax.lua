-- Sysnax ScriptHub – Final Stable
-- No external libraries · Real ScriptBlox scripts · Stunning UI
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Anti‑cheat bypass
pcall(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("LocalScript") and (v.Name:lower():find("anticheat") or v.Name:lower():find("antihack") or v.Name == "LocalScript") then
            v.Disabled = true
        end
    end
end)

-- ==================== CONSTANTS ====================
local BLACK = Color3.fromRGB(15, 15, 18)
local DARK = Color3.fromRGB(22, 22, 28)
local ELEM = Color3.fromRGB(32, 32, 40)
local ACCENT = Color3.fromRGB(140, 90, 255)
local TEXT1 = Color3.fromRGB(255, 255, 255)
local TEXT2 = Color3.fromRGB(170, 170, 185)

-- ==================== GUI ====================
local Gui = Instance.new("ScreenGui")
Gui.Name = "Sysnax"
Gui.ResetOnSpawn = false
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main frame
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(820, 540)
Main.Position = UDim2.new(0.5, -410, 0.5, -270)
Main.BackgroundColor3 = DARK
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

-- ==================== WELCOME OVERLAY ====================
local Welcome = Instance.new("Frame", Main)
Welcome.Size = UDim2.fromScale(1, 1)
Welcome.BackgroundColor3 = DARK
Welcome.ZIndex = 10
local WLogo = Instance.new("ImageLabel", Welcome)
WLogo.Size = UDim2.fromOffset(90, 90)
WLogo.Position = UDim2.new(0.5, -45, 0.38, -45)
WLogo.Image = "rbxassetid://122198206955790"
WLogo.BackgroundTransparency = 1
local WTitle = Instance.new("TextLabel", Welcome)
WTitle.Size = UDim2.new(1, 0, 0, 30)
WTitle.Position = UDim2.new(0, 0, 0.55, 0)
WTitle.Text = "Welcome, " .. LocalPlayer.DisplayName
WTitle.TextColor3 = TEXT1
WTitle.Font = Enum.Font.GothamBold
WTitle.TextSize = 28
WTitle.BackgroundTransparency = 1
local WSub = Instance.new("TextLabel", Welcome)
WSub.Size = UDim2.new(1, 0, 0, 22)
WSub.Position = UDim2.new(0, 0, 0.63, 0)
WSub.Text = "Sysnax ScriptHub"
WSub.TextColor3 = TEXT2
WSub.Font = Enum.Font.Gotham
WSub.TextSize = 16
WSub.BackgroundTransparency = 1
task.delay(2.2, function()
    TweenService:Create(Welcome, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(WLogo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(WTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(WSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6) Welcome:Destroy()
end)

-- ==================== TITLE BAR (DRAGGABLE) ====================
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = ELEM
local TText = Instance.new("TextLabel", TitleBar)
TText.Size = UDim2.new(0, 200, 1, 0)
TText.Position = UDim2.new(0, 14, 0, 0)
TText.Text = "Sysnax"
TText.TextColor3 = TEXT1
TText.Font = Enum.Font.GothamBold
TText.TextSize = 18
TText.TextXAlignment = Enum.TextXAlignment.Left
TText.BackgroundTransparency = 1
local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -36, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
Close.Text = "✕"
Close.TextColor3 = TEXT1
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
Close.MouseButton1Click:Connect(function() Gui:Destroy() end)

-- Drag to move
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== NAVIGATION ====================
local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(0, 160, 1, -40)
Nav.Position = UDim2.new(0, 0, 0, 40)
Nav.BackgroundColor3 = ELEM
local HomeBtn = Instance.new("TextButton", Nav)
HomeBtn.Size = UDim2.new(1, -20, 0, 34)
HomeBtn.Position = UDim2.new(0, 10, 0, 10)
HomeBtn.Text = "🏠  Home"
HomeBtn.TextColor3 = TEXT1
HomeBtn.Font = Enum.Font.Gotham
HomeBtn.TextSize = 14
HomeBtn.TextXAlignment = Enum.TextXAlignment.Left
HomeBtn.BackgroundColor3 = ACCENT
Instance.new("UICorner", HomeBtn).CornerRadius = UDim.new(0, 8)
local HubBtn = Instance.new("TextButton", Nav)
HubBtn.Size = UDim2.new(1, -20, 0, 34)
HubBtn.Position = UDim2.new(0, 10, 0, 50)
HubBtn.Text = "📜  ScriptHub"
HubBtn.TextColor3 = TEXT1
HubBtn.Font = Enum.Font.Gotham
HubBtn.TextSize = 14
HubBtn.TextXAlignment = Enum.TextXAlignment.Left
HubBtn.BackgroundColor3 = ELEM
Instance.new("UICorner", HubBtn).CornerRadius = UDim.new(0, 8)
local DcBtn = Instance.new("TextButton", Nav)
DcBtn.Size = UDim2.new(1, -20, 0, 34)
DcBtn.Position = UDim2.new(0, 10, 1, -45)
DcBtn.Text = "💬  Discord"
DcBtn.TextColor3 = TEXT1
DcBtn.Font = Enum.Font.GothamBold
DcBtn.TextSize = 14
DcBtn.BackgroundColor3 = ACCENT
Instance.new("UICorner", DcBtn).CornerRadius = UDim.new(0, 8)
DcBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/xadh9mPGaN")
    StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Discord invite copied!", Duration = 3})
end)

-- ==================== CONTENT ====================
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -160, 1, -40)
Content.Position = UDim2.new(0, 160, 0, 40)
Content.BackgroundColor3 = DARK

-- Home tab
local Home = Instance.new("Frame", Content)
Home.Size = UDim2.fromScale(1, 1)
Home.BackgroundTransparency = 1
local avFrame = Instance.new("Frame", Home)
avFrame.Size = UDim2.fromOffset(85, 85)
avFrame.Position = UDim2.fromOffset(20, 20)
avFrame.BackgroundTransparency = 1
local avImg = Instance.new("ImageLabel", avFrame)
avImg.Size = UDim2.fromScale(1, 1)
avImg.BackgroundTransparency = 1
avImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", avImg).CornerRadius = UDim.new(0, 42)
local nLabel = Instance.new("TextLabel", Home)
nLabel.Size = UDim2.new(0, 300, 0, 26)
nLabel.Position = UDim2.fromOffset(120, 25)
nLabel.Text = "@" .. LocalPlayer.Name
nLabel.TextColor3 = TEXT1
nLabel.Font = Enum.Font.GothamBold
nLabel.TextSize = 20
nLabel.TextXAlignment = Enum.TextXAlignment.Left
nLabel.BackgroundTransparency = 1
local dLabel = Instance.new("TextLabel", Home)
dLabel.Size = UDim2.new(0, 300, 0, 18)
dLabel.Position = UDim2.fromOffset(120, 55)
dLabel.Text = LocalPlayer.DisplayName
dLabel.TextColor3 = TEXT2
dLabel.Font = Enum.Font.Gotham
dLabel.TextSize = 14
dLabel.TextXAlignment = Enum.TextXAlignment.Left
dLabel.BackgroundTransparency = 1
local eLabel = Instance.new("TextLabel", Home)
eLabel.Size = UDim2.new(0, 300, 0, 18)
eLabel.Position = UDim2.fromOffset(120, 78)
eLabel.Text = "Executor: " .. (identifyexecutor and identifyexecutor() or "N/A")
eLabel.TextColor3 = TEXT2
eLabel.Font = Enum.Font.Gotham
eLabel.TextSize = 14
eLabel.TextXAlignment = Enum.TextXAlignment.Left
eLabel.BackgroundTransparency = 1

-- Server info panel
local sFrame = Instance.new("Frame", Home)
sFrame.Size = UDim2.new(0, 380, 0, 90)
sFrame.Position = UDim2.fromOffset(20, 130)
sFrame.BackgroundColor3 = ELEM
Instance.new("UICorner", sFrame).CornerRadius = UDim.new(0, 10)
local sTitle = Instance.new("TextLabel", sFrame)
sTitle.Size = UDim2.new(1, -20, 0, 22)
sTitle.Position = UDim2.fromOffset(10, 8)
sTitle.Text = "Server"
sTitle.TextColor3 = ACCENT
sTitle.Font = Enum.Font.GothamBold
sTitle.TextSize = 15
sTitle.TextXAlignment = Enum.TextXAlignment.Left
sTitle.BackgroundTransparency = 1
local function addLine(text, y)
    local l = Instance.new("TextLabel", sFrame)
    l.Size = UDim2.new(1, -20, 0, 18)
    l.Position = UDim2.fromOffset(10, y)
    l.Text = text
    l.TextColor3 = TEXT1
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
end
addLine("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers, 35)
addLine("Place ID: " .. game.PlaceId, 55)
addLine("Region: " .. (game:GetService("LocalizationService").RobloxLocaleId or "N/A"), 75)

-- ScriptHub tab
local Hub = Instance.new("Frame", Content)
Hub.Size = UDim2.fromScale(1, 1)
Hub.BackgroundTransparency = 1
Hub.Visible = false

-- Search & categories
local Search = Instance.new("TextBox", Hub)
Search.Size = UDim2.new(0, 260, 0, 32)
Search.Position = UDim2.fromOffset(15, 12)
Search.PlaceholderText = "Search scripts..."
Search.Text = ""
Search.TextColor3 = TEXT1
Search.PlaceholderColor3 = TEXT2
Search.BackgroundColor3 = ELEM
Search.Font = Enum.Font.Gotham
Search.TextSize = 14
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 8)
Search.Changed:Connect(function()
    cache.searchTerm = Search.Text:lower()
    displayScripts()
end)

local categories = {"All", "Rivals", "Arsenal", "HyperShot", "FPS", "Utility", "Misc"}
local catBtns = {}
local selectedCat = "All"
for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", Hub)
    btn.Size = UDim2.fromOffset(74, 28)
    btn.Position = UDim2.fromOffset(15 + (i-1)*80, 50)
    btn.Text = cat
    btn.TextColor3 = TEXT1
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BackgroundColor3 = (cat == selectedCat) and ACCENT or ELEM
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        selectedCat = cat
        for _, b in ipairs(catBtns) do b.BackgroundColor3 = (b.Text == cat) and ACCENT or ELEM end
        cache.category = cat
        fetchScripts(cat)
    end)
    table.insert(catBtns, btn)
end

local Refresh = Instance.new("TextButton", Hub)
Refresh.Size = UDim2.fromOffset(90, 28)
Refresh.Position = UDim2.fromOffset(470, 50)
Refresh.Text = "⟳ Refresh"
Refresh.TextColor3 = TEXT1
Refresh.Font = Enum.Font.GothamBold
Refresh.TextSize = 13
Refresh.BackgroundColor3 = ELEM
Instance.new("UICorner", Refresh).CornerRadius = UDim.new(0, 8)
Refresh.MouseButton1Click:Connect(function() fetchScripts(selectedCat) end)

-- Manual add
local urlBox = Instance.new("TextBox", Hub)
urlBox.Size = UDim2.new(0, 310, 0, 32)
urlBox.Position = UDim2.fromOffset(15, 400)
urlBox.PlaceholderText = "Raw script URL"
urlBox.Text = ""
urlBox.TextColor3 = TEXT1
urlBox.PlaceholderColor3 = TEXT2
urlBox.BackgroundColor3 = ELEM
urlBox.Font = Enum.Font.Gotham
urlBox.TextSize = 14
Instance.new("UICorner", urlBox).CornerRadius = UDim.new(0, 8)

local nameBox = Instance.new("TextBox", Hub)
nameBox.Size = UDim2.fromOffset(140, 32)
nameBox.Position = UDim2.fromOffset(335, 400)
nameBox.PlaceholderText = "Script name"
nameBox.Text = ""
nameBox.TextColor3 = TEXT1
nameBox.PlaceholderColor3 = TEXT2
nameBox.BackgroundColor3 = ELEM
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 14
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 8)

local addBtn = Instance.new("TextButton", Hub)
addBtn.Size = UDim2.fromOffset(75, 32)
addBtn.Position = UDim2.fromOffset(485, 400)
addBtn.Text = "Add"
addBtn.TextColor3 = TEXT1
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 14
addBtn.BackgroundColor3 = ACCENT
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 8)
addBtn.MouseButton1Click:Connect(function()
    local url, name = urlBox.Text, nameBox.Text
    if url ~= "" then
        local script = {
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
            table.insert(user, 1, script)
            saveUserScripts(user)
            mergeScripts()
            urlBox.Text = ""; nameBox.Text = ""
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Script added!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Already in your hub.", Duration = 3})
        end
    end
end)

-- Script list (ScrollingFrame)
local List = Instance.new("ScrollingFrame", Hub)
List.Size = UDim2.new(1, -30, 0, 310)
List.Position = UDim2.fromOffset(15, 85)
List.BackgroundTransparency = 1
List.ScrollBarThickness = 4
List.ScrollBarImageColor3 = ACCENT
List.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UIListLayout", List).Padding = UDim.new(0, 6)

-- ==================== DATA ====================
local cache = {scripts = {}, searchTerm = "", category = "All"}
local hubFolder = "sysnax/hub"
pcall(function() if not isfolder(hubFolder) then makefolder(hubFolder) end end)
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
    if fetched then
        for _, s in ipairs(fetched) do
            local dup = false
            for _, us in ipairs(user) do if us.script == s.script then dup = true break end end
            if not dup then table.insert(cache.scripts, s) end
        end
    end
end

-- ==================== CREATE SCRIPT CARD ====================
local function createCard(script)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 85)
    card.BackgroundColor3 = ELEM
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local thumb = Instance.new("ImageLabel", card)
    thumb.Size = UDim2.fromOffset(65, 65)
    thumb.Position = UDim2.fromOffset(8, 10)
    thumb.Image = script.image or "rbxassetid://122198206955790"
    thumb.ScaleType = Enum.ScaleType.Fit
    thumb.BackgroundColor3 = DARK
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 6)

    local tLabel = Instance.new("TextLabel", card)
    tLabel.Size = UDim2.new(1, -85, 0, 20)
    tLabel.Position = UDim2.fromOffset(82, 8)
    tLabel.Text = script.title or "Untitled"
    tLabel.TextColor3 = TEXT1
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 14
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.TextTruncate = Enum.TextTruncate.AtEnd
    tLabel.BackgroundTransparency = 1

    local dLabel = Instance.new("TextLabel", card)
    dLabel.Size = UDim2.new(1, -85, 0, 24)
    dLabel.Position = UDim2.fromOffset(82, 32)
    dLabel.Text = script.description or "No description"
    dLabel.TextColor3 = TEXT2
    dLabel.Font = Enum.Font.Gotham
    dLabel.TextSize = 12
    dLabel.TextXAlignment = Enum.TextXAlignment.Left
    dLabel.TextWrapped = true
    dLabel.BackgroundTransparency = 1

    local btnFrame = Instance.new("Frame", card)
    btnFrame.Size = UDim2.fromOffset(140, 24)
    btnFrame.Position = UDim2.new(1, -150, 0, 55)
    btnFrame.BackgroundTransparency = 1

    local execBtn = Instance.new("TextButton", btnFrame)
    execBtn.Size = UDim2.fromOffset(60, 24)
    execBtn.BackgroundColor3 = ACCENT
    execBtn.Text = "Execute"
    execBtn.TextColor3 = TEXT1
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 12
    Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 5)
    execBtn.MouseButton1Click:Connect(function()
        execBtn.Text = "Loading..."
        execBtn.BackgroundColor3 = TEXT2
        task.spawn(function()
            local ok, content = pcall(function() return game:HttpGet(script.script) end)
            if ok and content then
                pcall(function() loadstring(content)() end)
            else
                StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Could not load script.", Duration = 3})
            end
            execBtn.Text = "Execute"
            execBtn.BackgroundColor3 = ACCENT
        end)
    end)

    local infoBtn = Instance.new("TextButton", btnFrame)
    infoBtn.Size = UDim2.fromOffset(24, 24)
    infoBtn.Position = UDim2.fromOffset(66, 0)
    infoBtn.Text = "⋯"
    infoBtn.TextColor3 = TEXT1
    infoBtn.Font = Enum.Font.GothamBold
    infoBtn.TextSize = 14
    infoBtn.BackgroundColor3 = ELEM
    Instance.new("UICorner", infoBtn).CornerRadius = UDim.new(0, 5)
    infoBtn.MouseButton1Click:Connect(function()
        local pop = Instance.new("Frame", Gui)
        pop.Size = UDim2.fromOffset(330, 210)
        pop.Position = UDim2.new(0.5, -165, 0.5, -105)
        pop.BackgroundColor3 = DARK
        pop.BorderSizePixel = 0
        pop.ZIndex = 20
        Instance.new("UICorner", pop).CornerRadius = UDim.new(0, 10)
        local pt = Instance.new("TextLabel", pop)
        pt.Size = UDim2.new(1, -20, 0, 24)
        pt.Position = UDim2.fromOffset(10, 8)
        pt.Text = script.title or "Script Info"
        pt.TextColor3 = TEXT1
        pt.Font = Enum.Font.GothamBold
        pt.TextSize = 16
        pt.TextXAlignment = Enum.TextXAlignment.Left
        pt.BackgroundTransparency = 1
        local pd = Instance.new("TextLabel", pop)
        pd.Size = UDim2.new(1, -20, 0, 135)
        pd.Position = UDim2.fromOffset(10, 38)
        pd.Text = "Author: " .. (script.author or "Unknown") ..
                  "\nDownloads: " .. (script.downloads or "N/A") ..
                  "\n\n" .. (script.description or "No description")
        pd.TextColor3 = TEXT1
        pd.Font = Enum.Font.Gotham
        pd.TextSize = 13
        pd.TextXAlignment = Enum.TextXAlignment.Left
        pd.TextYAlignment = Enum.TextYAlignment.Top
        pd.BackgroundTransparency = 1
        local pc = Instance.new("TextButton", pop)
        pc.Size = UDim2.fromOffset(60, 24)
        pc.Position = UDim2.new(1, -70, 1, -32)
        pc.Text = "Close"
        pc.TextColor3 = TEXT1
        pc.Font = Enum.Font.GothamBold
        pc.TextSize = 13
        pc.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        Instance.new("UICorner", pc).CornerRadius = UDim.new(0, 5)
        local bd = Instance.new("TextButton", Gui)
        bd.Size = UDim2.fromScale(1, 1)
        bd.BackgroundColor3 = Color3.new(0, 0, 0)
        bd.BackgroundTransparency = 0.7
        bd.ZIndex = 19
        bd.Text = ""
        local function close() pop:Destroy() bd:Destroy() end
        pc.MouseButton1Click:Connect(close)
        bd.MouseButton1Click:Connect(close)
    end)

    if script.isUserScript then
        local delBtn = Instance.new("TextButton", btnFrame)
        delBtn.Size = UDim2.fromOffset(24, 24)
        delBtn.Position = UDim2.fromOffset(94, 0)
        delBtn.Text = "🗑"
        delBtn.TextColor3 = TEXT1
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        delBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 5)
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

-- ==================== DISPLAY SCRIPTS ====================
local function displayScripts()
    for _, v in ipairs(List:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local filtered = {}
    local search = cache.searchTerm or ""
    local cat = cache.category:lower()
    for _, s in ipairs(cache.scripts) do
        if search ~= "" and not s.title:lower():find(search) then continue end
        if cat ~= "all" then
            local txt = (s.title .. " " .. (s.description or "")):lower()
            if not txt:find(cat) then continue end
        end
        table.insert(filtered, s)
    end
    if #filtered == 0 then
        local no = Instance.new("TextLabel", List)
        no.Size = UDim2.new(1, 0, 0, 30)
        no.Text = "No scripts found."
        no.TextColor3 = TEXT2
        no.Font = Enum.Font.Gotham
        no.TextSize = 14
        no.BackgroundTransparency = 1
    else
        for _, s in ipairs(filtered) do
            createCard(s).Parent = List
        end
    end
    List.CanvasSize = UDim2.new(0, 0, 0, #filtered * 95 + 20)
end

-- ==================== FETCH SCRIPTS ====================
local function fetchScripts(category)
    local url = "https://scriptblox.com/api/scripts?sort=top&limit=40"
    if category and category:lower() ~= "all" then
        url = url .. "&search=" .. category:lower()
    end
    local ok, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    local fetched = {}
    if ok and result and result.scripts then
        for _, s in ipairs(result.scripts) do
            table.insert(fetched, {
                title = s.title or "Untitled",
                script = s.script or "",
                image = s.image or "rbxassetid://122198206955790",
                description = s.description or "",
                author = s.author or "Unknown",
                downloads = s.downloads or 0,
            })
        end
    else
        StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Could not fetch scripts.", Duration = 3})
    end
    mergeScripts(fetched)
    displayScripts()
end

-- ==================== INIT ====================
mergeScripts()
fetchScripts("All")

-- Tab switching
HomeBtn.MouseButton1Click:Connect(function()
    Home.Visible = true; Hub.Visible = false
    HomeBtn.BackgroundColor3 = ACCENT; HubBtn.BackgroundColor3 = ELEM
end)
HubBtn.MouseButton1Click:Connect(function()
    Home.Visible = false; Hub.Visible = true
    HubBtn.BackgroundColor3 = ACCENT; HomeBtn.BackgroundColor3 = ELEM
end)

-- Toggle window with Right Shift
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "ScriptHub loaded! Right Shift to toggle.", Duration = 5})