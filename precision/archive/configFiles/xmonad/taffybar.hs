{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.Taffybar
import System.Taffybar.Context (TaffybarConfig(..))
import System.Taffybar.Hooks
import System.Taffybar.Information.CPU
import System.Taffybar.Information.Memory
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.FreedesktopNotifications
import System.Taffybar.Widget.Text.NetworkMonitor


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
      clock = textClockNew Nothing "<span fgcolor='#8b9dc3'>%a %d %b %H:%M</span>" 1
      layout = layoutNew defaultLayoutConfig
      windowsW = windowsNew defaultWindowsConfig
      batt = textBatteryNew "$percentage$%"
      note = notifyAreaNew defaultNotificationConfig
      -- See https://github.com/taffybar/gtk-sni-tray#statusnotifierwatcher
      -- for a better way to set up the sni tray
      tray = sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt
      wifi = networkMonitorNew defaultNetFormat (Just ["wlp111s0"])
      myConfig = defaultSimpleTaffyConfig
        { startWidgets =
            workspaces : map (>>= buildContentsBox) [ note, layout, windowsW ]
        , endWidgets = map (>>= buildContentsBox)
          [
            --batteryIconNew
            clock,
            -- batt,
            batteryIconNew,
            wifi,
            tray,
            mpris2New
          ]
        , barPosition = Top
        , barHeight = 50
        , widgetSpacing = 10
        }
  in withBatteryRefresh $ withLogServer $
     withToggleServer $ toTaffyConfig myConfig


main = dyreTaffybar exampleTaffybarConfig

