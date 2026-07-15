import XMonad
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts

import XMonad.Actions.WithAll
import XMonad.Actions.Navigation2D
import XMonad.Actions.RotSlaves (rotSlavesUp, rotAllUp)

import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers (isDialog, doRectFloat)
import XMonad.Util.NamedScratchpad (customFloating)

import Graphics.X11
import Colors

-- Main Settings 
main :: IO()
main = xmonad $ def
	{ modMask            = mod4Mask
	, terminal           = "alacritty"
	, normalBorderColor  = Colors.alt_background
	, focusedBorderColor = Colors.accent
	, borderWidth        = 2
	, layoutHook         = theLayouts
	, manageHook = progHook <+> manageHook def
	} 
	`additionalKeysP` keyBinds

-- Custom Feature  Definitions
unGrab :: X ()
progHook :: ManageHook
keyBinds :: [(String, X ())]
theLayouts =  theGaps 3 $ toggleLayouts (Full) (Tall 1 (3/100) (1/2))
theGaps i = spacingRaw False (Border i i i i) True (Border i i i i) True
unGrab = withDisplay $ \d -> io $ allowEvents d 1 currentTime

-- Keybindings
keyBinds =
	[

	-- Window Manipulation
	  ("C-q", kill)
	, ("M1-<Tab>", rotAllUp)
	, ("M1-S-<Tab>", rotSlavesUp)
	, ("M-<Left>", windowGo L False)
	, ("M-<Right>", windowGo R False)
	, ("M-<Up>", windowGo U False)
	, ("M-<Down>", windowGo D False)
	, ("M-S-<Left>", windowSwap L False)
	, ("M-S-<Right>", windowSwap R False)
	, ("M-S-<Up>", windowSwap U False)
	, ("M-S-<Down>", windowSwap D False)
	, ("M-S-<Space>", sendMessage ToggleLayout >> sinkAll)
	, ("M-<Space>", windows W.focusDown)
	
	-- Run Programs
	, ("M-e", spawn "pcmanfm")
	, ("M-<Return>", spawn "alacritty")
	, ("M-<Print>", spawn "gscreenshot")
	--, ("M-r"), )
	]

-- Individual Window Properties
progHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , className =? "Celluloid"      --> doRectFloat (W.RationalRect 0.20 0.20 0.70 0.70)
    , appName   =? "scangearmp2"    --> doFloat
    , title     =? "Wallet"         --> doFloat
    , appName   =? "gscreenshot"    --> doFloat
    , appName   =? "pcmanfm"        --> doRectFloat (W.RationalRect 0.20 0.20 0.55 0.55)
    , className =? "Pinentry-gtk-2" --> doFloat
    
    -- Float dialog windows automatically
    , isDialog                      --> doFloat
    ]
