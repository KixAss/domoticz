----------------------------------------------------------------------------------------------------------------
-- IsItGonnaRain( int minutesinfuture)
-- returns: int avarage rainfall for the next minutesinfuture
--
-- Function to get rain prediction from Buienradar.nl (dutch)
-- 
-- http://gratisweerdata.buienradar.nl/#Buienradar You may use their free service for non-commercial purposes. 
-- 
-- Written in LUA by Hans van der Heijden (h4nsie @ gmail.com)
-- Spring 2015
-- 28-03-2015 v0.3 bug: quotes around url added.
-- 27-03-2015 v0.2 return value is now average for next time
-- 26-03-2015 v0.1 Initial release
-- todo: some error checking on http and file handling (tmp file)
----------------------------------------------------------------------------------------------------------------
function IsItGonnaRain( minutesinfuture )
-- config ---------------------------------------------------------
  lat='52.204143'   -- example lat/lon for Utrecht
  lon='5.9705981'
  debug=false
  tempfilename = '/var/tmp/rain.tmp' -- can be anywhere writeable
-- config ---------------------------------------------------------
        
  url='http://gadgets.buienradar.nl/data/raintext?lat='..lat..'&lon='..lon
  if debug then print(url) end
  read = os.execute('curl -s -o '..tempfilename..' "'..url..'"')
  file = io.open(tempfilename, "r")
  totalrain=0
  rainlines=0
  -- now analyse the received lines, format is like 000|15:30 per line.
  while true do 
     line = file:read("*line")
     if not line then break end
     if debug then print('Line:'..line) end
     linetime=string.sub(tostring(line), 5, 9)
     if debug then print('Linetime: '..linetime) end
        
        -- Linetime2 holds the full date calculated from the time on a line
        linetime2 = os.time{year=os.date('%Y'), month=os.date('%m'), day=os.date('%d'), hour=string.sub(linetime,1,2), min=string.sub(linetime,4,5), sec=os.date('%S')}
        difference = os.difftime (linetime2,os.time())
  
     -- When a line entry has a time in the future AND is in the given range, then totalize the rainfall
     if ((difference > 0) and (difference<=minutesinfuture*60)) then
        if debug then print('Line in time range found') end
        rain=tonumber(string.sub(tostring(line), 0, 3))
        totalrain = totalrain+rain
        rainlines=rainlines+1
        if debug then print('Rain in timerange: '..rain) end
        if debug then print('Total rain now: '..totalrain) end
     end
  
  end
  file:close()
  
  -- Returned value is average rain fall for next time
  -- 0 is no rain, 255 is very heavy rain
  -- When needed, mm/h is calculated by 10^((value -109)/32) (example: 77 = 0.1 mm/hour)
  averagerain=totalrain/rainlines
  
return(averagerain)
end

----- REGEN ------
minuten=30
regen = IsItGonnaRain(minuten)
if regen > 0 then
  print('Regen verwacht: '..regen..' binnen '..minuten..' minuten.')
end

commandArray = {}

if regen > 70 and otherdevices['Rain expected']=='Off' and otherdevices['SomeoneHome']=='On' then
  commandArray['SendNotification']='NijeHus#Regen verwacht'
  commandArray['Rain expected']='On'
  print('notif gestuurd')
end
if regen == 0 and otherdevices['Rain expected']=='On' then
  commandArray['SendNotification']='NijeHus#Geen regen meer verwacht'
  commandArray['Rain expected']='Off'
end

return commandArray
