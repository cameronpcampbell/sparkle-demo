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


UiKit.Widget {
  Scope = Scope,
  InitDockState = Enum.InitialDockState.Left,
  Id = "UiKit",

  [Children] = {

    UiKit.Container {
      Scope = Scope,
      
      [Children] = {
        UiKit.Accordion {
          Scope = Scope,
          Sections = {
            { Title = "Section", Content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." },
            { Title = "Section Two", Content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." },
            { Title = "Section Two", Content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." },
            { Title = "Section Two", Content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." }
          }
        },

        Scope:New "UIPadding" {
          PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
          PaddingBottom = UDim.new(0, 8), PaddingTop = UDim.new(0, 8)
        }
      }
    },


    UiKit.Container {
      Scope = Scope,
      
      [Children] = {
        UiKit.CodeLabel {
          Scope = Scope,
          Text = "local Message = \"You've Got To Put Some Swaz On It Gromit!\""
        },

        Scope:New "UIPadding" {
          PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
          PaddingBottom = UDim.new(0, 8), PaddingTop = UDim.new(0, 8)
        }
      }
    },

    UiKit.Container {
      Scope = Scope,
      
      [Children] = {
        UiKit.TextLabel {
          Scope = Scope,
          Text = "local Message = \"You've Got To Put Some Swaz On It Gromit!\""
        },

        Scope:New "UIPadding" {
          PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
          PaddingBottom = UDim.new(0, 8), PaddingTop = UDim.new(0, 8)
        }
      }
    },


    Scope:New "UIListLayout" {
      Padding = UDim.new(0, 4),
      SortOrder = Enum.SortOrder.LayoutOrder
    },

    Scope:New "UIPadding" {
      PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
      PaddingBottom = UDim.new(0, 4), PaddingTop = UDim.new(0, 4)
    }

  }
}

