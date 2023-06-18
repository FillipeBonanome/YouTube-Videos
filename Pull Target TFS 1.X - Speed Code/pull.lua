--[[
	Deah Hand
	- Puxa o target e causa dano de mort.
	Requer: createPath(pos_a, pos_b, steps)
]]--

function pullTarget(cid, target)
	local cid_position = cid:getPosition()
	local target_position = target:getPosition()
	local path = createPath(target_position, cid_position, 1)
	local pull_position = path[#path]
	if Tile(pull_position) and Tile(pull_position):isWalkable() and Tile(pull_position):getCreatureCount() == 0 then
		target:teleportTo(pull_position, true)
	end
end

function onCastSpell(cid, var)
	local target = cid:getTarget()
	local target_position = target:getPosition()
	local cid_position = cid:getPosition()
	doSendDistanceShoot(target_position, cid_position, CONST_ANI_SUDDENDEATH)
	doTargetCombat(cid, target, COMBAT_DEATHDAMAGE, -400, -600)
	pullTarget(cid, target)
	return true
end