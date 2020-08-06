require('constants')

function love.conf(t)
    t.window.title = TITLE -- Change le titre de la fenêtre
    t.window.icon = PATH_ICON -- Change l'icone de la fenêtre
    t.window.width = WIN_WIDTH -- Change la largeur de la fenêtre
    t.window.height = WIN_HEIGHT -- Change la hauteur de la fenêtre
end