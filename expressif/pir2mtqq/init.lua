-- Designed by rutierut

wifi.setmode(wifi.STATION)
wifi.sta.config("home","thisisnotapassword")

tmr.alarm(1, 1111, 1, function()
    ip = wifi.sta.getip()
	if ip ~= nill then
		print('Conectado, seu ip é:' .. ip)
        tmr.stop(1)
        dofile("pirdev.lua")
	end
end)