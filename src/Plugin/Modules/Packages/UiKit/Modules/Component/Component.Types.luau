--> Modules -------------------------------------------------------------------------------------------
local Modules = script.Parent.Parent

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)
-------------------------------------------------------------------------------------------------------


--> Types ---------------------------------------------------------------------------------------------
export type BackgroundConns = { RBXScriptConnection }

export type EventType =
  "InputBegan" | "InputEnded" | "InputChanged" |
  "MouseEnter" | "MouseLeave" | "MouseMoved"

export type BackgroundHandlers = {
  InputBegan: { (InputObject) -> () },
  InputEnded:  { (InputObject) -> () },
  InputChanged:  { (InputObject) -> () },

  MouseButton1Click: { () -> () },
  MouseButton1Down: { () -> () },
  MouseButton1Up: { () -> () },

  MouseButton2Click: { () -> () },
  MouseButton2Down: { () -> () },
  MouseButton2Up: { () -> () },

  MouseEnter: { (number, number) -> () },
  MouseLeave: { (number, number) -> () },
  MouseMoved: { (number, number) -> () },

  MouseWheelBackward: { (number, number) -> () },
  MouseWheelForward: { (number, number) -> () },
}

export type BackgroundHandler = (...any) -> ...any | nil

type CustomScope = {
  BackgroundConns: BackgroundConns?,
  BackgroundHandlers: BackgroundHandlers?,

  AddBackgroundEvent: (eventType: EventType, handlerFn: BackgroundHandler) -> (() -> nil),
}

export type Scope = Fusion.Scope<CustomScope & typeof(Fusion)>
-------------------------------------------------------------------------------------------------------


return nil