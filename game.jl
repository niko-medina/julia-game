# initialize screen

WIDTH = 600
HEIGHT = 600
BACKGROUND = colorant"steelblue"

# game state

global game_ongoing = true
# define initial state of actors

#r = Rect(xpos, ypos, width, height)
#c = Circle(xpos, ypos, radius)
#l = Line(xpos1, ypos1, xpos2, ypos2)
mouse = Circle(300, 300, 50)
circle = Circle(300, 300, 60)
cat = Circle(450, 60, 40)
score = 0
button = Rect(450, 550, 150, 50)
reset_button = Rect(200, 350, 150, 50)

#a = Actor(image.png, xpos, ypos)

function on_mouse_down(g::Game)
    global game_ongoing
    if collide(cat, reset_button)
        println("reset!")
        reset()
    elseif (collide(cat, button))
        game_ongoing = false
        println("game stopped")
    end
end

# draw actors

function draw(g::Game)
    draw(cat, colorant"blue", fill = true)

    if game_ongoing
        draw(mouse, colorant"black", fill = true)
        
        draw(button, colorant"yellow", fill= true)

        #button text
        stop_text = TextActor("Stop", "sourgummy";font_size = 36, color = Int[0, 0, 0, 255])
        stop_text.pos = (480, 550)
        draw(stop_text)

        # score text
        score_text = TextActor("Score: $(score)", "sourgummy";font_size = 36, color = Int[0, 0, 0, 255]) 
        score_text.pos = (400, 10)
        draw(score_text)

        # cursor position
        txt = TextActor("x = $(cat.x) | y = $(cat.y)", "sourgummy";
            font_size = 36, color = Int[0, 0, 0, 255]
        )
        txt.pos = (10, 10)
        draw(txt)

        if collide(mouse, cat)
            draw(circle)
        end
    else
        # Game over screen
        game_over = TextActor("Game Over", "sourgummy"; font_size=50, color=Int[0, 0, 0, 255])
        game_over.pos = (150, 180)
        draw(game_over)

        game_over_score = TextActor("Your score: $score", "sourgummy"; font_size=50, color=Int[0, 0, 0, 255])
        game_over_score.pos = (150, 250)
        draw(game_over_score)

        reset_button = Rect(200, 350, 150, 50)
        reset_button_text = TextActor("Reset", "sourgummy"; font_size=40, color=Int[0, 0, 0, 255])
        reset_button_text.pos = (220, 350)
        draw(reset_button, colorant"red", fill= true)
        draw(reset_button_text)
    end

end

# define mouse input

function on_mouse_move(g::Game, pos)
    cat.x = pos[1]
    cat.y = pos[2]
end

# define keyboard inputs

function on_key_down(g::Game)
    if game_ongoing
        println("key down!")
        global score
        if (collide(cat, mouse)) 
            score += 10
            println("collision!")
        end
    end
end

#change game state and attributes of the Actors

function update(g::Game)
    if !game_ongoing
        # game over screen
    end
end

function reset()
    #reset global variables
    println("resetting!")
    global score, game_ongoing, mouse, circle, cat, button, reset_button
    score = 0
    game_ongoing = true
    mouse = Circle(300, 300, 50)
    circle = Circle(300, 300, 60)
    cat = Circle(450, 60, 40)
    score = 0
    button = Rect(450, 550, 150, 50)
    reset_button = Rect(200, 350, 150, 50)
end