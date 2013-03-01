import XMonad
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks

main = do
	dzenTopBar <- spawnPipe myTopStatusBar 
	conkyBottomBar <- spawnPipe myBottomStatusBar
	xmonad $ defaultConfig {
		terminal = "urxvt"
		, normalBorderColor = myNormalBorderColor
		, focusedBorderColor = myFocusedBorderColor
		, layoutHook = avoidStruts $ layoutHook defaultConfig
		, manageHook = manageHook defaultConfig <+> manageDocks
	}

dzenFont		= "AvantGarde LT Medium:size=7"
colorDzenBack		= "#2C2C2A" --Background (Dzen_BG)
colorDzenFront		= "#ABAA98" --Frontground (DZen_FG)
myNormalBorderColor	= "#ABAA98"
myFocusedBorderColor	= "#00B9D7"

myTopStatusBar = "conky -c /home/ryan/.conkyrc.dzentop | dzen2 -e '' -p -h '16' -ta r -fg '" ++ colorDzenFront ++ "' -bg '" ++ colorDzenBack ++ "' -fn '" ++ dzenFont ++ "'"
myBottomStatusBar = "conky"
