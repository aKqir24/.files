module Keys (keyBinds) where

import XMonad
import Data.List (isInfixOf)
import XMonad.Actions.Navigation2D (Direction2D (..), windowGo, windowSwap)
import XMonad.Actions.RotSlaves (rotAllUp, rotAllDown, rotSlavesUp)
import XMonad.Actions.WithAll (sinkAll)
import XMonad.Layout.LayoutCombinators (JumpToLayout (..))
import XMonad.Layout.ToggleLayouts (ToggleLayout (..))
import qualified XMonad.StackSet as W

keyBinds :: [(String, X ())]
keyBinds =
  let myLeft = withWindowSet $ \ws -> do
        let lDesc = description . W.layout . W.workspace . W.current $ ws
        if "Full" `isInfixOf` lDesc || "Tabbed" `isInfixOf` lDesc || "Tabs" `isInfixOf` lDesc
          then windows W.focusUp
          else windowGo L False
      myRight = withWindowSet $ \ws -> do
        let lDesc = description . W.layout . W.workspace . W.current $ ws
        if "Full" `isInfixOf` lDesc || "Tabbed" `isInfixOf` lDesc || "Tabs" `isInfixOf` lDesc
          then windows W.focusDown
          else windowGo R False
  in
  [ -- Window Manipulation
    ("C-q", kill)
  , ("M1-<Tab>", rotAllUp)
  , ("M1-S-<Tab>", rotSlavesUp)
  , -- Navigation
    ("M-<Left>", myLeft)
  , ("M-<Right>", myRight)
  , ("M-<Up>", windowGo U False)
  , ("M-<Down>", windowGo D False)
  , -- Layout switches
    ("M-S-f", sendMessage (JumpToLayout "Full"))
  , ("M-S-t", sendMessage (JumpToLayout "Tabbed"))
  , ("M-S-w", sendMessage (JumpToLayout "Tall"))
  , ("M-S-v", sendMessage (JumpToLayout "Vertical"))
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
  , ("M1-<F4>", spawn "bash ~/.config/eww/toggle.sh powermenu")
  , ("M-r", spawn "~/.config/rofi/launch.sh drun")
  , ("M-S-r", spawn "~/.config/rofi/launch.sh run")
  , ("M-.", spawn "~/.config/eww/toggle.sh emoji")
  ]
