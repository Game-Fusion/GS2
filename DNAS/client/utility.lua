os.loadAPI("/GS2/APIs/gs")
-- It is assumed this is running on a GS2 or GS2 devkit

local function topmenu()
  gs.clrBg("blue")
  gs.setBg("white")
  gs.setTxt("blue")
  gs.clrLine(2)
  gs.clrLine(3)
  gs.clrLine(4)
  gs.center(3,"DNAS Utility")
end
 
topmenu()

-- Welcome section
gs.clrLine(7)
gs.clrLine(8)
gs.clrLine(9)
gs.clrLine(10)
gs.clrLine(11)
gs.center(8,"Welcome to the DNAS Utility!")
gs.center(9,"Here, we will test your connection and attempt")
gs.center(10,"to connect to the DNAS servers.")
ee.sleep(1.75)

-- Modem check
if not peripheral.find("modem") then
  topmenu()
  gs.clrLine(7)
  gs.clrLine(8)
  gs.clrLine(9)
  gs.center(8,"There is no modem attached!")
  gs.center(9,"Please attach a modem, then retry.")
  ee.sleep(2)
  error("No modem attached")
  
elseif peripheral.find("modem") then
  -- work as normal
  topmenu()
  gs.line(7)
  gs.line(8)
  gs.line(9)
  gs.line(10)
  gs.center(8,"Attempting Connection...")
  ee.sleep(1)
  local modem = peripheral.find("modem")
  modem.open(661)
  modem.transmit(661, 661, {sType = "status"})
  local t = ee.startTimer(3)
  
while true do
  local e = {os.pullEvent()}
  if e[1] == "modem_message" then
  if e[3] == 661 then
    if type(e[5]) == "table" then
      if e[5].sType then
        if e[5].sType == "status" then
          if e[5].sContents == "Offline" then
          topmenu()
          gs.clrLine(7)
          gs.clrLine(8)
          gs.clrLine(9)
          gs.clrLine(10)
          gs.center(8,"Connection Failed:")
          gs.center(9,"The DNAS servers are currently offline.")
          ee.sleep(3)
          --ee.shRun("/GS2/Browser")

elseif e[5].sContents == "Shutdown" then
  topmenu()
  gs.clrLine(7)
  gs.clrLine(8)
  gs.clrLine(9)
  gs.clrLine(10)
  gs.center(8,"Connection Failed:")
  gs.center(9,"DNAS has been terminated.")
  ee.sleep(3)
  --ee.shRun("/GS2/Browser")
    
elseif e[5].sContents == "Online" then
  topmenu()
  gs.clrLine(7)
  gs.clrLine(8)
  gs.clrLine(9)
  gs.clrLine(10)
  gs.center(8,"Connection Successful!")
  gs.center(9,"DNAS systems online.")
  ee.sleep(3)
  --ee.shRun("/GS2/Browser")
  end
end
end
end
end

elseif e[1] == "timer" then topmenu()
  gs.clrLine(7)
  gs.clrLine(8)
  gs.clrLine(9)
  gs.clrLine(10)
  gs.center(8,"Connection Failed:")
  gs.center(9,"The DNAS servers did not respond.")
  ee.sleep(2)
  --ee.shRun("/GS2/Browser")
end
end
end
