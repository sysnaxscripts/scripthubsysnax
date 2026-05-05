-- Sysnax ScriptHub (Stable v2)
-- WindUI · ScriptBlox integration · local save · AC bypass
-- Discord: https://discord.gg/xadh9mPGaN

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- AC bypass (disable all anti‑cheat LocalScripts)
pcall(function()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") then
            local name = obj.Name:lower()
            if name:find("anticheat") or name:find("antihack") or name:find("detection") or name:find("ac") or obj.Name == "LocalScript" then
                obj.Disabled = true
            end
        end
    end
end)

-- Load WindUI
local WindUI
pcall(function()
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)
if not WindUI then
    StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "WindUI failed to load.", Duration = 5})
    return
end

-- Theme
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

-- Window
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

-- Welcome overlay (fades after 2 seconds)
local welcomeFrame = Instance.new("Frame")
welcomeFrame.Size = UDim2.new(1, 0, 1, -35)
welcomeFrame.Position = UDim2.new(0, 0, 0, 35)
welcomeFrame.BackgroundColor3 = Color3.fromHex("#121215")
welcomeFrame.BorderSizePixel = 0
welcomeFrame.ZIndex = 10
welcomeFrame.Parent = Window.Main
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 80, 0, 80)
logo.Position = UDim2.new(0.5, -40, 0.4, -40)
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
spawn(function()
    wait(2)
    TweenService:Create(welcomeFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    wait(0.5)
    welcomeFrame:Destroy()
end)

-- Home tab (profile)
local HomeTab = Window:Tab({Title = "Home", Icon = "home"})
local profileSection = HomeTab:Section({Title = "Profile", Icon = "user"})
-- manually add avatar image
local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, 80, 0, 80)
avatarFrame.Position = UDim2.new(0, 0, 0, 0)
avatarFrame.BackgroundTransparency = 1
avatarFrame.Parent = profileSection:GetSectionFrame()
local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(1, 0, 1, 0)
avatarImg.BackgroundTransparency = 1
avatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 40)
avatarImg.Parent = avatarFrame
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

-- ScriptHub tab
local ScriptHub = Window:Tab({Title = "ScriptHub", Icon = "code"})
local cache = { scripts = {}, searchTerm = "", category = "All" }
local hubFolder = "sysnax/hub"
if not isfolder(hubFolder) then makefolder(hubFolder) end
local savedScriptsFile = hubFolder .. "/user_scripts.json"

local function loadUserScripts()
    local ok, data = pcall(function()
        if isfile(savedScriptsFile) then
            return HttpService:JSONDecode(readfile(savedScriptsFile))
        end
        return {}
    end)
    return ok and data or {}
end
local function saveUserScripts(scripts)
    pcall(function() writefile(savedScriptsFile, HttpService:JSONEncode(scripts)) end)
end
local function mergeScripts(fetched)
    local userScripts = loadUserScripts()
    cache.scripts = {}
    for _, s in ipairs(userScripts) do table.insert(cache.scripts, s) end
    for _, s in ipairs(fetched or {}) do
        local dup = false
        for _, us in ipairs(userScripts) do if us.script == s.script then dup = true break end end
        if not dup then table.insert(cache.scripts, s) end
    end
end

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
local refreshSection = ScriptHub:Section({Title = "Actions", Icon = "refresh-cw"})
refreshSection:AddButton({Title = "Refresh Scripts", Callback = function()
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
        local dup = false
        for _, s in ipairs(userScripts) do if s.script == url then dup = true break end end
        if not dup then
            table.insert(userScripts, 1, newScript)
            saveUserScripts(userScripts)
            mergeScripts()
            displayScripts()
            urlInput:SetValue(""); nameInput:SetValue("")
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Script added!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Sysnax", Text = "Script already in your hub.", Duration = 3})
        end
    end
end})

-- Script list (ScrollingFrame inside a custom section frame)
local listSection = ScriptHub:Section({Title = "Available Scripts", Icon = "file-text"})
local listFrame = nil
local function createListContainer()
    if listFrame then return end
    local sectionFrame = listSection:GetSectionFrame()
    if not sectionFrame then return end
    listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -20, 0, 280)
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
        local no = Instance.new("TextLabel")
        no.Size = UDim2.new(1, 0, 0, 30)
        no.BackgroundTransparency = 1
        no.Text = "No scripts found"
        no.TextColor3 = Color3.fromHex("#A0A0AA")
        no.Font = Enum.Font.Gotham
        no.TextSize = 14
        no.Parent = listFrame
    else
        for _, script in ipairs(filtered) do
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, -4, 0, 85)
            card.BackgroundColor3 = Color3.fromHex("#212125")
            card.BorderSizePixel = 0
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
            card.Parent = listFrame

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
            execBtn.Text = "Execute"
            execBtn.TextColor3 = Color3.fromHex("#FFFFFF")
            execBtn.Font = Enum.Font.GothamBold
            execBtn.TextSize = 12
            execBtn.BackgroundColor3 = Color3.fromHex("#7856FF")
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
                        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Failed to load script.", Duration = 3})
                    end
                    execBtn.Text = "Execute"
                    execBtn.BackgroundColor3 = Color3.fromHex("#7856FF")
                end)
            end)

            local infoBtn = Instance.new("TextButton")
            infoBtn.Size = UDim2.new(0, 22, 1, 0)
            infoBtn.Position = UDim2.new(0, 65, 0, 0)
            infoBtn.Text = "⋯"
            infoBtn.TextColor3 = Color3.fromHex("#FFFFFF")
            infoBtn.Font = Enum.Font.GothamBold
            infoBtn.TextSize = 14
            infoBtn.BackgroundColor3 = Color3.fromHex("#333338")
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
                delBtn.Position = UDim2.new(0, 92, 0, 0)
                delBtn.Text = "🗑"
                delBtn.TextColor3 = Color3.fromHex("#FF5555")
                delBtn.Font = Enum.Font.GothamBold
                delBtn.TextSize = 12
                delBtn.BackgroundColor3 = Color3.fromHex("#333338")
                Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
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
                    mergeScripts()
                    displayScripts()
                end)
            end
        end
    end
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #filtered * 92 + 20)
end

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

-- initial load
fetchScripts("All")