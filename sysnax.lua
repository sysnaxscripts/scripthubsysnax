-- Sysnax ScriptHub – Stable, WindUI, ScriptBlox integration
-- Discord: https://discord.gg/xadh9mPGaN

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==================== AC BYPASS ====================
pcall(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("LocalScript") then
            local n = v.Name:lower()
            if n:find("anticheat") or n:find("antihack") or n:find("detection") or n:find("ac") or v.Name == "LocalScript" then
                v.Disabled = true
            end
        end
    end
end)

-- ==================== LOAD WIND UI ====================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
if not WindUI then
    StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "WindUI failed to load", Duration = 5})
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

-- ==================== CREATE WINDOW ====================
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

-- ==================== WELCOME OVERLAY (fades after 2s) ====================
local welcomeFrame = Instance.new("Frame")
welcomeFrame.Size = UDim2.new(1, 0, 1, -35)
welcomeFrame.Position = UDim2.new(0, 0, 0, 35)
welcomeFrame.BackgroundColor3 = Color3.fromHex("#121215")
welcomeFrame.BorderSizePixel = 0
welcomeFrame.ZIndex = 10
welcomeFrame.Parent = Window.Main  -- assuming Window.Main exists; use pcall
pcall(function()
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 80, 0, 80)
    logo.Position = UDim2.new(0.5, -40, 0.35, -40)
    logo.Image = "rbxassetid://122198206955790"
    logo.BackgroundTransparency = 1
    logo.Parent = welcomeFrame
    local title = Instance.new("TextLabel", welcomeFrame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0.52, 0)
    title.Text = "Welcome, " .. LocalPlayer.DisplayName
    title.TextColor3 = Color3.fromHex("#F0F0F0")
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.BackgroundTransparency = 1
    local sub = Instance.new("TextLabel", welcomeFrame)
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0.58, 0)
    sub.Text = "Sysnax ScriptHub"
    sub.TextColor3 = Color3.fromHex("#A0A0AA")
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 16
    sub.BackgroundTransparency = 1
    -- fade out after 2 seconds
    spawn(function()
        wait(2)
        welcomeFrame:TweenSize(UDim2.new(0,0,0,0), "In", "Linear", 0.3)
        wait(0.3)
        welcomeFrame:Destroy()
    end)
end)

-- ==================== HOME TAB ====================
local HomeTab = Window:Tab({Title = "Home", Icon = "home"})
local homeSection = HomeTab:Section({Title = "Profile", Icon = "user"})
local avatar = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
homeSection:AddImage({Image = avatar, Size = UDim2.fromOffset(80, 80)})
homeSection:AddLabel("@" .. LocalPlayer.Name)
homeSection:AddLabel(LocalPlayer.DisplayName)
homeSection:AddLabel("Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"))

local serverSection = HomeTab:Section({Title = "Server", Icon = "server"})
serverSection:AddLabel("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
serverSection:AddLabel("Place ID: " .. game.PlaceId)
serverSection:AddLabel("Server Region: " .. (game:GetService("LocalizationService").RobloxLocaleId or "N/A"))

local discordBtn = HomeTab:Section({Title = "Community", Icon = "message-circle"})
discordBtn:AddButton({Title = "Join Discord", Callback = function()
    setclipboard("https://discord.gg/xadh9mPGaN")
    StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Discord invite copied!", Duration = 3})
end})

-- ==================== SCRIPTHUB TAB ====================
local ScriptHub = Window:Tab({Title = "ScriptHub", Icon = "code"})

local tags = {"All", "Rivals", "Arsenal", "HyperShot", "FPS", "Utility", "Misc"}
local selectedTag = "All"

local searchBox = ScriptHub:Section({Title = "Search & Filter", Icon = "search"})
searchBox:AddTextbox({Placeholder = "Search scripts...", Callback = function(text)
    -- search is done on client side after fetch, stored in cache
    ScriptHub.Cache.searchTerm = text
end})

local tagSection = ScriptHub:Section({Title = "Categories", Icon = "tag"})
local lastTag = "All"
for _, tag in ipairs(tags) do
    tagSection:AddButton({Title = tag, Callback = function()
        selectedTag = tag
        -- refresh tag highlights? Not needed; just update cache
        ScriptHub.Cache.lastTag = tag
        fetchScripts(selectedTag)
    end})
end

local scriptList = ScriptHub:Section({Title = "Scripts", Icon = "file-text"})
local refreshBtn = scriptList:AddButton({Title = "Refresh", Callback = function()
    fetchScripts(selectedTag)
end})

-- manual add section
local manualSection = ScriptHub:Section({Title = "Add Script Manually", Icon = "plus"})
local urlInput, nameInput
manualSection:AddTextbox({Placeholder = "Script URL (raw)", Callback = function(v) urlInput = v end})
manualSection:AddTextbox({Placeholder = "Script Name", Callback = function(v) nameInput = v end})
manualSection:AddButton({Title = "Add to Hub", Callback = function()
    if urlInput and urlInput ~= "" then
        local entry = {title = nameInput and nameInput ~= "" and nameInput or "Custom Script", script = urlInput, image = "rbxassetid://122198206955790", description = "User added script"}
        table.insert(ScriptHub.Cache.scripts or {}, 1, entry)
        displayScripts()
    end
end})

-- data cache
ScriptHub.Cache = {scripts = {}, searchTerm = "", lastTag = "All"}

-- display scripts in a scrollable frame (use WindUI's built-in list? WindUI doesn't have a scrollable list, so we'll use a section with multiple elements. We'll add buttons for each script. However, for many scripts, it's limited. We'll implement a simple scroll via a custom frame with UIListLayout if needed. But WindUI sections can hold many elements, but they might overflow. We'll use a Frame inside a section with a ScrollingFrame.
-- Instead, we'll use a WindUI list? WindUI does not have list. We'll implement a simple scroll area using raw frames within a section. Since it's not standard, but we'll make it work.

local listFrame = nil
local function createListContainer()
    if not listFrame then
        -- create a ScrollingFrame inside the scriptList section's content
        local section = scriptList:GetSectionFrame()
        if section then
            listFrame = Instance.new("ScrollingFrame")
            listFrame.Size = UDim2.new(1, -20, 0, 300)
            listFrame.Position = UDim2.new(0,10,0,0)
            listFrame.BackgroundTransparency = 1
            listFrame.ScrollBarThickness = 4
            listFrame.ScrollBarImageColor3 = Color3.fromHex("#7856FF")
            listFrame.CanvasSize = UDim2.new(0,0,0,0)
            listFrame.Parent = section
            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0,5)
            layout.Parent = listFrame
        end
    end
end

local function displayScripts()
    if not ScriptHub.Cache or not ScriptHub.Cache.scripts then return end
    createListContainer()
    if not listFrame then return end
    -- clear
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local search = ScriptHub.Cache.searchTerm or ""
    for _, script in ipairs(ScriptHub.Cache.scripts) do
        if search ~= "" and not script.title:lower():find(search:lower()) then
            continue
        end
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 90)
        card.BackgroundColor3 = Color3.fromHex("#212125")
        card.BorderSizePixel = 0
        Instance.new("UICorner", card).CornerRadius = UDim.new(0,6)
        card.Parent = listFrame

        local thumb = Instance.new("ImageLabel")
        thumb.Size = UDim2.new(0,70,0,70)
        thumb.Position = UDim2.new(0,10,0,10)
        thumb.Image = script.image or "rbxassetid://122198206955790"
        thumb.ScaleType = Enum.ScaleType.Fit
        thumb.BackgroundColor3 = Color3.fromHex("#121215")
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0,4)
        thumb.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -90, 0, 24)
        titleLabel.Position = UDim2.new(0,85,0,10)
        titleLabel.Text = script.title or "Untitled"
        titleLabel.TextColor3 = Color3.fromHex("#F0F0F0")
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 16
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
        titleLabel.Parent = card

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -90, 0, 30)
        descLabel.Position = UDim2.new(0,85,0,36)
        descLabel.Text = script.description or "No description"
        descLabel.TextColor3 = Color3.fromHex("#A0A0AA")
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.BackgroundTransparency = 1
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.Parent = card

        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(0,150,0,25)
        btnContainer.Position = UDim2.new(1, -160, 0, 58)
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = card

        local execBtn = Instance.new("TextButton")
        execBtn.Size = UDim2.new(0,70,1,0)
        execBtn.Position = UDim2.new(0,0,0,0)
        execBtn.Text = "Execute"
        execBtn.TextColor3 = Color3.fromHex("#F0F0F0")
        execBtn.Font = Enum.Font.GothamBold
        execBtn.TextSize = 13
        execBtn.BackgroundColor3 = Color3.fromHex("#7856FF")
        Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0,5)
        execBtn.Parent = btnContainer
        execBtn.MouseButton1Click:Connect(function()
            execBtn.Text = "Loading..."
            execBtn.BackgroundColor3 = Color3.fromHex("#555555")
            spawn(function()
                local ok, content = pcall(function() return game:HttpGet(script.script) end)
                if ok and content then
                    pcall(function() loadstring(content)() end)
                else
                    StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Failed to load script", Duration = 3})
                end
                execBtn.Text = "Execute"
                execBtn.BackgroundColor3 = Color3.fromHex("#7856FF")
            end)
        end)

        local infoBtn = Instance.new("TextButton")
        infoBtn.Size = UDim2.new(0,25,1,0)
        infoBtn.Position = UDim2.new(0,75,0,0)
        infoBtn.Text = "⋯"
        infoBtn.TextColor3 = Color3.fromHex("#F0F0F0")
        infoBtn.Font = Enum.Font.GothamBold
        infoBtn.TextSize = 16
        infoBtn.BackgroundColor3 = Color3.fromHex("#333338")
        Instance.new("UICorner", infoBtn).CornerRadius = UDim.new(0,5)
        infoBtn.Parent = btnContainer
        infoBtn.MouseButton1Click:Connect(function()
            -- show details popup
            local popup = Window:Dialog({
                Title = script.title or "Script Info",
                Description = "Author: " .. (script.author or "Unknown") ..
                              "\nDownloads: " .. (script.downloads or "N/A") ..
                              "\n\n" .. (script.description or "No description"),
                Buttons = {
                    {Title = "Close", Callback = function() end}
                }
            })
        end)
    end
    listFrame.CanvasSize = UDim2.new(0,0,0, #ScriptHub.Cache.scripts * 95 + 20)
end

-- fetch from scriptblox
local function fetchScripts(tag)
    ScriptHub.Cache.lastTag = tag
    local url = "https://scriptblox.com/api/scripts?sort=top&limit=50"
    if tag and tag:lower() ~= "all" then
        url = url .. "&search=" .. tag:lower()
    end
    local ok, json = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    if ok and json and json.scripts then
        ScriptHub.Cache.scripts = json.scripts
    else
        StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Could not fetch scripts.", Duration = 3})
    end
    displayScripts()
end

-- initial fetch
fetchScripts("all")

-- refresh when ScriptHub tab is opened? We'll just have a refresh button.