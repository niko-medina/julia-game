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
cat = Circle(450, 60, 40)
score = 0
button = Rect(450, 550, 150, 50)
reset_button = Rect(200, 350, 150, 50)
last_note_time = 0.0

NOTE_INTERVAL = 1.0
#a = Actor(image.png, xpos, ypos)

keys_x = [160, 260, 360, 460] # position of each lane
keys_y = 550 # y position if hitbox
keys = [] # hitboxes array

notes = []
positions = [(160, 0), (260, 0), (360, 0), (460, 0)]

function create_note()
    xpos, ypos = rand(positions)
    note = Circle(xpos, ypos, 40)
    return note
end


function on_mouse_down(g::Game)
    global game_ongoing
    if game_ongoing
        if collide(cat, button)
        game_ongoing = false
        println("game stopped")
        end
    else  
        if collide(cat, reset_button)
        println("reset!")
        reset()
        end
    end
end

# draw actors

function draw(g::Game)
    if game_ongoing

        # draw keys
        for k in keys_x
            key = Circle(k, keys_y, 45)
            push!(keys, key)
            draw(key)
        end 

        # color keys when pressed
        if g.keyboard.S
            draw(Circle(keys_x[1], keys_y, 30), colorant"red", fill=true)
        elseif g.keyboard.D
            draw(Circle(keys_x[2], keys_y, 30), colorant"red", fill=true)
        elseif g.keyboard.J
            draw(Circle(keys_x[3], keys_y, 30), colorant"red", fill=true)
        elseif g.keyboard.K
            draw(Circle(keys_x[4], keys_y, 30), colorant"red", fill=true)
        end

        # keys labels
        key_text_y = keys_y - 30
        key_text_size = 50
        key_text_color = Int[0, 0, 0, 255]
        key_text = ["S", "D", "J", "K"]
        for i in eachindex(key_text)
            k = key_text[i]
            t = TextActor("$k", "sourgummy"; font_size = key_text_size, color = key_text_color)
            t.pos = (keys_x[i] - 15, key_text_y)
            draw(t)
        end

        global last_note_time
        if time() - last_note_time > NOTE_INTERVAL            
            push!(notes, create_note())
            last_note_time = time()
        end

        for n in notes
            draw(n, colorant"green", fill="true")
        end
        
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

    else
        # Game over screen

        draw(cat, colorant"blue", fill = true)

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

function on_key_down(g::Game, k)
    if game_ongoing
        println("key down!")
        global score
        for note in notes

            if collide(note, keys[1]) && k == Keys.S
                score += 1
                popfirst!(notes)
            elseif collide(note, keys[2]) && k == Keys.D
                score += 1
                popfirst!(notes)
            elseif collide(note, keys[3]) && k == Keys.J
                score += 1
                popfirst!(notes)
            elseif collide(note, keys[4]) && k == Keys.K
                score += 1
                popfirst!(notes)
            end
        end
    end
end

#change game state and attributes of the Actors

function update(g::Game)
    if game_ongoing
        for n in notes
            n.y += NOTE_SPEED # move notes
            if n.y > HEIGHT
                deleteat!(notes, findall(x->x==n,notes)) # delete notes when they go off-screen
            end
        end
    end
end

function reset()
    #reset global variables
    println("resetting!")
    global score, game_ongoing, cat, button, reset_button, NOTE_SPEED
    score = 0
    game_ongoing = true
    cat = Circle(450, 60, 40)
    button = Rect(450, 550, 150, 50)
    reset_button = Rect(200, 350, 150, 50)
    NOTE_SPEED = 3
end

reset()