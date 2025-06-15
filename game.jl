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
const BLACK = Int[0,0,0,255]
const song_duration = 30.0

"""
#r = Rect(xpos, ypos, width, height)
#c = Circle(xpos, ypos, radius)
#l = Line(xpos1, ypos1, xpos2, ypos2)
a = Actor(image.png, xpos, ypos)
"""
#reset global variables

function reset()
    global score, game_ongoing, cursor, button, reset_button, last_update_time,
    last_note_time, keys_x, keys_y, keys, notes, positions, POINTS, combo, song_timer

    game_ongoing = true
    score = 0
    POINTS = 10
    combo = 0
    #cursor = Circle(450, 60, 30)
    cursor = Actor("tiny_ship5.png")
    button = Rect(10, 10, 110, 50)
    reset_button = Rect(200, 350, 200, 80)
    
    last_update_time = time()
    last_note_time = 0.0
    song_timer = 0.0

    keys_x = [115, 215, 315, 415] # position of each lane
    keys_y = 500 # y position of hitbox

    #keys = [Circle(x, keys_y, 45) for x in keys_x] # hitboxes array

    keys = [begin
    a = Actor("planet.png")
    a.x = x
    a.y = keys_y
    a
    end for x in keys_x]

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
        global combo
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
                combo = 0
            end
        end

        global song_timer += dt
        global game_ongoing

        if song_timer >= song_duration
            game_ongoing = false
        end
    end
end

# draw actors

function draw(g::Game)
    # cursor position
    """
    txt = TextActor("x = (cursor.x) | y = (cursor.y)", "sourgummy";
        font_size = 36, color = WHITE
    )
    txt.pos = (10, 10)
    draw(txt)
    """
    if game_ongoing

        # draw keys
        for k in keys
            #draw(k, colorant"red")
            draw(k)
        end 

        # color keys when pressed
        offset = 45
        off_y = keys_y + 45
        if g.keyboard.S
            draw(Circle(keys_x[1] + offset, off_y, 35), colorant"lightblue2", fill=true)
        elseif g.keyboard.D
            draw(Circle(keys_x[2] + offset, off_y, 35), colorant"lightblue2", fill=true)
        elseif g.keyboard.J
            draw(Circle(keys_x[3] + offset, off_y, 35), colorant"lightblue2", fill=true)
        elseif g.keyboard.K
            draw(Circle(keys_x[4] + offset, off_y, 35), colorant"lightblue2", fill=true)
        end

        # keys labels
        key_text_y = keys_y + 15
        key_text_size = 50
        key_text_color = BLACK
        key_text = ["S", "D", "J", "K"]

        for i in eachindex(key_text)
            k = key_text[i]
            t = TextActor("$k", "gravitybold8"; font_size = key_text_size, color = key_text_color)
            t.pos = (keys_x[i] + 15, key_text_y)
            draw(t)
        end

        for n in notes
            draw(n, colorant"cyan", fill=true)
        end
        
        draw(button, colorant"yellow", fill= true)

        #button text
        stop_text = TextActor("Stop", "gravitybold8";font_size = 24, color = BLACK)
        stop_text.pos = (20, 30)
        draw(stop_text)

        # score text
        score_text = TextActor("Score: $(score)", "gravityregular5";font_size = 20, color = WHITE) 
        score_text.pos = (350, 10)
        draw(score_text)

        # combo text
        combo_text = TextActor("x$combo", "gravitybold8"; font_size=24, color = WHITE)
        combo_text.pos = (250, 50)
        draw(combo_text)

    else
        # Game over screen

        #draw(cursor, colorant"blue", fill = true)
        draw(cursor)

        game_over = TextActor("Game Over", "gravitybold8"; font_size=48, color=WHITE)
        game_over.pos = (110, 180)
        draw(game_over)

        game_over_score = TextActor("Your score: $score", "gravityregular5"; font_size=35, color=WHITE)
        game_over_score.pos = (10, 250)
        draw(game_over_score)

        reset_button_text = TextActor("Reset", "gravitybold8"; font_size=40, color=WHITE)
        reset_button_text.pos = (215, 370)
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
    global combo
    for i in eachindex(notes)
        if !(notes[i].y >= 400)
            break
        else
            if collide(notes[i], keys[1]) && k == Keys.S
                combo += 1
                score += POINTS * combo
                play_sound(hit)
                deleteat!(notes, i)
                break
            elseif collide(notes[i], keys[2]) && k == Keys.D
                combo += 1
                score += POINTS * combo
                play_sound(hit)
                deleteat!(notes, i)
                break
            elseif collide(notes[i], keys[3]) && k == Keys.J
                combo += 1
                score += POINTS * combo
                play_sound(hit)
                deleteat!(notes, i)
                break
            elseif collide(notes[i], keys[4]) && k == Keys.K
                combo += 1
                score += POINTS * combo
                play_sound(hit)
                deleteat!(notes, i)
                break
            end
    end
    end
end

# define mouse input

function on_mouse_move(g::Game, pos)
    cursor.x = pos[1] - 25
    cursor.y = pos[2] - 30
end

function on_mouse_down(g::Game)
    global game_ongoing
    if game_ongoing
        if collide(cursor, button)
        game_ongoing = false
        end
    else  
        if collide(cursor, reset_button)
        reset()
        end
    end
end

function create_note()
    xpos, ypos = rand(positions)
    note = Circle(xpos, ypos, 40)
    return note
end