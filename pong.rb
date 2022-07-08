# The requried library for 2D game
require 'ruby2d'

# Setting background COLOUR and TITLE
set background: 'balck'
set title: 'Pong'

# Setting the PADDLE class
# Which rquires a parameter "SIDE" to be fed
# IF ':left' is chosen, then the x-coordinate will be 20-pixels from the LEFT
# ELSE (':left' is not chosen), the x-coordinate will be 600-pixels from the LEFT
# HEIGHT of paddle
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
    # Having an array will ensure that when the bottom and top is hit it will stop and won;t go through.
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
        @shape = Rectangle.new(x: @x, y: @y, width: 25, height: HEIGHT, color: 'white')
    end


    # Method for when the Ball hits the Paddle
    # So, if the cooridnates of the ball are int he bounds of the paddel then it will bounce off the paddle
    def hitBall(ball)
        ball.shape && [[ball.shape.x1, ball.shape.y1], [ball.shape.x2, ball.shape.y2], [ball.shape.x3, ball.shape.y3], [ball.shape.x4, ball.shape.y4]].any? do |coordinates|
            @shape.contains?(coordinates[0],coordinates[1])
        end
    end

    def trackBall(ball)
        if ball.yMiddle > yMiddle
            @y += @movementSpeed
        elsif ball.yMiddle < yMiddle
            @y -= @movementSpeed
        end
    end

    private

    def yMiddle
        @y + (HEIGHT/2) 
    end

    # Private method which can only be called within the class itslef, i.e. 'maxY' method can only be called in class 'Paddle'
    private
    def maxY
        Window.height - HEIGHT
    end

end

# New class for 'Ball'
class Ball
    HEIGHT = 25

    attr_reader :shape
    def initialize(speed)
        @x = 320
        @y = 400
        @yVelocity = speed
        @xVelocity = -speed
    end


    # The 'draw' method for the ball
    # Strating at @x and @y positions when initialised
    def draw
        @shape = Square.new(x: @x, y: @y, size: HEIGHT, color: 'white')
    end

    def bounce
        @xVelocity = -@xVelocity
    end

    def yMiddle
        @y + (HEIGHT/2)
    end

    def outOfBounds
        @x <= 0 || @shape.x2 >= Window.width
    end

    # The 'move' method allows the ball to move freely at a given @xVelocity and @yVelcoity
    # i.e. the @x position will change at the rate of @xVelocity and @y position will change at the rate of @yVelocity
    # Conditional statement added for behaviour when hitBottom, it simply reverses the velocity
    def move
        if hitBottom || hitTop
            @yVelocity = -@yVelocity
        end
        @x = @x + @xVelocity
        @y = @y + @yVelocity
    end

    private
    # A private method for behaviour of ball when it hits bottom
    # So, wherver its position is, '@y', + its HEIGHT, height of ball, >= height of Window = 480
    def hitBottom
        @y + HEIGHT >= Window.height
    end

    def hitTop
        @y <= 0
    end
end

ballVelocity = 6

# Initialising an INSTANT of PADDLE
player = Paddle.new(:left,5)
opponent = Paddle.new(:right,5)

# Initialising an INSTANT of BALL
ball = Ball.new(ballVelocity)

# Refreshing the paddle for each cycle so that it would be displayed continuously
# 'Clear' was added as to get rid of the old stuff and that the update is continous
update do
    clear

    if player.hitBall(ball) || opponent.hitBall(ball)
        ball.bounce
    end

    player.move
    player.draw

    opponent.draw
    opponent.trackBall(ball)

    ball.move
    ball.draw

    if ball.outOfBounds
        ball = Ball.new(ballVelocity)
    end
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