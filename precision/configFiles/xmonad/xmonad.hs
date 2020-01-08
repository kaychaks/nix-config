import qualified Data.Map                           as M
import           Data.Monoid                        ((<>))
import qualified Graphics.X11.Types                 as XT

import           System.Taffybar.Support.PagerHints (pagerHints)
import           XMonad
import           XMonad.Actions.Navigation2D
import           XMonad.Config
import           XMonad.Hooks.EwmhDesktops          (ewmh, fullscreenEventHook)
import           XMonad.Hooks.ManageDocks           (avoidStruts, docks,
                                                     manageDocks)
import           XMonad.Hooks.ManageHelpers         (doFullFloat, doCenterFloat, isFullscreen, doRectFloat)
import           XMonad.Layout.NoBorders            (smartBorders)
import           XMonad.Layout.Spacing
import           XMonad.Layout.ThreeColumns
import           XMonad.StackSet (RationalRect(..))
import Data.Ratio ((%))

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
    -- layoutHook = smartBorders $ spacingRaw True (Border 0 1 1 1) True (Border 10 10 0 0) True $ avoidStruts $ layoutHook def ||| ThreeColMid 1 (3/100) (1/2)
    layoutHook = avoidStruts $ smartBorders $ layoutHook def ||| ThreeColMid 1 (3/100) (1/2)
  }

myKeys :: XConfig Layout -> M.Map (XT.ButtonMask, XT.KeySym) (X ())
myKeys conf@(XConfig {modMask = modM}) =
  let
      xK_X86MonBrightnessDown = 0x1008ff03
      xK_X86MonBrightnessUp   = 0x1008ff02
      xK_X86AudioLowerVolume  = 0x1008ff11
      xK_X86AudioRaiseVolume  = 0x1008ff13
      xK_X86AudioMute         = 0x1008ff12
      xK_X86AudioPlay         = 0x1008ff14
      xK_X86AudioPrev         = 0x1008ff16
      xK_X86AudioNext         = 0x1008ff17
      hyper = mod4Mask
      myKeys = M.fromList [
        ((modM, xK_p), spawn "rofi -show drun  -modi \"drun,calc,window,ssh\" -show-icons -plugin-path ~/.config/rofi/lib"),
        ((XT.mod4Mask .|. modM, XT.xK_l), spawn "betterlockscreen -l dim"),
        ((modM .|. controlMask, XT.xK_c), spawn "gpaste-client ui"),
        ((hyper, XT.xK_o), spawn "emacs --title emacs-org"),
        ((hyper, XT.xK_t), spawn "systemctl --user restart taffybar.service"),
        ((hyper .|. shiftMask, XT.xK_t), spawn "systemctl --user stop taffybar.service"),
        ((XT.mod4Mask .|. shiftMask, XT.xK_n), spawn "thunar"),

        ((modM .|. shiftMask, xK_j), windowSwap L True),
        ((modM .|. shiftMask, xK_k), windowSwap R True),

        ((0, xK_X86MonBrightnessDown), spawn "brightnessctl s 5%-"),
        ((0, xK_X86MonBrightnessUp), spawn "brightnessctl s +5%"),
        ((0, xK_X86AudioLowerVolume), spawn "amixer sset Master 5%-"),
        ((0, xK_X86AudioRaiseVolume), spawn "amixer sset Master 5%+"),
        ((0, xK_X86AudioMute), spawn "amixer sset Master toggle"),

        ((hyper .|. modM, xK_s), spawn "autorandr --load solo"),
        ((hyper .|. modM, xK_c), spawn "autorandr --load clamshell"),
        ((hyper .|. modM, xK_d), spawn "autorandr --load dual"),
        ((hyper .|. modM, xK_h), spawn "autorandr --load hdmi_dual")
        ]
  in
    myKeys <> keys def conf

myWorkspaces :: [String]
myWorkspaces = [
  "1: Web",
  "2: Dev",
  "3: Chat",
  "4: Org",
  "5",
  "6: Mail",
  "7: Feeds",
  "8: Music",
  "9"
  ]

myManageHook :: ManageHook
myManageHook = composeAll [
  className =? "Thunderbird" --> doShift "6: Mail",
  title =? "emacs-org" --> doShift "4: Org",
  className =? "Signal" --> doShift "3: Chat",
  className =? "Hexchat" --> doShift "3: Chat",
  className =? "Discord" --> doShift "3: Chat",

  -- floating windows
  className =? "Thunar" --> doRectFloat (RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2)),
  className =? ".blueman-manager-wrapped" --> doCenterFloat,

  isFullscreen --> doFullFloat
  ]
