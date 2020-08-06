require('constants')

function initializeRacket()
    local racket = {}
    racket.speedX = 400
    racket.width = WIN_WIDTH / 4
    racket.height = WIN_HEIGHT / 37
    racket.x = (WIN_WIDTH-racket.width) / 2
    racket.y = WIN_HEIGHT - 64
    return racket
end

function createBrick(line, column)
    local brick = {}
    brick.isNotBroken = true
    brick.width = WIN_WIDTH / BRICKS_PER_LINE - 5
    brick.height = WIN_HEIGHT / 35
    brick.x = 2.5 + (column-1) * (5+brick.width)
    brick.y = line * (WIN_HEIGHT/35+2.5)
    return brick
end

function initializeBricks()
    local bricks = {}
    for line=1, BRICKS_PER_COLUMN do
        table.insert(bricks, {})
        for column=1, BRICKS_PER_LINE do
            local brick = createBrick(line, column)
            table.insert(bricks[line], brick)
        end
    end
    return bricks
end

function initializeLives()
    local lives = {}
    lives.count = NB_LIVES
    lives.img = love.graphics.newImage(PATH_LIFE)
    lives.width, lives.height = lives.img:getDimensions()
    return lives
end

function initializeBall(racketHeight, racketY)
    local ball = {}
    ball.width, ball.height = racketHeight * 0.75, racketHeight * 0.75
    ball.speedY = -DEFAULT_SPEED_BY
    ball.speedX = math.random(-DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
    ball.x = WIN_WIDTH / 2 - ball.width / 2
    ball.y = racketY - 2 * ball.height - ball.height / 2
    return ball
end

function resetRacket(racket)
    racket.x = (WIN_WIDTH-racket.width) / 2
    racket.y = WIN_HEIGHT - 64
    return racket
end

function resetBall(racket, ball)
    ball.speedY = -DEFAULT_SPEED_BY
    ball.speedX = math.random(-DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
    ball.x = WIN_WIDTH / 2 - ball.width / 2
    ball.y = racket.y - 2 * ball.height - ball.height / 2
    return ball
end