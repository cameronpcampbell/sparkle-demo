--!strict
--!nolint LocalUnused
--!nolint LocalShadow
local task = nil -- Disable usage of Roblox's task scheduler

--[[
	Constructs and returns a new instance, with options for setting properties,
	event handlers and other attributes on the instance right away.
]]


--> Modules -------------------------------------------------------------------------------------------
local Package = script.Parent.Parent
local Types = require(Package.Types)
local External = require(Package.External)
local defaultProps = require(Package.Instances.defaultProps)
local applyInstanceProps = require(Package.Instances.applyInstanceProps)
local Children = require(Package.Instances.Children)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
type Component = (Types.PropertyTable) -> Instance
-------------------------------------------------------------------------------------------------------


--> Private Functions ---------------------------------------------------------------------------------
local function CombineProps(...: Types.PropertyTable): Types.PropertyTable
	local combinedProps: Types.PropertyTable = {}
	local combinedChildren: { Instance } = {}

	for i = 1, select("#", ...) do
		local propTble = select(i, ...)

		for propName,propValue in propTble do

			if propName == Children then
				if typeof(propValue) == "table" and not propValue.kind then
					for _,child in propValue do table.insert(combinedChildren, child) end
				else
					table.insert(combinedChildren, propValue)
				end
				continue
			end

			combinedProps[propName] = propValue
		end
	end

	if #combinedChildren then
		combinedProps[Children] = combinedChildren
	end

	return combinedProps
end
-------------------------------------------------------------------------------------------------------


local function New(
	scope: Types.Scope<unknown>,
	className: string
)
	if (className :: any) == nil then
		local scope = (scope :: any) :: string
		External.logError("scopeMissing", nil, "instances using New", "myScope:New \"" .. scope .. "\" { ... }")
	end

	-- This might look appealing to try and cache. But please don't. The scope
	-- upvalue is shared between the two curried function calls, so this will
	-- open incredible cross-codebase wormholes like you've never seen before.
	return function(
		...: Types.PropertyTable
	): Instance
		local ok, instance = pcall(Instance.new, className)
		if not ok then
			External.logError("cannotCreateClass", nil, className)
		end

		local props = CombineProps(...)

		local classDefaults = defaultProps[className]
		if classDefaults ~= nil then
			for defaultProp, defaultValue in pairs(classDefaults) do
				(instance :: any)[defaultProp] = defaultValue
			end
		end

		table.insert(scope, instance)
		applyInstanceProps(scope, props, instance)

		return instance
	end
end

return New