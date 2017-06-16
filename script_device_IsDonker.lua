-- script_coming_home.lua
nowday = tonumber(os.date("%w"))
hour = tonumber(os.date("%H"))

commandArray = {}

if (hour > 7) then
	if (devicechanged['IsDonker'] == 'On') then
		print('Licht aan')

		if (otherdevices['SomeoneHome'] == 'On') then
			print('Avond-verlichting aan')

			commandArray['Scene:Tv avond']='On'
			commandArray['Scene:Buitenverlichting']='On'
		else
			print('Niemand thuis, dus sommige verlichting aan')
			commandArray['TV Licht']='On'
			commandArray['Garage buitenlamp']='On'
			commandArray['Buitenlamp huis']='On'
		end

	elseif (devicechanged['IsDonker'] == 'Off') then
		commandArray['Scene:Tv avond']='Off'
		commandArray['Scene:Buitenverlichting']='Off'
		
		print('Lampen uit')

	end
end

return commandArray
