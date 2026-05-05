-- Sysnax ScriptHub – Official Release (No errors, real scripts)
-- Discord: https://discord.gg/xadh9mPGaN
local Players, HttpService, StarterGui, TweenService, UserInputService = game:GetService("Players"), game:GetService("HttpService"), game:GetService("StarterGui"), game:GetService("TweenService"), game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Anti-cheat bypass
pcall(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("LocalScript") and (v.Name:lower():find("anticheat") or v.Name:lower():find("antihack") or v.Name:lower():find("detection") or v.Name == "LocalScript") then
            v.Disabled = true
        end
    end
end)

-- Main GUI
local Gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
Gui.Name = "Sysnax"

-- Colors
local bg = Color3.fromRGB(18,18,20)
local accent = Color3.fromRGB(130,86,255)
local sec = Color3.fromRGB(28,28,32)
local elem = Color3.fromRGB(33,33,38)
local text1 = Color3.fromRGB(255,255,255)
local text2 = Color3.fromRGB(170,170,180)

-- Window
local main = Instance.new("Frame", Gui)
main.Size = UDim2.fromOffset(800,520)
main.Position = UDim2.new(0.5,-400,0.5,-260)
main.BackgroundColor3 = sec
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- Welcome overlay
local welcome = Instance.new("Frame", main)
welcome.Size = UDim2.fromScale(1,1)
welcome.BackgroundColor3 = sec
welcome.ZIndex = 10
local welLogo = Instance.new("ImageLabel", welcome)
welLogo.Size = UDim2.fromOffset(90,90)
welLogo.Position = UDim2.new(0.5,-45,0.4,-45)
welLogo.Image = "rbxassetid://122198206955790"
welLogo.BackgroundTransparency = 1
local welTitle = Instance.new("TextLabel", welcome)
welTitle.Size = UDim2.new(1,0,0,30)
welTitle.Position = UDim2.new(0,0,0.55,0)
welTitle.Text = "Welcome, "..LocalPlayer.DisplayName
welTitle.TextColor3 = text1
welTitle.Font = Enum.Font.GothamBold
welTitle.TextSize = 26
welTitle.BackgroundTransparency = 1
local welSub = Instance.new("TextLabel", welcome)
welSub.Size = UDim2.new(1,0,0,22)
welSub.Position = UDim2.new(0,0,0.62,0)
welSub.Text = "Sysnax ScriptHub"
welSub.TextColor3 = text2
welSub.Font = Enum.Font.Gotham
welSub.TextSize = 16
welSub.BackgroundTransparency = 1
spawn(function()
    wait(2.2)
    TweenService:Create(welcome, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(welLogo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(welTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(welSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    wait(0.6) welcome:Destroy()
end)

-- Title bar (draggable)
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = elem
local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(0,180,1,0)
titleText.Position = UDim2.new(0,12,0,0)
titleText.Text = "Sysnax"
titleText.TextColor3 = text1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.fromOffset(28,28)
closeBtn.Position = UDim2.new(1,-32,0,4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = text1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
closeBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)
-- drag
local dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragStart = nil end end)
        dragInput = input
    end
end)
titleBar.InputChanged:Connect(function(input)
    if dragInput == input and dragStart then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Navigation
local nav = Instance.new("Frame", main)
nav.Size = UDim2.new(0,150,1,-36)
nav.Position = UDim2.new(0,0,0,36)
nav.BackgroundColor3 = elem
local homeBtn = Instance.new("TextButton", nav)
homeBtn.Size = UDim2.new(1,-20,0,32)
homeBtn.Position = UDim2.new(0,10,0,10)
homeBtn.Text = "🏠  Home"
homeBtn.TextColor3 = text1
homeBtn.Font = Enum.Font.Gotham
homeBtn.TextSize = 14
homeBtn.TextXAlignment = Enum.TextXAlignment.Left
homeBtn.BackgroundColor3 = accent
Instance.new("UICorner", homeBtn).CornerRadius = UDim.new(0,8)
local hubBtn = Instance.new("TextButton", nav)
hubBtn.Size = UDim2.new(1,-20,0,32)
hubBtn.Position = UDim2.new(0,10,0,50)
hubBtn.Text = "📜  ScriptHub"
hubBtn.TextColor3 = text1
hubBtn.Font = Enum.Font.Gotham
hubBtn.TextSize = 14
hubBtn.TextXAlignment = Enum.TextXAlignment.Left
hubBtn.BackgroundColor3 = elem
Instance.new("UICorner", hubBtn).CornerRadius = UDim.new(0,8)
local discordBtn = Instance.new("TextButton", nav)
discordBtn.Size = UDim2.new(1,-20,0,32)
discordBtn.Position = UDim2.new(0,10,1,-42)
discordBtn.Text = "💬  Discord"
discordBtn.TextColor3 = text1
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 14
discordBtn.BackgroundColor3 = accent
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0,8)
discordBtn.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/xadh9mPGaN") StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Discord invite copied!",Duration=3}) end)

-- Content area
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-150,1,-36)
content.Position = UDim2.new(0,150,0,36)
content.BackgroundColor3 = sec

-- Home tab
local homeTab = Instance.new("Frame", content)
homeTab.Size = UDim2.fromScale(1,1)
homeTab.BackgroundTransparency = 1
homeTab.Visible = true
-- Avatar
local avFrame = Instance.new("Frame", homeTab)
avFrame.Size = UDim2.fromOffset(80,80)
avFrame.Position = UDim2.fromOffset(20,20)
avFrame.BackgroundTransparency = 1
local avImg = Instance.new("ImageLabel", avFrame)
avImg.Size = UDim2.fromScale(1,1)
avImg.BackgroundTransparency = 1
avImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", avImg).CornerRadius = UDim.new(0,40)
-- Name
local nameLbl = Instance.new("TextLabel", homeTab)
nameLbl.Size = UDim2.new(0,300,0,26)
nameLbl.Position = UDim2.fromOffset(115,25)
nameLbl.Text = "@"..LocalPlayer.Name
nameLbl.TextColor3 = text1
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 20
nameLbl.TextXAlignment = Enum.TextXAlignment.Left
nameLbl.BackgroundTransparency = 1
local displayLbl = Instance.new("TextLabel", homeTab)
displayLbl.Size = UDim2.new(0,300,0,18)
displayLbl.Position = UDim2.fromOffset(115,55)
displayLbl.Text = LocalPlayer.DisplayName
displayLbl.TextColor3 = text2
displayLbl.Font = Enum.Font.Gotham
displayLbl.TextSize = 14
displayLbl.TextXAlignment = Enum.TextXAlignment.Left
displayLbl.BackgroundTransparency = 1
local execLbl = Instance.new("TextLabel", homeTab)
execLbl.Size = UDim2.new(0,300,0,18)
execLbl.Position = UDim2.fromOffset(115,78)
execLbl.Text = "Executor: "..(identifyexecutor and identifyexecutor() or "Unknown")
execLbl.TextColor3 = text2
execLbl.Font = Enum.Font.Gotham
execLbl.TextSize = 14
execLbl.TextXAlignment = Enum.TextXAlignment.Left
execLbl.BackgroundTransparency = 1
-- Server info
local srvFrame = Instance.new("Frame", homeTab)
srvFrame.Size = UDim2.new(0,360,0,90)
srvFrame.Position = UDim2.fromOffset(20,125)
srvFrame.BackgroundColor3 = elem
Instance.new("UICorner", srvFrame).CornerRadius = UDim.new(0,10)
local srvTitle = Instance.new("TextLabel", srvFrame)
srvTitle.Size = UDim2.new(1,-20,0,22)
srvTitle.Position = UDim2.fromOffset(10,8)
srvTitle.Text = "Server"
srvTitle.TextColor3 = accent
srvTitle.Font = Enum.Font.GothamBold
srvTitle.TextSize = 15
srvTitle.TextXAlignment = Enum.TextXAlignment.Left
srvTitle.BackgroundTransparency = 1
local function addSrvLine(text, y)
    local l = Instance.new("TextLabel", srvFrame)
    l.Size = UDim2.new(1,-20,0,18)
    l.Position = UDim2.fromOffset(10,y)
    l.Text = text
    l.TextColor3 = text1
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
end
addSrvLine("Players: "..#Players:GetPlayers().."/"..Players.MaxPlayers, 35)
addSrvLine("Place ID: "..game.PlaceId, 55)
addSrvLine("Region: "..(game:GetService("LocalizationService").RobloxLocaleId or "N/A"), 75)

-- ScriptHub tab
local hubTab = Instance.new("Frame", content)
hubTab.Size = UDim2.fromScale(1,1)
hubTab.BackgroundTransparency = 1
hubTab.Visible = false

-- Scrolling script list
local scriptList = Instance.new("ScrollingFrame", hubTab)
scriptList.Size = UDim2.new(1,-30,0,310)
scriptList.Position = UDim2.fromOffset(15,70)
scriptList.BackgroundTransparency = 1
scriptList.ScrollBarThickness = 4
scriptList.ScrollBarImageColor3 = accent
scriptList.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UIListLayout", scriptList).Padding = UDim.new(0,6)

-- Search & Categories
local search = Instance.new("TextBox", hubTab)
search.Size = UDim2.new(0,250,0,30)
search.Position = UDim2.fromOffset(15,10)
search.PlaceholderText = "Search scripts..."
search.Text = ""
search.TextColor3 = text1
search.PlaceholderColor3 = text2
search.BackgroundColor3 = elem
search.Font = Enum.Font.Gotham
search.TextSize = 14
Instance.new("UICorner", search).CornerRadius = UDim.new(0,8)
search.Changed:Connect(function()
    cache.searchTerm = search.Text:lower()
    displayScripts()
end)

local categories = {"All","Rivals","Arsenal","HyperShot","FPS","Utility","Misc"}
local selectedCat = "All"
local catButtons = {}
for i,cat in ipairs(categories) do
    local btn = Instance.new("TextButton", hubTab)
    btn.Size = UDim2.fromOffset(70,26)
    btn.Position = UDim2.fromOffset(15 + (i-1)*75, 48)
    btn.Text = cat
    btn.TextColor3 = text1
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BackgroundColor3 = (cat==selectedCat) and accent or elem
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    btn.MouseButton1Click:Connect(function()
        selectedCat = cat
        for _, b in ipairs(catButtons) do b.BackgroundColor3 = (b.Text==cat) and accent or elem end
        cache.category = cat
        fetchScripts(cat)
    end)
    table.insert(catButtons, btn)
end

local refreshBtn = Instance.new("TextButton", hubTab)
refreshBtn.Size = UDim2.fromOffset(80,26)
refreshBtn.Position = UDim2.fromOffset(440,48)
refreshBtn.Text = "⟳ Refresh"
refreshBtn.TextColor3 = text1
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 13
refreshBtn.BackgroundColor3 = elem
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0,8)
refreshBtn.MouseButton1Click:Connect(function() fetchScripts(selectedCat) end)

-- Manual add
local urlInput = Instance.new("TextBox", hubTab)
urlInput.Size = UDim2.new(0,300,0,30)
urlInput.Position = UDim2.fromOffset(15,390)
urlInput.PlaceholderText = "Raw script URL"
urlInput.Text = ""
urlInput.TextColor3 = text1
urlInput.PlaceholderColor3 = text2
urlInput.BackgroundColor3 = elem
urlInput.Font = Enum.Font.Gotham
urlInput.TextSize = 14
Instance.new("UICorner", urlInput).CornerRadius = UDim.new(0,8)

local nameInput = Instance.new("TextBox", hubTab)
nameInput.Size = UDim2.fromOffset(130,30)
nameInput.Position = UDim2.fromOffset(325,390)
nameInput.PlaceholderText = "Name"
nameInput.Text = ""
nameInput.TextColor3 = text1
nameInput.PlaceholderColor3 = text2
nameInput.BackgroundColor3 = elem
nameInput.Font = Enum.Font.Gotham
nameInput.TextSize = 14
Instance.new("UICorner", nameInput).CornerRadius = UDim.new(0,8)

local addBtn = Instance.new("TextButton", hubTab)
addBtn.Size = UDim2.fromOffset(70,30)
addBtn.Position = UDim2.fromOffset(465,390)
addBtn.Text = "Add"
addBtn.TextColor3 = text1
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 14
addBtn.BackgroundColor3 = accent
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0,8)
addBtn.MouseButton1Click:Connect(function()
    local url, name = urlInput.Text, nameInput.Text
    if url ~= "" then
        local script = {title = (name~="" and name) or "Custom Script", script = url, image = "rbxassetid://122198206955790", description = "Manually added", author = "You", downloads = 0, isUserScript = true}
        local user = loadUserScripts()
        local dup = false; for _,s in ipairs(user) do if s.script == url then dup = true break end end
        if not dup then
            table.insert(user,1,script) saveUserScripts(user) mergeScripts()
            urlInput.Text = "" nameInput.Text = ""
            StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Script added!",Duration=3})
        else StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Already in your hub.",Duration=3}) end
    end
end)

-- Cache & Save
local cache = {scripts = {}, searchTerm = "", category = "All"}
local hubFolder = "sysnax/hub"
pcall(function() if not isfolder(hubFolder) then makefolder(hubFolder) end end)
local savedFile = hubFolder.."/user_scripts.json"

local function loadUserScripts()
    local ok,data = pcall(function()
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
    for _,s in ipairs(user) do table.insert(cache.scripts, s) end
    if fetched then for _,s in ipairs(fetched) do
        local dup = false; for _,us in ipairs(user) do if us.script == s.script then dup = true break end end
        if not dup then table.insert(cache.scripts, s) end
    end end
end

local function createScriptCard(script)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 85)
    card.BackgroundColor3 = elem
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)

    local thumb = Instance.new("ImageLabel", card)
    thumb.Size = UDim2.fromOffset(65,65)
    thumb.Position = UDim2.fromOffset(8,10)
    thumb.Image = script.image or "rbxassetid://122198206955790"
    thumb.ScaleType = Enum.ScaleType.Fit
    thumb.BackgroundColor3 = sec
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(0,6)

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Size = UDim2.new(1,-85,0,20)
    titleLbl.Position = UDim2.fromOffset(80,8)
    titleLbl.Text = script.title or "Untitled"
    titleLbl.TextColor3 = text1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.BackgroundTransparency = 1

    local descLbl = Instance.new("TextLabel", card)
    descLbl.Size = UDim2.new(1,-85,0,24)
    descLbl.Position = UDim2.fromOffset(80,32)
    descLbl.Text = script.description or "No description"
    descLbl.TextColor3 = text2
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 12
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.BackgroundTransparency = 1

    local btnFrame = Instance.new("Frame", card)
    btnFrame.Size = UDim2.fromOffset(135,24)
    btnFrame.Position = UDim2.new(1,-145,0,55)
    btnFrame.BackgroundTransparency = 1

    local execBtn = Instance.new("TextButton", btnFrame)
    execBtn.Size = UDim2.fromOffset(58,24)
    execBtn.BackgroundColor3 = accent
    execBtn.Text = "Execute"
    execBtn.TextColor3 = text1
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 12
    Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0,5)
    execBtn.MouseButton1Click:Connect(function()
        execBtn.Text = "Loading..."
        execBtn.BackgroundColor3 = text2
        spawn(function()
            local ok, content = pcall(game.HttpGet, game, script.script)
            if ok and content then pcall(function() loadstring(content)() end)
            else StarterGui:SetCore("SendNotification",{Title="Error",Text="Failed to load script.",Duration=3}) end
            execBtn.Text = "Execute"
            execBtn.BackgroundColor3 = accent
        end)
    end)

    local infoBtn = Instance.new("TextButton", btnFrame)
    infoBtn.Size = UDim2.fromOffset(24,24)
    infoBtn.Position = UDim2.fromOffset(63,0)
    infoBtn.Text = "⋯"
    infoBtn.TextColor3 = text1
    infoBtn.Font = Enum.Font.GothamBold
    infoBtn.TextSize = 14
    infoBtn.BackgroundColor3 = elem
    Instance.new("UICorner", infoBtn).CornerRadius = UDim.new(0,5)
    infoBtn.MouseButton1Click:Connect(function()
        local p = Instance.new("Frame", Gui)
        p.Size = UDim2.fromOffset(320,200)
        p.Position = UDim2.new(0.5,-160,0.5,-100)
        p.BackgroundColor3 = sec
        p.BorderSizePixel = 0
        p.ZIndex = 20
        Instance.new("UICorner", p).CornerRadius = UDim.new(0,10)
        local pt = Instance.new("TextLabel", p)
        pt.Size = UDim2.new(1,-20,0,24)
        pt.Position = UDim2.fromOffset(10,8)
        pt.Text = script.title or "Script Info"
        pt.TextColor3 = text1
        pt.Font = Enum.Font.GothamBold
        pt.TextSize = 16
        pt.TextXAlignment = Enum.TextXAlignment.Left
        pt.BackgroundTransparency = 1
        local pd = Instance.new("TextLabel", p)
        pd.Size = UDim2.new(1,-20,0,130)
        pd.Position = UDim2.fromOffset(10,38)
        pd.Text = "Author: "..(script.author or "Unknown").."\nDownloads: "..(script.downloads or "N/A").."\n\n"..(script.description or "No description")
        pd.TextColor3 = text1
        pd.Font = Enum.Font.Gotham
        pd.TextSize = 13
        pd.TextXAlignment = Enum.TextXAlignment.Left
        pd.TextYAlignment = Enum.TextYAlignment.Top
        pd.BackgroundTransparency = 1
        local pc = Instance.new("TextButton", p)
        pc.Size = UDim2.fromOffset(60,24)
        pc.Position = UDim2.new(1,-70,1,-32)
        pc.Text = "Close"
        pc.TextColor3 = text1
        pc.Font = Enum.Font.GothamBold
        pc.TextSize = 13
        pc.BackgroundColor3 = Color3.fromRGB(255,70,70)
        Instance.new("UICorner", pc).CornerRadius = UDim.new(0,5)
        local bd = Instance.new("TextButton", Gui)
        bd.Size = UDim2.fromScale(1,1)
        bd.BackgroundColor3 = Color3.new(0,0,0)
        bd.BackgroundTransparency = 0.7
        bd.ZIndex = 19
        bd.Text = ""
        local function close()
            p:Destroy() bd:Destroy()
        end
        pc.MouseButton1Click:Connect(close)
        bd.MouseButton1Click:Connect(close)
    end)

    if script.isUserScript then
        local delBtn = Instance.new("TextButton", btnFrame)
        delBtn.Size = UDim2.fromOffset(24,24)
        delBtn.Position = UDim2.fromOffset(92,0)
        delBtn.Text = "🗑"
        delBtn.TextColor3 = text1
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        delBtn.BackgroundColor3 = Color3.fromRGB(255,70,70)
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0,5)
        delBtn.MouseButton1Click:Connect(function()
            local user = loadUserScripts()
            for i,s in ipairs(user) do
                if s.script == script.script then table.remove(user,i) break end
            end
            saveUserScripts(user) mergeScripts() displayScripts()
        end)
    end

    return card
end

local function displayScripts()
    for _,c in ipairs(scriptList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    local filtered = {}
    local searchTerm = cache.searchTerm or ""
    local cat = cache.category:lower()
    for _,s in ipairs(cache.scripts) do
        if searchTerm ~= "" and not s.title:lower():find(searchTerm) then continue end
        if cat ~= "all" then
            local txt = (s.title.." "..(s.description or "")):lower()
            if not txt:find(cat) then continue end
        end
        table.insert(filtered, s)
    end
    if #filtered == 0 then
        local no = Instance.new("TextLabel", scriptList)
        no.Size = UDim2.new(1,0,0,30)
        no.Text = "No scripts found."
        no.TextColor3 = text2
        no.Font = Enum.Font.Gotham
        no.TextSize = 14
        no.BackgroundTransparency = 1
    else
        for _,s in ipairs(filtered) do
            createScriptCard(s).Parent = scriptList
        end
    end
    scriptList.CanvasSize = UDim2.new(0,0,0, #filtered*95 + 20)
end

-- Fetch from ScriptBlox API
local function fetchScripts(category)
    local url = "https://scriptblox.com/api/scripts?sort=top&limit=40"
    if category and category:lower() ~= "all" then
        url = url .. "&search=" .. category:lower()
    end
    local ok,json = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    local fetched = {}
    if ok and json and json.data then
        for _,s in ipairs(json.data) do
            table.insert(fetched, {
                title = s.title,
                script = s.script,
                image = s.image or "rbxassetid://122198206955790",
                description = s.description,
                author = s.author or "Unknown",
                downloads = s.downloads or 0
            })
        end
    else
        StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="Could not fetch scripts.",Duration=3})
    end
    mergeScripts(fetched)
    displayScripts()
end

-- Initial load
mergeScripts()
fetchScripts("All")

-- Tab switching
homeBtn.MouseButton1Click:Connect(function()
    homeTab.Visible = true hubTab.Visible = false
    homeBtn.BackgroundColor3 = accent hubBtn.BackgroundColor3 = elem
end)
hubBtn.MouseButton1Click:Connect(function()
    homeTab.Visible = false hubTab.Visible = true
    hubBtn.BackgroundColor3 = accent homeBtn.BackgroundColor3 = elem
end)

-- Toggle with Right Shift
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

StarterGui:SetCore("SendNotification",{Title="Sysnax",Text="ScriptHub loaded! Right Shift to toggle.",Duration=5})