-- Roblox LUA Script
local allowedPlaceId = 17687504411
if game.PlaceId ~= allowedPlaceId then
    warn("Script only works in All Star Tower Defense.")
    return
end

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

-- Sound IDs
local openSoundId = "rbxassetid://84041558102940"
local closeSoundId = "rbxassetid://78706875936198"

-- Funções Auxiliares
local function playSound(assetId)
    local sound = Instance.new("Sound")
    sound.SoundId = assetId
    sound.Volume = 1
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- KEY GUI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/oxotaa/teste/refs/heads/main/source2.lua'))()
local keyWindow = Rayfield:CreateWindow({
    Name = "Shift Hub - Key",
    LoadingTitle = "Loading Shift Hub...",
    LoadingSubtitle = "Checking Key...",
    ConfigurationSaving = { Enabled = false },
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

keyTab:CreateButton({
    Name = "Validate Key",
    Callback = function()
        if userKey == ".w9SUW_IL^Cq&JyldotWZrqMnVjRi4W3U" then
            Rayfield:Notify({
                Title = "Success",
                Content = "Valid key! Welcome to Shift Hub.",
                Duration = 3
            })
            Rayfield:Destroy()
            wait(0.2)
            openMainWindow()
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Invalid key! Try again.",
                Duration = 5
            })
        end
    end
})

keyTab:CreateButton({
    Name = "Open Discord",
    Callback = function()
        local success, err = pcall(function()
            setclipboard("https://discord.gg/mAn7k89V")
        end)

        if success then
            Rayfield:Notify({
                Title = "Link copied!",
                Content = "Discord link copied to clipboard. Paste in browser to join.",
                Duration = 5
            })
        else
            Rayfield:Notify({
                Title = "Link de Convite",
                Content = "https://discord.gg/mAn7k89V. Por favor, copie manualmente.",
                Duration = 7
            })
        end
    end
})

-- FUNÇÃO PRINCIPAL DA GUI
function openMainWindow()
    local Rayfield2 = loadstring(game:HttpGet('https://raw.githubusercontent.com/oxotaa/teste/refs/heads/main/source2.lua'))()

    local mainWindow = Rayfield2:CreateWindow({
        Name = "Shift Hub",
        LoadingTitle = "Shift Hub",
        LoadingSubtitle = "",
        ConfigurationSaving = { Enabled = false },
        KeySystem = false
    })

    -- Main Tab
    local mainTab = mainWindow:CreateTab("🏠 Main")
    mainTab:CreateSection("Welcome to Shift Hub!")

    -- Rollback Trait
    local rollbackEnabled = false

    -- Hook do metatable para rollback seguro
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if rollbackEnabled and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
            print("[Rollback] Bloqueado:", self.Name)
            if self:IsA("RemoteFunction") and method == "InvokeServer" then
                return false -- retorna algo válido para RemoteFunction
            else
                return nil -- RemoteEvent pode apenas ser bloqueado
            end
        end
        return oldNamecall(self, ...)
    end)

    mainTab:CreateToggle({
        Name = "Rollback Trait",
        CurrentValue = false,
        Callback = function(value)
            rollbackEnabled = value
            if rollbackEnabled then
                print("Rollback Ativado.")
            else
                print("Rollback Desativado.")
            end
        end
    })

    mainTab:CreateButton({
        Name = "Confirm Rollback",
        Callback = function()
            if rollbackEnabled then
                Rayfield2:Notify({Title = "Rollback", Content = "Rollback carregando...", Duration = 3})
                wait(6)
                Rayfield2:Notify({Title = "Rollback", Content = "Rollback feito com sucesso.", Duration = 3})
                wait(3)
                TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
            else
                Rayfield2:Notify({Title = "Error", Content = "Rollback Trait não está ativado.", Duration = 3})
            end
        end
    })

    -- Config Tab
    local configsTab = mainWindow:CreateTab("⚙️ Config")
    configsTab:CreateSection("Settings")

    configsTab:CreateButton({
        Name = "Rejoin",
        Callback = function()
            TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    })

    local bindKey = nil
    local listeningForBind = false
    local bindLabel = configsTab:CreateLabel({ Name = "Current Bind: None" })

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
            if mainWindow.Visible then
                playSound(openSoundId)
            else
                playSound(closeSoundId)
            end
        end
    end)

    mainWindow.Visible = true
    playSound(openSoundId)
end
