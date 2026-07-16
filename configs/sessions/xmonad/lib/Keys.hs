module Keys (keyBinds) where

import XMonad
import XMonad.Actions.Navigation2D (Direction2D (..), windowGo, windowSwap)
import XMonad.Actions.RotSlaves (rotAllUp, rotSlavesUp)
import XMonad.Actions.WithAll (sinkAll)
import XMonad.Layout.LayoutCombinators (JumpToLayout (..))
import XMonad.Layout.ToggleLayouts (ToggleLayout (..))
import qualified XMonad.StackSet as W

keyBinds :: [(String, X ())]
keyBinds =
  [ -- Window Manipulation
    ("C-q", kill)
  , ("M1-<Tab>", rotAllUp)
  , ("M1-S-<Tab>", rotSlavesUp)
  , -- Navigation
    ("M-<Left>", windowGo L False)
  , ("M-<Right>", windowGo R False)
  , ("M-<Up>", windowGo U False)
  , ("M-<Down>", windowGo D False)
  , -- i3-style swap + layout switch
    ("M-S-<Left>", windowSwap L False >> sendMessage (JumpToLayout "Tall"))
  , ("M-S-<Right>", windowSwap R False >> sendMessage (JumpToLayout "Tall"))
  , ("M-S-<Up>", windows W.swapUp >> sendMessage (JumpToLayout "Vertical"))
  , ("M-S-<Down>", windows W.swapDown >> sendMessage (JumpToLayout "Vertical"))
  , ("M-S-<Space>", sendMessage ToggleLayout >> sinkAll)
  , ("M-<Space>", windows W.focusDown)
  , -- Run Programs
    ("M-e", spawn "pcmanfm")
  , ("M-<Return>", spawn "alacritty")
  , ("M-<Print>", spawn "gscreenshot")
  , ("M1-<F4>", spawn "~/.config/eww/scripts/toggle-powermenu")
  , ("M-r", spawn "~/.config/eww/scripts/toggle-launcher")
  , ("M-.", spawn "~/.config/eww/scripts/toggle-emoji")
  , ("<Escape>", spawn "~/.config/eww/scripts/escape-handler")
  ]
