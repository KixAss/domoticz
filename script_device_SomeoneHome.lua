-- script_coming_home.lua
nowday = tonumber(os.date("%w"))
hour = tonumber(os.date("%H"))

commandArray = {}

if (devicechanged['SomeoneHome'] == 'On') then
	print('Er is iemand thuis gekomen')

	if (hour >= 20) then
		commandArray['OpenURL'] = '192.168.192.10:8080/json.htm?type=setused&idx=9&name=Thermostaat%20Setpoint&setpoint=20.5&protected=false&used=true'
		print('Temperatuur ingesteld op 20.5')
		
	elseif (hour >= 17) then
		commandArray['OpenURL'] = '192.168.192.10:8080/json.htm?type=setused&idx=9&name=Thermostaat%20Setpoint&setpoint=20&protected=false&used=true'
		print('Temperatuur ingesteld op 20')

	elseif (hour > 10) then
		commandArray['OpenURL'] = '192.168.192.10:8080/json.htm?type=setused&idx=9&name=Thermostaat%20Setpoint&setpoint=18.5&protected=false&used=true'
		print('Temperatuur ingesteld op 18.5')

	end

	if (otherdevices['IsDonker'] == 'On') then
		print('Verlichting aan')

		commandArray['Scene:Tv avond']='On'
		commandArray['Scene:Buitenverlichting']='On'
	end

elseif (devicechanged['SomeoneHome'] == 'Off') then
	print('Er is niemand meer thuis')

	commandArray['OpenURL'] = '192.168.192.10:8080/json.htm?type=setused&idx=9&name=Thermostaat%20Setpoint&setpoint=15&protected=false&used=true'
	print('Temperatuur ingesteld op 15')

	if (otherdevices['IsDonker'] == 'On') then
		commandArray['Dressoir']='Off'
		commandArray['Veranda verlichting']='Off'

		print('Overbodige lampen uit')
	end


end

return commandArray
