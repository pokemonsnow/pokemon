filename = 'OTP'
loaded = false

function init()
  connect(g_game, { onClientVersionChange = load })
end

function terminate()
  disconnect(g_game, { onClientVersionChange = load })
end

function setFileName(name)
  filename = name
end

function isLoaded()
  return loaded
end

function load()
  local version = g_game.getClientVersion()
  local datPath = resolvepath(version .. '/' .. filename .. '.Arquivo DAT')
  local sprPath = resolvepath(version .. '/' .. filename .. '.Sprites File')

  local errorMessage = ''
  if not g_things.loadDat(datPath) then
    errorMessage = errorMessage .. tr("Unable to load dat file, please place a valid dat in '%s'", datPath) .. '\n'
  end
  if not g_sprites.loadSpr(sprPath) then
    errorMessage = errorMessage .. tr("Unable to load spr file, please place a valid spr in '%s'", sprPath)
  end

  loaded = (errorMessage:len() == 0)

  if errorMessage:len() > 0 then
    local messageBox = displayErrorBox(tr('Error'), errorMessage)
    addEvent(function() messageBox:raise() messageBox:focus() end)

    disconnect(g_game, { onClientVersionChange = load })
    g_game.setClientVersion(0)
    connect(g_game, { onClientVersionChange = load })
  end
end
