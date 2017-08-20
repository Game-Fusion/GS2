function center(y,string)
  local w,h = term.getSize()
  local x = (w/2)-(#string/2)
  term.setCursorPos(x,y)
  print(string)
end

local function clr()
  if term.isColour() then
  term.setTextColour(colours.white)
  term.setBackgroundColour(colours.red)
  else
  term.setTextColour(colours.black)
  term.setBackgroundColour(colours.white)
  end
end
  

function centerSlow(y,string)
  local w,h = term.getSize()
  local x = (w/2)-(#string/2)
  term.setCursorPos(x,y)
  textutils.slowPrint(string)
end

if peripheral.find("monitor") then shell.run("monitor right startup")
  shell.run("monitor left startup")
  shell.run("monitor top startup")
  shell.run("monitor bottom startup")
  shell.run("monitor front startup")
  shell.run("monitor back startup")
          
else 
  clr()
  term.clear()
  centerSlow(9,"Game Fusion Presents...")
  sleep(1)
  term.clear()
  centerSlow(8,"GameStation 2.")
  sleep(1)
  center(10,"Real power to real players.")
  sleep(1.5)
  shell.run("/GS2/Browser")
end
