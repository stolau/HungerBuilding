--[[
x0 = 1
y0 = 1
x1 = 5
y1 = 5
t = 0

function TIC()
  cls(12)
  if t%30 == 0 then
    x0 = x0+1
    y0 = y0+1
    x1 = x1*2
    y1 = y1*2
  end
  drawBox(x0,x1,y0,y1)
  t = t+1
end

function drawBox(x0, x1, y0, y1)
  line(x0, y0, x0, y1, 10)
  line(x0, y1, x1, y1, 10)
  line(x1, y1, x1, y0, 10)
  line(x1, y0, x0, y0, 10)
end
--]]

function TIC()
  cls(12)
  map(12, 0)
end
