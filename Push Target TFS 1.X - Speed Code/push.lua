--[[
	Explosive Shot
	- Cria um tiro explosivo que empurra o inimigo para trás.
	Requer: createPath(pos_a, pos_b, steps)
]]--

function pushTarget(cid, target)
	local cid_position = cid:getPosition()
	local target_position = target:getPosition()
	local distance = getDistanceBetween(cid_position, target_position)
	local path = createPath(cid_position, target_position, distance + 1)
	local push_position = path[#path]
	if Tile(push_position) and Tile(push_position):isWalkable() and Tile(push_position):getCreatureCount() == 0 then
		target:teleportTo(push_position, true)
	end
end

function onCastSpell(cid, var)
	local target = cid:getTarget()
	local target_position = target:getPosition()
	local cid_position = cid:getPosition()
	doSendDistanceShoot(cid_position, target_position, CONST_ANI_EXPLOSION)
	doSendMagicEffect(target_position, CONST_ME_EXPLOSIONAREA)
	doTargetCombat(cid, target, COMBAT_PHYSICALDAMAGE, -400, -600)
	pushTarget(cid, target)
	return true
end