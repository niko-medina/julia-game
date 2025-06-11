# initialize screen

WIDTH = 600
HEIGHT = 600
BACKGROUND = colorant"steelblue"

# game state

global game_ongoing = true
global circles = []
radius = 50
# define initial state of actors

#r = Rect(xpos, ypos, width, height)
#c = Circle(xpos, ypos, radius)
#l = Line(xpos1, ypos1, xpos2, ypos2)
mouse = Circle(300, 300, 50)
circle = Circle(300, 300, 60)
cat = Rect(450, 60, 100, 100)
score = 0
button = Rect(450, 550, 150, 50)

#a = Actor(image.png, xpos, ypos)

function on_mouse_down(g::Game, pos, btn)
    global game_ongoing
    if (collide(cat, button))
        game_ongoing = false
        println("game stopped")
    end
end

# draw actors

function draw(g::Game)
    draw(mouse, colorant"black", fill = true)
    draw(cat, colorant"blue", fill = true)
    draw(button, colorant"yellow", fill= true)

    score_text = TextActor("Score: $(score)", "sourgummy";font_size = 36, color = Int[0, 0, 0, 255]) 
    score_text.pos = (400, 10)
    draw(score_text)

    if collide(mouse, cat)
        draw(circle)
    end

end

# define mouse input

function on_mouse_move(g::Game, pos)
    cat.x = pos[1]
    cat.y = pos[2]
end

# define keyboard inputs

function on_key_down(g::Game)
    println("key down!")
    global score
    if (collide(cat, mouse)) 
        score += 10
        println("collision!")
    end
end

#change game state and attributes of the Actors

function update(g::Game)
    if !game_ongoing
        # game over screen
    end
end