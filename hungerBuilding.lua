-- title:  hungerBuilding
-- author: Anssi Uistola, Topias Syri
-- desc:   Build city
-- script: lua

gMult= 8
t = 0
goldAmount = 5
cursor_x = 1
cursor_y = 1

play_area_limit_x = 193
play_area_limit_y = 129

flip = 0
button_press = 0

-- Variables for building Menu --
menu_Screen = 0
cursor_x_menu = 202
cursor_y_menu = 10

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
    map_X = 1
    map_Y = 1
    repeat
        table.insert(map_List, 0)
        map_X = map_X + 1
        
    until map_X > 24
    whole_List = {}
    repeat
        table.insert(whole_List, map_List)
        map_Y = map_Y + 1
    until map_Y > 16
    
    return whole_List
end

function Farm()
    local cost = 25
    local size = 1
    
end


function human()
		print("I'm human man!", 1, 1)
end

function placeHuman()

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


mapList = createMap()


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
		drawCursor()
        drawMenuCursor()
		if t%180 == 0 then
				gold()
		end
        --[[for i = 1, 16, 1
        do
            for z = 1, 24, 1
            do
                print(mapList[i][z], z* 4, i * 8)
            end
        end]]--
		t = t+1

end
