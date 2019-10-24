import qualified Data.Map as M
import Data.Monoid ((<>))
import qualified Graphics.X11.Types as XT

import XMonad
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Layout.NoBorders (smartBorders)

main = xmonad . ewmh . docks $ def
  {
    borderWidth = 3,
    terminal = "termite",
    normalBorderColor = "#cccccc",
    focusedBorderColor = "#cd8b00",
    handleEventHook = handleEventHook def <+> fullscreenEventHook,
    manageHook = manageDocks <+> manageHook def,
    layoutHook = smartBorders $ avoidStruts $ layoutHook def
  }

myKeys :: XConfig Layout -> M.Map (XT.ButtonMask, XT.KeySym) (X ())
myKeys conf@(XConfig {modMask = modM}) =
  let
    myKeys = M.fromList [
                        ]
  in
    myKeys <> keys def conf
