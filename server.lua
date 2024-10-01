local sentAlerts = {}

CreateThread(function()
    while true do
        PerformHttpRequest("https://redalert.me/alerts", function(err, text, headers) 
            if text then
                newJson = json.decode(text)
                local object = {}
                for k, v in pairs(newJson) do
                    year, month, day, hour, min, sec = os.date('%Y-%m-%d %H:%M:%S', v['date']):match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
                    if os.time() - os.time({day=day, month=month, year=year, hour=hour, min=min, sec=sec}) <= 60 * 2.5 then
                        if not sentAlerts[v['id']] then 
                            object[k] = v
                            sentAlerts[v['id']] = true 
                        end
                    end
                end

                if next(object) ~= nil then 
                    TriggerClientEvent('newAlert', -1, object)
                end
            end
        end)

        Wait(3000)
    end
end)

RegisterCommand('testalert', function(source, args, rawCommand)
    local alertObjects = {
        { id = "alert", area = "אזור תעשייה רמת הגולן " },
        { id = "alert", area = "בדיקה" },

    }

    TriggerClientEvent('newAlert', -1, alertObjects)
end, false)
