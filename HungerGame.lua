-- title:  hungerBuilding
-- author: Anssi Uistola, Topias Syri
-- desc:   Build city
-- script: lua

gMult= 8
t = 1
goldAmount = 90
cursor_x = 1
cursor_y = 1

play_area_limit_x = 193
play_area_limit_y = 129

flip = 0
button_press = 0

--Variables for Human menu --
humanButton = 0
sacId = 37

-- Variables for building Menu --
menu_screen = 0
cursor_x_menu = 202
cursor_y_menu = 10
selectedId = 0
selectedHuman = nil
cursorScale = 1

cost = {}
cost[7] = 30
cost[9] = 30
cost[11] = 30

tech_count = {0,0,0,0}
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

moneyh_count = 1
school_count = 1
farm_count = 1
human_count = 0

buildingObjects = {}
bNumber = 1
hNumber = 1
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
    for i=0, 23, 1 do
      for k=0, 15, 1 do
        map_List[i .. "," .. k] = 1
      end
    end
    return map_List
end

-- Building constructor --
function Building:new(spriteID, pos)
  infoTable = {
              pos = pos;
              spriteID = spriteID;
              size = 2
              }
  if spriteID == 7 then
    moneyh_count = moneyh_count + 1
    goldAmount = goldAmount - cost[7]
  end
  if spriteID == 9 then
    school_count = school_count + 1
    goldAmount = goldAmount - cost[9]
  end
  if spriteID == 11 then
    farm_count = farm_count + 1
    goldAmount = goldAmount - cost[11]
  end
  self._index = self
  return setmetatable(infoTable, self)
end

-- Human constructor --
function Human:new(age, sex, skills, posit)
    mapList[fromPtoB(posit[1]) .. "," .. fromPtoB(posit[2])] = nil
    infoTable = {
                age = age;
                sex = sex;
                skills = skills;
                pos = posit;
                spriteID = 16;
                bDay = t;
                size = 1;
                direction = {0,0};
                loc1 = fromPtoB(posit[1]) .. "," .. fromPtoB(posit[2]);
                loc2 = fromPtoB(posit[1]) .. "," .. fromPtoB(posit[2]);
                state = 1
                }
    self._index = self
    return setmetatable(infoTable, self)
end

-- function to go from mapList coordinates to Pixel coordinates --
function fromBtoP(value)
  return ((value*8) + 1)
end


-- function to go from Pixel coordinates to mapList coordinates --
function fromPtoB(value)
  val = (value-1)/8
  if (value-1)%8 == 0 then
    return math.floor(val)
  else
    return 10000
  end
end


-- Checks the legal directions for a human from mapList --
function getlegalMoves(obj)
    moves = {}
    if mapList[fromPtoB(obj.pos[1]) - 1 .. "," .. fromPtoB(obj.pos[2])] == 1 then
      table.insert(moves, {-1, 0})
    end
    if mapList[fromPtoB(obj.pos[1]) + 1 .. "," .. fromPtoB(obj.pos[2])] == 1 then
      table.insert(moves, {1, 0})
    end
    if mapList[fromPtoB(obj.pos[1]) .. "," .. fromPtoB(obj.pos[2]) - 1] == 1 then
      table.insert(moves, {0, -1})
    end
    if mapList[fromPtoB(obj.pos[1]) .. "," .. fromPtoB(obj.pos[2]) + 1] == 1 then
      table.insert(moves, {0, 1})
    end
    if #moves == 0 then
      return 0
    else
      return moves[math.random(#moves)]
    end
end

-- Chooses the direction a human will move --
function chooseDirection(obj)
    dir = getlegalMoves(obj)
    if dir == 0 then
      obj.direction = {0,0}
    else
      obj.direction = dir
      -- Point to correct sprites for directional movement --
      if obj.direction[2] == 1 and obj.sex == "female" then obj.spriteID = 35 end
      if obj.direction[2] == 1 and obj.sex == "male" then obj.spriteID = 3 end
      if obj.direction[2] == -1 and obj.sex == "female" then obj.spriteID = 20 end
      if obj.direction[2] == -1 and obj.sex == "male" then obj.spriteID = 19 end
      if obj.direction[1] == 1 and obj.sex == "female" then obj.spriteID = 36 end
      if obj.direction[1] == 1 and obj.sex == "male" then obj.spriteID = 4 end
      if obj.direction[1] == -1 and obj.sex == "female" then obj.spriteID = 52 end
      if obj.direction[1] == -1 and obj.sex == "male" then obj.spriteID = 51 end
      obj.loc2 = fromPtoB(obj.pos[1]) + obj.direction[1] .. "," .. fromPtoB(obj.pos[2]) + obj.direction[2]
      mapList[obj.loc2] = 0
    end
end

-- Calculates movement for Humans, and moves the sprite locations. Moves one tile at a time--

function moveHuman()
  for i,v in pairs(humanList) do
    if (fromPtoB(v.pos[1]) .. "," .. fromPtoB(v.pos[2])) == v.loc2 then
      mapList[v.loc1] = 1
      v.loc1 = v.loc2
      chooseDirection(v)
    else if ((v.pos[1] + v.direction[1]) > 0) and (v.pos[1] + 8*v.direction[1]) < play_area_limit_x and (v.pos[2] + v.direction[2]) > 0 and (v.pos[2] + 8*v.direction[2] < play_area_limit_y) then
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
    if v.state == 1 then spr(v.spriteID, v.pos[1], v.pos[2],0) end
  end
end

-- Updates the maplist to block moving on buildings --

function updateMapList(obj)
    for i, v in pairs(humanList) do
      if v.loc1 == fromPtoB(obj.pos[1])+1 .. "," .. fromPtoB(obj.pos[2]) or v.loc2 == fromPtoB(obj.pos[1])+1 .. "," .. fromPtoB(obj.pos[2]) then
        newPos = randomPosition()
        v.pos = {fromBtoP(newPos[1]), fromBtoP(newPos[2])}
        v.loc1 = newPos[1] .. "," .. newPos[2]
        v.loc2 = newPos[1] .. "," .. newPos[2]
        v.direction = {0,0}
      end
      if v.loc1 == fromPtoB(obj.pos[1])+1 .. "," .. fromPtoB(obj.pos[2])+1 or v.loc2 == fromPtoB(obj.pos[1])+1 .. "," .. fromPtoB(obj.pos[2])+1 then
        newPos = randomPosition()
        v.pos = {fromBtoP(newPos[1]), fromBtoP(newPos[2])}
        v.loc1 = newPos[1] .. "," .. newPos[2]
        v.loc2 = newPos[1] .. "," .. newPos[2]
        v.direction = {0,0}
      end
      if v.loc1 == fromPtoB(obj.pos[1]) .. "," .. fromPtoB(obj.pos[2])+1 or v.loc2 == fromPtoB(obj.pos[1]) .. "," .. fromPtoB(obj.pos[2])+1 then
        newPos = randomPosition()
        v.pos = {fromBtoP(newPos[1]), fromBtoP(newPos[2])}
        v.loc1 = newPos[1] .. "," .. newPos[2]
        v.loc2 = newPos[1] .. "," .. newPos[2]
        v.direction = {0,0}
      end
      if v.loc2 == fromPtoB(obj.pos[1]) .. "," .. fromPtoB(obj.pos[2]) or v.loc2 == fromPtoB(obj.pos[1]) .. "," .. fromPtoB(obj.pos[2]) then
        newPos = randomPosition()
        v.pos = {fromBtoP(newPos[1]), fromBtoP(newPos[2])}
        v.loc1 = newPos[1] .. "," .. newPos[2]
        v.loc2 = newPos[1] .. "," .. newPos[2]
        v.direction = {0,0}
      end
    end
    mapList[fromPtoB(obj.pos[1])+1 .. "," .. fromPtoB(obj.pos[2])+1] = 2
    mapList[fromPtoB(obj.pos[1]) .. "," .. fromPtoB(obj.pos[2])+1] = 2
    mapList[fromPtoB(obj.pos[1]) .. "," .. fromPtoB(obj.pos[2])] = 2
    mapList[fromPtoB(obj.pos[1])+1 .. "," .. fromPtoB(obj.pos[2])] = 2
end


function updateAge()
  for i,v in pairs(humanList) do
    if (t-v.bDay)%120 == 0  then
      v.age = v.age + 1
    end
  end
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
  if selectedId == 1 and btn(z) then
    if goldAmount - cost[buildId] > 0 and mapList[fromPtoB(cursor_x) .. "," .. fromPtoB(cursor_y)] < 2 and mapList[fromPtoB(cursor_x) + 1 .. "," .. fromPtoB(cursor_y)] < 2 and mapList[fromPtoB(cursor_x) .. "," .. fromPtoB(cursor_y) + 1] < 2 then
      buildingList["B" .. bNumber] = Building:new(buildId, {cursor_x, cursor_y})
      updateMapList(buildingList["B" .. bNumber])
      bNumber = bNumber + 1
      selectedId = 0
    else
    end
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
    if cursor_y_menu == 10 then
        buildId = 7
    end
    if cursor_y_menu == 45 then
        buildId = 9
    end
    if cursor_y_menu == 80 then
        buildId = 11
    end
    button_press = 1
  end
end

function human_cursor_buttons()
    if btn(a) and button_press == 0 then
        humanButton = 0
        selectedHuman = nil
        button_press = 1
    end
    if btn(x) and button_press == 0 then
        killHuman(selectedHuman)
        selectedHuman = nil
        humanButton = 0
        button_press = 1
    end
end

sizeItem = 4
itemItem = {9, 10, 25, 26}
-- item gets values left top, right top, bottom left, bottom right
function drawItemUnderCursor(size, item)
    spr(buildId, cursor_x, cursor_y, 0, 1, 0, 0, 2, 2)
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
		goldAmount = goldAmount + 1 + (moneyh_count)/5
end

function hungerLevelManager(hungerCount)
    hungerLevel = hungerLevel + (1*hungerCount - 0.25*human_count + 0.25*farm_count)/5
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
    techProgress = techProgress + techCount + 0.25*school_count
    if techProgress >= 30*techLevel then
        techProgress = 0
        techLevel = techLevel + 1
    end
end

function randomPosition()
    repeat
      rand_x = math.random(0,23)
      rand_y = math.random(0,15)
    until mapList[rand_x .. "," .. rand_y] == 1
    return {rand_x, rand_y}
end

function killHuman(target)
  mapList[target.loc1] = 1
  mapList[target.loc2] = 1
  target.state = 0
  human_count = human_count - 1
end

function techLevels()
  for i, v in pairs(humanList) do
    if v.skill == "Red" then tech_count[1] = tech_count[1]+1 end
    if v.skill == "Blue" then tech_count[2] = tech_count[2]+1 end
    if v.skill == "Green" then tech_count[3] = tech_count[3]+1 end
    if v.skill == "Gold" then tech_count[4] = tech_count[4]+1 end
  end
end

function addHuman()
    genderList = {"male", "female"}
    colors = {"Red", "Blue", "Green", "Gold"}
    choiceG = math.random(1, 2)
    choiceC = math.random(1, 4)
    repeat
      random_x_Pos = math.random(0,23)
      random_y_Pos = math.random(0,15)
    until mapList[random_x_Pos .. "," .. random_y_Pos] == 1
    humanList["H" .. hNumber] = Human:new(1, genderList[choiceG], colors[choiceC], {fromBtoP(random_x_Pos), fromBtoP(random_y_Pos)})
    hNumber = hNumber + 1
    human_count = human_count + 1
end

-- Test Objects --
mapList = createMap()

function TIC()
    if inGame then
      if not btn(0) and not btn(1) and not btn(2) and not btn(3) and not btn(z) and not btn(x) and not btn(a) then
        button_press = 0
      end
      if btn(z) and button_press == 0 and menu_screen == 0 and selectedId == 0 then
            if mapList[fromPtoB(cursor_x) .."," .. fromPtoB(cursor_y)] == 0 then
                for i, v in pairs(humanList) do
                  if v.loc1 == fromPtoB(cursor_x) .."," .. fromPtoB(cursor_y) or v.loc2 == fromPtoB(cursor_x) .."," .. fromPtoB(cursor_y) then
                    selectedHuman = v
                  end
                end
                humanButton = 1
            end
      end
      techLevels()
      if button_press == 0 and menu_screen == 0 then cursor_buttons() end
      if btn(x) and button_press == 0 and humanButton == 0 then menu_screen = 1 end
      cls(5)
       map()
       rect(0, play_area_limit_y, 240, 8, 2)
       rect(play_area_limit_x, 0, 80, 136, 2)
       -- Prints screen for Building interface panel
       if menu_screen == 0 and humanButton == 0 then

           spr(32, 208, 4, 0, 3, 0, 0, 1, 1)
           spr(48, 208, 28, 0, 3, 0, 0, 1, 1)
           spr(64, 208, 52, 0, 3, 0, 0, 1, 1)
           spr(80, 208, 76, 0, 3, 0, 0, 1, 1)
           -- Prints numbers alive, of each ability
           print(tech_count[1] .."x", 194, 13)
           print(tech_count[2] .."x", 194, 13+3*8)
           print(tech_count[3] .."x", 194, 13+6*8)
           print(tech_count[4] .."x", 194, 13+9*8)
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
           print(30, 220, 31, 14)
           print(30, 220, 66, 14)
           print(30, 220, 101, 14)


           if button_press == 0 then
               cursor_menu_buttons()
           end
       end
       if humanButton == 1 then
            skillS = selectedHuman.skills
            ageS = selectedHuman.age
            print("Age: " .. ageS, 200, 8+35)
            print("Skill: ", 200, 16+35)
            print(skillS, 200, 24+35)
            -- Draws skills in
            --[[for h=1, skillOwned, 1 do
                spr(skillSpritePos, 200, 8+(h*35), 0, 2, 0, 0, 2, 2)
            end --]]

            --[[if t%90 == 0 then
                sacId = 37
            elseif t%45 == 0 then
                sacId = 39 --]]
            --spr(sacId, 80, 50, 0, 2, 0, 0, 2, 2)
            --end
            --print("PRESS X TO SACRIFICE", 10, 22)
            human_cursor_buttons()
       end

       print("Score:", 0, 130)
       print("Gold: " .. math.floor(goldAmount), 90, 130, 9)

       --Prints Hunger Level
       rect(200, 112, 32, 7, 1)
       rect(201, 113, hungerLevel * 3, 5, hungerLevel_color)

       --Prints Tech level
       rect(200, 120, 32, 7, 1)
       rect(201, 121, techProgress/techLevel, 5, 8)
       print(techLevel, 194, 121)
       print(cursor_y_menu, 0,0, 1)
       --Draws Different Cursors
       drawMap()
       if selectedId == 1 then
           drawItemUnderCursor()
       end
       drawCursor()
       if menu_screen == 1 then drawMenuCursor() end

       if t%600 == 0 then techLevelManager(2) end
       if techLevel > 3 then
           techSpeed = 0
           print("GAME IS OVER HIT THE SHOWER", 40, 40)
       end

       if t%60 == 0 then hungerLevelManager(-1) end

       if t%60 == 0 then gold() end
       updateAge()
       if t%300 == 0 then addHuman() end
       if t%12 == 0 then moveHuman() end
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
           button_press = 1
       end

       print("WELCOME TO SITY BUILDING SIMILUATOR", 25, 15)


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
