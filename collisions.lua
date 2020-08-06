
function collideRect(rect1, rect2)
    if rect1.x < rect2.x + rect2.width and
       rect1.x + rect1.width > rect2.x and
       rect1.y < rect2.y + rect2.height and
       rect1.height + rect1.y > rect2.y then
         return true
    end
    return false
end

function collisionBallWithRacket(racket, ball, soundRacket)
    soundRacket:play()
    -- Collision gauche
    if ball.x < racket.x + 1/8 * racket.width and ball.speedX >= 0 then
      if ball.speedX <= DEFAULT_SPEED_BX/2 then
        ball.speedX = -math.random(0.75*DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
      else
        ball.speedX = -ball.speedX
      end
    -- Collision droite
    elseif ball.x > racket.x + 7/8 * racket.width and ball.speedX <= 0 then
      if ball.speedX >= -DEFAULT_SPEED_BX/2 then
        ball.speedX = math.random(0.75*DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
      else 
        ball.speedX = -ball.speedX
      end
    end
    -- Collision haut
    if ball.y < racket.y and ball.speedY > 0 then
      ball.speedY = -ball.speedY
  end
  return ball
end


function collisionBallWithBrick(ball, brick, nbBricks, soundBrick)
    soundBrick:play()
    -- Collision gauche
    if ball.x < brick.x and ball.speedX > 0 then
        ball.speedX = -ball.speedX
    -- Collision droit
    elseif ball.x > brick.x + brick.width and ball.speedX < 0 then
        ball.speedX = -ball.speedX
    end
    -- Collision haut
    if ball.y < brick.y and ball.speedY > 0 then
      ball.speedY = -ball.speedY
    -- Collision bas
    elseif ball.y > brick.y and ball.speedY < 0 then
      ball.speedY = -ball.speedY
    end
    brick.isNotBroken = false
    nbBricks = nbBricks - 1
    return ball, brick, nbBricks
end