local display = true
local onlineplayer = true
local displayFps = true
local textString = nil
local rgb = {r = 255, g = 153, b = 102}

local prevframes = GetFrameCount()
local fps = -1

local name = GetPlayerName(PlayerId())
local id = GetPlayerServerId(PlayerId())
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local totalplayers = 0
		for i = 0, 256 do
		    if NetworkIsPlayerActive(i) then
		        totalplayers = totalplayers+1
		    end
		end
		totalplayers_hud(0.500, 0.49, 1.0,1.0,0.40, "~w~Players Online:~r~ "..totalplayers.. "/64", 255, 255, 255, 255)
	end
end)

function totalplayers_hud(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
	SetTextColour( 0,0,0, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end



Citizen.CreateThread(function()
	while true do
		Wait(1)

		if display == true then
			local ped = GetPlayerPed()
			local health = GetEntityHealth(ped)
			local vehicle = GetVehiclePedIsIn(ped, false)
			local speed = GetEntitySpeed(vehicle)
			local kmh = (speed * 3.6)
			local mph = math.ceil(speed * 2.236936)
			local speed = mph
			local gameversion = GetGameVersion()
			local vehfuel = GetVehicleFuelLevel(vehicle)
			local vehgear = GetVehicleCurrentGear(vehicle)
			health = GetEntityHealth(ped) / 2
			CalculateTimeToDisplay()
			textString = "~w~FPS:~r~ " .. fps .. "~g~~n~" .. "~w~Your ID:" .. " ~r~" .. id .. "~n~" .. "~w~Health:" .. " ~r~" .. health .. "~n~"  .. "~w~Speed:" .. " ~r~" .. mph .. "~n~"  .. "~w~Vehicle Fuel:" .. " ~r~" .. vehfuel .. "~n~"  .. "~w~Game Version:" .. " ~r~" .. gameversion .. "~n~" 
		end

		SetTextFont(4)
		SetTextProportional(1)
		SetTextScale(0.40, 0.40)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextRightJustify(false)
		SetTextWrap(0.1,0.93)
		SetTextEntry("STRING")

		AddTextComponentString(textString)
		DrawText(0.001, 0.02)

	end
end)

function round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) or not NetworkIsSessionStarted() do
		Citizen.Wait(250)
			prevframes = GetFrameCount()
      prevtime = GetGameTimer()
		end
		while true do
          curtime = GetGameTimer()
	        curframes = GetFrameCount()

	    if((curtime - prevtime) > 1000) then
		    fps = (curframes - prevframes) - 1
		    prevtime = curtime
		    prevframes = curframes
	    end

      if IsGameplayCamRendering() and fps >= 0 then
				PrintText(fps .. " FPS")
      end
      Citizen.Wait(1)
  end
end)

function PrintText(text)
	SetTextEntry("STRING")
end
