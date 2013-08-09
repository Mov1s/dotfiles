import XMonad
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import System.IO

main = do
	dzenTopBar <- spawnPipe myTopStatusBar
	conkyBottomBar <- spawnPipe myBottomStatusBar
	xmonad $ defaultConfig {
		terminal                = myTerminal
        , workspaces            = myWorkspaces
        , logHook               = myLogHook dzenTopBar >> fadeInactiveLogHook 0xdddddddd
		, normalBorderColor     = myNormalBorderColor
		, focusedBorderColor    = myFocusedBorderColor
		, layoutHook            = avoidStruts $ layoutHook defaultConfig
		, manageHook            = manageHook defaultConfig <+> manageDocks
	}

-- Dzen specific color and font settings
dzenFont		    = "AvantGarde LT Medium:size=7"
colorDzenBack		= "#2C2C2A" --Background (Dzen_BG)
colorDzenFront		= "#ABAA98" --Frontground (DZen_FG)

-- Basic settings and prefs
myTerminal              = "urxvt"
myNormalBorderColor	    = "#ABAA98"
myFocusedBorderColor	= "#00B9D7"
myWorkspaces            = ["1:main", "2:vim", "3:web"]

-- Log output hook for printing workspaces into dzen
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#FF3D73" colorDzenBack . pad
      , ppVisible           =   dzenColor "white" colorDzenBack . pad
      , ppHidden            =   dzenColor "white" colorDzenBack . pad
      , ppHiddenNoWindows   =   dzenColor colorDzenFront colorDzenBack . pad
      , ppUrgent            =   dzenColor "#ff0000" colorDzenBack . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#1B1D1E" . (\x -> "")
      , ppOutput            =   hPutStrLn h
    }

-- Dzen and conky status bar configurations
myBottomStatusBar = "conky"
myTopStatusBar = "dzen2 -e '' -p -h '16' -ta l -fg '" ++ colorDzenFront ++ "' -bg '" ++ colorDzenBack ++ "' -fn '" ++ dzenFont ++ "'"
