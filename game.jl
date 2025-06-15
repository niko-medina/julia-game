# initialize screen

const WIDTH = 600
const HEIGHT = 600
const BACKGROUND = colorant"black"

# game state

global game_ongoing = true

# define initial state of actors

const NOTE_SPEED::Int8 = 7
const NOTE_INTERVAL::Float16 = 0.2
const music = "16_bit_space.ogg"
const hit = "electronicbip3.wav"
const miss = "orchestrashot2.wav"
const WHITE = Int[255, 255, 255, 255]

"""
#r = Rect(xpos, ypos, width, height)
#c = Circle(xpos, ypos, radius)
#l = Line(xpos1, ypos1, xpos2, ypos2)
a = Actor(image.png, xpos, ypos)
"""
#reset global variables

function reset()
    global score, game_ongoing, cursor, button, reset_button, last_update_time,
    last_note_time, keys_x, keys_y, keys, notes, positions, POINTS

    game_ongoing = true
    score = 0
    POINTS = 10
    cursor = Circle(450, 60, 40)
    button = Rect(450, 550, 150, 50)
    reset_button = Rect(200, 350, 150, 50)
    
    last_update_time = time()
    last_note_time = 0.0

    keys_x = [160, 260, 360, 460] # position of each lane
    keys_y = 550 # y position if hitbox

    keys = [Circle(x, keys_y, 45) for x in keys_x] # hitboxes array

    notes = []
    positions = [(160, 0), (260, 0), (360, 0), (460, 0)]
end

reset()
play_sound(music)
#change game state and attributes of the Actors

function update(g::Game)
    if game_ongoing
        
        global last_update_time
        global last_note_time
        current_time = time()
        dt = current_time - last_update_time
        last_update_time = current_time
        
        if current_time - last_note_time > NOTE_INTERVAL
            push!(notes, create_note())
            last_note_time = current_time
        end
        for n in notes
            n.y += NOTE_SPEED * dt * 60 
            if n.y > HEIGHT
                deleteat!(notes, findall(x->x==n,notes)) # delete notes when they go off-screen
                play_sound(miss)
            end
        end
    end
end

# draw actors

function draw(g::Game)
    if game_ongoing

        # draw keys
        for k in keys
            draw(k, colorant"red")
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
        key_text_color = WHITE
        key_text = ["S", "D", "J", "K"]

        for i in eachindex(key_text)
            k = key_text[i]
            t = TextActor("$k", "sourgummy"; font_size = key_text_size, color = key_text_color)
            t.pos = (keys_x[i] - 15, key_text_y)
            draw(t)
        end

        for n in notes
            draw(n, colorant"green", fill=true)
        end
        
        draw(button, colorant"yellow", fill= true)

        #button text
        stop_text = TextActor("Stop", "sourgummy";font_size = 36, color = WHITE)
        stop_text.pos = (480, 550)
        draw(stop_text)

        # score text
        score_text = TextActor("Score: $(score)", "sourgummy";font_size = 36, color = WHITE) 
        score_text.pos = (400, 10)
        draw(score_text)

        # cursor position
        txt = TextActor("x = $(cursor.x) | y = $(cursor.y)", "sourgummy";
            font_size = 36, color = WHITE
        )
        txt.pos = (10, 10)
        draw(txt)

    else
        # Game over screen

        draw(cursor, colorant"blue", fill = true)

        game_over = TextActor("Game Over", "sourgummy"; font_size=50, color=WHITE)
        game_over.pos = (150, 180)
        draw(game_over)

        game_over_score = TextActor("Your score: $score", "sourgummy"; font_size=50, color=WHITE)
        game_over_score.pos = (150, 250)
        draw(game_over_score)

        reset_button_text = TextActor("Reset", "sourgummy"; font_size=40, color=WHITE)
        reset_button_text.pos = (220, 350)
        draw(reset_button, colorant"red", fill= true)
        draw(reset_button_text)
    end

end

# define keyboard inputs

function on_key_down(g::Game, k)
    if !game_ongoing
        return
    end
    global score
    for i in eachindex(notes)
        if collide(notes[i], keys[1]) && k == Keys.S
            score += POINTS
            play_sound(hit)
            deleteat!(notes, i)
            break
        elseif collide(notes[i], keys[2]) && k == Keys.D
            score += POINTS
            play_sound(hit)
            deleteat!(notes, i)
            break
        elseif collide(notes[i], keys[3]) && k == Keys.J
            score += POINTS
            play_sound(hit)
            deleteat!(notes, i)
            break
        elseif collide(notes[i], keys[4]) && k == Keys.K
            score += POINTS
            play_sound(hit)
            deleteat!(notes, i)
            break
        end
    end
end

# define mouse input

function on_mouse_move(g::Game, pos)
    cursor.x = pos[1]
    cursor.y = pos[2]
end

function on_mouse_down(g::Game)
    global game_ongoing
    if game_ongoing
        if collide(cursor, button)
        game_ongoing = false
        println("game stopped")
        end
    else  
        if collide(cursor, reset_button)
        println("reset!")
        reset()
        end
    end
end

function create_note()
    xpos, ypos = rand(positions)
    note = Circle(xpos, ypos, 40)
    return note
end