module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Debug as Debug
import Effect (Effect)
import Effect.Exception as Exception
import React.Basic.DOM as DOM
import React.Basic.DOM.Client as Client
import React.Basic.DOM.Events as DOM.Events
import React.Basic.Events as Events
import React.Basic.Hooks (Component)
import React.Basic.Hooks as Hooks
import Unsafe.Coerce as Coerce
import Web.DOM.NonElementParentNode as NonElementParentNode
import Web.HTML as HTML
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.Window as Window

main :: Effect Unit
main = do
  maybeRoot <- HTML.window
    >>= Window.document
    >>= HTMLDocument.toNonElementParentNode
      >>> NonElementParentNode.getElementById "root"
  case maybeRoot of
    Nothing -> Exception.throw "Root element not found."
    Just root -> do
      app <- mkApp
      reactRoot <- Client.createRoot root
      Client.renderRoot reactRoot (app unit)

mkApp :: Component Unit
mkApp = do
  Hooks.component "App" \_ -> Hooks.do
    pure
      ( DOM.div_
          [ DOM.button
              { onClick:
                  Events.handler DOM.Events.preventDefault
                    Debug.traceM
              , children:
                  [ DOM.text "preventDefault"
                  ]
              }
          , DOM.button
              { onClick:
                  Events.handler (DOM.Events.preventDefault >>> DOM.Events.isDefaultPrevented)
                    Debug.traceM
              , children:
                  [ DOM.text "preventDefault >>> isDefaultPrevented"
                  ]
              }
          , DOM.button
              { onClick:
                  Events.handler DOM.Events.stopPropagation
                    Debug.traceM
              , children:
                  [ DOM.text "stopPropagation"
                  ]
              }
          , DOM.button
              { onClick:
                  Events.handler (DOM.Events.stopPropagation >>> DOM.Events.isPropagationStopped)
                    Debug.traceM
              , children:
                  [ DOM.text "stopPropagation >>> isPropagationStopped"
                  ]
              }
          ]
      )