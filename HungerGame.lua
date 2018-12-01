-- title:  hungerBuilding
-- author: Anssi Uistola, Topias Syri
-- desc:   Build city
-- script: lua
--[[
Up = 0
Down = 1
Right = 3
Left = 2
Z = 4
X = 5
A = 6
s = 7
--]]

up = 0
down = 1
left = 2
right = 3
z = 4
x = 5
a = 6
s = 7

gMult= 8

t = 0
goldAmount = 5

cursor_x = 1
cursor_y = 1
cursor_scale = 1
cursor_state = 0

play_area_limit_x = 193
play_area_limit_y = 129

flip = 0
button_press = 0

Human = {}
humanList = {}


function Human:new(age, sex, name, skills, hunger, position, spriteID)
  infoTable = {age = age;
              sex = sex;
              name = name;
              skills = skills;
              hunger = hunger;
              position = position;
              spriteID = spriteID;
              bDay = t}
  self._index = self
  return setmetatable(infoTable, self)
end

Anssi = Human:new(10, "male", "Anssi Uistola", "art", 10, {18, 22}, 3)
table.insert(humanList, Anssi)

function placeBuilding()

end

function updateObjectList(object)

end

function drawAnimatedCursor()
  spr(1+t%60//30, cursor_x, cursor_y, 0, 1, 0, 0, 1, 1)
end

function drawCursor()
  if cursor_state == 0 then
    spr(1, cursor_x, cursor_y, 0, cursor_scale, 0, 0, 1, 1)
  else
    spr(1+t%60//30, cursor_x, cursor_y, 0, cursor_scale, 0, 0, 1, 1)
  end
end

function gold()
		goldAmount = goldAmount + 5
end

function cursor_buttons()
  if btn(up) and (cursor_y-8 > 0) then
    cursor_y=cursor_y-8
    button_press = 1
  end
  if btn(down) and (cursor_y+8*cursor_scale<129) then
    cursor_y=cursor_y+8
    button_press = 1
  end
  if btn(left) and (cursor_x-8 > 0) then
    cursor_x=cursor_x-8
    button_press = 1
  end
  if btn(right) and (cursor_x+8*cursor_scale < 193) then
    cursor_x=cursor_x+8
    button_press = 1
  end
  if btn(z) then
    cursor_scale = 2
    cursor_state = 1
    button_press = 1
  end
end

function updateAge()
  for i=1, #humanList, 1 do
    if 1 == 1 then
      humanList[i].bDay = humanList[i].bDay + 1
    end
  end
end

function TIC()

		if not btn(up) and not btn(down) and not btn(left) and not btn(right) then
			button_press = 0
		end
		if button_press == 0 then cursor_buttons() end
		cls(5)
		map()
		rect(0, play_area_limit_y, 240, 8, 2)
		rect(play_area_limit_x, 0, 80, 136, 2)
		print("Score:", 0, 130)
		print("Day:", 50, 130)
		print("Gold: " .. goldAmount, 90, 130, 9)
		drawCursor()
		if t%60 == 0 then
				gold()
        updateAge()
		end
    print(Anssi.name .. "  " .. Anssi.age, 10, 10)
    spr(Anssi.spriteID, Anssi.position[1]*(t//100), Anssi.position[2], 0, 2)
		t = t+1

end
