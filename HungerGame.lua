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
techLevel = 1
timeCounter = 0
hungerLevel_color = 11 --Color green
techSpeed = 2
techProgress = 0
-- Lists for tracking Objects --
Human = {}
Building = {}
humanList = {}
buildingList = {}
schoolList = {}
bankList = {}
farmList = {}

-- Building Objects list

buildingObjects = {}
bNumber = 1
buildId = 1

-- Game States

inGame = false
mainMenu = true


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

function Building:new(type, pos)
  if type == 2 then spriteID = 9 end
  if type == 1 then spriteID = 7 end
  if type == 3 then spriteID = 11 end
  infoTable = {
              type = type;
              pos = pos;
              spriteID = spriteID;
              size = 2
              }
  self._index = self
  return setmetatable(infoTable, self)
end

function Human:new(age, sex, name, skills, pos, spriteID, size)
    infoTable = {
                age = age;
                sex = sex;
                name = name;
                skills = skills;
                pos = pos;
                spriteID = spriteID;
                bDay = t;
                size = size;
                direction = {0,0}
                }
    self._index = self
    return setmetatable(infoTable, self)
end

function getlegalMoves(obj)
    moves = {}
    if ((obj.pos[1]-1)//8)-2 > 0 then
      if mapList[((obj.pos[1]-1)//8)-1][((obj.pos[2]-1)//8)] == 0 then
        table.insert(moves, {-1, 0})
      end
    end
    if ((obj.pos[1]-1)//8)+2 < play_area_limit_x then
      if mapList[((obj.pos[1]-1)//8)+1][((obj.pos[2]-1)//8)] == 0 then
        table.insert(moves, {1,0})
      end
    end
    if ((obj.pos[2]-1)//8)-2 > 0 then
      if mapList[((obj.pos[1]-1)//8)][((obj.pos[2]-1)//8)-1] == 0 then
        table.insert(moves, {0, -1})
      end
    end
    if ((obj.pos[2]-1)//8)+2 < play_area_limit_y then
      if mapList[((obj.pos[1]-1)//8)][((obj.pos[2]-1)//8)+1] == 0 then
        table.insert(moves, {0, 1})
      end
    end
    return moves[math.random(#moves)]
end

function chooseDirection()
  for i, v in pairs(humanList) do
    v.direction = getlegalMoves(v)
    if v.direction[2] == 1 and v.sex == "female" then v.spriteID = 35 end
    if v.direction[2] == 1 and v.sex == "male" then v.spriteID = 3 end
    if v.direction[2] == -1 and v.sex == "female" then v.spriteID = 20 end
    if v.direction[2] == -1 and v.sex == "male" then v.spriteID = 19 end
    if v.direction[1] == 1 and v.sex == "female" then v.spriteID = 36 end
    if v.direction[1] == 1 and v.sex == "male" then v.spriteID = 4 end
    if v.direction[1] == -1 and v.sex == "female" then v.spriteID = 36 end
    if v.direction[1] == -1 and v.sex == "male" then v.spriteID = 4 end
  end
end

function moveHuman()
  for i,v in pairs(humanList) do
    if ((v.pos[1] - 2) > 0) and (v.pos[1] + 2) < play_area_limit_x and (v.pos[2] - 2) > 0 and (v.pos[2] + 2 < play_area_limit_y) then
      if mapList[(v.pos[1] + v.direction[1])//8][(v.pos[2] + v.direction[2])//8] == 0 then
        v.pos = {v.pos[1] + v.direction[1], v.pos[2] + v.direction[2]}
      end
    end
  end
end

-- Test to draw the contents of mapList on correct poss --

function drawMap()
  for i, v in pairs(buildingList) do
    spr(v.spriteID, v.pos[1], v.pos[2], 0, 1, 0, 0, 2, 2)
  end
  for i, v in pairs(humanList) do
    spr(v.spriteID, v.pos[1], v.pos[2],0)
  end
end

function updateMapList(obj)
    if obj.size == 2 then
      mapList[((obj.pos[1]-1)//8)+1][((obj.pos[2]-1)//8)+1] = 1
      mapList[((obj.pos[1]-1)//8)+2][((obj.pos[2]-1)//8)+1] = 1
      mapList[((obj.pos[1]-1)//8)+2][((obj.pos[2]-1)//8)+2] = 1
      mapList[((obj.pos[1]-1)//8)+1][((obj.pos[2]-1)//8)+2] = 1
    else
      mapList[(((obj.pos[1]-1)//8)+1)][(((obj.pos[2]-1)//8)+1)] = 2
    end
end


function updateAge()
  for i,v in pairs(humanList) do
    if (t-v.bDay)%120 == 0  then
      v.age = v.age + 1
    end
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
  if btn(a) then selectedId = 0 end

  --[[if selectedId == 1 then
    if btn(z) then
            --bKiller = Building:new(1,{cursor_x, cursor_y})
            --"B" .. bNumber = bKiller
            --table.insert(buildingObjects, {"B" .. bNumber = bKiller})
    buildingObjects["B" .. bNumber] = Building:new(1, {cursor_X, cursor_y})
    updateMapList(selectedBuilding)
    bNumber = bNumber + 1
    end
  end --]]
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
    selectedId = 1
    menu_screen = 0
    if cursor_y_menu == 10 then
        buildId = 7
    end
    if cursor_y_menu == 45 then
        buildId = 9
    end
    if cursor_y_menu == 80 then
        buildId = 11
    end
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

function techLevelManager(techCount)
    techProgress = techProgress + techCount
    if techProgress >= 30 then
        techProgress = 0
        techLevel = techLevel + 1
    end
end

-- Test Objects --
mapList = createMap()
humanList["Anssi"] = Human:new(1, "male", "Anssi Uistola", "none", {(8*9)+1, (8*9)+1}, 3, 1)
humanList["Topias"] = Human:new(1, "female", "Topias Syri", "everything", {(8*3)+1, (8*3)+1}, 35, 1)
buildingList["A"] = Building:new(1, {(6*8)+1, (6*8)+1})
buildingList["B"] = Building:new(2, {(10*8)+1,(6*8)+1})
buildingList["C"] = Building:new(2, {(6*8)+1, (10*8)+1})
buildingList["D"] = Building:new(3, {(10*8)+1, (10*8)+1})

for i, v in pairs(buildingList) do
  updateMapList(v)
end


function TIC()
    if inGame then
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
       -- Prints screen for Building interface panel
       if menu_screen == 0 then

           spr(32, 204, 4, 0, 3, 0, 0, 1, 1)
           spr(48, 204, 28, 0, 3, 0, 0, 1, 1)
           spr(64, 204, 52, 0, 3, 0, 0, 1, 1)
           spr(80, 204, 76, 0, 3, 0, 0, 1, 1)
           -- Prints numbers alive, of each ability
           print(4 .."x", 193, 13)

       end
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
       print("Tech:", 50, 130)
       print("Gold: " .. goldAmount, 90, 130, 9)

       --Prints Hunger Level
       rect(200, 112, 32, 7, 1)
       rect(201, 113, hungerLevel * 3, 5, hungerLevel_color)

       --Prints Tech level
       rect(200, 120, 32, 7, 1)
       rect(201, 121, techProgress, 5, 8)
       print(techLevel, 194, 121)



       print(cursor_y_menu, 0,0, 1)
       --Draws Different Cursors
       drawMap()
       drawCursor()
       if selectedId == 1 then
           drawItemUnderCursor()
       end
       if menu_screen == 1 then drawMenuCursor() end

       techLevelManager(techSpeed *4  / 60)
       if techLevel >= 3 then
           techSpeed = 0

           --print("GAME IS OVER HIT THE SHOWER", 40, 40)
       end

       if t%60 == 0 then
         hungerLevelManager(-1)
       end

       if t%180 == 0 then
         gold()
       end
       updateAge()
       if t%60 == 0 then chooseDirection() end
       if t%8 == 0 then moveHuman() end

       --print(Anssi.name .. "  " .. Anssi.age, 10, 10)
       print(humanList["Anssi"].name .. " ".. humanList["Anssi"].age, 10, 10)
       print(humanList["Topias"].name .. " " .. humanList["Topias"].age, 10, 20)
       print(mapList[7][7], 30,30)
       t = t+1
       if t%60 == 0 then
           timeCounter = timeCounter + 1
       end
   end
   if mainMenu then
       cls(5)
       if btn(x) then
           mainMenu = false
           inGame = true
       end

       print("WELCOME TO CITY BUILDING SIMILUATOR", 25, 15)


       spr(112, 5, 44, 0, 1, 0, 0, 2, 2)
       spr(144, 20, 44, 0, 1, 0, 0, 2, 2)
       spr(112, 5, 64, 0, 1, 0, 0, 2, 2)
       spr(144, 37, 64, 0, 1, 0, 0, 2, 2)
       spr(176, 21, 64, 0, 1, 0, 0, 2, 2)
       print("PLAY", 10, 50)
       print("OPTIONS", 10, 70)
       print("QUIT", 10, 90, 6)
   end
end
