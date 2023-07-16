SaveBildNum = nil;
SaveBildisStart = false;
-- Сохраняет текущие настройки в пресет
function save_binding_key(num)
    SaveBindingPresetsLocal = SaveBindingPresetsLocal or {}
    num = num or #SaveBindingPresetsLocal + 1
    SaveBindingPresetsLocal[num] = {}
    SaveBindingPresetsLocal[num]["link"] = {}
    local b = {}
    for i = 1, GetNumBindings() do
        local a = { GetBinding(i) }
        if (#a > 2) then
            -- SaveBindingPresetsLocal[num]["link"][i] = {GetBinding(i)}
            table.insert(SaveBindingPresetsLocal[num]["link"], a)
        end
        table.insert(b, a)
        SaveBindingBackup = SaveBindingBackup or b
    end
    print("Сохранён пресет №" .. num)
end

-- Загружает настройки из пресета
function load_binding_key(num)
    SaveBindingPresetsLocal = SaveBindingPresetsLocal or {}
    num = num or 1
    -- print("===== "..num)
    -- local clr = {}
    for i = 1, GetNumBindings() do
        local clr = { GetBinding(i) }
        -- print(i.." test "..#clr)
        for ii = 3, #clr do
            if (clr[ii] ~= nil) then
                -- print(clr[i][ii])
                SetBinding(clr[ii])
            end
        end
    end

    if (num <= #SaveBindingPresetsLocal) then
        for i = 1, #SaveBindingPresetsLocal[num]["link"] do
            for ii = 3, #SaveBindingPresetsLocal[num]["link"][i] do
                if (SaveBindingPresetsLocal[num]["link"][i][ii] ~= nil) then
                    -- print(SaveBindingPresetsLocal[num]["link"][i][ii])
                    -- SetBinding(SaveBindingPresetsLocal[num]["link"][i][ii])
                    SetBinding(SaveBindingPresetsLocal[num]["link"][i][ii], SaveBindingPresetsLocal[num]["link"][i][1])
                end
            end
        end
        print("Загружен пресет №" .. num)
        SaveBindings(2)
    else
        print("пресета №" .. num .. " не существует, их всего " .. #SaveBindingPresetsLocal)
    end
end

-- Устанавливает линк пресета и спека
function spec_binding_key(num)
    SaveBindingConfigLocal = SaveBindingConfigLocal or {}
    SaveBindingConfigLocal["links"] = SaveBindingConfigLocal["links"] or {}
    SaveBindingConfigLocal["links"][GetSpecialization()] = num
    print("Спек " .. GetSpecialization() .. " слинкован с пресетом кнопок №" .. num)
end

-- Удаляет линк пресета и спека
function spec_binding_key_remove()
    SaveBindingConfigLocal = SaveBindingConfigLocal or {}
    SaveBindingConfigLocal["links"] = SaveBindingConfigLocal["links"] or {}
    print("Спек " ..
        GetSpecialization() .. " отвязан от пресета кнопок №" ..
        SaveBindingConfigLocal["links"][GetSpecialization()])
    table.remove(SaveBindingConfigLocal["links"][GetSpecialization()])
end

--
function SaveBindingEvents()
    if(SaveBildisStart==true)then
        SaveBildNum = SaveBildNum or GetSpecialization()
        if (SaveBildNum ~= GetSpecialization()) then
            print('Вы сменили спек с ' .. SaveBildNum .. ' на ' .. GetSpecialization())
            save_binding_key(SaveBildNum)
            SaveBildNum = GetSpecialization()

            SaveBindingConfigLocal = SaveBindingConfigLocal or {}
            SaveBindingConfigLocal["links"] = SaveBindingConfigLocal["links"] or {}
            SaveBindingPresetsLocal = SaveBindingPresetsLocal or {}
            for i=1, 4 do
                if (SaveBindingPresetsLocal[i] == nil) then
                    save_binding_key(i); 
                    SaveBindingConfigLocal["links"][i] = i; 
                end
            end

            if (SaveBindingConfigLocal["links"][GetSpecialization()]) then
                print("Текущий спек " .. GetSpecialization())
                load_binding_key(SaveBindingConfigLocal["links"][GetSpecialization()])
            else
                print("спек не найден?")
            end
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_TALENT_UPDATE")
f:SetScript("OnEvent", function(self, event, ...)
    SaveBindingEvents()
end)

--[[ local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, AddonName, isReload)
    if(AddonName == "!SaveBinding")then
    end
end) ]]

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, AddonName, isReload)
        SaveBildNum = GetSpecialization()
        SaveBildisStart = true
        SaveBindingConfigLocal = SaveBindingConfigLocal or {}
        SaveBindingConfigLocal["links"] = SaveBindingConfigLocal["links"] or {}
        SaveBindingPresetsLocal = SaveBindingPresetsLocal or {}
        for i=1, 4 do
            if (SaveBindingPresetsLocal[i] == nil) then
                save_binding_key(i); 
                SaveBindingConfigLocal["links"][i] = i; 
            end
        end
        local a = {GetBuildInfo()}
        SaveBindingConfigLocal["versionWOW"] = a[4]
        -- SaveBindingEvents()
end)
