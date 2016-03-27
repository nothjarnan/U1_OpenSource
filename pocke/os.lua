os.pullEvent = os.pullEventRaw
if not fs.exists("startup") then
  os.loadAPI("pocke/api/edge")
  os.loadAPI("pocke/api/settings")
end
modem = peripheral.wrap("back")
state = "locked"
version = "Pre160311-2302"
connecting = false
quit = false
defaultcolor = colors.gray
brighttext = colors.white
darktext = colors.black
windowcolor = colors.lightGray
tasks = {}
knownstates = "home, locked, app"
function lang(l)
  edge.log("Language: "..l)
  if l == "en-US" then
    lang_boot_color = colors.red
    lang_shutdown_msg = "Saving."
    lang_back = "<Back"
    lang_setting = "<Back | Settings"
    lang_setting_language = "Language:"
    lang_setting_translation = "*Translation is inaccurate"
    lang_setting_timefor = "Time Format:"
    lang_setting_freespace = "Free space: "..fs.getFreeSpace("/") /1000 .."KB"
    lang_apps = "Apps"
    lang_apps_sett = "Sett"
    lang_devicelocked = "device locked"
    lang_os_by = "U1 by Nothy"
    lang_os_update = "Update U1"
    lang_os_update_inprog = "Update in progress!"
    lang_os_update_failed = "Update failed."
  end
  if l == "sv-SE" then
    lang_boot_color = colors.blue
    lang_shutdown_msg = "Sparar."
    lang_back = "<Tillaka"
    lang_setting = "<Tillbaka | Inställningar"
    lang_setting_language = "Språk:"
    lang_setting_translation = "*Översättn. är fel."
    lang_setting_timefor = "Tidsformat:"
    lang_setting_freespace = "Free space: "..fs.getFreeSpace("/") /1000 .."KB"
    lang_apps = "Appar"
    lang_apps_sett = "Inst"
    lang_devicelocked = "enhet låst"
    lang_os_by = "U1, gjord av Nothy"
    lang_os_update = "Uppdatera U1"
    lang_os_update_inprog = "Uppdatering pågår!"
    lang_os_update_failed = "Uppdatering misslyckades."
  end
  if l == "dn-DK" then
    lang_boot_color = colors.green
    lang_shutdown_msg = "Gem indstillinger."
    lang_back = "<Tilbage"
    lang_setting = "<Tilbage | Indstillinger"
    lang_setting_language = "Sprog:"
    lang_setting_translation = "*Oversættelsen er forkert"
    lang_setting_timefor = ""
    lang_setting_freespace = "Free space: "..fs.getFreeSpace("/") /1000 .."KB"
    lang_apps = "Apps"
    lang_apps_sett = "Inds"
    lang_devicelocked = "enhed låst"
    lang_os_by = "U1 lavet af Nothy"
    lang_os_update = "Opdater U1"
    lang_os_update_inprog ="Opdaterer!"
    lang_os_update_failed = ":("
  end
end
download = function(url, file)
    edge.log("Downloading "..file.." from "..url)
    --print("Downloading "..file)
    fdl = http.get(url)
    if not fdl then
      connecting = "error"
    end
    local f = fs.open(file,"w")
    f.write(fdl.readAll())
    f.close()
end
notifhandler = function()
  while(true) do
    if quit == true then
      edge.render(1,1,1,1,defaultcolor,defaultcolor,"?s",colors.red)
    end
    if fs.getFreeSpace("/") <= 10000 then
      if state == "home" then
        edge.render(3,1,3,1,defaultcolor,defaultcolor,"!",colors.orange)
      end
      if state == "locked" then
        edge.render(3,1,3,1,defaultcolor,defaultcolor,"!",colors.orange)
      end
    end
    if fs.getFreeSpace("/") <= 5600 then
      if state == "home" then
        edge.render(3,1,3,1,defaultcolor,defaultcolor,"!",colors.red)
      end
      if state == "locked" then
        edge.render(3,1,3,1,defaultcolor,defaultcolor,"!",colors.red)
      end
    end
    if connecting == true then
      if state == "home" then
        edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.green)
        sleep(0.5)
        edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.black)
        sleep(0.5)
        edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.green)
        sleep(0.5)
        edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.black)
        sleep(0.5)
      end
      if state == "locked" then
        edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.green)
        sleep(0.5)
        edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.black)
        sleep(0.5)
        edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.green)
        sleep(0.5)
        edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.black)
        sleep(0.5)
      end
    elseif connecting == "error" then
      if state == "home" then
        edge.render(1,1,2,1,defaultcolor,defaultcolor,"@x",colors.red)
        sleep(0.5)
      end
      if state == "locked" then
        edge.render(1,1,2,1,defaultcolor,defaultcolor,"@x",colors.red)
        sleep(0.5)
      end
    end
    if state == "home" and connecting == false then
      edge.render(1,1,2,1,defaultcolor,defaultcolor,"@",colors.black)
      sleep(0.5)
    elseif state == "locked" and connecting == false then
      edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.black)
      sleep(0.5)
    end
  end
end

update = function()
  connecting = true
  if fs.exists("startup") then
    download("https://www.dropbox.com/s/k15800l0dkhirmo/startup?dl=1","startup")
  end
  download("https://www.dropbox.com/s/6exvxj3l60vs8r5/os.lua?dl=1","pocke/os.lua")
  download("https://www.dropbox.com/s/hbmt6bf1tjl8z4z/settings?dl=1","pocke/api/settings")
  --download("http://pastebin.com/raw/RYKHrp1d","test")
  download("https://www.dropbox.com/s/rxxg8cxhoe83h2o/edge?dl=1","pocke/api/edge")
  download("https://www.dropbox.com/s/48ca6yjrsecsnd7/crash?dl=1","pocke/user/crash")
  download("https://www.dropbox.com/s/i18p42ph8blylfm/settings.cfg?dl=1","pocke/settings.cfg")
  download("https://www.dropbox.com/s/ed57owqqjp53l57/installer?dl=1","pocke/user/updater")
  if connecting == "error" then
    edge.log("Update failed.")
  else
    connecting = false
  end

end
time = function()
  while(true) do

    if state == "locked" then
      term.setTextColor(colors.black)
      edge.cprint(edge.time(),8)
      --edge.cprint("Day "..os.day(),9)
      edge.cprint(lang_devicelocked,17)
      sleep(1)
    end
    if state == "home" then
      term.setTextColor(colors.black)
      edge.cprint(edge.time(),1)
      sleep(0.05)
    end
    if quit then
      edge.xprint("?s",1,1,colors.red)
      edge.xprint("!",4,1,colors.red)
      sleep(5)
      edge.log("U1 HAS CRASHED:")
      os.shutdown()
    end
    if state == "shutdown" then
      os.shutdown()
    end
    if state == "crash" then
      shell.run("pocke/user/crash")
      sleep(1)
    end
    if not state == string.find(state,knownstates) then
      quit = true
    end
    --edge.xprint(quit,1,20,colors.red)
  end
end
home = function()
  state = "home"
  os.run({},"rom/programs/clear")
  -- APP DRAWER ICON
  term.setTextColor(colors.black)
  edge.cprint("===",18)
  edge.render(1,1,1,1,defaultcolor,defaultcolor,"@",colors.black)

  while(true) do
    local event, button, x, y = os.pullEvent("mouse_click")
    if x >= 24 and x <= 26 and y == 18 then
      --state = "home-menu"
      edge.render(9,2,43,19,colors.lightGray,defaultcolor,lang_back,darktext)
      edge.render(12,4,15,4,colors.gray,defaultcolor,"",colors.black)
      edge.render(13,3,14,5,colors.gray,defaultcolor,"",colors.black)
      edge.render(12,7,16,7,windowcolor,defaultcolor,lang_apps_sett,darktext)
      while(true) do
        local event, button, x, y = os.pullEvent("mouse_click")
        if x >= 9 and x <= 14 and y == 2 then
          home()
        end
        if x >= 12 and x <= 15 and y >= 3 and y <= 6 then
          --state = "home-settings"
          edge.render(9,2,43,19,windowcolor,defaultcolor,lang_setting,colors.white)
          edge.render(10,17,10,17,windowcolor,defaultcolor,version,colors.white)
          edge.render(10,4,26,4,windowcolor,defaultcolor,lang_setting_language,colors.white)
          edge.render(10,5,26,5,windowcolor,defaultcolor,"English | Svenska | Dansk",colors.white)
          edge.render(10,6,26,6,windowcolor,defaultcolor,lang_setting_translation,colors.red)
          edge.render(10,7,26,7,windowcolor,defaultcolor,lang_os_update,colors.white)
          edge.render(10,16,26,16,windowcolor,defaultcolor,lang_setting_freespace,colors.white)
          if connecting then
            if not connecting == true then
              edge.render(10,7,26,7,windowcolor,defaultcolor,lang_os_update_failed,colors.red)
            else
              edge.render(10,7,26,7,windowcolor,defaultcolor,lang_os_update_inprog,colors.green)
            end
          end
          edge.render(10,18,26,18,windowcolor,defaultcolor,lang_os_by,colors.white)
          while(true) do
            local event, button, x, y = os.pullEvent("mouse_click")
            if x >= 9 and x <= 15 and y == 2 then
              home()
            end
            if x >= 10 and x <= 18 and y == 5 then
              settings.setVariable("pocke/settings.cfg","language","en-US")
              lang(settings.getVariable("pocke/settings.cfg","language"))
              --os.reboot()
            end
            if x >= 20 and x <= 27 and y == 5 then
              settings.setVariable("pocke/settings.cfg","language","sv-SE")
              lang(settings.getVariable("pocke/settings.cfg","language"))
              --os.reboot()
            end
            if x >= 30 and x <= 35 and y == 5 then
              settings.setVariable("pocke/settings.cfg","language","dn-DK")
              lang(settings.getVariable("pocke/settings.cfg","language"))
              --os.reboot()
            end
            if x >= 10 and x <= 20 and y == 7 then
              edge.render(2,7,26,7,colors.gray,defaultcolor,lang_os_update_inprog, colors.green)
              parallel.waitForAll(update,home,notifhandler)
            end
          end
        end
      end
    end
  end
end
-- funkar det att stå? nope. nope fuck that. sitting is da shit.
keydetection = function()
  while(true) do
    local event, key = os.pullEvent("key")
    if key == keys.tab then
      shell.run("clear")
      edge.log("Device is now locked.")
      state = "locked"
      while(state == "locked") do
        local event, button, x, y = os.pullEvent("mouse_click")
        if button == 1 then
          state = "home"
          parallel.waitForAll(time,home,keydetection)
        end
      end
    end
    if key == keys.f1 then
      term.setBackgroundColor(colors.gray)
      term.setTextColor(colors.black)
      os.run({},"rom/programs/clear")
      edge.log("U1 is now shutting down.")
      edge.xprint(lang_shutdown_msg, 13 - string.len(lang_shutdown_msg) / 2 + 1, 10,lang_boot_color)
      sleep(3)
      os.shutdown()
    end
  end
end

lockscreen = function()
  shell.run("clear")
  if not http then
    edge.render(1,1,10,1,defaultcolor,defaultcolor,"@H",colors.red)
  else
    edge.render(1,1,10,1,defaultcolor,defaultcolor,"@",colors.black)
  end
  while(state == "locked") do
    local event, button, x, y = os.pullEvent("mouse_click")
    if button == 1 then
      state = "home"
      parallel.waitForAll(home,keydetection)
    end
  end
end

function start()
  edge.log("Version: "..version)
  term.setBackgroundColor(defaultcolor)
  term.setTextColor(colors.black)
  os.run({},"rom/programs/clear")
  term.setTextColor(lang_boot_color)
  edge.cprint("U1",8)
  term.setTextColor(colors.black)
  sleep(5)
  os.run({},"rom/programs/clear")
  edge.log("Initializing MT")
  if state == "locked" then
    parallel.waitForAll(lockscreen,time,notifhandler)
  end
end
edge.log("pocke/os.lua: Boot successful")
lang(settings.getVariable("pocke/settings.cfg","language"))
--edge.render(27,1,1,1,colors.black,colors.black,"test",colors.white)
edge.log("pocke/os.lua: Starting U1")
local logSize = fs.getSize("pocke/log.txt")
if fs.getSize("pocke/log.txt") >= 16000 then
  file = fs.open("pocke/log.txt","w")
  file.write("")
  file.close()
  edge.log("pocke/os.lua: Log size exceeded 16KB ("..logSize.." byte), Cleared.")
end
rednet.broadcast(tostring(math.random(0,15018))..": U1 Broadcast")
print("U1 is discontinued until further notice.")
sleep(3)
start()
