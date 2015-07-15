m= mqtt.Client("PIR",60,"","")
m:on("connect", function(con) print ("connected") end)
m:on("offline", function(con) print ("offline") end)

m:lwt("/pirs/offline","GartenPIR",0,0)
m:connect("85.119.83.194",1883,0, function(conn) 
	print("connecteded") 
	m:publish("/sensor/pir","Estou online",1,1, function(conn) print("sent") end)
end)

function triggered(level)
     if (level==1)
          then m:publish("/sensor/pir","Pega Ladrão!!!",1,1, function(conn) print("sent") end)
     else
          m:publish("/sensor/pir","Já passou mais fica esperto!",1,1, function(conn) print("sent") end)
     end
end

gpio.mode(7, gpio.INT, gpio.FLOAT)
gpio.trig(7,"both",triggered)