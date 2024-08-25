--!strict


--> Services ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Modules -------------------------------------------------------------------------------------------
local _Component = script.Parent
local ComponentTypes = require(_Component["Component.Types"])
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Functions -----------------------------------------------------------------------------------------
local function GetBackgroundHandlersFromScope(scope: ComponentTypes.Scope)
  local backgroundHandlers = scope.BackgroundHandlers

  if not backgroundHandlers then
    backgroundHandlers = {
      InputBegan = {},
      InputEnded = {},
      InputChanged = {},
    
      MouseButton1Click = {},
      MouseButton1Down = {},
      MouseButton1Up = {},
    
      MouseButton2Click = {},
      MouseButton2Down = {},
      MouseButton2Up = {},
    
      MouseEnter = {},
      MouseLeave = {},
      MouseMoved = {},
    
      MouseWheelBackward = {},
      MouseWheelForward = {},
    }
    
    scope.BackgroundHandlers = backgroundHandlers
  end

  return backgroundHandlers :: ComponentTypes.BackgroundHandlers
end
-------------------------------------------------------------------------------------------------------


return {
  GetBackgroundHandlersFromScope = GetBackgroundHandlersFromScope
}