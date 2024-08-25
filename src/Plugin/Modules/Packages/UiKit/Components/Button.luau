--!strict


--> Services ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Modules -------------------------------------------------------------------------------------------
local Modules = script.Parent.Parent.Modules
local Component = require(Modules.Component)
local ThemeHandler = require(Modules.ThemeHandler)
local ComputeTransforms = require(Modules.ComputeTransforms)
local TableUtils = require(Modules.TableUtils)

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)

local Components = Modules.Parent.Components
local CoreComponents = Components.Core
local Squircle = require(CoreComponents.Squircle)
local TextLabel = require(CoreComponents.TextLabel)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
type ButtonProps = {
  Width: Fusion.UsedAs<UDim>?,
  Text: Fusion.UsedAs<string>?,
}
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local ThemeHandlerGet = ThemeHandler.Get
local ComputeUDim2 = ComputeTransforms.UDim2

local TableTake = TableUtils.Take

local Children = Fusion.Children
-------------------------------------------------------------------------------------------------------


--> Private Functions ---------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


return Component(function(scope, props: ButtonProps)
  local width = TableTake(props, "Width", UDim.new(1,0)) :: Fusion.UsedAs<UDim>
  local text = TableTake(props, "Text", "Button") :: Fusion.UsedAs<string>

  return Squircle ({
    Scope = scope,
    As = "ImageButton" :: "ImageButton",
    Size = ComputeUDim2(scope, width, UDim.new(0, 25)),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = ThemeHandlerGet("Accent/Primary"),
    Name = "Button",

    [Children] = {
      Squircle {
        Scope = scope,
        Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://108824901287727"
      },

      scope:New "Frame" {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Name = "Button:ContentWrapper",

        [Children] = {
          TextLabel {
            Scope = scope,
            Text = text,
            Focus = "Title" :: "Title",
            Weight = Enum.FontWeight.SemiBold,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
          },
    
          scope:New "UIPadding" { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) },
        }
      }
    }
  }, props :: any)
end)