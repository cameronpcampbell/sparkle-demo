--!strict

--> Modules -------------------------------------------------------------------------------------------
local ComponentTypes = require(script["Component.Types"])
local ComponentUtils = require(script["Component.Utils"])

local Modules = script.Parent
local CombineProps = require(Modules.CombineProps)
local TableUtils = require(Modules.TableUtils)

local Packages = Modules.Packages
local Fusion = require(Packages.Fusion)
-------------------------------------------------------------------------------------------------------

--> Types ---------------------------------------------------------------------------------------------
type BaseProps = {
  Scope: Fusion.Scope<typeof(Fusion)>,
  [string | Fusion.SpecialKey]: unknown?
}

type OptionalBaseProps = {
  Scope: (Fusion.Scope<typeof(Fusion)>)?,
  [string | Fusion.SpecialKey]: unknown?
}

export type BackgroundHandler = ComponentTypes.BackgroundHandler
export type BackgroundHandlers = ComponentTypes.BackgroundHandlers
export type EventType = ComponentTypes.EventType
export type Scope = ComponentTypes.Scope
export type BackgroundConns = ComponentTypes.BackgroundConns
-------------------------------------------------------------------------------------------------------


--> Variables -----------------------------------------------------------------------------------------
local GetBackgroundHandlersFromScope = ComponentUtils.GetBackgroundHandlersFromScope

local TableTake = TableUtils.Take
-------------------------------------------------------------------------------------------------------


--> Functions -----------------------------------------------------------------------------------------
local function Component<Props>(fn: (scope: Scope, props: Props) -> Instance)
  return function(props: Props & BaseProps, ...: Props & OptionalBaseProps)
    local combinedProps = CombineProps(props, ...)
    local scope = TableTake(combinedProps, "Scope") :: Scope

    if not scope.AddBackgroundEvent then
      local backgroundHandlers = GetBackgroundHandlersFromScope(scope)

      scope.AddBackgroundEvent = function(eventType, handlerFn)
        local backgroundHandlersForEventType = backgroundHandlers[eventType]
        table.insert(backgroundHandlersForEventType, handlerFn)

        return function()
          table.remove(backgroundHandlersForEventType, table.find(backgroundHandlersForEventType, handlerFn))
        end
      end
    end

    return fn(scope, (combinedProps :: any) :: BaseProps & Props)
  end
end
-------------------------------------------------------------------------------------------------------


return Component






