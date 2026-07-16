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

myTheme :: Theme
myTheme =
  def
    { activeColor = Colors.active_color
    , activeBorderColor = Colors.active_border
    , activeTextColor = Colors.active_text
    , inactiveColor = Colors.inactive_color
    , inactiveBorderColor = Colors.inactive_border
    , inactiveTextColor = Colors.inactive_text
    , urgentColor = Colors.urgent_color
    , urgentTextColor = Colors.urgent_text
    , decoHeight = 24
    }

ewwLogHook :: X ()
ewwLogHook = do
  ws <- gets windowset
  let tag = W.currentTag ws
  spawn $ "eww update current_ws=" ++ tag

main :: IO ()
main =
  xmonad $ docks $ ewmh $ def
      { modMask = mod4Mask
      , terminal = "alacritty"
      , normalBorderColor = Colors.border_normal
      , focusedBorderColor = Colors.border_focused
      , borderWidth = 2
      , layoutHook = avoidStruts myLayouts
      , manageHook = manageDocks <+> progHook <+> manageHook def
      , logHook = ewwLogHook
      , startupHook = spawn "eww kill 2>/dev/null; eww daemon && sleep 0.3 && eww open bar"
      }
    `additionalKeysP` keyBinds
