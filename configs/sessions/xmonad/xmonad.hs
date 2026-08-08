{-# OPTIONS_GHC -Wno-deprecations #-}
import qualified Colors
import Hooks (progHook)
import Keys (keyBinds)
import Layouts (myLayouts)
import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeysP)
import System.Environment (getEnv)

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
      , normalBorderColor = Colors.border_normal
      , focusedBorderColor = Colors.border_focused
      , borderWidth = 3
      , layoutHook = avoidStruts myLayouts
      , manageHook = manageDocks <+> progHook userName <+> manageHook def
      , logHook = ewwLogHook
      }
    `additionalKeysP` keyBinds
