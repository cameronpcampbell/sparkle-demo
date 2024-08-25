--!strict


--> Services ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Modules -------------------------------------------------------------------------------------------
local Components = script.Parent
local Squircle = require(Components.Core.Squircle)

local Modules = script.Parent.Parent.Modules
local Component = require(Modules.Component)
local ThemeHandler = require(Modules.ThemeHandler)
local TrackProperty = require(Modules.TrackProperty)
local PluginHandler = require(Modules.PluginHandler)
local ForceToState = require(Modules.ForceToState)
local ComputeTransforms = require(Modules.ComputeTransforms)
local TableUtils = require(Modules.TableUtils)

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
type SliderProps = {
  Width: Fusion.UsedAs<UDim>?,
  ProgressPercent: Fusion.UsedAs<number>?,
  Step: Fusion.UsedAs<number>?,
}
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek

local ComputeUDim, ComputeUDim2, ComputeUDim2FromScale = ComputeTransforms.UDim, ComputeTransforms.UDim2, ComputeTransforms.UDim2FromScale

local TableTake = TableUtils.Take
local ThemeHandlerGet = ThemeHandler.Get
local PluginHandlerGet = PluginHandler.GetPlugin

local DraggerSize = 14
-------------------------------------------------------------------------------------------------------


--> Functions -----------------------------------------------------------------------------------------
--[[local function FocusVisual(scope: Component.Scope, isFocusState: Fusion.Value<boolean>)
  local computeSizeOffset = scope:Computed(function(use) return use(isFocusState) and 4 or 8 end)
  local computeSizeUDim = ComputeUDim(scope, 1, computeSizeOffset)

  local computeTransparency = scope:Computed(function(use) return use(isFocusState) and .6 or 1 end)

  return scope:New "ImageLabel" {
    Size = scope:Spring(ComputeUDim2(scope, computeSizeUDim, computeSizeUDim), 20, 1),
    Position = UDim2.fromScale(.5, .5),
    AnchorPoint = Vector2.new(.5, .5),
    Image = "rbxassetid://91473496883985",
    ImageColor3 = ThemeHandlerGet("Accent/Primary"),
    ImageTransparency = computeTransparency,
    BackgroundTransparency = 1,
    Name = "Slider:FocusVisual"
  }
end]]

local function MoveDragger(
  progressPercentState: Fusion.Value<number>, sliderAbsSizeState: Fusion.Value<Vector2>,
  sliderAbsPosState: Fusion.Value<Vector2>, mousePosXState: Fusion.Value<number>
)
  return function(x: number?)
    local peeekdSliderAbsWidth = (peek(sliderAbsSizeState) or Vector2.zero).X
    local peekedSliderAbsPosX = (peek(sliderAbsPosState) or Vector2.zero).X

    -- Gets the relative position along the slider where the dragger should now be.
    local relPosX = math.clamp(
      ((x or peek(mousePosXState)) - peekedSliderAbsPosX) / peeekdSliderAbsWidth,
      0, 1
    )

    progressPercentState:set(relPosX)
  end
end

local function OnDraggerMove(scope: Component.Scope, sliderRef: Fusion.Value<ImageButton>, moveDragger: (x: number?) -> nil)
  return function()
    moveDragger()

    local removeUpdateDraggerPosConn = scope.AddBackgroundEvent("MouseMoved", moveDragger)

    local removeStopDraggingConn: () -> nil, draggerButton1UpConn: RBXScriptConnection, pluginMouseMoveConn: RBXScriptConnection = nil, nil, nil

    local function stopDragging()
      removeStopDraggingConn()
      draggerButton1UpConn:Disconnect()
      pluginMouseMoveConn:Disconnect()
      removeUpdateDraggerPosConn()
    end

    draggerButton1UpConn = peek(sliderRef).MouseButton1Up:Connect(stopDragging)
    removeStopDraggingConn = scope.AddBackgroundEvent("InputEnded", stopDragging)
    pluginMouseMoveConn = PluginHandlerGet():GetMouse().Move:Connect(stopDragging)
  end
end
-------------------------------------------------------------------------------------------------------


return Component(function(scope, props: SliderProps)
  local width, progressPercentState, _stepSize =
    TableTake(props, "Width", UDim.new(1,0)) :: Fusion.UsedAs<UDim>,
    ForceToState(scope, TableTake(props, "ProgressPercent", 0)) :: Fusion.Value<number>,
    TableTake(props, "StepSize") :: Fusion.UsedAs<number>

  local sliderRef = (scope:Value(nil) :: any) :: Fusion.Value<Instance>
  local sliderAbsSizeState, sliderAbsPosState =
    TrackProperty(scope, sliderRef, "AbsoluteSize") :: Fusion.Value<Vector2>, TrackProperty(scope, sliderRef, "AbsolutePosition") :: Fusion.Value<Vector2>

  local mousePosXState = scope:Value(0)

  local moveDragger = MoveDragger(progressPercentState, sliderAbsSizeState, sliderAbsPosState, mousePosXState)

  return sliderRef:set(
    scope:New "ImageButton" ({
      Size = ComputeUDim2(scope, width, UDim.new(0, 14)),
      BackgroundTransparency = 1,
      Name = "Slider",

      [OnEvent "MouseButton1Down"] = OnDraggerMove(scope, (sliderRef :: any) :: Fusion.Value<ImageButton>, moveDragger),

      [OnEvent "MouseMoved"] = function(x: number) mousePosXState:set(x) end,
  
      [Children] = {
        Squircle {
          Scope = scope,
          Size = UDim2.new(1,0, 0,4),
          Position = UDim2.fromScale(0, .5),
          AnchorPoint = Vector2.new(0, .5),
          BackgroundColor3 = ThemeHandlerGet("Accent/Primary"),
          BackgroundTransparency = .65,
          Image = "rbxassetid://104271355998011",
          SliceCenter = Rect.new(8,4,8,4),
          Name = "Slider:Background",
  
          [Children] = Squircle {
            Scope = scope,
            Size = ComputeUDim2FromScale(scope, progressPercentState, 1),
            BackgroundColor3 = ThemeHandlerGet("Accent/Primary"),
            Image = "rbxassetid://104271355998011",
            SliceCenter = Rect.new(8,4,8,4),
            Name = "Slider:Progress"
          }
        },

        scope:New "Frame" {
          Size = UDim2.new(1,-DraggerSize, 1,0),
          BackgroundTransparency = 1,
          Name = "Slider:DragBounds",

          [Children] = scope:New "ImageLabel" {
            Size = UDim2.fromOffset(DraggerSize, DraggerSize),
            Position = ComputeUDim2FromScale(scope, progressPercentState, 0),
            Image = "rbxassetid://114187647106547",
            BackgroundTransparency = 1,
            ImageColor3 = ThemeHandlerGet("Accent/Primary"),
            Name = "Dragger",
      
            [Children] = {
              scope:New "ImageLabel" {
                Size = UDim2.fromScale(1, 1),
                Image = "rbxassetid://128086402167912",
                BackgroundTransparency = 1,
                ImageColor3 = ThemeHandlerGet("Background/Primary"),
                Name = "Dragger:Inner",
              },

              scope:New "ImageLabel" {
                Size = UDim2.fromScale(1, 1),
                Image = "rbxassetid://71078180733332",
                BackgroundTransparency = 1,
                Name = "Dragger:Highlight",
              },

              --FocusVisual(scope, scope:Value(true)),
            }
          }
        },
  
  
      }
    }, props)
  )
end)






























--[[

--!strict


--> Services ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


--> Modules -------------------------------------------------------------------------------------------
local Modules = script.Parent.Parent.Modules
local Component = require(Modules.Component)
local TableUtils = require(Modules.TableUtils)
local ThemeHandler = require(Modules.ThemeHandler)

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
type SliderProps = {
  Width: Fusion.UsedAs<UDim>,
  ValueA: Fusion.UsedAs<number>?,
  ValueB: Fusion.UsedAs<number>?,
  StartValue: Fusion.UsedAs<number>?,
  EndValue: Fusion.UsedAs<number>?,
  StepSize: Fusion.UsedAs<number>?,
  Segments: Fusion.UsedAs<number>?,
}
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local Children = Fusion.Children

local TableTake = TableUtils.Take
local ThemeHandlerGet = ThemeHandler.Get
-------------------------------------------------------------------------------------------------------


--> Functions -----------------------------------------------------------------------------------------
local function ForRange(scope: Fusion.Scope<typeof(Fusion)>, range: Fusion.UsedAs<number>, fn: () -> Instance)
  return (scope:Computed(function(use)
    local usedRange = use(range)

    local children = table.create(usedRange)
    for idx = 1, usedRange do children[idx] = fn() end

    return children
  end) :: any) :: Instance
end

local function ComputeSize(scope: Fusion.Scope<typeof(Fusion)>, width: Fusion.UsedAs<UDim>, height: Fusion.UsedAs<UDim>)
  return scope:Computed(function(use)
    local usedWidth, usedHeight = use(width), use(height)

    return UDim2.new(usedWidth.Scale, usedWidth.Offset, usedHeight.Scale, usedHeight.Offset)
  end)
end

local function Segment(scope: Fusion.Scope<typeof(Fusion)>, width: Fusion.UsedAs<UDim>)
  return scope:New "Frame" {
    Size = UDim2.new(1,0, 0,4),
    BackgroundColor3 = ThemeHandlerGet("Accent/Primary"),
    Name = "Slider",

    [Children] = scope:New "UICorner" { CornerRadius = UDim.new(1, 0) }
  }
end
-------------------------------------------------------------------------------------------------------


return Component(function(scope, props: SliderProps)
  local width, _valueA, _valueB, _startValue, _endValue, _stepSize, segments =
    TableTake(props, "Width") :: Fusion.UsedAs<UDim>,
    TableTake(props, "ValueA", 0), TableTake(props, "ValueB"),
    TableTake(props, "StartValue", 0), TableTake(props, "EndValue", 100),
    TableTake(props, "StepSize") :: Fusion.UsedAs<number>, TableTake(props, "Segments", 1) :: Fusion.UsedAs<number>
  
  return scope:New "Frame" {
    Size = ComputeSize(scope, width, UDim.new(0, 14)),
    BackgroundTransparency = 1,
    Name = "SliderWrapper",

    [Children] = {
      scope:New "Frame" {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Name = "Segments",

        [Children] = {
          ForRange(scope, segments, function() return Segment(scope, width) end),

          scope:New "UIListLayout" {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 1)
          }
        }
      },

      scope:New "ImageLabel" {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.fromScale(1,0),
        AnchorPoint = Vector2.new(1,0),
        Image = "rbxassetid://100204971947389",
        BackgroundTransparency = 1,
        ImageColor3 = ThemeHandlerGet("Accent/Primary"),
        Name = "DraggerOuter",

        [Children] = scope:New "ImageButton" {
          Size = UDim2.fromScale(1, 1),
          Image = "rbxassetid://132211924025649",
          BackgroundTransparency = 1,
          ImageColor3 = ThemeHandlerGet("Background/Primary"),
          Name = "DraggerInner",
        }
      }
    }
  }
end)

]]