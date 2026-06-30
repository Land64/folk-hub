return function(Library)
    local tab = Library:CreateTab("DFTE", "brain")

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
                    if inst.Name == "Wave" and inst:IsA("Model") then
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
                end)

            else
                if conn then
                    conn:Disconnect()
                    conn = nil
                end
            end
        end
    })

end
