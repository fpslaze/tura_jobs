local Core = exports.vorp_core:GetCore()
local Menu = exports.vorp_menu:GetMenuData()

local savedPaycheck = 0;
local isJobActive = false;
local xp = 5;


local controlKey = 0x760A9C6F -- (E-Taste)
local promptJobStart

Citizen.CreateThread(function()
    local str = "Job-Menu öffnen!"
    promptJobStart = PromptRegisterBegin()
    PromptSetControlAction(promptJobStart, controlKey)
    PromptSetText(promptJobStart, CreateVarString(10, "LITERAL_STRING", str))
    PromptSetStandardMode(promptJobStart, true)
    PromptRegisterEnd(promptJobStart)
    PromptSetEnabled(promptJobStart, false)
    PromptSetVisible(promptJobStart, false)
end)



function ShowPromt(promtid)
    PromptSetEnabled(promts[1], true)
    PromptSetVisible(promts[1], true)
end

function HidePromt(promtid)
    PromptSetEnabled(promts[1], false)
    PromptSetVisible(promts[1], false)
end

local function getDistance(index)
    local coords = GetEntityCoords(PlayerPedId())
    local coords2 = vector3(Config.Npc[index].NpcPosition.x, Config.Npc[index].NpcPosition.y,
        Config.Npc[index].NpcPosition.z)
    return #(coords - coords2)
end

local function LoadModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model, false)
        repeat Wait(0) until HasModelLoaded(model)
    end
end


local function AddBlip(index)
    if (Config.Npc[index].blipAllowed) then
        local blip = BlipAddForCoords(1664425300, Config.Npc[index].NpcPosition.x, Config.Npc[index].NpcPosition.y,
            Config.Npc[index].NpcPosition.z)
        SetBlipSprite(blip, Config.Npc[index].blipSprite, true)
        SetBlipScale(blip, 0.2)
        SetBlipName(blip, Config.Npc[index].name)
        Config.Npc[index].BlipHandle = blip

        print("Ein Blip für den Index " .. index .. " wurde erstellt!")
    end
end

Citizen.CreateThread(function()
    AddBlip(1)
end)

---@param index integer
function SpawnNPC(index)
    local v = Config.npc[index]
    LoadModel(v.NpcModel)
    local npc = CreatePed(joaat(v.NpcModel), v.NpcPosition.x, v.NpcPosition.y, v.NpcPosition.z, v.NpcPosition.h, false,
        false, false, false)
    repeat Wait(0) until DoesEntityExist(npc)
    PlaceEntityOnGroundProperly(npc, true)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    Wait(1000)
    TaskStandStill(npc, -1)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetModelAsNoLongerNeeded(v.NpcModel)

    if index ~= 0 then
        AddBlip(index)
    end

    AddBlip(index)
end

Citizen.CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession
end)

function OpenMenu()
    Menu.CloseAll()
    MenuElements = {

        {
            label = "Aktuelle hinterlegtes Geld: " .. savedPaycheck .. "$",
            value = "0.00$",
            desc = "Hier siehst du dein Geld was du dir auszahlen lassen kannst!"
        },
    }

    if isJobActive then
        table.insert(MenuElements, #MenuElements + 1,
            {
                label = "Aktuellen Job abbrechen!",
                value = "endjob",
                desc = "Aktuellen Job abbrechen!"
            })
    end


    if not isJobActive then
        if xp >= Config.Cleaning.neededXp then
            table.insert(MenuElements, #MenuElements + 1,
                {
                    label = "Job als Reiniger starten!",
                    value = "startjob",
                    desc = "Hier kannst du einen Job als Reinigungsdienst starten!!"
                })
        else
            table.insert(MenuElements, #MenuElements + 1,
                {
                    label = "Du hast zu wenig XP um den Job zu starten!",
                    value = "startjob",
                    desc = "Du benötigst noch " .. Config.Cleaning.neededXp - xp .. " XP um den Job zu starten!"
                })
        end
    end



    Menu.Open("default", GetCurrentResourceName(), "OpenMenu",

        {
            title = "TURA JOBS",
            subtext = "",
            align = "align",
            elements = MenuElements,
            itemHeight = "2vh",
        },


        function(data, menu)
            if (data.current == "backup") then
                return _G[data.trigger](any, any)
            end
            if data.current.value == "startjob" then
                isJobActive = true;
                StartWork()
                menu.close()
                return
            else
                if data.current.value == "endjob" then
                    isJobActive = false;
                    menu.close()
                    Core.NotifyTip("Du hast deinen Job als beendet!")
                    menu.open()
                    return
                end
            end

            if data.current.info == "param" then
                return menu.close()
            end
        end, function(data, menu)
            menu.close()
        end)
end

function StartWork()
    Core.NotifyTip("Du hast deinen Job als Reiniger gestartet!")
end

Citizen.CreateThread(function()
    local npcCoords = vector3(-748.4995, -1282.0966, 46.0478)

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - npcCoords)

        if getDistance(1) <= 3.0 then
            PromptSetEnabled(promptJobStart, true)
            PromptSetVisible(promptJobStart, true)
        else
            PromptSetEnabled(promptJobStart, false)
            PromptSetVisible(promptJobStart, false)
        end

        Citizen.Wait(1)
    end
end)
