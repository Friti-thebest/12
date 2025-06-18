-- Script para criar estrutura geométrica com partes do personagem
-- Pressione E para ativar

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variáveis para controlar o estado
local isActive = false
local originalPositions = {}
local originalSizes = {}
local parts = {}

-- Função para salvar posições e tamanhos originais
local function saveOriginalState()
    originalPositions = {}
    originalSizes = {}
    parts = {}
    
    -- Coleta todas as partes do personagem
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            table.insert(parts, part)
            originalPositions[part] = part.Position
            originalSizes[part] = part.Size
        end
    end
end

-- Função para criar a estrutura geométrica
local function createGeometry()
    if #parts < 3 then
        warn("Não há partes suficientes para criar a estrutura!")
        return
    end
    
    local rootPart = character.HumanoidRootPart
    local basePosition = rootPart.Position
    
    -- Configurar primeiro quadrado (esquerda)
    local square1 = parts[1]
    square1.Size = Vector3.new(4, 4, 1)
    square1.Position = basePosition + Vector3.new(-5, 0, 0)
    square1.Shape = Enum.PartType.Block
    square1.BrickColor = BrickColor.new("Bright red")
    square1.CanCollide = true
    square1.Anchored = true
    
    -- Configurar segundo quadrado (direita)
    local square2 = parts[2]
    square2.Size = Vector3.new(4, 4, 1)
    square2.Position = basePosition + Vector3.new(5, 0, 0)
    square2.Shape = Enum.PartType.Block
    square2.BrickColor = BrickColor.new("Bright blue")
    square2.CanCollide = true
    square2.Anchored = true
    
    -- Configurar retângulo vertical (meio)
    local rectangle = parts[3]
    rectangle.Size = Vector3.new(1, 8, 1)
    rectangle.Position = basePosition + Vector3.new(0, 4, 0)
    rectangle.Shape = Enum.PartType.Block
    rectangle.BrickColor = BrickColor.new("Bright green")
    rectangle.CanCollide = true
    rectangle.Anchored = true
    
    -- Configurar partes restantes como invisíveis
    for i = 4, #parts do
        parts[i].Transparency = 1
        parts[i].CanCollide = false
        parts[i].Anchored = true
        parts[i].Position = basePosition + Vector3.new(0, -50, 0) -- Mover para baixo
    end
    
    print("Estrutura geométrica criada!")
end

-- Função para restaurar o estado original
local function restoreOriginal()
    for _, part in pairs(parts) do
        if originalPositions[part] and originalSizes[part] then
            part.Position = originalPositions[part]
            part.Size = originalSizes[part]
            part.Transparency = 0
            part.CanCollide = false
            part.Anchored = false
            part.BrickColor = BrickColor.new("Medium stone grey")
        end
    end
    print("Estado original restaurado!")
end

-- Função para aplicar God Mode
local function applyGodMode()
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        -- Conectar evento para manter a saúde infinita
        humanoid.HealthChanged:Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        print("God Mode ativado!")
    end
end

-- Função principal para alternar entre os estados
local function toggleGeometry()
    if not isActive then
        saveOriginalState()
        createGeometry()
        applyGodMode()
        isActive = true
    else
        restoreOriginal()
        isActive = false
    end
end

-- Detectar pressionar da tecla E
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        toggleGeometry()
    end
end)

-- Reconectar quando o personagem for resetado
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    isActive = false
    
    -- Aplicar God Mode automaticamente após reset
    wait(1) -- Aguardar um pouco para garantir que tudo carregou
    applyGodMode()
end)

-- Aplicar God Mode inicial
applyGodMode()

print("Script carregado! Pressione E para alternar a estrutura geométrica.")
print("God Mode está ativo - você não morrerá mesmo após resetar.")
