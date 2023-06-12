local reactorSide = "back"  -- The side of the reactor where the modem is connected
local monitorSide = "left"  -- The side of the monitor where it is connected

local highHeatThreshold = 0.40  -- The threshold at which the reactor should be shut off (95% of max case heat)
local reactorShutdown = false  -- Flag to track whether the reactor has been shut down

-- Set up the monitor
local monitor = peripheral.wrap(monitorSide)
monitor.clear()

while true do
  local caseHeat = peripheral.call(reactorSide, "getCaseHeat")
  local maxCaseHeat = peripheral.call(reactorSide, "getMaxCaseHeat")
  local heatPercentage = caseHeat / maxCaseHeat

  -- Display temperature on monitor
  monitor.setCursorPos(1, 1)
  monitor.clearLine()
  monitor.write("Reactor Temperature: " .. tostring(caseHeat) .. "C")

  -- Change color based on temperature
  if heatPercentage >= highHeatThreshold and not reactorShutdown then
    redstone.setOutput(reactorSide, true)  -- Turns off the reactor
    reactorShutdown = true
    print("Reactor shutting down due to high heat!")
    monitor.setBackgroundColor(colors.red)  -- Set background color to red
  elseif heatPercentage < highHeatThreshold and reactorShutdown then
    redstone.setOutput(reactorSide, false)  -- Turns on the reactor
    reactorShutdown = false
    print("Reactor has cooled down. Restarting reactor...")
    monitor.setBackgroundColor(colors.green)  -- Set background color to green
  else
    monitor.setBackgroundColor(colors.black)  -- Set background color to black
  end

  sleep(1)  -- Pauses the program for 1 second before repeating the loop
end