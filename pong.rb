# The requried library for 2D game
require 'ruby2d'

# Setting background COLOUR and TITLE
set background: 'balck'
set title: 'Pong'

# Setting the PADDLE class
# Which rquires a parameter "SIDE" to be fed
# IF ':left' is chosen, then the x-coordinate will be 20-pixels from the LEFT
# ELSE (':left' is not chosen), the x-coordinate will be 620-pixels from the LEFT
class Paddle
    attr_writer :direction
    def initialize(side)
        # When initiliased there will be no change in direction
        @direction = nil 

        # Tracking the 'y' value 
        @y = 200

        if side == :left
            @x = 20
        else
            @x = 620
        end
    end

    # Setting up the movement of the PADDLE
    def move
        if @direction == :up
            @y -= 1
        elsif @direction == :down
            @y += 1
        end
    end

    # Drawing a reactangle with the start position of 'x' and 'y'
    # Setting the 'width', 'height' and 'colour'
    def draw
        Rectangle.new(x: @x, y: @y, width: 25, height: 100, color: 'white')
    end



end

# Initialising an INSTANT of PADDLE
player = Paddle.new(:left)

# Refreshing the paddle for each cycle so that it would be displayed continuously
update do
    clear

    player.move
    player.draw
end

# Move player when key is pressed
on :key_down do |event|
    if event.key == 'up'
        player.direction = :up
    elsif event.key == 'down'
        player.direction = :down
    end
end


# Stop player moevement when key is released
on :key_up do |event|
    player.direction = nil
end


show