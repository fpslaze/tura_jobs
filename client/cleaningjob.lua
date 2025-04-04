local Core = exports.vorp_core:GetCore()


local NPC <const> = {
    [1] = {
        name = "Albert",
        position = vec4(0, 0, 0, 120),
        modelhash = "A_M_M_STRDEPUTYRESIDENT_01"
    },

    [2] = {
        name = "Frank",
        position = vec4(0, 0, 0, 120),
        modelhash = "A_M_M_UniCoachGuards_01"
    }
}

local WorkCore = {}

local page = {}

local pageEntrys = {}

local cleaningPoints = { vec3(0, 0, 0), vec3(0, 0, 0), vec3(0, 0, 0), vec3(0, 0, 0), vec3(0, 0, 0), vec3(0, 0, 0), vec3(
    0, 0, 0), vec3(0, 0, 0) }

local paycheck = 0

local ped = {}


Citizen.CreateThread(function()
    CreateNPC(1)
end)

Citizen.CreateThread(function()
    local __player = PlayerId()
    while true do
        if GetDistance(GetEntityCoords(__player), NPC[1].position) <= 3 and
            IsControlJustReleased(0, 0x760A9C6F) then
            OpenMenu()
        end
        Citizen.Wait(1)
    end
end)

function OpenMenu(data)
    if not data then
        data = "default"
    end
end

function GetDistance(coords1, coords2)
    return #coords1 - coords2
end

---@param npcid integer
function CreateNPC(npcid)
    while not HasModelLoaded(NPC[npcid].modelhash) do
        Wait(10)
    end
    ped[#ped + 1] = CreatePed(0, NPC[npcid].modelhash, NPC[npcid].position.x, NPC[npcid].position.y,
        NPC[npcid].position.z, NPC[npcid].position.w, false, false)
end

local inWork = false
local currentJobPoint = nil

WorkCore.StartWork = function()
    if inWork then
        Core.NotifyTip("Du hast bereits eine Aktive Aufgabe!", 4000)
        return
    end

    if inWork == false and paycheck ~= 0 then
        Core.NotifyTip("Hole zuerst deinen Paycheck ab bevor du einen neuen Job anfangen kannst!", 4000)
        return
    end

    print("Du hast den Job erfolgreich gestartet")


    currentJobPoint = cleaningPoints[math.random(1, #cleaningPoints)]

    local __player = PlayerId()
    local isPressed = false

    while true do
        if GetDistance(GetEntityCoords(__player), currentJobPoint) <= 2 and
            IsControlJustReleased(0, 0x760A9C6F) then
            StartWorkAnim()
        end
        Citizen.Wait(1)
    end
end

function StartWorkAnim()

end

---@param name string
---@param payout integer
---@param diff string
---@param neededTasks number
function AddPage(name, payout, diff, neededTasks)
    page = { name = name, payoutforaction = payout, difficulty = diff, neededtaskstoearn = neededTasks }
end

function GetPage(name)
    if page[name] == nil then
        return 0
    end
end

RegisterCommand("testnpc", function()
    CreateNPC(1)
    Core.NotifyTip("Du hast den NPC mit der id 1 gesetzt!")
end, false)
