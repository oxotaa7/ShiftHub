local allowedPlaceId = 17687504411
if game.PlaceId ~= allowedPlaceId then
    warn("Script only works in All Star Tower Defense.")
    return
end

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Sound IDs (replace with yours)
local openSoundId = "rbxassetid://84041558102940"
local closeSoundId = "rbxassetid://78706875936198"

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
        local url = "http://localhost:3000/validate/" .. HttpService:UrlEncode(userKey)
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        if success then
            local data = HttpService:JSONDecode(response)
            if data.valid then
                Rayfield:Notify({
                    Title = "Success",
                    Content = "Valid key! Welcome to Shift Hub.",
                    Duration = 3
                })
                Rayfield:Destroy()
                wait(0.2)
                local Rayfield2 = loadstring(game:HttpGet('https://raw.githubusercontent.com/oxotaa/teste/refs/heads/main/source2.lua'))()
                openMainWindow(Rayfield2)
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Invalid key! Try again.",
                    Duration = 5
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Could not connect to server.",
                Duration = 5
            })
        end
    end
})

keyTab:CreateButton({
    Name = "Open Discord",
    Callback = function()
        setclipboard("https://discord.gg/mAn7k89V")
        Rayfield:Notify({
            Title = "Link copied!",
            Content = "Discord link copied to clipboard. Paste in browser to join.",
            Duration = 5
        })
    end
})

-- Main GUI functio
function openMainWindow(Rayfield2)
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

    -- RollBack Trait (Toggle)
    local rollbackEnabled = false
    mainTab:CreateToggle({
        Name = "Rollback Trait",
        CurrentValue = false,
        Callback = function(value)
            rollbackEnabled = value
            print("Rollback Ativado.", value)
        end
    })

    -- Confirm Rollback Button
    mainTab:CreateButton({
        Name = "Confirm Rollback",
        Callback = function()
            if rollbackEnabled then
                Rayfield:Notify({
                    Title = "Rollback",
                    Content = "Rollback carregando...",
                    Duration = 3
                })
                
                -- Simulação do processo de rollback
                wait(10) -- Simula o tempo de rollback

                Rayfield:Notify({
                    Title = "Rollback",
                    Content = "Rollback feito com sucesso.",
                    Duration = 3
                })

                wait(3) -- Espera um pouco antes de relogar
                Rayfield:Notify({
                    Title = "Rollback",
                    Content = "Relogando...",
                    Duration = 3
                })

                -- Relogar no servidor
                game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Rollback Trait não está ativado.",
                    Duration = 3
                })
            end
        end
    })

    -- Gems system (visual give, fires only when toggled ON)
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
                local ohTable1 = {
                    ["Premium"] = gemValue,
                    ["Type"] = "Cash",
                    ["Cash"] = 300 -- pode ser qualquer valor, igual ao Hydroxide
                }
                if ReplicatedStorage:FindFirstChild("Binds") and ReplicatedStorage.Binds:FindFirstChild("CashBind") then
                    ReplicatedStorage.Binds.CashBind:Fire(ohTable1)
                    print("Fired remote for", gemValue, "gems! Table sent:", ohTable1)
                else
                    print("ERROR: Remote not found! ReplicatedStorage.Binds.CashBind does not exist.")
                end
            end
        end
    })

    -- Config Tab
    local configsTab = mainWindow:CreateTab("⚙️ Config")
    configsTab:CreateSection("Settings")

    configsTab:CreateButton({
        Name = "Rejoin",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    })

    -- Bind + sound
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