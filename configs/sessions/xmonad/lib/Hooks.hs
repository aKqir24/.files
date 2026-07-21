module Hooks (progHook) where

import XMonad
import XMonad.Hooks.ManageHelpers (doRectFloat, isDialog)
import qualified XMonad.StackSet as W

progHook :: ManageHook
progHook =
  composeAll
    [ title =? "eww-bar" --> doShift "1"
    , className =? "Gimp" --> doFloat
    , className =? "io.github.celluloid_player.Celluloid" --> doRectFloat (W.RationalRect 0.10 0.10 0.76 0.76)
    , title =? "ScanGear" --> doRectFloat (W.RationalRect 0.32 0.45 0.40 0.12)
    , title =? "Select Scanner" --> doRectFloat (W.RationalRect 0.40 0.50 0.25 0.10)
    , title =? "Searching..." --> doRectFloat (W.RationalRect 0.40 0.45 0.24 0.15)
    , title =? "Wallet" --> doFloat
    , appName =? "gscreenshot" --> doFloat
    , appName =? "pcmanfm" --> doRectFloat (W.RationalRect 0.18 0.20 0.65 0.55)
    , className =? "Pinentry-gtk-2" --> doFloat
	, className =? "Eww" --> doIgnore 
	, className =? "eww" --> doIgnore
    , isDialog --> doFloat
    ]
