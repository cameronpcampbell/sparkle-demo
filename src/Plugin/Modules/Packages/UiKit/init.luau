--!strict


--> Services ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Modules -------------------------------------------------------------------------------------------
local Modules = script.Modules
local PluginHandler = require(Modules.PluginHandler)

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)

local Components = script.Components
local CoreComponents = Components.Core
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Private Functions ---------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


return {
  Fusion = Fusion,
  SetPlugin = PluginHandler.SetPlugin,

  -- Plugins.
  Widget = require(Components.Widget),

  -- Wrappers.
  Background = require(Components.Background),
  Container = require(Components.Container),
  Accordion = require(Components.Accordion),

  -- Labels.
  TextLabel = require(CoreComponents.TextLabel),
  CodeLabel = require(CoreComponents.CodeLabel),

  -- Inputs.
  TextInput = require(Components.TextInput),

  -- Buttons.
  Button = require(Components.Button),
  Switch = require(Components.Switch),
  Slider = require(Components.Slider),

  Progress = require(Components.Progress),
}