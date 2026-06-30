local AssetQualityService = game:GetService("AssetQualityService")
local TweenService = game:GetService("TweenService")

return function(Library)
    local tab = Library:CreateTab("DFTE", "brain")
    local player = game.Players.LocalPlayer

    Library:CreateToggle(tab, {
        Name = "Wave God Mode",
        Callback = function(value)

            local conn

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
                for _, model in ipairs(workspace:WaitForChild("Tsunamis"):GetChildren()) do
                    disableWaveCollisions(model)
                end

                conn = workspace.Tsunamis.DescendantAdded:Connect(function(inst)
                    if inst.Name == "Wave" then
                        apply(inst)

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
    local currentTarget = nil
    local currentBestTier = -1

    local spawners = workspace:WaitForChild("ItemSpawners")

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

    local itemAdded = Instance.new("BindableEvent")

    local function getTier(item)
        return tiers[item.Name] or 0
    end

    local function evaluate(item)
        if not item or not item:IsDescendantOf(workspace) then return end
        if not item:FindFirstChild("HumanoidRootPart") then return end

        local tier = getTier(item.Name)

        if tier > currentBestTier then
            currentBestTier = tier
            currentTarget = item
        end
    end

    for _, spawner in ipairs(spawners:GetChildren()) do
        spawner.DescendantAdded:Connect(function(inst)
            if inst.Name == "SpawnedItem" then
                evaluate(inst)
                itemAdded:Fire()
            end
        end)
    end

    Library:CreateToggle(tab, {
        Name = "Auto Farm",
        Callback = function(value)
            autoFarmEnabled = value

            if value then
                task.spawn(function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")

                    while autoFarmEnabled do

                        if not currentTarget
                            or not currentTarget:IsDescendantOf(workspace)
                            or not currentTarget:FindFirstChild("HumanoidRootPart") then

                            currentTarget = nil
                            currentBestTier = -1

                            itemAdded.Event:Wait()

                            for _, spawner in ipairs(spawners:GetChildren()) do
                                for _, item in ipairs(spawner:GetDescendants()) do
                                    if item.Name == "SpawnedItem" then
                                        evaluate(item)
                                    end
                                end
                            end
                        end

                        if currentTarget then
                            local hrpt = currentTarget:FindFirstChild("HumanoidRootPart")
                            local prompt = hrpt and hrpt:FindFirstChildOfClass("ProximityPrompt")

                            if hrpt and prompt then
                                local old = hrp.CFrame
                            
                                local tweenInfo = TweenInfo.new(
                                    0.5, -- time
                                    Enum.EasingStyle.Quad,
                                    Enum.EasingDirection.Out
                                )
                            
                                local tween = TweenService:Create(hrp, tweenInfo, {
                                    CFrame = hrpt.CFrame
                                })
                            
                                tween:Play()
                                tween.Completed:Wait()
                            
                                task.wait(0.1)
                                fireproximityprompt(prompt)
                            
                                task.wait(0.1)
                            
                                local tweenBack = TweenService:Create(hrp, tweenInfo, {
                                    CFrame = old
                                })
                            
                                tweenBack:Play()
                                tweenBack.Completed:Wait()
                            
                                task.wait(0.2)
                            end
                        end

                        task.wait(0.3)
                    end
                end)
            else
                autoFarmEnabled = false
                currentTarget = nil
                currentBestTier = -1
            end
        end
    })
end