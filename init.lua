local hyper = {"ctrl", "alt", "shift", "cmd"}

hs.hotkey.bind(hyper, "r", function()
  hs.reload()
  hs.notify.new({title="Hammerspoon", informativeText="Reloaded"}):send()
end)

function moveWindow(win, direction)
  local screen = win:screen()
  local screen_frame = screen:frame()
  local new_frame = {}
  local win_frame = win:frame()

  local is_on_left_half = win_frame.x < screen_frame.x + (screen_frame.w / 2) - 1
  
  if direction == "left" then
    -- Move to left half (x: 0, y: 0, w: 1/2, h: full)
    new_frame = {x = screen_frame.x, y = screen_frame.y, w = screen_frame.w / 2, h = screen_frame.h}
  elseif direction == "right" then
    -- Move to right half (x: 1/2, y: 0, w: 1/2, h: full)
    new_frame = {x = screen_frame.x + (screen_frame.w / 2), y = screen_frame.y, w = screen_frame.w / 2, h = screen_frame.h}
  elseif direction == "up" then
    -- Moves window to 1/4 of screen, top corner of current half
    if is_on_left_half then
      -- Top-Left Quarter (x: 0, y: 0, w: 1/2, h: 1/2)
      new_frame = {x = screen_frame.x, y = screen_frame.y, w = screen_frame.w / 2, h = screen_frame.h / 2}
    else
      -- Top-Right Quarter (x: 1/2, y: 0, w: 1/2, h: 1/2)
      new_frame = {x = screen_frame.x + (screen_frame.w / 2), y = screen_frame.y, w = screen_frame.w / 2, h = screen_frame.h / 2}
    end
  elseif direction == "down" then
    -- Moves window to 1/4 of screen, bottom corner of current half
    if is_on_left_half then
      -- Bottom-Left Quarter (x: 0, y: 1/2, w: 1/2, h: 1/2)
      new_frame = {x = screen_frame.x, y = screen_frame.y + (screen_frame.h / 2), w = screen_frame.w / 2, h = screen_frame.h / 2}
    else
      -- Bottom-Right Quarter (x: 1/2, y: 1/2, w: 1/2, h: 1/2)
      new_frame = {x = screen_frame.x + (screen_frame.w / 2), y = screen_frame.y + (screen_frame.h / 2), w = screen_frame.w / 2, h = screen_frame.h / 2}
    end
  end
  
  -- The check below ensures that we only call setFrame if a move direction was recognized.
  if new_frame.x ~= nil then
    win:setFrame(new_frame)
  end
end

hs.hotkey.bind(hyper, "left", function()
  local win = hs.window.focusedWindow()
  if win then
    moveWindow(win, "left")
  end
end)
hs.hotkey.bind(hyper, "right", function()
  local win = hs.window.focusedWindow()
  if win then
    moveWindow(win, "right")
  end
end)
hs.hotkey.bind(hyper, "up", function()
  local win = hs.window.focusedWindow()
  if win then
    moveWindow(win, "up")
  end
end)
hs.hotkey.bind(hyper, "down", function()
  local win = hs.window.focusedWindow()
  if win then
    moveWindow(win, "down")
  end
end)

hs.hotkey.bind(hyper, "m", function()
    local win = hs.window.focusedWindow()
    if win then
      win:maximize()
    end
end)

hs.hotkey.bind(hyper, "l", function()
  hs.caffeinate.lockScreen()
end)

hs.hotkey.bind(hyper, "h", function()
  hs.execute("open ~")
end)
