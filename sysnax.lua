-- Sysnax ScriptHub – Fully functional, no WindUI errors
-- Discord: https://discord.gg/xadh9mPGaN

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
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

-- ==================== LOAD WINDUI ====================
local WindUI = nil
pcall(function()
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)
if not WindUI then
    StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "WindUI failed to load.", Duration = 5})
    return
end

-- ==================== THEME ====================
WindUI:AddTheme({
    Name = "Sysnax",
    Accent = Color3.fromHex("#7856FF"),
    Background = Color3.fromHex("#121215"),
    AccentOutline = Color3.fromHex("#7856FF"),
    Text = Color3.fromHex("#F0F0F0"),
    Placeholder = Color3.fromHex("#A0A0AA"),
    Button = Color3.fromHex("#212125"),
    Icon = Color3.fromHex("#A0A0AA"),
})
WindUI:SetTheme("Sysnax")

-- ==================== WINDOW ====================
local Window = WindUI:CreateWindow({
    Title = "Sysnax",
    Icon = "rbxassetid://122198206955790",
    Folder = "sysnax",
    Theme = "Sysnax",
    Resizable = true,
    MinSize = Vector2.new(700, 450),
    MaxSize = Vector2.new(1000, 650),
    Size = UDim2.fromOffset(800, 520),
    ToggleKey = Enum.KeyCode.RightShift,
    HideSearchBar = true,
    ScrollBarEnabled = false,
})

-- ==================== WELCOME OVERLAY ====================
if Window.Main then
    local welcome = Instance.new("Frame")
    welcome.Size = UDim2.new(1, 0, 1, -35)
    welcome.Position = UDim2.new(0, 0, 0, 35)
    welcome.BackgroundColor3 = Color3.fromHex("#121215")
    welcome.BorderSizePixel = 0
    welcome.ZIndex = 10
    welcome.Parent = Window.Main

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 80, 0, 80)
    logo.Position = UDim2.new(0.5, -40, 0.4, -40)
    logo.Image = "rbxassetid://122198206955790"
    logo.BackgroundTransparency = 1
    logo.Parent = welcome

    local title = Instance.new("TextLabel", welcome)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0.52, 0)
    title.Text = "Welcome, " .. LocalPlayer.DisplayName
    title.TextColor3 = Color3.fromHex("#F0F0F0")
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.BackgroundTransparency = 1

    local sub = Instance.new("TextLabel", welcome)
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0.58, 0)
    sub.Text = "Sysnax ScriptHub"
    sub.TextColor3 = Color3.fromHex("#A0A0AA")
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 16
    sub.BackgroundTransparency = 1

    spawn(function()
        wait(2)
        TweenService:Create(welcome, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(sub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        wait(0.5)
        welcome:Destroy()
    end)
end

-- ==================== HOME TAB ====================
local HomeTab = Window:Tab({Title = "Home", Icon = "home"})

-- Avatar and profile info (manually built on HomeTab.Frame)
if HomeTab.Frame then
    -- Round avatar
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 80, 0, 80)
    avatarFrame.Position = UDim2.new(0, 15, 0, 15)
    avatarFrame.BackgroundTransparency = 1
    avatarFrame.Parent = HomeTab.Frame

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(1, 0, 1, 0)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 40)
    avatarImg.Parent = avatarFrame

    -- Username label (custom)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 300, 0, 24)
    nameLabel.Position = UDim2.new(0, 110, 0, 15)
    nameLabel.Text = "@" .. LocalPlayer.Name
    nameLabel.TextColor3 = Color3.fromHex("#F0F0F0")
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 20
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = HomeTab.Frame

    -- Display name label
    local displayLabel = Instance.new("TextLabel")
    displayLabel.Size = UDim2.new(0, 300, 0, 18)
    displayLabel.Position = UDim2.new(0, 110, 0, 42)
    displayLabel.Text = LocalPlayer.DisplayName
    displayLabel.TextColor3 = Color3.fromHex("#A0A0AA")
    displayLabel.Font = Enum.Font.Gotham
    displayLabel.TextSize = 14
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.BackgroundTransparency = 1
    displayLabel.Parent = HomeTab.Frame

    -- Executor label
    local execLabel = Instance.new("TextLabel")
    execLabel.Size = UDim2.new(0, 300, 0, 18)
    execLabel.Position = UDim2.new(0, 110, 0, 62)
    execLabel.Text = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown")
    execLabel.TextColor3 = Color3.fromHex("#A0A0AA")
    execLabel.Font = Enum.Font.Gotham
    execLabel.TextSize = 14
    execLabel.TextXAlignment = Enum.TextXAlignment.Left
    execLabel.BackgroundTransparency = 1
    execLabel.Parent = HomeTab.Frame
end

-- Server info section (using buttons as labels, since AddLabel is unreliable)
local serverSection = HomeTab:Section({Title = "Server", Icon = "server"})
serverSection:AddButton({Title = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers, Callback = function() end})
serverSection:AddButton({Title = "Place ID: " .. game.PlaceId, Callback = function() end})
serverSection:AddButton({Title = "Region: " .. (game:GetService("LocalizationService").RobloxLocaleId or "N/A"), Callback = function() end})

-- Discord button
local communitySection = HomeTab:Section({Title = "Community", Icon = "message-circle"})
communitySection:AddButton({Title = "Join Discord", Callback = function()
    setclipboard("https://discord.gg/xadh9mPGaN")
    StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Discord invite copied!", Duration = 3})
end})

-- ==================== SCRIPTHUB TAB ====================
local ScriptHub = Window:Tab({Title = "ScriptHub", Icon = "code"})

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

-- Search & filters
local searchSection = ScriptHub:Section({Title = "Search & Filters", Icon = "search"})
searchSection:AddTextbox({Placeholder = "Search scripts...", Callback = function(v)
    cache.searchTerm = v:lower()
    displayScripts()
end})

local catSection = ScriptHub:Section({Title = "Categories", Icon = "tag"})
catSection:AddDropdown({
    Title = "Category",
    Values = {"All", "Rivals", "Arsenal", "HyperShot", "FPS", "Utility", "Misc"},
    Value = "All",
    Callback = function(v)
        cache.category = v
        fetchScripts(v)
    end
})

local refreshSec = ScriptHub:Section({Title = "Actions", Icon = "refresh-cw"})
refreshSec:AddButton({Title = "Refresh Scripts", Callback = function() fetchScripts(cache.category) end})

-- Manual add section
local manualSection = ScriptHub:Section({Title = "Add Your Own Script", Icon = "plus"})
local urlInput = manualSection:AddTextbox({Placeholder = "Raw script URL (pastebin.com/raw/...)", Callback = function() end})
local nameInput = manualSection:AddTextbox({Placeholder = "Script Name", Callback = function() end})
manualSection:AddButton({Title = "Add & Save", Callback = function()
    local url = urlInput:GetValue()
    local name = nameInput:GetValue()
    if url and url ~= "" then
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
            urlInput:SetValue("")
            nameInput:SetValue("")
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Script added!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Already in your hub.", Duration = 3})
        end
    end
end})

-- ==================== SCRIPT LIST (SCROLL) ====================
local listFrame = nil
if ScriptHub.Frame then
    listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -20, 0, 260)
    listFrame.Position = UDim2.new(0, 10, 0, 180)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = Color3.fromHex("#7856FF")
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.Parent = ScriptHub.Frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = listFrame
end

local function createScriptCard(script)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 85)
    card.BackgroundColor3 = Color3.fromHex("#212125")
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(0, 65, 0, 65)
    thumb.Position = UDim2.new(0, 8, 0, 10)
    thumb.Image = script.image or "rbxassetid://122198206955790"
    thumb.ScaleType = Enum.ScaleType.Fit
    thumb.BackgroundColor3 = Color3.fromHex("#121215")
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 4)
    thumb.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -90, 0, 20)
    titleLabel.Position = UDim2.new(0, 82, 0, 8)
    titleLabel.Text = script.title or "Untitled"
    titleLabel.TextColor3 = Color3.fromHex("#F0F0F0")
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -90, 0, 24)
    descLabel.Position = UDim2.new(0, 82, 0, 30)
    descLabel.Text = script.description or "No description"
    descLabel.TextColor3 = Color3.fromHex("#A0A0AA")
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.BackgroundTransparency = 1
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = card

    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0, 140, 0, 22)
    btnFrame.Position = UDim2.new(1, -148, 0, 56)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = card

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0, 60, 1, 0)
    execBtn.Position = UDim2.new(0, 0, 0, 0)
    execBtn.BackgroundColor3 = Color3.fromHex("#7856FF")
    execBtn.Text = "Execute"
    execBtn.TextColor3 = Color3.fromHex("#FFFFFF")
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 12
    Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 4)
    execBtn.Parent = btnFrame
    execBtn.MouseButton1Click:Connect(function()
        execBtn.Text = "Loading..."
        execBtn.BackgroundColor3 = Color3.fromHex("#555555")
        spawn(function()
            local ok, content = pcall(function() return game:HttpGet(script.script) end)
            if ok and content then
                pcall(function() loadstring(content)() end)
            else
                StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Could not download script.", Duration = 3})
            end
            execBtn.Text = "Execute"
            execBtn.BackgroundColor3 = Color3.fromHex("#7856FF")
        end)
    end)

    local infoBtn = Instance.new("TextButton")
    infoBtn.Size = UDim2.new(0, 22, 1, 0)
    infoBtn.Position = UDim2.new(0, 64, 0, 0)
    infoBtn.BackgroundColor3 = Color3.fromHex("#333338")
    infoBtn.Text = "⋯"
    infoBtn.TextColor3 = Color3.fromHex("#FFFFFF")
    infoBtn.Font = Enum.Font.GothamBold
    infoBtn.TextSize = 14
    Instance.new("UICorner", infoBtn).CornerRadius = UDim.new(0, 4)
    infoBtn.Parent = btnFrame
    infoBtn.MouseButton1Click:Connect(function()
        Window:Dialog({
            Title = script.title or "Script Info",
            Description = "Author: " .. (script.author or "Unknown") ..
                          "\nDownloads: " .. (script.downloads or "N/A") ..
                          "\n\n" .. (script.description or "No description"),
            Buttons = {
                {Title = "Close", Callback = function() end}
            }
        })
    end)

    if script.isUserScript then
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 22, 1, 0)
        delBtn.Position = UDim2.new(0, 90, 0, 0)
        delBtn.BackgroundColor3 = Color3.fromHex("#FF5555")
        delBtn.Text = "🗑"
        delBtn.TextColor3 = Color3.fromHex("#FFFFFF")
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
    if not listFrame then return end
    for _, child in ipairs(listFrame:GetChildren()) do
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
        noLabel.TextColor3 = Color3.fromHex("#A0A0AA")
        noLabel.Font = Enum.Font.Gotham
        noLabel.TextSize = 14
        noLabel.Parent = listFrame
    else
        for _, script in ipairs(filtered) do
            local card = createScriptCard(script)
            card.Parent = listFrame
        end
    end
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #filtered * 92 + 20)
end

-- ==================== FETCH FROM SCRIPTBLOX ====================
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

-- Initial load
fetchScripts("All")