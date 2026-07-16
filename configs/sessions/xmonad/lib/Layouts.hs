module Layouts (myLayouts) where

import XMonad hiding ((|||))
import XMonad.Layout.LayoutCombinators ((|||))
import XMonad.Layout.Renamed (Rename (..), renamed)
import XMonad.Layout.Spacing (Border (..), spacingRaw)
import XMonad.Layout.ToggleLayouts (toggleLayouts)

myLayouts = theGaps 3 $ toggleLayouts fullLayout (tallLayout ||| verticalLayout)
  where
    fullLayout     = renamed [Replace "Full"] Full
    tallLayout     = renamed [Replace "Tall"] (Tall 1 (3 / 100) (1 / 2))
    verticalLayout = renamed [Replace "Vertical"] (Mirror (Tall 1 (3 / 100) (1 / 2)))
    theGaps i = spacingRaw False (Border i i i i) True (Border i i i i) True