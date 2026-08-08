module Layouts (myLayouts) where

import XMonad hiding ((|||))
import XMonad.Layout.LayoutCombinators ((|||))
import XMonad.Layout.Renamed (Rename (..), renamed)
import XMonad.Layout.Spacing (Border (..), spacingRaw)
import XMonad.Layout.Tabbed (tabbed, shrinkText)

myLayouts theme = theGaps 4 (fullLayout ||| tallLayout ||| verticalLayout ||| tabbed shrinkText theme)
  where
    fullLayout     = renamed [Replace "Full"] (Full :: Full Window)
    tallLayout     = renamed [Replace "Tall"] (Tall 1 (3 / 100) (1 / 2) :: Tall Window)
    verticalLayout = renamed [Replace "Vertical"] (Mirror (Tall 1 (3 / 100) (1 / 2)) :: Mirror Tall Window)
    theGaps i = spacingRaw False (Border i i i i) True (Border i i i i) True
