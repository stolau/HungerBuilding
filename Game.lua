t = 0
cursor_x = 1
cursor_y = 1

play_area_limit_x = 193
play_area_limit_y = 129

flip = 0
button_press = 0
function cursor_buttons()
  if btn(0) and (cursor_y-8 > 0) then
    cursor_y=cursor_y-8
    button_press = 1
  end
  if btn(1) and (cursor_y+8+8<129) then
    cursor_y=cursor_y+8
    button_press = 1
  end
  if btn(2) and (cursor_x-8 > 0) then
    cursor_x=cursor_x-8
    button_press = 1
  end
  if btn(3) and (cursor_x+8+8 < 193) then
    cursor_x=cursor_x+8
    button_press = 1
  end
end

function drawAnimatedCursor()
  spr(1+t%60//30, cursor_x, cursor_y, 0, 1, 0, 0, 1, 1)
end

function drawCursor()
  spr(1, cursor_x, cursor_y, 0, 1, 0, 0, 1, 1)
end

function TIC()

  if button_press == 0 then cursor_buttons() end
  cls(12)
  map()
  drawCursor()
  if not btn(0) and not btn(1) and not btn(2) and not btn(3) then
    button_press = 0
  end
  print(string("A","B"), 1, 1)
  t = t+1
end
