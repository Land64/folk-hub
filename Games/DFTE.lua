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

    Library:CreateButton(tab, {
        Name = "Auto Farm",
        Callback = function()
            --local conneciton

            local intialPos = player.Character.HumanoidRootPart.CFrame

            for _, spawned in ipairs(workspace.ItemSpawners.Ancient:GetDescendants()) do
                if spawned.Name == "SpawnedItem" and spawned then
                    player.Character.HumanoidRootPart.CFrame = spawned.HumanoidRootPart.CFrame
                    fireproximityprompt(spawned.HumanoidRootPart.ProximityPrompt)
                    player.Character.HumanoidRootPart.CFrame = intialPos
                end
            end
            
        end
    })

end
