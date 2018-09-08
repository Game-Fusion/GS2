--[[

Official GameStation 2 (GS2) software development
kit (SDK) installer

By Mr_Iron2/TheMrIron2
(C) 2018 Game Fusion
GameStation 2 is (C) 2015-2018 Game Fusion.

NOTE: The GS2 SDK does NOT include the GS2 operating system.
It is recommended that the SDK is installed on top of an existing GS2,
however this is not required. The SDK can also function as an
independent development environment, with no GS2 files necessary.

This SDK is free to be used by anyone.
It is open source and is permissive of modification.
You may modify this as you wish and/or redistribute your modified GS2SDK,
as long as credit is provided.
--]]

local function center(y, string)
  local w, h = term.getSize()
  local x = (w / 2)-(#string / 2)
  term.setCursorPos(x, y)
  print(string)
end

term.setBackgroundColour(colours.blue)
term.setTextColour(colours.white)
term.clear()

center(3, "Welcome to the GameStation 2 (GS2)")
center(4, "Software Development Kit (SDK) installer.")
sleep(2)
center(6, "This will now install the GS2 SDK.")
center(7, "If you do not want the program to continue,")
center(8, "please terminate now (CTRL + T). Otherwise, wait 10 seconds.")
sleep(10)
term.clear()

-- Removing GS2 components to download new ones
if fs.exists("/GS2/APIs/") then
  fs.delete("/GS2/APIs")
else
center(1, "GS2 SDK")
term.setCursorPos(1,2)
term.setBackgroundColour(colours.white)
term.clearLine()
term.setBackgroundColour(colours.blue)

-- Downloading everything
center(4, "Installing necessary APIs... ")
shell.run("pastebin get p7p3R4ze /GS2/APIs/ee")
shell.run("pastebin get WXCnYffd /GS2/APIs/gs")
shell.run("pastebin get gCkEYHDh /GS2/APIs/vu")
write("done!")
sleep()
center(5, "Installing GS2SDK commandline... ")
shell.run("pastebin get yA9ez1Z8")
write("done!")
sleep()
center(6, "Installing Lua pre-processor... ")
shell.run("pastebin get V9x3Sctv /.gs2/sdk/bin/lua-preproc")
write("done!")
sleep(1) -- ensure user sees everything has been completed

-- Finalising
term.clear()
center(7, "GS2SDK installed!")
center(8, "Run "/.gs2/sdk/dev" to enter the GS2SDK commandline.")
sleep(5)

term.setBackgroundColour(colours.black)
term.clear()
term.setCursorPos(1, 1)
