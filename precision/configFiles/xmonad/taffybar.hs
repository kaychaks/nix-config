{-# LANGUAGE OverloadedStrings #-}

module Main where

import           System.Taffybar
import           System.Taffybar.Context                    (TaffybarConfig (..))
import           System.Taffybar.Hooks
import           System.Taffybar.SimpleConfig
import           System.Taffybar.Widget
import           System.Taffybar.Widget.Text.NetworkMonitor


-- colorize :: String -> String -> String
-- colorize c t = "<span fgcolor='"<> c <> "'>" <> t <> "</span>"

exampleTaffybarConfig :: TaffybarConfig
exampleTaffybarConfig =
  let myWorkspacesConfig =
        defaultWorkspacesConfig
        { minIcons = 0
        , widgetGap = 0
        , showWorkspaceFn = hideEmpty
        , iconSort = const $ return []
        }
      workspaces = workspacesNew myWorkspacesConfig
      clock = textClockNew Nothing (colorize "#8b9dc3" "" "%a %d %b %H:%M") 1
      layout = layoutNew defaultLayoutConfig
      windowsW = windowsNew defaultWindowsConfig
      note = notifyAreaNew defaultNotificationConfig
      -- See https://github.com/taffybar/gtk-sni-tray#statusnotifierwatcher
      -- for a better way to set up the sni tray
      tray = sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt
      network = networkMonitorNew (colorize "green" "" defaultNetFormat) (Just ["wlp111s0"])
      myConfig = defaultSimpleTaffyConfig
        { startWidgets =
            workspaces : map (>>= buildContentsBox)
            [
            -- layout,
              windowsW
            ]
        , endWidgets = map (>>= buildContentsBox)
          [
            batteryIconNew,
            clock,
            tray,
            -- mpris2New,
            note
            -- network
          ]
        , barPosition = Top
        , barHeight = 30
        , widgetSpacing = 10
        -- , barPadding = 10
        }
  in withBatteryRefresh $ withLogServer $
     withToggleServer $ toTaffyConfig myConfig


main :: IO ()
main = dyreTaffybar exampleTaffybarConfig

