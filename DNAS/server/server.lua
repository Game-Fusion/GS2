--[[
DNAS master server

Credits:
Mr_Iron2: Concept, client utility
Gonow32: Modem code

Note: since this is a server program, it is NOT
reliant on the GS2 APIs and is NOT designed to be
run on a real GS2. It will work on any computer.
--]]

term.clear()
term.setCursorPos(1,1)
print("DNAS Server")

local online = true
 
if online == true then
  print("Current Status: Online")
elseif online == false then
  print("Current Status: Unavailable")
else
  print("Current Status: Shut Down")
end
 
local modem = peripheral.find("modem")
modem.open(6)
 
while true do
  local e = {os.pullEvent()}
  if e[1] == "modem_message" then
    if e[3] == 661 then
      if type(e[5]) == "table" then
        if e[5].sType then
          if e[5].sType == "status" then
            if online == true then
              modem.transmit(661, 661, {sType = "status", sContents = "Online"})
            elseif online == false then
              modem.transmit(661, 661, {sType = "status", sContents = "Shutdown"})
            else
              modem.transmit(661, 661, {sType = "status", sContents = "Offline"})
          end
        end
      end
    end
  end
end
