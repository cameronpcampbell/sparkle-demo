--!strict


--> Services ------------------------------------------------------------------------------------------
local StarterGui = game:GetService("StarterGui")
-------------------------------------------------------------------------------------------------------


--> Modules -------------------------------------------------------------------------------------------
local Modules = script.Parent.Parent.Modules
local PluginHandler = require(Modules.PluginHandler)

local _Component = Modules.Component
local Component = require(_Component)
local ComponentUtils = require(_Component["Component.Utils"])

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)

local Components = script.Parent.Parent.Components
local Background = require(Components.Background)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
type WindowSettingsProps = {
	Id: string,
  Title: string | Fusion.Value<string> | Fusion.Computed<string>?,
	InitDockState: Enum.InitialDockState?,
	InitEnabled: boolean?,
	OverrideEnabledRestore: boolean?,
	FloatXSize: number?,
	FloatYSize: number?,
	MinWidth: number?,
	MinHeight: number?,
	DebugMode: boolean?
}
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local GetBackgroundHandlersFromScope = ComponentUtils.GetBackgroundHandlersFromScope 

local GetPlugin = PluginHandler.GetPlugin

local Children = Fusion.Children

local EventsTypes = {
  "InputBegan", "InputEnded", "InputChanged",
  "MouseEnter", "MouseLeave", "MouseMoved",
  "MouseWheelBackward", "MouseWheelForward"
}
-------------------------------------------------------------------------------------------------------


--> Private Functions ---------------------------------------------------------------------------------
local function CleanUpBackgroundConns(backgroundConns: Component.BackgroundConns)
  return function()
    for _,conn in (backgroundConns :: any) :: { RBXScriptConnection } do
      conn:Disconnect()
    end
  end
end

local function GetBackgroundConnsFromScope(scope: Component.Scope)
  local backgroundConns = scope.BackgroundConns

  if not backgroundConns then
    backgroundConns = {}
    scope.BackgroundConns = backgroundConns

    table.insert(scope, CleanUpBackgroundConns((backgroundConns :: any) :: { RBXScriptConnection }))
  end

  return (backgroundConns :: any) :: Component.BackgroundConns
end

local function BackgroundOnEvent(background: Instance, eventType: Component.EventType, handlerFns: { Component.BackgroundHandler })
  return ((background :: any)[eventType] :: RBXScriptSignal):Connect(function(...)
    for _,handlerFn in handlerFns do handlerFn(...) end
  end)
end
-------------------------------------------------------------------------------------------------------


return Component(function(scope, props: WindowSettingsProps)
  local id, title, initDockState, initEnabled, overrideEnabledRestore, floatXSize, floatYSize, minWidth, minHeight = 
	  props.Id, props.Title, props.InitDockState, props.InitEnabled, props.OverrideEnabledRestore,
    props.FloatXSize, props.FloatYSize, props.MinWidth, props.MinHeight

  local widget = GetPlugin():CreateDockWidgetPluginGui(id, DockWidgetPluginGuiInfo.new(
    initDockState or Enum.InitialDockState.Float, initEnabled or true, overrideEnabledRestore or true,
    floatXSize or 0, floatYSize or 0,
    minWidth or floatXSize or 0, minHeight or floatYSize or 0
  ))

  local root = scope:New "Frame" {
    Size = UDim2.fromScale(1, 1),
    ZIndex = 999,
    BackgroundTransparency = 1,
    Active = false,
    Selectable = false,
    Name = "Widget:Root"
  }

  local content = Background {
    Scope = scope,

    [Children] = {
      root,

      scope:New "Frame" {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Name = "Widget:Content",
    
        [Children] = props[Children]
      }
    }
  }

  if debug then
    local debugGuiName = `UI_KIT_DEBUG[{id}]`
    local found = StarterGui:FindFirstChild(debugGuiName)
    if found then found:Destroy() end

    scope:New "ScreenGui" {
      Parent = StarterGui,
      Name = debugGuiName,
      [Children] = content:Clone()
    }
  end

  local backgroundConns = GetBackgroundConnsFromScope(scope)
  local backgroundHandlers = GetBackgroundHandlersFromScope(scope)

  for _,eventType in EventsTypes do
    table.insert(backgroundConns, BackgroundOnEvent(root, eventType :: Component.EventType, backgroundHandlers[eventType]))
  end

  return scope:Hydrate(widget) {
    Title = title or id,
    [Children] = content,
  }
end)