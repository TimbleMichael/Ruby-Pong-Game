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
    HEIGHT = 125

    attr_writer :direction
    def initialize(side,movementSpeed)
        @movementSpeed = movementSpeed
        # When initiliased there will be no change in direction
        @direction = nil 

        # Tracking the 'y' value 
        @y = 200

        if side == :left
            @x = 20
        else
            @x = 600
        end
    end

    # Setting up the movement of the PADDLE
    def move
        if @direction == :up
            @y = [@y - @movementSpeed, 0].max
        elsif @direction == :down
            @y = [@y + @movementSpeed, maxY].min
        end
    end

    # Drawing a reactangle with the start position of 'x' and 'y'
    # Setting the 'width', 'height' and 'colour'
    def draw
        Rectangle.new(x: @x, y: @y, width: 25, height: HEIGHT, color: 'white')
    end

    private

    def maxY
        Window.height - HEIGHT
    end

end

class Ball
    HEIGHT = 25
    def initialize
        @x = 320
        @y = 400
        @yVelocity = 1
        @xVelocity = -1
    end

    def draw
        Square.new(x: @x, y: @y, size: HEIGHT, color: 'white')
    end

    def move
        if hitBottom?
            @yVelocity = -@yVelocity
        end
        @x = @x + @xVelocity
        @y = @y + @yVelocity
    end

    private

    def hitBottom?
        @y + HEIGHT >= Window.height
    end
end

# Initialising an INSTANT of PADDLE
player = Paddle.new(:left,5)
opponent = Paddle.new(:right,5)
ball = Ball.new

# Refreshing the paddle for each cycle so that it would be displayed continuously
# 'Clear' was added as to get rid of the old stuff and that the update is continous
update do
    clear

    player.move
    player.draw

    opponent.draw

    ball.move
    ball.draw
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