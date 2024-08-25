--!strict


--> Services ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Modules -------------------------------------------------------------------------------------------
local Modules = script.Parent.Parent.Modules
local Component = require(Modules.Component)
local ThemeHandler = require(Modules.ThemeHandler)

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local ThemeHandlerGet = ThemeHandler.Get
-------------------------------------------------------------------------------------------------------


return Component(function(scope, props: Fusion.PropertyTable)
  local background = scope:New "ImageButton" ({
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = ThemeHandlerGet("Background/Primary"),
  }, props) :: ImageButton

  return background :: Instance
end)

