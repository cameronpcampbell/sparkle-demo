--!strict

local _Plugin: Plugin = nil

return {
	GetPlugin = function() return _Plugin end,
	SetPlugin = function(_plugin: Plugin)
		_Plugin = _plugin
		_Plugin:Activate(true)
	end
}