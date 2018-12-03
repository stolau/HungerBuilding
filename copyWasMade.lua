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

-- Human Objects list

hNumber = 1

-- Main menu cursors
main_menu_cursor_x = 37
main_menu_cursor_y = 48

--Main menu variables

mainMenuColor = 14
o = 0

-- Control variables
up = 0
down = 1
left = 2
right = 3
z = 4
x = 5
a = 6
s = 7

-- Game States

inGame = false
mainMenu = true



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

function Human:new(age, sex, skills, pos)
    infoTable = {
                age = age;
                sex = sex;
                name = "lolwut";
                skills = skills;
                pos = pos;
                spriteID = 0;
                bDay = t;
                size = 1;
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
    if v.direction[1] == -1 and v.sex == "female" then v.spriteID = 52 end
    if v.direction[1] == -1 and v.sex == "male" then v.spriteID = 51 end
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
    if goldAmount - cost[buildId] > 0 then
      buildingList["B" .. bNumber] = Building:new(buildId, {cursor_x, cursor_y})
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
    button_press = 1
  end
end


-- item gets values left top, right top, bottom left, bottom right 
function drawItemUnderCursor()
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
		goldAmount = goldAmount + 5
end


function draw_main_menu_Cursor()
  spr(17, main_menu_cursor_x, main_menu_cursor_y, 0, 1, 0, 0, 1, 1)
  
end

function cursor_main_menu_buttons()

  if btn(up) and (main_menu_cursor_y> 48) then
    main_menu_cursor_y = main_menu_cursor_y - 16
    button_press = 1
  end
  if btn(down) and (main_menu_cursor_y < 60) then
    main_menu_cursor_y=main_menu_cursor_y + 16
    button_press = 1
  end
  if btn(z) and (main_menu_cursor_y == 48) then
    inGame = true
    mainMenu = false
  end
  if btn(z) and (main_menu_cursor_y == 64) then
    --QUIT
    inGame = true
  end
end



for i, v in pairs(buildingList) do
  updateMapList(v)
end

function addHuman()

    genderList = {"male", "female"}
    colors = {"Red", "Blue", "Green", "Gold"}
    choiceG = math.random(1, 2)
    choiceC = math.random(1, 4)
    random_x_Pos = math.random(0, 23)
    random_y_Pos = math.random(0, 15)
    
    humanList["H" .. hNumber] = Human:new(1, genderList[choiceG], colors[choiceC], {(8*random_x_Pos + 1), (8*random_y_Pos + 1)})
    
    hNumber = hNumber + 1
    
end


function TIC()



    if not btn(0) and not btn(1) and not btn(2) and not btn(3) then
		button_press = 0
	end
    if inGame then
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
        
        -- Tech manager
        techLevelManager(techSpeed / 60)
        if techLevel >= 3 then
            techSpeed = 0
            
            print("GAME IS OVER HIT THE SHOWER", 40, 40)
        end
        
        --Passive Hunger Level reduce
        if t%60 == 0 then
            hungerLevelManager(-1)
        end
            
        --Passive Gold
		if t%180 == 0 then
				gold()
		end
        --Passive population increase
        if t%180 == 0 then addHuman() end
        --Update Age of humans
        updateAge()
        if t%60 == 0 then chooseDirection() end
        if t%8 == 0 then moveHuman() end
        
		t = t+1
        if t%60 == 0 then  
            timeCounter = timeCounter + 1
        end 
    end
    if mainMenu then
        cls(4)
        if btn(x) then
            mainMenu = false
            inGame = true
        end
        
        if o%360 == 0 then
            if mainMenuColor == 14 then
                mainMenuColor = 6
                o = 0 + 340
            elseif mainMenuColor == 6 then
                mainMenuColor = 14
            end
        end
        print(o, 0,0, 0)
        print("WELCOME TO CITY BUILDING SIMILUATOR", 25, 15,mainMenuColor)
        
        
        spr(112, 5, 44, 0, 1, 0, 0, 2, 2)
        spr(144, 20, 44, 0, 1, 0, 0, 2, 2)
        spr(112, 5, 60, 0, 1, 0, 0, 2, 2)
        spr(144, 20, 60, 0, 1, 0, 0, 2, 2)
        --spr(112, 5, 64, 0, 1, 0, 0, 2, 2)
        --spr(144, 37, 64, 0, 1, 0, 0, 2, 2)
        --spr(176, 21, 64, 0, 1, 0, 0, 2, 2)
        --spr(17, 40, 47, 0, 1, 0, 0, 1, 1) -- Main Menu Indicator
        print("PLAY", 10, 50)
        print("QUIT", 10, 66, 6)
        draw_main_menu_Cursor()
        cursor_main_menu_buttons()
        
            for d = 1, 50, 1 do
                if o%math.random(10, 20) == 0 then
                    initial_x = math.random(0,240)
                    rect(initial_x, 140-d, math.random(1,2), math.random(1,2), 14)
                end
            end
            
        o = o + 1
    end

end
