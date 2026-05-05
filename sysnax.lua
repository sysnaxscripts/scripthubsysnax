-- Sysnax ScriptHub – Stable, WindUI, ScriptBlox integration
-- Discord: https://discord.gg/xadh9mPGaN
-- Manual scripts saved locally in "sysnax/hubscripts.json"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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

-- ==================== WELCOME OVERLAY (fades after 2s) ====================
local welcomeFrame = Instance.new("Frame")
welcomeFrame.Size = UDim2.new(1, 0, 1, -35)
welcomeFrame.Position = UDim2.new(0, 0, 0, 35)
welcomeFrame.BackgroundColor3 = Color3.fromHex("#121215")
welcomeFrame.BorderSizePixel = 0
welcomeFrame.ZIndex = 10
welcomeFrame.Parent = Window.Main
local welcomeLogo = Instance.new("ImageLabel")
welcomeLogo.Size = UDim2.new(0, 80, 0, 80)
welcomeLogo.Position = UDim2.new(0.5, -40, 0.4, -40)
welcomeLogo.Image = "rbxassetid://122198206955790"
welcomeLogo.BackgroundTransparency = 1
welcomeLogo.Parent = welcomeFrame
local welcomeTitle = Instance.new("TextLabel", welcomeFrame)
welcomeTitle.Size = UDim2.new(1, 0, 0, 30)
welcomeTitle.Position = UDim2.new(0, 0, 0.52, 0)
welcomeTitle.Text = "Welcome, " .. LocalPlayer.DisplayName
welcomeTitle.TextColor3 = Color3.fromHex("#F0F0F0")
welcomeTitle.Font = Enum.Font.GothamBold
welcomeTitle.TextSize = 24
welcomeTitle.BackgroundTransparency = 1
local welcomeSub = Instance.new("TextLabel", welcomeFrame)
welcomeSub.Size = UDim2.new(1, 0, 0, 20)
welcomeSub.Position = UDim2.new(0, 0, 0.58, 0)
welcomeSub.Text = "Sysnax ScriptHub"
welcomeSub.TextColor3 = Color3.fromHex("#A0A0AA")
welcomeSub.Font = Enum.Font.Gotham
welcomeSub.TextSize = 16
welcomeSub.BackgroundTransparency = 1
spawn(function()
    wait(2)
    TweenService:Create(welcomeFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(welcomeLogo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(welcomeTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(welcomeSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    wait(0.5)
    welcomeFrame:Destroy()
end)

-- ==================== HOME TAB ====================
local HomeTab = Window:Tab({Title = "Home", Icon = "home"})
local profileSection = HomeTab:Section({Title = "Profile", Icon = "user"})
profileSection:AddImage({Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420), Size = UDim2.fromOffset(80, 80)})
profileSection:AddLabel("@" .. LocalPlayer.Name)
profileSection:AddLabel(LocalPlayer.DisplayName)
profileSection:AddLabel("Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"))
local serverSection = HomeTab:Section({Title = "Server", Icon = "server"})
serverSection:AddLabel("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
serverSection:AddLabel("Place ID: " .. game.PlaceId)
serverSection:AddLabel("Server Region: " .. (game:GetService("LocalizationService").RobloxLocaleId or "N/A"))
local communitySection = HomeTab:Section({Title = "Community", Icon = "message-circle"})
communitySection:AddButton({Title = "Join Discord", Callback = function()
    setclipboard("https://discord.gg/xadh9mPGaN")
    StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Discord invite copied!", Duration = 3})
end})

-- ==================== SCRIPTHUB TAB ====================
local ScriptHub = Window:Tab({Title = "ScriptHub", Icon = "code"})

-- Internal cache
local cache = { scripts = {}, searchTerm = "", category = "All" }

-- Folder for locally saved scripts
local hubFolder = "sysnax/hub"
if not isfolder(hubFolder) then makefolder(hubFolder) end
local savedScriptsFile = hubFolder .. "/user_scripts.json"

-- Utility to load local scripts
local function loadUserScripts()
    local ok, data = pcall(function()
        if isfile(savedScriptsFile) then
            return HttpService:JSONDecode(readfile(savedScriptsFile))
        end
        return {}
    end)
    return ok and data or {}
end

-- Utility to save local scripts
local function saveUserScripts(scripts)
    pcall(function() writefile(savedScriptsFile, HttpService:JSONEncode(scripts)) end)
end

-- Merge user scripts into cache
local function mergeScripts(fetched)
    local userScripts = loadUserScripts()
    cache.scripts = {}
    -- Add user scripts first
    for _, s in ipairs(userScripts) do
        table.insert(cache.scripts, s)
    end
    -- Then fetched ones (skip duplicates by URL)
    for _, s in ipairs(fetched or {}) do
        local duplicate = false
        for _, us in ipairs(userScripts) do
            if us.script == s.script then duplicate = true break end
        end
        if not duplicate then
            table.insert(cache.scripts, s)
        end
    end
end

-- UI elements for ScriptHub
local searchSection = ScriptHub:Section({Title = "Search & Filters", Icon = "search"})
local searchBox = searchSection:AddTextbox({Placeholder = "Search scripts...", Callback = function(v)
    cache.searchTerm = v:lower()
    displayScripts()
end})

local catSection = ScriptHub:Section({Title = "Categories", Icon = "tag"})
local categoryDropdown = catSection:AddDropdown({
    Title = "Category",
    Values = {"All", "Rivals", "Arsenal", "HyperShot", "FPS", "Utility", "Misc"},
    Value = "All",
    Callback = function(v)
        cache.category = v
        fetchScripts(v)
    end
})

local refreshBtn = ScriptHub:Section({Title = "Actions", Icon = "refresh-cw"})
refreshBtn:AddButton({Title = "Refresh Scripts", Callback = function()
    fetchScripts(cache.category)
end})

local manualSection = ScriptHub:Section({Title = "Add Your Own Script", Icon = "plus"})
local urlInput = manualSection:AddTextbox({Placeholder = "Raw script URL (pastebin.com/raw/...)", Callback = function(v) end})
local nameInput = manualSection:AddTextbox({Placeholder = "Script Name", Callback = function(v) end})
manualSection:AddButton({Title = "Add & Save", Callback = function()
    local url = urlInput:GetValue()
    local name = nameInput:GetValue()
    if url and url ~= "" then
        local newScript = {
            title = name ~= "" and name or "Custom Script",
            script = url,
            image = "rbxassetid://122198206955790",
            description = "Manually added",
            author = "You",
            downloads = 0,
            isUserScript = true
        }
        local userScripts = loadUserScripts()
        -- Avoid exact duplicate
        local dup = false
        for _, s in ipairs(userScripts) do
            if s.script == url then dup = true break end
        end
        if not dup then
            table.insert(userScripts, 1, newScript)
            saveUserScripts(userScripts)
            mergeScripts(cache.scripts) -- will re-sync
            displayScripts()
            urlInput:SetValue("")
            nameInput:SetValue("")
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Script added!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "This script is already in your hub.", Duration = 3})
        end
    end
end})

-- Script list area (ScrollFrame)
local listSection = ScriptHub:Section({Title = "Available Scripts", Icon = "file-text"})
local listFrame = nil
local function createListContainer()
    if listFrame then return end
    local sectionFrame = listSection:GetSectionFrame()
    if not sectionFrame then return end
    listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -20, 0, 300)
    listFrame.Position = UDim2.new(0, 10, 0, 0)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = Color3.fromHex("#7856FF")
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.Parent = sectionFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = listFrame
end

local function displayScripts()
    createListContainer()
    if not listFrame then return end
    -- Clear old cards
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local filtered = {}
    local search = cache.searchTerm or ""
    local category = cache.category:lower()
    for _, script in ipairs(cache.scripts) do
        if search ~= "" and not script.title:lower():find(search) then continue end
        if category ~= "all" then
            -- Rough category matching based on description/title
            local txt = (script.title .. " " .. script.description):lower()
            if not txt:find(category) then continue end
        end
        table.insert(filtered, script)
    end
    if #filtered == 0 then
        local noScript = Instance.new("TextLabel")
        noScript.Size = UDim2.new(1, 0, 0, 30)
        noScript.BackgroundTransparency = 1
        noScript.Text = "No scripts found"
        noScript.TextColor3 = Color3.fromHex("#A0A0AA")
        noScript.Font = Enum.Font.Gotham
        noScript.TextSize = 14
        noScript.Parent = listFrame
    else
        for _, script in ipairs(filtered) do
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, -4, 0, 90)
            card.BackgroundColor3 = Color3.fromHex("#212125")
            card.BorderSizePixel = 0
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
            card.Parent = listFrame

            local thumb = Instance.new("ImageLabel")
            thumb.Size = UDim2.new(0, 70, 0, 70)
            thumb.Position = UDim2.new(0, 8, 0, 10)
            thumb.Image = script.image or "rbxassetid://122198206955790"
            thumb.ScaleType = Enum.ScaleType.Fit
            thumb.BackgroundColor3 = Color3.fromHex("#121215")
            Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 4)
            thumb.Parent = card

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -92, 0, 20)
            titleLabel.Position = UDim2.new(0, 84, 0, 10)
            titleLabel.Text = script.title or "Untitled"
            titleLabel.TextColor3 = Color3.fromHex("#F0F0F0")
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 15
            titleLabel.BackgroundTransparency = 1
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
            titleLabel.Parent = card

            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -92, 0, 26)
            descLabel.Position = UDim2.new(0, 84, 0, 34)
            descLabel.Text = script.description or "No description"
            descLabel.TextColor3 = Color3.fromHex("#A0A0AA")
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 12
            descLabel.BackgroundTransparency = 1
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextWrapped = true
            descLabel.Parent = card

            local btnFrame = Instance.new("Frame")
            btnFrame.Size = UDim2.new(0, 150, 0, 25)
            btnFrame.Position = UDim2.new(1, -160, 0, 58)
            btnFrame.BackgroundTransparency = 1
            btnFrame.Parent = card

            local execBtn = Instance.new("TextButton")
            execBtn.Size = UDim2.new(0, 70, 1, 0)
            execBtn.Position = UDim2.new(0, 0, 0, 0)
            execBtn.Text = "Execute"
            execBtn.TextColor3 = Color3.fromHex("#FFFFFF")
            execBtn.Font = Enum.Font.GothamBold
            execBtn.TextSize = 13
            execBtn.BackgroundColor3 = Color3.fromHex("#7856FF")
            Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 5)
            execBtn.Parent = btnFrame
            execBtn.MouseButton1Click:Connect(function()
                execBtn.Text = "Loading..."
                execBtn.BackgroundColor3 = Color3.fromHex("#555555")
                spawn(function()
                    local ok, content = pcall(function() return game:HttpGet(script.script) end)
                    if ok and content then
                        pcall(function() loadstring(content)() end)
                    else
                        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Failed to load script.", Duration = 3})
                    end
                    execBtn.Text = "Execute"
                    execBtn.BackgroundColor3 = Color3.fromHex("#7856FF")
                end)
            end)

            local infoBtn = Instance.new("TextButton")
            infoBtn.Size = UDim2.new(0, 25, 1, 0)
            infoBtn.Position = UDim2.new(0, 75, 0, 0)
            infoBtn.Text = "⋯"
            infoBtn.TextColor3 = Color3.fromHex("#FFFFFF")
            infoBtn.Font = Enum.Font.GothamBold
            infoBtn.TextSize = 16
            infoBtn.BackgroundColor3 = Color3.fromHex("#333338")
            Instance.new("UICorner", infoBtn).CornerRadius = UDim.new(0, 5)
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

            -- Delete button (only for user scripts)
            if script.isUserScript then
                local delBtn = Instance.new("TextButton")
                delBtn.Size = UDim2.new(0, 25, 1, 0)
                delBtn.Position = UDim2.new(0, 105, 0, 0)
                delBtn.Text = "🗑"
                delBtn.TextColor3 = Color3.fromHex("#FF5555")
                delBtn.Font = Enum.Font.GothamBold
                delBtn.TextSize = 14
                delBtn.BackgroundColor3 = Color3.fromHex("#333338")
                Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 5)
                delBtn.Parent = btnFrame
                delBtn.MouseButton1Click:Connect(function()
                    local userScripts = loadUserScripts()
                    for i, us in ipairs(userScripts) do
                        if us.script == script.script then
                            table.remove(userScripts, i)
                            break
                        end
                    end
                    saveUserScripts(userScripts)
                    mergeScripts(nil) -- will refetch from api?
                    fetchScripts(cache.category) -- refresh
                end)
            end
        end
    end
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #filtered * 100 + 20)
end

-- Fetch scripts from ScriptBlox API
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
        StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Could not fetch scripts from ScriptBlox.", Duration = 3})
    end
    mergeScripts(fetched)
    displayScripts()
end

-- Initial fetch
fetchScripts("All")