--[[

    WindUI Example (wip)
    
]]


local WindUI

do
    local ok, result = pcall(function()
        return require("./src/init")
    end)
    
    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end
end


-- */  Window  /* --
local Window = WindUI:CreateWindow({
    Title = ".ftgs hub  |  WindUI Example",
    Author = "by .ftgs • Footagesus",
    Folder = "ftgshub",
    NewElements = true,
    
    HideSearchBar = false,
    
    OpenButton = {
    Title = "Abrir XRNL HUB", -- cambia el texto si quieres
    Icon = "rbxassetid://12187365364", -- ✅ imagen personalizada de Roblox
    CornerRadius = UDim.new(1, 0), -- forma redonda
    StrokeThickness = 3, -- borde visible
    Enabled = true, -- habilitado
    Draggable = true, -- se puede mover
    OnlyMobile = false, -- visible en PC y móvil
    
    Color = ColorSequence.new({ -- efecto degradado
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 15, 123)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(248, 155, 41))
    }),
}


-- */ Other Functions /* --
local function parseJSON(luau_table, indent, level, visited)
    indent = indent or 2
    level = level or 0
    visited = visited or {}
    
    local currentIndent = string.rep(" ", level * indent)
    local nextIndent = string.rep(" ", (level + 1) * indent)
    
    if luau_table == nil then
        return "null"
    end
    
    local dataType = type(luau_table)
    
    if dataType == "table" then
        if visited[luau_table] then
            return "\"[Circular Reference]\""
        end
        
        visited[luau_table] = true
        
        local isArray = true
        local maxIndex = 0
        
        for k, _ in pairs(luau_table) do
            if type(k) == "number" and k > maxIndex then
                maxIndex = k
            end
            if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
                isArray = false
                break
            end
        end
        
        local count = 0
        for _ in pairs(luau_table) do
            count = count + 1
        end
        if count ~= maxIndex and isArray then
            isArray = false
        end
        
        if count == 0 then
            return "{}"
        end
        
        if isArray then
            if count == 0 then
                return "[]"
            end
            
            local result = "[\n"
            
            for i = 1, maxIndex do
                result = result .. nextIndent .. parseJSON(luau_table[i], indent, level + 1, visited)
                if i < maxIndex then
                    result = result .. ","
                end
                result = result .. "\n"
            end
            
            result = result .. currentIndent .. "]"
            return result
        else
            local result = "{\n"
            local first = true
            
            local keys = {}
            for k in pairs(luau_table) do
                table.insert(keys, k)
            end
            table.sort(keys, function(a, b)
                if type(a) == type(b) then
                    return tostring(a) < tostring(b)
                else
                    return type(a) < type(b)
                end
            end)
            
            for _, k in ipairs(keys) do
                local v = luau_table[k]
                if not first then
                    result = result .. ",\n"
                else
                    first = false
                end
                
                if type(k) == "string" then
                    result = result .. nextIndent .. "\"" .. k .. "\": "
                else
                    result = result .. nextIndent .. "\"" .. tostring(k) .. "\": "
                end
                
                result = result .. parseJSON(v, indent, level + 1, visited)
            end
            
            result = result .. "\n" .. currentIndent .. "}"
            return result
        end
    elseif dataType == "string" then
        local escaped = luau_table:gsub("\\", "\\\\")
        escaped = escaped:gsub("\"", "\\\"")
        escaped = escaped:gsub("\n", "\\n")
        escaped = escaped:gsub("\r", "\\r")
        escaped = escaped:gsub("\t", "\\t")
        
        return "\"" .. escaped .. "\""
    elseif dataType == "number" then
        return tostring(luau_table)
    elseif dataType == "boolean" then
        return luau_table and "true" or "false"
    elseif dataType == "function" then
        return "\"function\""
    else
        return "\"" .. dataType .. "\""
    end
end

local function tableToClipboard(luau_table, indent)
    indent = indent or 4
    local jsonString = parseJSON(luau_table, indent)
    setclipboard(jsonString)
    return jsonString
end


-- */  Abo ut Tab  /* --
do
    local AboutTab = Window:Tab({
        Title = "About WindUI",
        Icon = "info",
    })
    
    local AboutSection = AboutTab:Section({
        Title = "About WindUI",
    })
    
    AboutSection:Image({
        Image = "https://repository-images.githubusercontent.com/880118829/428bedb1-dcbd-43d5-bc7f-3beb2e9e0177",
        AspectRatio = "16:9",
        Radius = 9,
    })
    
    AboutSection:Space({ Columns = 3 })
    
    AboutSection:Section({
        Title = "What is WindUI?",
        TextSize = 24,
        FontWeight = Enum.FontWeight.SemiBold,
    })

    AboutSection:Space()
    
    AboutSection:Section({
        Title = [[WindUI is a stylish, open-source UI (User Interface) library specifically designed for Roblox Script Hubs.
Developed by Footagesus (.ftgs, Footages).
It aims to provide developers with a modern, customizable, and easy-to-use toolkit for creating visually appealing interfaces within Roblox.
The project is primarily written in Lua (Luau), the scripting language used in Roblox.]],
        TextSize = 18,
        TextTransparency = .35,
        FontWeight = Enum.FontWeight.Medium,
    })
    
    AboutTab:Space({ Columns = 4 }) 
    
    
    -- Default buttons
    
    AboutTab:Button({
        Title = "Export WindUI JSON (copy)",
        Color = Color3.fromHex("#a2ff30"),
        Justify = "Center",
        IconAlign = "Left",
        Icon = "", -- removing icon
        Callback = function()
            tableToClipboard(WindUI)
            WindUI:Notify({
                Title = "WindUI JSON",
                Content = "Copied to Clipboard!"
            })
        end
    })
    AboutTab:Space({ Columns = 1 }) 
    
    
    AboutTab:Button({
        Title = "Destroy Window",
        Color = Color3.fromHex("#ff4830"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
        end
    })
end

-- */  Elements Section  /* --
local ElementsSection = Window:Section({
    Title = "Elements",
})
local ConfigUsageSection = Window:Section({
    Title = "Config Usage",
})
local OtherSection = Window:Section({
    Title = "Other",
})


-- */ Using Nebula Icons /* --
do
    local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()
    
    -- Adding icons (e.g. Fluency)
    WindUI.Creator.AddIcons("fluency",    NebulaIcons.Fluency)
    --               ^ Icon name          ^ Table of Icons
    
    -- You can also add nebula icons
    WindUI.Creator.AddIcons("nebula",    NebulaIcons.nebulaIcons)
    
    -- Usage ↑ ↓
    
    local TestSection = Window:Section({
        Title = "Custom icons usage test (nebula)",
        Icon = "nebula:nebula",
    })
end



-- */  Toggle Tab  /* --
do
    local ToggleTab = ElementsSection:Tab({
        Title = "Script",
        Icon = "arrow-left-right"
    })

    -- Estado global (persistente)
local S = getgenv().XRNL or {}
S.SpeedEnabled = S.SpeedEnabled or false
S.Speed = S.Speed or 16

-- Función que aplica la velocidad al jugador
local function applySpeed()
    local player = game:GetService("Players").LocalPlayer
    if not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if S.SpeedEnabled then
        hum.WalkSpeed = S.Speed
    else
        hum.WalkSpeed = 16 -- velocidad por defecto
    end
end

-- Toggle para activar/desactivar Speed Boost
ToggleTab:Toggle({
    Title = "Speed",
    Desc = "Toggle Speed Boost",
    Default = S.SpeedEnabled,
    Callback = function(state)
        S.SpeedEnabled = state
        applySpeed()
    end
})

-- Slider para ajustar la velocidad en tiempo real
ToggleTab:Slider({
    Title = "Speed Value",
    Step = 1,
    Value = { Min = 16, Max = 500, Default = S.Speed },
    Callback = function(v)
        S.Speed = v
        if S.SpeedEnabled then
            applySpeed()
        end
    end
})

---------------------------------------------------------------------------------------------------------
    
    -- Estado global (persistente)
S.JumpEnabled = S.JumpEnabled or false
S.JumpPower = S.JumpPower or 100

-- Función que aplica el JumpBoost al jugador
local function applyJump()
    local player = game:GetService("Players").LocalPlayer
    if not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if S.JumpEnabled then
        hum.JumpPower = S.JumpPower
    else
        hum.JumpPower = 50 -- salto por defecto
    end
end

-- Toggle para activar/desactivar JumpBoost
ToggleTab:Toggle({
    Title = "JumpBoost",
    Desc = "Toggle Jump Boost",
    Default = S.JumpEnabled,
    Callback = function(state)
        S.JumpEnabled = state
        applyJump()
    end
})

-- Slider para ajustar el salto en tiempo real
ToggleTab:Slider({
    Title = "Jump Power Beta",
    Step = 1,
    Value = { Min = 50, Max = 800, Default = S.JumpPower },
    Callback = function(v)
        S.JumpPower = v
        if S.JumpEnabled then
            applyJump()
        end
    end
})
------------------------------------------------------------------------------------------------------------------------
-- Estado global
S.NoclipEnabled = S.NoclipEnabled or false

-- Variable de conexión para RunService
local RunService = game:GetService("RunService")
local noclipConn

-- Función que activa/desactiva noclip
local function toggleNoclip(state)
    S.NoclipEnabled = state

    if state then
        -- Activar noclip
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            local player = game:GetService("Players").LocalPlayer
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Desactivar noclip
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        -- Restaurar colisiones
        local player = game:GetService("Players").LocalPlayer
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Toggle UI
ToggleTab:Toggle({
    Title = "Noclip",
    Desc = "Toggle noclip on/off",
    Default = S.NoclipEnabled,
    Callback = function(state)
        toggleNoclip(state)
        -- Mensaje opcional
        if state then
            print("Noclip enabled")
        else
            print("Noclip disabled")
        end
    end
})
--------------------------------------------------------------------------------------------------------------------
-- Estado global
S.RisingPlatform = S.RisingPlatform or false
S.PlatformSpeed = S.PlatformSpeed or 0.2 -- velocidad más lenta

local platform
local runService = game:GetService("RunService")
local riseConn

-- Función para activar/desactivar la plataforma ascendente
local function toggleRisingPlatform(state)
    S.RisingPlatform = state
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character

    if state then
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Crear plataforma
        platform = Instance.new("Part")
        platform.Size = Vector3.new(10, 1, 10)
        platform.Anchored = true
        platform.Position = hrp.Position - Vector3.new(0, 3, 0)
        platform.Material = Enum.Material.Neon
        platform.Color = Color3.fromRGB(0, 255, 128)
        platform.Parent = workspace

        -- Movimiento ascendente y seguimiento del jugador
        if riseConn then riseConn:Disconnect() end
        riseConn = runService.Heartbeat:Connect(function()
            if platform and platform.Parent and hrp then
                -- Subir lentamente
                local newPos = platform.Position + Vector3.new(0, S.PlatformSpeed, 0)
                -- Seguir al jugador horizontalmente
                newPos = Vector3.new(hrp.Position.X, newPos.Y, hrp.Position.Z)
                platform.Position = newPos
            end
        end)
    else
        -- Destruir plataforma
        if platform then
            platform:Destroy()
            platform = nil
        end
        if riseConn then
            riseConn:Disconnect()
            riseConn = nil
        end
    end
end

-- Toggle UI
ToggleTab:Toggle({
    Title = "Rising Platform",
    Desc = "Crea una plataforma que sigue al personaje y sube lentamente",
    Default = S.RisingPlatform,
    Callback = function(state)
        toggleRisingPlatform(state)
        if state then
            print("Rising Platform enabled")
        else
            print("Rising Platform disabled")
        end
    end
})
----------------------------------------------------------------------------------                    
   
 --------------------------------------------------------------------------------------------------------                       
    
    ToggleTab:Space()
    
    
    ToggleTab:Toggle({
        Title = "Toggle",
        Locked = true,
    })
    
    ToggleTab:Toggle({
        Title = "Toggle",
        Desc = "Toggle example",
        Locked = true,
    })
end


-- */  Button Tab  /* --
do
    local ButtonTab = ElementsSection:Tab({
        Title = "Button",
        Icon = "mouse-pointer-click",
    })
    
    
    local HighlightButton
    HighlightButton = ButtonTab:Button({
        Title = "Highlight Button",
        Icon = "mouse",
        Callback = function()
            print("clicked highlight")
            HighlightButton:Highlight()
        end
    })

    ButtonTab:Space()
    
    ButtonTab:Button({
        Title = "Blue Button",
        Color = Color3.fromHex("#305dff"),
        Icon = "",
        Callback = function()
        end
    })

    ButtonTab:Space()
    
    ButtonTab:Button({
        Title = "Blue Button",
        Desc = "With description",
        Color = Color3.fromHex("#305dff"),
        Icon = "",
        Callback = function()
        end
    })
    
    ButtonTab:Space()
    
    ButtonTab:Button({
        Title = "Button",
        Desc = "Button example",
    })
    
    ButtonTab:Space()
    
    ButtonTab:Button({
        Title = "Button",
        Locked = true,
    })
    
    
    ButtonTab:Button({
        Title = "Button",
        Desc = "Button example",
        Locked = true,
    })
end


-- */  Input Tab  /* --
do
    local InputTab = ElementsSection:Tab({
        Title = "Input",
        Icon = "text-cursor-input",
    })
    
    
    InputTab:Input({
        Title = "Input",
        Icon = "mouse"
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Type = "Textarea",
        Icon = "mouse",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Type = "Textarea",
        --Icon = "mouse",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input",
        Desc = "Input example",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Desc = "Input example",
        Type = "Textarea",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input",
        Locked = true,
    })
    
    
    InputTab:Input({
        Title = "Input",
        Desc = "Input example",
        Locked = true,
    })
end





-- */  Config Usage  /* --
do -- config elements
    local ConfigElementsTab = ConfigUsageSection:Tab({
        Title = "Config Elements",
        Icon = "square-dashed-mouse-pointer",
    })
    
    -- All elements are taken from the official documentation: https://footagesus.github.io/WindUI-Docs/docs
    
    -- Saving elements to the config using `Flag`
    
    ConfigElementsTab:Colorpicker({
        Flag = "ColorpickerTest",
        Title = "Colorpicker",
        Desc = "Colorpicker Description",
        Default = Color3.fromRGB(0, 255, 0),
        Transparency = 0,
        Locked = false,
        Callback = function(color) 
            print("Background color: " .. tostring(color))
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Dropdown({
        Flag = "DropdownTest",
        Title = "Advanced Dropdown",
        Values = {
            {
                Title = "Category A",
                Icon = "bird"
            },
            {
                Title = "Category B",
                Icon = "house"
            },
            {
                Title = "Category C",
                Icon = "droplet"
            },
        },
        Value = "Category A",
        Callback = function(option) 
            print("Category selected: " .. option.Title .. " with icon " .. option.Icon) 
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Input({
        Flag = "InputTest",
        Title = "Input",
        Desc = "Input Description",
        Value = "Default value",
        InputIcon = "bird",
        Type = "Input", -- or "Textarea"
        Placeholder = "Enter text...",
        Callback = function(input) 
            print("Text entered: " .. input)
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Keybind({
        Flag = "KeybindTest",
        Title = "Keybind",
        Desc = "Keybind to open ui",
        Value = "G",
        Callback = function(v)
            Window:SetToggleKey(Enum.KeyCode[v])
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Slider({
        Flag = "SliderTest",
        Title = "Slider",
        Step = 1,
        Value = {
            Min = 20,
            Max = 120,
            Default = 70,
        },
        Callback = function(value)
            print(value)
        end
    })
    
    ConfigElementsTab:Space()
    
    ConfigElementsTab:Toggle({
        Flag = "ToggleTest",
        Title = "Toggle",
        Desc = "Toggle Description",
        --Icon = "house",
        --Type = "Checkbox",
        Default = false,
        Callback = function(state) 
            print("Toggle Activated" .. tostring(state))
        end
    })
end

do -- config panel
    local ConfigTab = ConfigUsageSection:Tab({
        Title = "Config Usage",
        Icon = "folder",
    })

    local ConfigManager = Window.ConfigManager
    local ConfigName = "default"

    local ConfigNameInput = ConfigTab:Input({
        Title = "Config Name",
        Icon = "file-cog",
        Callback = function(value)
            ConfigName = value
        end
    })

    local AllConfigs = ConfigManager:AllConfigs()
    local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

    ConfigTab:Dropdown({
        Title = "All Configs",
        Desc = "Select existing configs",
        Values = AllConfigs,
        Value = DefaultValue,
        Callback = function(value)
            ConfigName = value
            ConfigNameInput:Set(value)
        end
    })

    ConfigTab:Space()

    ConfigTab:Button({
        Title = "Save Config",
        Icon = "",
        Justify = "Center",
        Callback = function()
            Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
            if Window.CurrentConfig:Save() then
                WindUI:Notify({
                    Title = "Config Saved",
                    Desc = "Config '" .. ConfigName .. "' saved",
                    Icon = "check",
                })
            end
        end
    })

    ConfigTab:Space()

    ConfigTab:Button({
        Title = "Load Config",
        Icon = "",
        Justify = "Center",
        Callback = function()
            Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
            if Window.CurrentConfig:Load() then
                WindUI:Notify({
                    Title = "Config Loaded",
                    Desc = "Config '" .. ConfigName .. "' loaded",
                    Icon = "refresh-cw",
                })
            end
        end
    })
end




-- */  Other  /* --
do
    local InviteCode = "ftgs-development-hub-1300692552005189632"
    local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

    local Response = game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request({
        Url = DiscordAPI,
        Method = "GET",
        Headers = {
            ["User-Agent"] = "WindUI/Example",
            ["Accept"] = "application/json"
        }
    }).Body)
    
    local DiscordTab = OtherSection:Tab({
        Title = "Discord",
    })
    
    if Response and Response.guild then
        DiscordTab:Section({
            Title = "Join our Discord server!",
            TextSize = 20,
        })
        local DiscordServerParagraph = DiscordTab:Paragraph({
            Title = tostring(Response.guild.name),
            Desc = tostring(Response.guild.description),
            Image = "https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024",
            Thumbnail = "https://cdn.discordapp.com/banners/1300692552005189632/35981388401406a4b7dffd6f447a64c4.png?size=512",
            ImageSize = 48,
            Buttons = {
                {
                    Title = "Copy link",
                    Icon = "link",
                    Callback = function()
                        setclipboard("https://discord.gg/" .. InviteCode)
                    end
                }
            }
        })
        
    end
end
