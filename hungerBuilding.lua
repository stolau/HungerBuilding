-- title:  hungerBuilding
-- author: Anssi Uistola, Topias Syri
-- desc:   Build city
-- script: lua

gMult= 8
t = 1
goldAmount = 5
cursor_x = 1
cursor_y = 1

play_area_limit_x = 193
play_area_limit_y = 129

flip = 0
button_press = 0

-- Variables for building Menu --
menu_screen = 0
cursor_x_menu = 202
cursor_y_menu = 10
selectedId = 0

cursorScale = 1

--Variables for hunger and tech progress-
hungerLevel = 10
techLevel = 0
timeCounter = 0
hungerLevel_color = 11 --Color green

-- Lists for tracking Objects --
Human = {}
Building = {}
humanList = {}
schoolList = {}
bankList = {}
farmList = {}


up = 0
down = 1
left = 2
right = 3
z = 4
x = 5
a = 6
s = 7



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



--Places object to the ground
function placeSelectedBuilding(buildingID)
        spr(buildingID, cursor_x, cursor_y)
end


function cursor_buttons()
  if btn(0) and (cursor_y-8 > 0) then
    cursor_y=cursor_y-8
    button_press = 1
  end
  if btn(1) and (cursor_y+8<129) then
    cursor_y=cursor_y+8
    button_press = 1
  end
  if btn(2) and (cursor_x-8 > 0) then
    cursor_x=cursor_x-8
    button_press = 1
  end
  if btn(3) and (cursor_x+8 < 193) then
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
  if btn(z) then
    menu_screen = 0
    selectedId = 1
  end
end

sizeItem = 4
itemItem = {9, 10, 25, 26}
-- item gets values left top, right top, bottom left, bottom right 
function drawItemUnderCursor(size, item)
    spr(9, cursor_x, cursor_y, 0, 1, 0, 0, 2, 2)
end
    

function drawAnimatedCursor()
  spr(1+t%60//30, cursor_x, cursor_y, 0, 1, 0, 0, 1, 1)
end


function drawCursor()
  spr(1, cursor_x, cursor_y, 0, 1, 0, 0, 1, 1)
end

function drawMenuCursor()
  spr(1, cursor_x_menu, cursor_y_menu, 0, 4, 0, 0, 1, 1)
end

function gold()
		goldAmount = goldAmount + 5
end

function hungerLevelManager(hungerCount)
    hungerLevel = hungerLevel + hungerCount
    if hungerLevel < 5 then
        hungerLevel_color = 6
    end
    if hungerLevel >= 5 then
        hungerLevel_color = 11
    end
    -- If hungerLevel = 0 --> 3 random citizens will starve to death 
    -- No bonus food from them

end


mapList = createMap()
Anssi = Human:new(0, "male", "Anssi Uistola", "none", {(8*5)+1, (8*11)+1}, 3, 1)
table.insert(humanList, Anssi)

SchoolA = Building:new(1, {(8*12)+1, (8*12)+1}, 2)
table.insert(schoolList, SchoolA)

updateMapList(Anssi)
updateMapList(SchoolA)


function TIC()


    
		if not btn(0) and not btn(1) and not btn(2) and not btn(3) then
			button_press = 0
		end
        if btn(x) then menu_screen = 1 end
		if button_press == 0 and menu_screen == 0 then cursor_buttons() end
		cls(5)
        --
		map()
		rect(0, play_area_limit_y, 240, 8, 2)
		rect(play_area_limit_x, 0, 80, 136, 2)
        if selectedId == 1 then
            drawItemUnderCursor(sizeItem, itemItem)
        end
        -- Prints screen for Building interface panel
        if menu_screen == 1 then
            rect(200, 8, 32, 32, 4)
            rect(200, 43, 32, 32, 4)
            rect(200, 78, 32, 32, 4)
            rect(202, 10, 28, 28, 1)
            rect(202, 45, 28, 28, 1)
            rect(202, 80, 28, 28, 1)
            
            spr(7, 200, 8, 0, 2, 0, 0, 2, 2)
            spr(9, 200, 43, 0, 2, 0, 0, 2, 2)
            spr(11, 200, 78, 0, 2,0, 0, 2, 2)
            
            rect(220, 28, 10, 10, 1)
            rect(220, 63, 10, 10, 1)
            rect(220, 98, 10, 10, 1)
            print(10, 220, 31, 14)
            print(10, 220, 66, 14)
            print(10, 220, 101, 14)
            
            
            if button_press == 0 then
                cursor_menu_buttons()
            end
        end
		print("Score:", 0, 130)
		print("Day:", 50, 130)
		print("Gold: " .. goldAmount, 90, 130, 9)
        
        --Prints Hunger Level
        rect(200, 112, 32, 7, 1)
        rect(201, 113, hungerLevel * 3, 5, hungerLevel_color)
        
        --Prints Tech level
        rect(200, 120, 32, 7, 1)
        rect(201, 121, 30, 5, 8)
        
        print(timeCounter, 0,0, 1)
        --Draws
        drawMap()
		drawCursor()
        drawMenuCursor()
        
        if t%60 == 0 then
            hungerLevelManager(-1)
        end
            
		if t%180 == 0 then
				gold()
                updateAge()
		end
        --[[for i = 1, 16, 1
        do
            for z = 1, 24, 1
            do
                print(mapList[i][z], z* 4, i * 8)
            end
        end]]--
        
        
        print(Anssi.name .. "  " .. Anssi.age, 10, 10)
		t = t+1
        if t%60 == 0 then  
            timeCounter = timeCounter + 1
        end 

end
