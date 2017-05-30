-- Modes utilisables !
-- "boucle"     : Pour une vraie boucle, pensez a ajouter en dernier un segment qui rejoint les points de départ.
-- "goAndBack"
-- "oneTime"

paths = {}
paths.liste = {}

function paths.add(pX, pY, pDuree)
  local path = {}
  path.run = true
  path.startX = pX
  path.startY = pY
  path.duree = pDuree
  path.timerPositif = true
  path.timer = 0
  path.mode = "boucle"
  path.longueur = 0
  path.segments = {}
  table.insert(paths.liste, path)
  return path
end

function paths.addSegment(pPath, pX, pY)
  local segment = {}
  if pPath.longueur == 0 then
    segment.x1 = pPath.startX
    segment.y1 = pPath.startY
  else
    segment.x1 = pPath.segments[#pPath.segments].x2
    segment.y1 = pPath.segments[#pPath.segments].y2
  end
  segment.x2 = pX
  segment.y2 = pY
  segment.startTime = 0
  segment.endTime = 0
  segment.duree = 0
  segment.angle = math.atan2(segment.x2 - segment.x1, segment.y2 - segment.y1)
  segment.longueur = math.sqrt((segment.x1 - segment.x2)^2 + (segment.y1 - segment.y2)^2)
  pPath.longueur = pPath.longueur + segment.longueur
  table.insert(pPath.segments, segment)
  local duree = 0
  for i=1,#pPath.segments do
    pPath.segments[i].startTime = duree
    pPath.segments[i].duree = (pPath.segments[i].longueur / pPath.longueur) * pPath.duree
    pPath.segments[i].endTime = pPath.segments[i].startTime + pPath.segments[i].duree
    duree = duree + pPath.segments[i].duree
  end
end

function paths.getSegment(pPath)
  for i=1,#pPath.segments do
    local segment = pPath.segments[i]
    if pPath.timer >= segment.startTime and pPath.timer <= segment.endTime then
      return segment
    end
  end
  return false, "Segment non trouvé"
end

function paths.getPosition(pPath)
  local segment = paths.getSegment(pPath)
  local time = pPath.timer - segment.startTime
  local track = segment.longueur * (time/segment.duree)
  local X = segment.x1 + math.sin(segment.angle) * track
  local Y = segment.y1 + math.cos(segment.angle) * track
  return X,Y,segment.angle
end

function paths.setMode(pPath, pMode)
  if pMode == "boucle" or pMode == "goAndBack" or pMode == "oneTime" then
    pPath.mode = pMode
    return true
  end
  return false
end

function paths.restart(pPath)
  pPath.timer = 0
  pPath.run = true
end

function paths.start(pPath)
  pPath.run = true
end

function paths.stop(pPath)
  pPath.run = false
end

function paths.updateTimer(pPath, dt)
  if not pPath.run then 
    return 
  end
  if pPath.timerPositif then
    pPath.timer = pPath.timer + dt
  else
    pPath.timer = pPath.timer - dt
  end
  
  if (pPath.timer > pPath.duree) or (pPath.timer < 0) then
    if pPath.mode == "boucle" then
      pPath.timer = 0
    end
    if pPath.mode == "goAndBack" then
      pPath.timerPositif = not pPath.timerPositif
      if pPath.timer > pPath.duree then 
        pPath.timer = pPath.duree
      else
        pPath.timer = 0
      end
    end
    if pPath.mode == "oneTime" then
      pPath.timer = pPath.duree
      pPath.run = false
    end
  end
end
