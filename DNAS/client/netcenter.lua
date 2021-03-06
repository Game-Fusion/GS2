-- Add center in case there's no existing center function

local function center(y,str)
  local w,h = term.getSize()
  local x = (w/2)-(#str/2)
  term.setCursorPos(x,y)
  print(str)
end

local modem = peripheral.find("modem")
local openModem = false

for k,v in pairs({"right", "left", "top", "bottom", "front", "back"}) do
  if peripheral.getType(v) == "modem" then
    rednet.open(v)
    local openModem = true
end
 
local function renderNetCentre()
  term.setBackgroundColour(colours.green)
  term.setTextColour(colours.white)
  center(8, "  Network Centre  ")
  term.setBackgroundColour(colours.white)
  term.setTextColour(colours.green)
  center(9, "      Profile     ")
  center(10, "    Power Off     ")
  center(11, "    Disconnect    ")
end
 
while true do
  renderNetCentre()
  local evt, button, x, y = os.pullEvent("mouse_click")
    if y == 9 then
    shell.run("/dnas/profile")
    
    elseif y == 10 then
      term.clear()
      center(8,"Shutting Down...")
      sleep(1)
      os.shutdown()
      
    elseif y == 11 then
      modem.open(30000)
      modem.transmit(30000, 30000, {sType = "disconnect"})
      error("Disconnected")
   
   end
 end
end
