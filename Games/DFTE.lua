return function(Library)
    local tab = Library:CreateTab("DFTE", "brain")

    Library:CreateToggle(tab, {
        Name = "Wave God Mode",
        Callback = function(value)

            local connection

            if value then
                for _, inst in ipairs(workspace.Tsunamis:GetDescendants()) do
                    inst.CanCollide = false
                    inst.CanTouch = false
                end

                connection = workspace.Tsunamis.DescendantAdded:Connect(function(inst)
                    inst.CanCollide = false
                    inst.CanTouch = false
                end)

            else
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end
    })

end
