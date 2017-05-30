nodes = {}
nodes.liste = {}

-- Ajoute un node dont le point central est à la position pX, pY. l'écart entre les points entrés est de pW de large et pH de haut
-- retourne le node après son insertion dans la liste nodes.liste
function nodes.add(pX, pY, pW, pH)
  local node = {}
  node.x = pX
  node.y = pY
  node.angle = 0
  node.count = 0
  node.positions = {}
  node.positions.width = pW
  node.positions.height = pH
  node.positions.liste = {}
  table.insert(nodes.liste, node)
  return node
end

-- Supprime un node pNode de la liste nodes.liste et retourne true en cas de succès, false sinon. Retourne également un texte selon le résultat.
function nodes.delete(pNode)
  for i=#nodes.liste,1,-1 do
    if nodes.liste[i] == pNode then
      table.remove(nodes.liste, i)
      return true,"Node deleted"
    end
  end
  return false, "Node not Found"
end

-- retourne un node en fonction de son numéro d'indice, 0 sinon. Retourne également un texte selon le résultat.
function nodes.get(numero)
  if numero <= #nodes.liste then
    return nodes.liste[numero],"Node found"
  end
  return 0,"Node not found"
end

-- retourne l'indice d'un node pNode, 0 sinon. Retourne également un texte selon le résultat.
function nodes.getNumber(pNode)
  for i=1,#nodes.liste do
    if nodes.liste[i] == pNode then
      return i,"Node found"
    end
  end
  return 0, "Node not Found"
end

-- Ajoute une position dans le node pNode a la position relatice pX, pY.
function nodes.nodeAddPosition(pNode, pX, pY)
  local position = {}
  local xr = pNode.positions.width * pX
  local yr = pNode.positions.height * pY
  position.distance = math.sqrt(xr^2 + yr^2)
  position.angle = math.atan2(xr, yr)
  position.x = pNode.x + xr
  position.y = pNode.y + yr
  table.insert(pNode.positions.liste, position)
  pNode.count = pNode.count + 1
  return position
end

function nodes.nodeDeletePosition(pNode, pPosition)
  for i=#pNode.positions.liste,1,-1 do
    if pNode.positions.liste[i] == pPosition then
      table.remove(pNode.positions.liste, i)
      pNode.count = pNode.count - 1
      return true,"Position deleted"
    end
  end
  return false, "Position not found"
end

function nodes.nodeGetPosition(pNode, numero)
  if numero <= #pNode.positions then
    return pNode.positions[numero],"Position found"
  end
  return 0,"Position not found"
end

function nodes.nodeGetPositionNumber(pNode, pPosition)
  for i=1,#pNode.positions do
    if pNode.positions[i] == pPosition then
      return i,"Position found"
    end
  end
  return 0, "Position not Found"
end

function nodes.GetX(pNode, pNumber)
  return pNode.positions.liste[pNumber].x
end

function nodes.GetY(pNode, pNumber)
  return pNode.positions.liste[pNumber].y
end

function nodes.GetPosition(pNode, pNumber)
  return pNode.positions.liste[pNumber].x,pNode.positions.liste[pNumber].y
end

function nodes.update()
  for i=1,#nodes.liste do
    local node = nodes.liste[i]
    for j=1,#node.positions.liste do
      local position = node.positions.liste[j]
      position.x = node.x + math.sin(node.angle + position.angle) * ( position.distance )
      position.y = node.y + math.cos(node.angle + position.angle) * ( position.distance )
    end
  end
end
