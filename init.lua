-- =================================================================
-- Hammerspoon Configuration File
-- File: ~/.hammerspoon/init.lua
-- =================================================================

-- 1. Define the Hyper Key
-- This combines Control, Alt (Option), Shift, and Command (GUI)
local hyper = {"ctrl", "alt", "shift", "cmd"}

-- 2. Define a hotkey to reload the config with a notification
hs.hotkey.bind(hyper, "r", function()
  hs.reload()
  hs.notify.new({title="Hammerspoon", informativeText="Reloaded"}):send()
end)

-- =================================================================
-- WINDOW MANAGEMENT - TILING
-- =================================================================

-- Define a reusable function to tile the current window
local function tile_window(direction)
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local screen = win:screen()
  local screen_frame = screen:frame()
  local new_frame = {}
  local win_frame = win:frame()

  if direction == "left" then
    new_frame = {x = screen_frame.x, y = screen_frame.y, w = screen_frame.w / 3, h = screen_frame.h}
  elseif direction == "right" then
    new_frame = {x = screen_frame.x + (screen_frame.w * 2 / 3), y = screen_frame.y, w = screen_frame.w / 3, h = screen_frame.h}
  elseif direction == "up" then
    new_frame = {x = screen_frame.x + (screen_frame.w / 3), y = screen_frame.y, w = screen_frame.w / 3, h = screen_frame.h}
  elseif direction == "down" then
    local is_on_left_side = win_frame.x < screen_frame.x + (screen_frame.w / 2)
    local is_on_right_side = win_frame.x > screen_frame.x + (screen_frame.w / 2) - 1
    if is_on_left_side then
      new_frame = {x = screen_frame.x, y = screen_frame.y, w = screen_frame.w / 2, h = screen_frame.h}
    elseif is_on_right_side then
      new_frame = {x = screen_frame.x + (screen_frame.w / 2), y = screen_frame.y, w = screen_frame.w / 2, h = screen_frame.h}
    else
      new_frame = {x = screen_frame.x, y = screen_frame.y, w = screen_frame.w / 2, h = screen_frame.h}
    end
  end
  win:setFrame(new_frame)
end

-- 3. Bind the hotkeys for tiling
hs.hotkey.bind(hyper, "left", function() tile_window("left") end)
hs.hotkey.bind(hyper, "right", function() tile_window("right") end)
hs.hotkey.bind(hyper, "up", function() tile_window("up") end)
hs.hotkey.bind(hyper, "down", function() tile_window("down") end)

-- Optional: Maximize window with Hyper + M
hs.hotkey.bind(hyper, "m", function()
    local win = hs.window.focusedWindow()
    if win then
      win:maximize()
    end
end)

-- =================================================================
-- APPLICATION SHORTCUTS
-- =================================================================

-- 4. New hotkey to open Finder at the user's home directory
hs.hotkey.bind(hyper, "h", function()
  hs.fs.open(os.getenv("HOME"))
end)

-- 5. Native Hammerspoon hotkey to clear all notifications
hs.hotkey.bind(hyper, "c", function()
  local notificationCenter = hs.uielement.applications("NotificationCenter")
  if notificationCenter and notificationCenter:count() > 0 then
    local clearButton = notificationCenter[1]:findFirst({
        element = "button",
        title = "Clear All"
    })
    if clearButton then
      clearButton:performAction("AXPress")
      hs.alert.show("Notifications cleared.")
    else
      hs.alert.show("Clear All button not found.")
    end
  else
    hs.alert.show("Notification Center not found.")
  end
end)