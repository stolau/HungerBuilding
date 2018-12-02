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

-- Button IDs --
up = 0
down = 1
left = 2
right = 3
z = 4
x = 5
a = 6
s = 7

gMult= 8

-- Variables for building Menu --
menu_screen = 0
cursor_x_menu = 202
cursor_y_menu = 10

-- Variables for selection --
selection = 0

t = 0
goldAmount = 5

-- Variables for Cursor --
cursor_x = 1
cursor_y = 1
cursor_scale = 1
cursor_state = 0

play_area_limit_x = 193
play_area_limit_y = 129

flip = 0
button_press = 0

-- Lists for tracking Objects --
Human = {}
Building = {}
humanList = {}
schoolList = {}
bankList = {}
farmList = {}

--Create Map list for units to checkout squares
function createMap()
    map_List = {}
    map_Y = 1
    map_X = 1
    repeat
        table.insert(map_List, 0)
        map_Y = map_Y + 1
    until map_Y > 16
    whole_List = {}
    repeat
        table.insert(whole_List, map_List)
        map_X = map_X + 1
    until map_X > 24

    return whole_List
end

function Farm()
    local cost = 25
    local size = 1

end

function placeSelectedBuilding(buildingID)
    spr(buildingID, cursor_x, cursor_y)
end

function Building:new(type, position, size)
  --if type == 1 then spriteID = 11 end
  infoTable = {
              type = type;
              position = position;
              spriteID = 11;
              size = size
              }
  self._index = self
  return setmetatable(infoTable, self)
end

function Human:new(age, sex, name, skills, position, spriteID, size)
    infoTable = {
                age = age;
                sex = sex;
                name = name;
                skills = skills;
                position = position;
                spriteID = spriteID;
                bDay = t;
                size = size
                }
    self._index = self
    return setmetatable(infoTable, self)
end



function drawCursor()
  if cursor_state == 0 then
    spr(1, cursor_x, cursor_y, 0, cursor_scale, 0, 0, 1, 1)
  else
    spr(1+t%60//30, cursor_x, cursor_y, 0, cursor_scale, 0, 0, 1, 1)
  end
end

function drawMenuCursor()
    spr(1, cursor_x_menu, cursor_y_menu, 0, 4, 0, 0, 1, 1)
end

-- Test to draw the contents of mapList on correct positions --
function drawMap()
    for i = 1, #mapList, 1 do
      for p = 1, #mapList[i], 1 do
        if mapList[i][p] == 0 or mapList[i][p] == 1 then
        else
          if mapList[i][p].size == 2 then
            spr(mapList[i][p].spriteID, mapList[i][p].position[1], mapList[i][p].position[2], 0, 1, 0, 0, 2, 2)
          else
            spr(mapList[i][p].spriteID, mapList[i][p].position[1], mapList[i][p].position[2], 0)
          end
      end
    end
  end
end

function gold()
		goldAmount = goldAmount + 2
end

function updateAge()
  for i=1, #humanList, 1 do
    if (t-humanList[i].bDay)%120 == 0  then
      humanList[i].age = humanList[i].age + 1
    end
  end
end

-- Test insert object to a position in mapList --
function updateMapList(object)
    if object.size == 2 then
      mapList[(((object.position[1]-1)/8)+1)][(((object.position[2]-1)/8)+1)] = object
      mapList[((((object.position[1]-1)/8)+1)+1)][((((object.position[2]-1)/8)+1)+1)] = 1
      mapList[((((object.position[1]-1)/8)+1)+1)][((((object.position[2]-1)/8)+1))] = 1
      mapList[(((object.position[1]-1)/8)+1)][((((object.position[2]-1)/8)+1)+1)] = 1
    else
      mapList[(((object.position[1]-1)/8)+1)][(((object.position[2]-1)/8)+1)] = object
    end
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
end

function cursor_menu_buttons()
  if btn(up) and (cursor_y_menu > 10) then
    cursor_y_menu= cursor_y_menu - 35
    button_press = 1
  end
  if btn(down) and (cursor_y_menu < 80) then
    cursor_y_menu=cursor_y_menu + 35
    button_press = 1
  end
  if btn(a) then menu_screen = 0 end
end


mapList = createMap()
Anssi = Human:new(0, "male", "Anssi Uistola", "none", {(8*5)+1, (8*11)+1}, 3, 1)
table.insert(humanList, Anssi)

SchoolA = Building:new(1, {(8*12)+1, (8*12)+1}, 2)
table.insert(schoolList, SchoolA)

updateMapList(Anssi)
updateMapList(SchoolA)

function TIC()

		if not btn(up) and not btn(down) and not btn(left) and not btn(right) then
			button_press = 0
		end

    if btn(z) then selection = 1 end

    if btn(x) then menu_screen = 1 end
    if button_press == 0 and menu_screen == 0 then cursor_buttons() end

    cls(5)
		map()
    rect(0, play_area_limit_y, 240, 8, 2)
		rect(play_area_limit_x, 0, 80, 136, 2)

    if menu_screen == 1 then
        rect(202, 10, 28, 28, 1)
        rect(202, 45, 28, 28, 1)
        rect(202, 80, 28, 28, 1)
        if button_press == 0 then
            cursor_menu_buttons()
        end
    end

		print("Score:", 0, 130)
		print("Day:", 50, 130)
		print("Gold: " .. goldAmount, 90, 130, 9)
    print(cursor_x .. " " .. cursor_y, 160, 130)
    drawMap()
    drawCursor()
    drawMenuCursor()
		if t%30 == 0 then
				gold()
        updateAge()
		end
    print(Anssi.name .. "  " .. Anssi.age, 10, 10)
		t = t+1

end
