RegisterNetEvent('car_parts:lib_timer')
AddEventHandler('car_parts:lib_timer',function(time, data)
	-- if lib.progressCircle({
	if lib.progressBar({
		duration = time,
        label = data.label,
		position = 'middle',
		allowRagdoll = true,
		allowSwimming = true,
		allowFalling = true,
		useWhileDead = false,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
			sprint = true,
		},
		anim = {
			dict = data.lib,
			clip = data.anim
		},
		prop = {
			model = data.prop,
			pos = vec3(0.13, 0.04, 0.02),
			rot = vec3(0.0, 0.0, -1.5)
		},

	})
	then
		-- print('complete')
		if data.type == 'client' then
			TriggerClientEvent(data.event)
		else
			TriggerServerEvent(data.event,event_val_1,event_val_2)
		end
	else
		-- print('not complete')
        return
		-- if data.type == 'client' then
		-- 	TriggerClientEvent(data.cancelevent)
		-- else
		-- 	TriggerServerEvent(data.cancelevent)
		-- end
	end
end)

function lib_timer(data)
	-- if lib.progressCircle({
	if lib.progressBar({
		duration = data.time,
        label = data.label,
		position = 'middle',
		allowRagdoll = true,
		allowSwimming = true,
		allowFalling = true,
		useWhileDead = false,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
			sprint = true,
		},
		anim = {
			dict = data.lib,
			clip = data.anim
		},
		prop = {
			model = data.prop,
			pos = vec3(0.13, 0.04, 0.02),
			rot = vec3(0.0, 0.0, -1.5)
		},

	})
	then
		return true
	else
        return false
	end
end
exports("lib_timer",lib_timer)