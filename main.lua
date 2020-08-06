require('collisions')
require('init')

-- pour debug
io.stdout:setvbuf('no')

local lives -- les vies
local bricks -- les briques
local racket -- la raquette
local ball -- la balle
local nbBricks = BRICKS_PER_COLUMN * BRICKS_PER_LINE -- nombre de briques
local currentPage = PAGE_BEGINNING -- page courante
local font -- police d'écriture
local soundBrick -- son brique
local soundRacket -- son raquette

function love.load()
    font = love.graphics.newFont(32)
    love.graphics.setFont(font)
    soundBrick = love.audio.newSource(PATH_SOUND_BRICK, "static")
    soundRacket = love.audio.newSource(PATH_SOUND_RACKET, "static")
    racket = initializeRacket()
    bricks = initializeBricks()
    lives = initializeLives()
    ball = initializeBall(racket.height, racket.y)
end

function love.update(dt)
    if currentPage == PAGE_ROUND then
        -- android touch
        local touches = love.touch.getTouches()
        for _, touch in ipairs(touches) do
            local tx, ty = love.touch.getPosition(touch)
            if tx < WIN_WIDTH/2 and racket.x > 0 then
                racket.x = racket.x - (racket.speedX*dt)
            elseif tx > WIN_WIDTH/2 and racket.x + racket.width < WIN_WIDTH then
                racket.x = racket.x + (racket.speedX*dt)
            end
        end

        -- keyboard touch
        if love.keyboard.isDown('left', 'q', 'a') and racket.x > 0 then
            racket.x = racket.x - (racket.speedX*dt)
        elseif love.keyboard.isDown('right', 'd', 'e') and racket.x + racket.width < WIN_WIDTH then
            racket.x = racket.x + (racket.speedX*dt)
        end

        -- update ball
        ball.x = ball.x + ball.speedX * dt
        ball.y = ball.y + ball.speedY * dt

        if ball.x + ball.width >= WIN_WIDTH then  -- Bordure droite
            ball.speedX = -ball.speedX
        elseif ball.x <= 0 then -- Bordure gauche
            ball.speedX = -ball.speedX
        end
        
        if ball.y <= 0 then  -- Bordure haut
            ball.speedY = -ball.speedY
        elseif ball.y + ball.height >= WIN_HEIGHT then -- Bordure bas
            lives.count = lives.count - 1
            resetBall(racket, ball)
        end

        if collideRect(ball, racket) then
            ball = collisionBallWithRacket(racket, ball, soundRacket)
        end

        for line=#bricks, 1, -1 do
            for column=#bricks[line], 1, -1 do
                if bricks[line][column].isNotBroken and collideRect(ball, bricks[line][column]) then
                    ball, bricks[line][column], nbBricks = collisionBallWithBrick(ball, bricks[line][column], nbBricks, soundBrick)
                end
            end
        end

        if lives.count == 0 or nbBricks == 0 then
            currentPage = PAGE_END -- Page de fin
        end
    end
end

function love.draw()

    local scale = love.graphics.getWidth() / WIN_WIDTH
    local scaleY = love.graphics.getHeight() / WIN_HEIGHT
    if scaleY < scale then scale = scaleY end
    love.graphics.scale(scale)

    if currentPage == PAGE_BEGINNING then
        -- Traitement page début
        love.graphics.printf("Casse-briques", 0, 0.25*WIN_HEIGHT, WIN_WIDTH, "center") -- Écriture
        love.graphics.printf("Appuyez pour commencer", 0, 0.45*WIN_HEIGHT, WIN_WIDTH, "center") -- Écriture
    elseif currentPage == PAGE_ROUND then
        -- Fonction pour dessiner (appelée à chaque frame)
        love.graphics.setColor(255, 255, 255) -- Couleur blanche
        love.graphics.rectangle('fill', racket.x, racket.y, racket.width, racket.height) -- Rectangle

        for line=1, #bricks do -- Ligne
            for column=1, #bricks[line] do -- Colonne
                local brick = bricks[line][column]
                if brick.isNotBroken then -- Si la brique n'est pas cassée
                    love.graphics.rectangle('fill', brick.x, brick.y, brick.width, brick.height) -- Rectangle
                end
            end
        end

        for i=0, lives.count-1 do -- Pour chaque vie
            local posX = 5 + i * 1.20 * lives.width -- Calcul de la position en abscisse
            love.graphics.draw(lives.img, posX, WIN_HEIGHT-lives.height) -- Affichage de l'image
        end


        love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height) -- Rectangle

    elseif currentPage == PAGE_END then
        -- Traitement page fin
        local message = "Victoire !"
        if lives.count == 0 then
        message = "Défaite !"
        end
        love.graphics.printf(message, 0, 0.25*WIN_HEIGHT, WIN_WIDTH, "center") -- Écriture
        love.graphics.printf("Appuyez pour recommencer", 0, 0.45*WIN_HEIGHT, WIN_WIDTH, "center") -- Écriture
        
    end
end

function love.keypressed(key)
    if key ~= "escape" then
        if currentPage == PAGE_BEGINNING then
            currentPage = PAGE_ROUND
        end

        if currentPage == PAGE_END then
            racket = resetRacket(racket)
            -- Réinitialisation des briques
            for line=1, #bricks do
                for column=1, #bricks[line] do
                bricks[line][column].isNotBroken = true
                end
            end
            lives.count = NB_LIVES -- Réinitialisation des vies
            nbBricks = BRICKS_PER_COLUMN * BRICKS_PER_LINE -- Réinitialisation du nombre de briques
            resetBall(racket, ball) -- Réinitialisation de la balle
            currentPage = PAGE_ROUND
        end
    end

    if key == "escape" then
        love.event.quit() -- Pour quitter le jeu
    end
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    if currentPage == PAGE_BEGINNING then
        currentPage = PAGE_ROUND -- Page jeu
    end

    if currentPage == PAGE_END then
        racket = resetRacket(racket)
        -- Réinitialisation des briques
        for line=1, #bricks do
            for column=1, #bricks[line] do
            bricks[line][column].isNotBroken = true
            end
        end
        lives.count = NB_LIVES -- Réinitialisation des vies
        nbBricks = BRICKS_PER_COLUMN * BRICKS_PER_LINE -- Réinitialisation du nombre de briques
        resetBall(racket, ball) -- Réinitialisation de la balle
        currentPage = PAGE_ROUND
    end
end
