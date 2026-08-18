local funcs = {}
function funcs.SwitchState(newState)
	State = newState
	if State.load then State.load() end
end
return funcs
