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

    Library:CreateToggle(tab, {
    Name = "Auto Farm",
    Callback = function(value)
        autoFarmEnabled = value

        if value then
            task.spawn(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")

                while autoFarmEnabled do
                    -- validate target
                    if not currentTarget
                        or not currentTarget:FindFirstChild("HumanoidRootPart")
                        or not currentTarget:IsDescendantOf(workspace) then

                        currentTarget = nil
                        currentBestTier = -1

                        for _, spawner in ipairs(spawners:GetChildren()) do
                            for _, item in ipairs(spawner:GetDescendants()) do
                                if item.Name == "SpawnedItem" then
                                    setBest(item)
                                end
                            end
                        end
                    end

                    -- act on best
                    if currentTarget then
                        local hrpt = currentTarget:FindFirstChild("HumanoidRootPart")
                        local prompt = hrpt and hrpt:FindFirstChildOfClass("ProximityPrompt")

                        if hrpt and prompt then
                            local old = hrp.CFrame

                            hrp.CFrame = hrpt.CFrame
                            fireproximityprompt(prompt)

                            task.wait(0.1)
                            hrp.CFrame = old
                        end
                    end

                    task.wait(0.5)
                end
            end)
        else
            currentTarget = nil
            currentBestTier = -1
                autoFarmEnabled = false
            end
        end
    })

end
