local v0 = 17687505296 -(261 + 624)
if game.PlaceId ~= v0 then
    warn("Script only works in All Star Tower Defense.")
    return
end

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Carrega o script principal
local v7 = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxotaa7/ShiftHub/refs/heads/main/shifthub_teest.lua", true))()

local keyWindow = v7:CreateWindow({
    Name = "Shift Hub - Key",
    LoadingTitle = "Loading Shift Hub...",
    LoadingSubtitle = "Checking Key...",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local keyTab = keyWindow:CreateTab("🔑 Key")
local userKey = ""

keyTab:CreateInput({
    Name = "Your Key",
    PlaceholderText = "Enter your key here",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        userKey = value
    end
})

-- Mascara do campo da key
task.spawn(function()
    task.wait(1.5)
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name:find("Shift Hub") then
            for _, v in ipairs(gui:GetDescendants()) do
                if v:IsA("TextBox") and v.PlaceholderText == "Enter your key here" then
                    v.TextMasked = true
                end
            end
        end
    end
end)

-- Botão de validar a key
keyTab:CreateButton({
    Name = "Validate Key",
    Callback = function()
        local url = "http://localhost:3000/validate/" .. HttpService:UrlEncode(userKey)
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        if success then
            local data = HttpService:JSONDecode(response)
            if data.valid then
                v7:Notify({Title = "Success", Content = "Valid key! Welcome to Shift Hub.", Duration = 3})
                v7:Destroy()
                wait(0.2)
                local v64 = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxotaa7/ShiftHub/refs/heads/main/shifthub_teest.lua", true))()
                openMainWindow(v64)
            else
                v7:Notify({Title = "Error", Content = "Invalid key! Try again.", Duration = 5})
            end
        else
            v7:Notify({Title = "Error", Content = "Could not connect to server.", Duration = 5})
        end
    end
})

-- Botão para abrir Discord
keyTab:CreateButton({
    Name = "Open Discord",
    Callback = function()
        setclipboard("https://discord.gg/mAn7k89V")
        v7:Notify({Title = "Link copied!", Content = "Discord link copied to clipboard. Paste in browser to join.", Duration = 5})
    end
})

-- Função da GUI principal
function openMainWindow(Rayfield2)
    local mainWindow = Rayfield2:CreateWindow({
        Name = "Shift Hub",
        LoadingTitle = "Shift Hub",
        LoadingSubtitle = "",
        ConfigurationSaving = {Enabled = false},
        KeySystem = false
    })

    local mainTab = mainWindow:CreateTab("🏠 Main")
    mainTab:CreateSection("Welcome to Shift Hub!")

    local rollbackEnabled = false
    mainTab:CreateToggle({
        Name = "Rollback Trait",
        CurrentValue = false,
        Callback = function(value)
            rollbackEnabled = value
            print("Rollback Ativado.", value)
        end
    })

    mainTab:CreateButton({
        Name = "Confirm Rollback",
        Callback = function()
            if rollbackEnabled then
                v7:Notify({Title = "Rollback", Content = "Rollback feito com sucesso.", Duration = 3})
                wait(3)
                v7:Notify({Title = "Rollback", Content = "Relogando...", Duration = 3})
                game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
            else
                v7:Notify({Title = "Error", Content = "Rollback Trait não está ativado.", Duration = 3})
            end
        end
    })

    local gemValue = 0
    mainTab:CreateInput({
        Name = "Amount of Gems",
        PlaceholderText = "Enter gems amount",
        RemoveTextAfterFocusLost = false,
        Callback = function(value)
            local num = tonumber(value)
            if num then
                gemValue = num
                print("Amount of Gems set to:", gemValue)
            else
                print("Please enter a valid number")
            end
        end
    })

    mainTab:CreateToggle({
        Name = "Give Gems",
        CurrentValue = false,
        Callback = function(enabled)
            print("Give Gems toggled:", enabled, "Amount:", gemValue)
            if enabled and gemValue > 0 then
                local ohTable1 = {Premium = gemValue, Type = "Cash", Cash = 300}
                if ReplicatedStorage:FindFirstChild("Binds") and ReplicatedStorage.Binds:FindFirstChild("CashBind") then
                    ReplicatedStorage.Binds.CashBind:Fire(ohTable1)
                    print("Fired remote for", gemValue, "gems! Table sent:", ohTable1)
                else
                    print("ERROR: Remote not found! ReplicatedStorage.Binds.CashBind does not exist.")
                end
            end
        end
    })

    local configsTab = mainWindow:CreateTab("⚙️ Config")
    configsTab:CreateSection("Settings")
    configsTab:CreateButton({
        Name = "Rejoin",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    })

    local bindKey = nil
    local listeningForBind = false
    local bindLabel = configsTab:CreateLabel({Name = "Current Bind: None"})

    configsTab:CreateButton({
        Name = "Choose bind to show/hide interface",
        Callback = function()
            listeningForBind = true
            bindLabel:SetText("Press any key...")
        end
    })

    UserInputService.InputBegan:Connect(function(input, processed)
        if listeningForBind and input.UserInputType == Enum.UserInputType.Keyboard then
            bindKey = input.KeyCode
            listeningForBind = false
            bindLabel:SetText("Current Bind: " .. tostring(bindKey.Name))
        elseif bindKey and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == bindKey then
            mainWindow.Visible = not mainWindow.Visible
        end
    end)

    mainWindow.Visible = true
end
