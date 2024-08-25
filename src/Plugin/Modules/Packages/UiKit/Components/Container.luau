--!strict


--> Modules -------------------------------------------------------------------------------------------
local Components = script.Parent
local CoreComponents = Components.Core
local Squircle = require(CoreComponents.Squircle)
local TextLabel = require(CoreComponents.TextLabel)
local Arrow = require(CoreComponents.Arrow)

local Modules = script.Parent.Parent.Modules
local Component = require(Modules.Component)
local ThemeHandler = require(Modules.ThemeHandler)
local ComputeTransforms = require(Modules.ComputeTransforms)
local TrackProperty = require(Modules.TrackProperty)
local TableUtils = require(Modules.TableUtils)

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
type ContainerTypes = {
  Width: Fusion.UsedAs<UDim>
}
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local ThemeHandlerGet = ThemeHandler.Get
local ComputeUDim, ComputeUDim2, ComputeTweenInfo = ComputeTransforms.UDim, ComputeTransforms.UDim2, ComputeTransforms.TweenInfo

local TableTake = TableUtils.Take

local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek
-------------------------------------------------------------------------------------------------------


--> Functions -----------------------------------------------------------------------------------------
local function UpdateContainerTweenSpeed(peekedComputeSize: UDim2, peekedContentRefAbsSize: Vector2, tweenSpeedState: Fusion.Value<number>)
  if not peekedComputeSize then return end
  if not peekedContentRefAbsSize then return end

  tweenSpeedState:set((peekedComputeSize.Y.Offset == 25 + peekedContentRefAbsSize.Y) and 0 or .2)
end


local function ContainerHeader(scope: Component.Scope, isExpandedState: Fusion.Value<boolean>, tweenSpeedState: Fusion.Value<number>)
  return Squircle {
    Scope = scope,
    Size = UDim2.new(1,0, 0,25),
    Image = "rbxassetid://93713962247299",
    BackgroundColor3 = ThemeHandlerGet("Background/Tertiary"),
    Name = "Container:Header",

    [Children] = {
      Arrow {
        Scope = scope,
        IsExpanded = isExpandedState,
        CollapsedRotation = -90,
        ExpandedRotation = 0,
        LayoutOrder = 0,
        Name = "Container:Header:Arrow",

        [OnEvent "MouseButton1Click"] = function()
          tweenSpeedState:set(.2) -- Makes the containers' height change gradually when collapsing / expanding.
          isExpandedState:set(not peek(isExpandedState))
        end
      },

      TextLabel {
        Scope = scope,
        Text = "Header Title",
        Focus = "Title" :: "Title",
        Weight = Enum.FontWeight.SemiBold,
        Size = UDim2.fromScale(0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        LayoutOrder = 1,
        Name = "Container:Header:Title"
      },

      scope:New "UIListLayout" {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 7),
      },

      scope:New "UIPadding" {
        PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
      }
    }
  }
end
-------------------------------------------------------------------------------------------------------


return Component(function(scope, props: Fusion.PropertyTable)
  local width, children = TableTake(props, "Width", UDim.new(1, 0)), TableTake(props, Children)
  local header = scope:Value(true)

  local isExpandedState = scope:Value(true)
  local tweenSpeedState = scope:Value(((not peek(header)) or peek(isExpandedState)) and 0 or .2)

  local contentRef = (scope:Value(nil) :: any) :: Fusion.Value<Instance>
  local contentRefAbsSize = TrackProperty(scope, contentRef, "AbsoluteSize")

  -- When the container is expanded the height should be the header height (25px) plus the height of its children.
  -- When the container is collapsed the height should only be the header height.
  local computeHeight = scope:Computed(function(use)
    local heightOffset = use(header) and 25 or 0

    if not use(isExpandedState) then return heightOffset end
    local usedContentRefAbsSize = use(contentRefAbsSize)
    if usedContentRefAbsSize then return heightOffset + usedContentRefAbsSize.Y else return heightOffset end
  end)

  local computeSize = scope:Tween(
    ComputeUDim2(scope, width, ComputeUDim(scope, 0, computeHeight)),
    ComputeTweenInfo(scope, tweenSpeedState, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
  )

  local computeContentWrapperImage = scope:Computed(function(use)
    return use(header) and "rbxassetid://131049749520663" or "rbxassetid://116342589966879"
  end)

  -- If the header is enabled/disabled then it recalculates the tween speed.
  scope:Observer(header):onChange(function()
    UpdateContainerTweenSpeed(peek(computeSize), peek(contentRefAbsSize), tweenSpeedState)
  end)

  -- Changes the container tween speed so that when it is expanded its size updates instantly.
  scope:Observer(computeSize):onChange(function()
    -- Makes sure the tween speed does not change if there is no header
    -- since containers without a header can't be collapsed/expanded.
    if not peek(header) then return end

    UpdateContainerTweenSpeed(peek(computeSize), peek(contentRefAbsSize), tweenSpeedState)
  end)

  return Squircle ({
    Scope = scope,
    As = "ImageButton" :: "ImageButton",
    Size = computeSize,
    Image = "rbxassetid://116342589966879",
    BackgroundColor3 = ThemeHandlerGet("Background/Stroke"),
    ClipsDescendants = true,
    Name = "Container",

    [Children] = {
      -- Only shows the header if specified to do so.
      scope:Computed(function(use)
        local usedHeader = use(header)
        return usedHeader and ContainerHeader(scope, isExpandedState, tweenSpeedState) or nil
      end) :: any,

      Squircle {
        Scope = scope,
        BackgroundColor3 = ThemeHandlerGet("Background/Secondary"),
        Size = scope:Computed(function(use) return use(header) and UDim2.new(1,0, 1,-25) or UDim2.new(1,0, 1,0) end),
        Position = scope:Computed(function(use) return use(header) and UDim2.fromOffset(0, 25) or UDim2.fromScale(0, 0) end),
        Image = computeContentWrapperImage,
        Name = "Container:ContentWrapper",

        [Children] = contentRef:set(scope:New "Frame" {
          Size = UDim2.fromScale(1, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Name = "Container:Content",
          [Children] = children
        })
      },

      Squircle {
        Scope = scope,
        Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://121739840492365",
        BackgroundColor3 = ThemeHandlerGet("Background/Primary"),
        Name = "Container:DotsOccluder"
      },

      Squircle {
        Scope = scope,
        Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://72425541434885",
        BackgroundColor3 = ThemeHandlerGet("Background/Stroke"),
        Name = "Container:Stroke"
      },
    }
  }, props :: any)
end)