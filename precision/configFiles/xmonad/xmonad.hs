import qualified Data.Map as M
import Data.Monoid ((<>))
import qualified Graphics.X11.Types as XT

import XMonad
import XMonad.Config
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Layout.NoBorders (smartBorders)
import System.Taffybar.Support.PagerHints (pagerHints)
import XMonad.Layout.ThreeColumns

main = xmonad . docks . ewmh . pagerHints $ def
  {
    borderWidth = 3,
    terminal = "termite",
    -- normalBorderColor = "#cccccc",
    normalBorderColor = "#000000",
    focusedBorderColor = "#ffff00",
    workspaces = myWorkspaces,
    keys = myKeys,
    handleEventHook = handleEventHook def <+> fullscreenEventHook,
    manageHook = myManageHook <+> manageDocks <+> manageHook def,
    layoutHook = smartBorders $ avoidStruts $ layoutHook def ||| ThreeColMid 1 (3/100) (1/2)
  }

myKeys :: XConfig Layout -> M.Map (XT.ButtonMask, XT.KeySym) (X ())
myKeys conf@(XConfig {modMask = modM}) =
  let
    myKeys = M.fromList [
      ((modM, xK_p), spawn "rofi -show drun -show-icons")
                        ]
  in
    myKeys <> keys def conf

myWorkspaces :: [String]
myWorkspaces = [
  "1: Web",
  "2: Dev",
  "3: Chat",
  "4",
  "5",
  "6: Mail",
  "7: Feeds",
  "8: Music",
  "9"
  ]

myManageHook :: ManageHook
myManageHook = composeAll [
  className =? "Thunderbird" --> doShift "6: Mail",
  className =? "Signal" --> doShift "3: Chat",
  className =? "Hexchat" --> doShift "3: Chat",
  className =? "Files" --> doFloat,
  isFullscreen --> doFullFloat
  ]
