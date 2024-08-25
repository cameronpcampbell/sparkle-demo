--!strict


--> Services ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

--> Modules -------------------------------------------------------------------------------------------
local Modules = script.Parent.Modules

local Packages = Modules.Packages
local UiKit = require(Packages.UiKit)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local Fusion = UiKit.Fusion
local Scope = Fusion.scoped(Fusion)
local Children = Fusion.Children
-------------------------------------------------------------------------------------------------------


--> Private Functions ---------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


UiKit.SetPlugin(plugin)

local ProgressPercent = Scope:Value(0)

UiKit.Widget {
  Scope = Scope,
  InitDockState = Enum.InitialDockState.Left,
  Id = "UiKit",

  [Children] = {

    UiKit.Progress {
      Scope = Scope,
      ProgressPercent = ProgressPercent,
      Sections = { "Step 1: Loading", "Step 2: Verifying", "Step 3: Applying" },
    },

    UiKit.TextInput {
      Scope = Scope,
    },

    UiKit.Button {
      Scope = Scope
    },

    UiKit.Container {
      Scope = Scope,
      
      [Children] = {
        UiKit.CodeLabel {
          Scope = Scope,
          Text = "local Message = \"You've Got To Put Some Swaz On It Gromit!\"\n\nif not Message then\n    print(\"No message found :(\")\nend"
        },

        Scope:New "UIPadding" {
          PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
          PaddingBottom = UDim.new(0, 8), PaddingTop = UDim.new(0, 8)
        }
      }
    },

    UiKit.Accordion {
      Scope = Scope,
      Sections = {
        { Title = "Section A", Content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." },
        { Title = "Section B", Content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." },
        { Title = "Section C", Content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." },
      },
      ExpandedSection = 2
    },

    Scope:New "Frame" {
      Size = UDim2.fromScale(1, 0),
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,

      [Children] = {
        UiKit.Switch { Scope = Scope, Enabled = false },
        UiKit.Switch { Scope = Scope, Size = "Small" :: "Small" },

        Scope:New "UIListLayout" {
          Padding = UDim.new(0, 12),
          FillDirection = Enum.FillDirection.Horizontal,
          SortOrder = Enum.SortOrder.LayoutOrder
        },
      }
    },

    UiKit.Slider {
      Scope = Scope,
      ProgressPercent = .75
    },

    Scope:New "UIListLayout" {
      Padding = UDim.new(0, 12),
      SortOrder = Enum.SortOrder.LayoutOrder
    },

    Scope:New "UIPadding" {
      PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
      PaddingBottom = UDim.new(0, 8), PaddingTop = UDim.new(0, 8)
    }

  }
}


task.wait(5)
for count = 1, 100, .5 do
  ProgressPercent:set(count / 100)
  task.wait(.06)
end