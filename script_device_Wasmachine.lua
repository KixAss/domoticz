-- script_coming_home.lua
nowday = tonumber(os.date("%w"))
hour = tonumber(os.date("%H"))

commandArray = {}

if (devicechanged['Wasmachine']) then
	if (tonumber(devicechanged['Wasmachine']) > 50) then
		if (otherdevices['WasAan'] == 'Off') then
			print('Wasmachine is aan')
			commandArray['WasAan']='On'
		end

	elseif (tonumber(devicechanged['Wasmachine']) <= 2) then
		if (otherdevices['WasAan'] == 'On') then
			commandArray['SendNotification'] = 'NijeHus#De was is klaar!'
			commandArray['WasAan']='Off'
			print('Was is klaar')
		end
	end
end

return commandArray
