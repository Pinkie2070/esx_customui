local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
ESX = exports["es_extended"]:getSharedObject()
local isTalking = false

function(
	TriggerEvent('es:setMoneyDisplay', 0.0)
end)

RegisterNetEvent('talkinges')
AddEventHandler('talkinges', function()
	if not isTalking then
		TriggerServerEvent('syncData', PlayerId())
		SendNUIMessage({action = "setTalking", value = true})	
		isTalking = true
	end
end)--SendNUIMessage({action = "setProximity", value = voip})

RegisterNetEvent('talkingesnot')
AddEventHandler('talkingesnot', function()
	if isTalking then
		TriggerServerEvent('unsyncData', PlayerId())
		SendNUIMessage({action = "setTalking", value = false})
		isTalking = false
	end
end)

RegisterNetEvent('talkingesnotVOIP')
AddEventHandler('talkingesnotVOIP', function(voip)
	SendNUIMessage({action = "setProximity", value = voip})
end)

RegisterNetEvent('syncFacial')
AddEventHandler('syncFacial', function(id)
	local playerLocal = GetPlayerPed(-1)
	local targetPed   = GetPlayerPed(id)

	if GetDistanceBetweenCoords(GetEntityCoords(playerLocal), GetEntityCoords(targetPed), true) < 10.0 then
		local ad = "mp_facial" 
		PlayFacialAnim(GetPlayerPed(id), "mic_chatter", "mp_facial")
	end
end)

RegisterNetEvent('stopsyncFacial')
AddEventHandler('stopsyncFacial', function(id)
	local playerLocal = GetPlayerPed(-1)
	local targetPed   = GetPlayerPed(id)

	if GetDistanceBetweenCoords(GetEntityCoords(playerLocal), GetEntityCoords(targetPed), true) < 10.0 then
		local ad = "facials@gen_female@base" 
		loadAnimDict(ad)
		PlayFacialAnim(GetPlayerPed(id), "mood_normal_1", "facials@gen_male@variations@normal")
	end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

Citizen.CreateThread(function()
	Citizen.Wait(700)
	while true do
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		
		if car ~= 0 and (wasInCar or IsCar(car)) then
		
			wasInCar = true
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			if speedBuffer[2] ~= nil 
			   and not beltOn
			   and GetEntitySpeedVector(car, true).y > 1.0  
			   and speedBuffer[1] > 19
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
			   
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
				
			if IsControlJustReleased(0, 29) then
				beltOn = not beltOn				  
				if beltOn then 
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "belton", 0.6)
				SendNUIMessage({action = "setPasy", value = 'pasy', amount = 100})
				else 
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "beltoff", 0.6)
				SendNUIMessage({action = "setPasy", value = 'pasy', amount = 0}) end 
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
				Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if wasInCar then
			SendNUIMessage({action = "setNewIcons", value = 'pasy'})
			if not beltOn then
				SendNUIMessage({action = "setPasy", value = 'pasy', amount = false})
			end
		else
			local hp = GetEntityHealth(GetPlayerPed(-1))
			SendNUIMessage({action = "setNewIcons", value = 'heart'})
			SendNUIMessage({action = "setPasy", value = 'heart', amount = hp})
		end
	end
end)


RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

RegisterNetEvent('esx_customui:updateWeight')
AddEventHandler('esx_customui:updateWeight', function(weight)
	weightprc = (weight/8000)*100
	SendNUIMessage({action = "updateWeight", weight = weightprc})
end)
