{-# OPTIONS_GHC -Wno-deprecations #-}
import qualified Colors
import Hooks (progHook)
import Keys (keyBinds)
import Layouts (myLayouts)
import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Layout.Decoration (Theme (..))
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeysP)
import System.Environment (getEnv)

myTheme :: Theme
myTheme = def
    { activeColor         = Colors.active_color
    , activeBorderColor   = Colors.active_border
    , activeTextColor     = Colors.active_text
    , inactiveColor       = Colors.inactive_color
    , inactiveBorderColor = Colors.inactive_border
    , inactiveTextColor   = Colors.inactive_text
    , urgentColor         = Colors.urgent_color
    , urgentTextColor     = Colors.urgent_text
    , decoHeight          = 20
    }

ewwLogHook :: X ()
ewwLogHook = do
  ws <- gets windowset
  let tag = W.currentTag ws
  spawn $ "eww update current_ws=" ++ tag

main :: IO ()
main = do
  userName <- getEnv "USER"
  xmonad $ docks $ ewmh $ def
      { modMask = mod4Mask
      , terminal = "alacritty"
      , workspaces = [ "1", "2", "3", "4", "5", "7", "8" ]
      , normalBorderColor = Colors.inactive_border
      , focusedBorderColor = Colors.active_border
      , borderWidth = 3
      , layoutHook = avoidStruts (myLayouts myTheme)
      , manageHook = manageDocks <+> progHook userName <+> manageHook def
      , logHook = ewwLogHook
      }
    `additionalKeysP` keyBinds
