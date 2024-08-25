--!strict


--> Services ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Modules -------------------------------------------------------------------------------------------
local Components = script.Parent
local CoreComponents = Components.Core
local Squircle = require(CoreComponents.Squircle)

local Modules = script.Parent.Parent.Modules
local Component = require(Modules.Component)
local ThemeHandler = require(Modules.ThemeHandler)
local ComputeTransforms = require(Modules.ComputeTransforms)
local TableUtils = require(Modules.TableUtils)

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
type TextInputProps = {
  Width: Fusion.UsedAs<UDim>?
}
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local ThemeHandlerGet = ThemeHandler.Get
local ComputeUDim2, ComputeUDim = ComputeTransforms.UDim2, ComputeTransforms.UDim

local TableTake = TableUtils.Take

local Children, OnEvent = Fusion.Children, Fusion.OnEvent
-------------------------------------------------------------------------------------------------------


--> Private Functions ---------------------------------------------------------------------------------
local function FocusVisual(scope: Component.Scope, isFocusState: Fusion.Value<boolean>)
  local computeSizeOffset = scope:Computed(function(use) return use(isFocusState) and 4 or 8 end)
  local computeSizeUDim = ComputeUDim(scope, 1, computeSizeOffset)

  local computeTransparency = scope:Computed(function(use) return use(isFocusState) and .6 or 1 end)

  return Squircle {
    Scope = scope,
    Size = scope:Spring(ComputeUDim2(scope, computeSizeUDim, computeSizeUDim), 20, 1),
    Position = UDim2.fromScale(.5, .5),
    AnchorPoint = Vector2.new(.5, .5),
    Image = "rbxassetid://129606470741282",
    BackgroundColor3 = ThemeHandlerGet("Accent/Primary"),
    Transparency = computeTransparency,
    Name = "TextInput:FocusVisual"
  }
end
-------------------------------------------------------------------------------------------------------


return Component(function(scope, props: TextInputProps)
  local width = TableTake(props, "Width", UDim.new(1,0)) :: Fusion.UsedAs<UDim>

  local isHoverState, isFocusState = scope:Value(false), scope:Value(false)

  local computeStrokeColor = ThemeHandlerGet(scope:Computed(function(use)
    return
      (use(isFocusState) and "Accent/Primary" or
      use(isHoverState) and "Background/StrokeHighlight" or
      "Background/Stroke") :: any
  end))

  return Squircle ({
    Scope = scope,
    As = "ImageButton" :: "ImageButton",
    Size = ComputeUDim2(scope, width, UDim.new(0, 25)),
    Image = "rbxassetid://116342589966879",
    BackgroundColor3 = ThemeHandlerGet("Background/Secondary"),
    Name = "TextInput",

    [Children] = {
      Squircle {
        Scope = scope,
        Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://72425541434885",
        BackgroundColor3 = computeStrokeColor,
        Name = "TextInput:Stroke"
      },

      FocusVisual(scope, isFocusState),

      scope:New "TextBox" {
        Size = UDim2.new(1,0, 1,0),
        BackgroundTransparency = 1,
        TextSize = 14,
        Text = "Text Input",
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = Font.fromId(16658221428, Enum.FontWeight.Medium),
        TextColor3 = ThemeHandlerGet("Text/Title"),

        [Children] = scope:New "UIPadding" { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) },

        [OnEvent "Focused"] = function() isFocusState:set(true) end,
        [OnEvent "FocusLost"] = function() isFocusState:set(false) end,

        [OnEvent "MouseEnter"] = function() isHoverState:set(true) end,
        [OnEvent "MouseLeave"] = function() isHoverState:set(false) end
      },
    }
  }, props :: any)
end)