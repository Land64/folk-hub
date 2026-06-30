local AssetQualityService = game:GetService("AssetQualityService")
return function(Library)
    local tab = Library:CreateTab("DFTE", "brain")
    local player = game.Players.LocalPlayer

    Library:CreateToggle(tab, {
        Name = "Wave God Mode",
        Callback = function(value)

            local conn

            -- probably add this func to utility once im done wit dis
            local function apply(inst)
                if inst:IsA("BasePart") then
                    inst.CanCollide = false
                    inst.CanTouch = false
                end
            end
            
            local function disableWaveCollisions(model)
                for _, inst in ipairs(model:GetDescendants()) do
                    if inst.Name == "Wave" then
                        apply(inst)
                        for _, part in ipairs(inst:GetDescendants()) do
                            apply(part)
                        end
                    end
                end
            end

            if value then
                for _, model in ipairs(workspace.Tsunamis:GetChildren()) do
                    disableWaveCollisions(model)
                end
                conn = workspace.Tsunamis.DescendantAdded:Connect(function(inst)
                    apply(inst)
                    if inst.Name == "Wave" then
                        for _, part in ipairs(inst:GetDescendants()) do
                            apply(part)
                        end
                    end
                end)

            else
                if conn then
                    conn:Disconnect()
                    conn = nil
                end
            end
        end
    })

    local autoFarmEnabled = false
    local farmConnection = nil
    
    local tiers = {
        ["Common"] = 0,
        ["Uncommon"] = 1,
        ["Rare"] = 2,
        ["Epic"] = 3,
        ["Legendary"] = 4,
        ["Mythical"] = 5,
        ["Godly"] = 6,
        ["Secert"] = 7,
        ["Admin"] = 8,
        ["Ancient"] = 9,
        ["Divine"] = 10,
        ["Celestial"] = 11
    }
    
    local function getTier(item)
        return tiers[item.Name] or 0
    end
    
    Library:CreateToggle(tab, {
        Name = "Auto Farm",
        Callback = function(value)
            autoFarmEnabled = value
        
            if value then
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                local initialPos = hrp.CFrame
            
                local folder = workspace.ItemSpawners.Divine
            
                local function getBestItem()
                    local bestItem = nil
                    local bestTier = -math.huge
                
                    for _, item in ipairs(folder:GetDescendants()) do
                        if item.Name == "SpawnedItem" and item:FindFirstChild("HumanoidRootPart") then
                            local tier = getTier(item)
                        
                            if tier > bestTier then
                                bestTier = tier
                                bestItem = item
                            end
                        end
                    end
                
                    return bestItem
                end
            
                farmConnection = task.spawn(function()
                    while autoFarmEnabled do
                        local item = getBestItem()
                    
                        if item and item:FindFirstChild("HumanoidRootPart") then
                            local itemHRP = item.HumanoidRootPart
                            local prompt = itemHRP:FindFirstChildOfClass("ProximityPrompt")
                        
                            if prompt and hrp then
                                initialPos = hrp.CFrame
                            
                                hrp.CFrame = itemHRP.CFrame
                                fireproximityprompt(prompt)
                                task.wait(0.1)
                                hrp.CFrame = initialPos
                            end
                        end
                    
                        task.wait(1)
                    end
                end)
            
            else
                -- TURN OFF CLEANLY
                autoFarmEnabled = false
            end
        end
    })

end
