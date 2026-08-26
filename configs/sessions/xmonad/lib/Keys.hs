module Keys (keyBinds) where

import XMonad
import Data.List (isInfixOf)
import XMonad.Actions.Navigation2D (Direction2D (..), windowGo, windowSwap)
import XMonad.Actions.RotSlaves (rotAllUp, rotAllDown, rotSlavesUp)
import XMonad.Actions.WithAll (sinkAll)
import XMonad.Actions.Submap (submap)
import XMonad.Layout.LayoutCombinators (JumpToLayout (..))
import XMonad.Layout.ToggleLayouts (ToggleLayout (..))
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Graphics.X11

resizeMap :: M.Map (KeyMask, KeySym) (X ())
resizeMap = M.fromList
    [ ((0, xK_h), sendMessage Shrink)
    , ((0, xK_l), sendMessage Expand)
    , ((0, xK_j), sendMessage Shrink)
    , ((0, xK_k), sendMessage Expand)
    , ((0, xK_Left), sendMessage Shrink)
    , ((0, xK_Right), sendMessage Expand)
    , ((0, xK_Down), sendMessage Shrink)
    , ((0, xK_Up), sendMessage Expand)
    , ((0, xK_Escape), return ())
    , ((0, xK_Return), return ())
    ]

keyBinds :: [(String, X ())]
keyBinds =
  let myLeft = withWindowSet $ \ws -> do
        let lDesc = description . W.layout . W.workspace . W.current $ ws
        if "Full" `isInfixOf` lDesc
          then windows W.focusUp
          else windowGo L False
      myRight = withWindowSet $ \ws -> do
        let lDesc = description . W.layout . W.workspace . W.current $ ws
        if "Full" `isInfixOf` lDesc
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
  , -- Resize Mode (i3 style)
    ("M-z", submap resizeMap)
  , -- Layout switches
    ("M-S-f", sendMessage (JumpToLayout "Full"))
  , ("M-S-w", sendMessage (JumpToLayout "Tall"))
  , ("M-S-v", sendMessage (JumpToLayout "Vertical"))
  , -- i3-style swap + layout switch
    ("M-S-<Left>", windowSwap L False >> sendMessage (JumpToLayout "Tall"))
  , ("M-S-<Right>", windowSwap R False >> sendMessage (JumpToLayout "Tall"))
  , ("M-S-<Up>", windows W.swapUp >> sendMessage (JumpToLayout "Vertical"))
  , ("M-S-<Down>", windows W.swapDown >> sendMessage (JumpToLayout "Vertical"))
  , ("M-S-<Space>", sendMessage NextLayout >> sinkAll)
  , ("M-<Space>", windows W.focusDown)
  , -- Run Programs
    ("M-e", spawn "pcmanfm")
  , ("M-r", spawn "~/.config/rofi/launch.sh drun")
  , ("M-<Return>", spawn "alacritty")
  , ("M-<Print>", spawn "gscreenshot")
  , ("M1-<F4>", spawn "bash ~/.config/eww/toggle.sh powermenu")
  , ("M-S-r", spawn "~/.config/rofi/launch.sh run")
  , ("M-.", spawn "~/.config/eww/toggle.sh emoji")
  ]
