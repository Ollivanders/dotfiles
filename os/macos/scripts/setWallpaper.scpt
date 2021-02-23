#!/usr/bin/env osascript

tell application "System Events"
	set desktopCount to count of desktops
	repeat with desktopNumber from 1 to desktopCount
		tell desktop desktopNumber
			set someFile to some file of folder ("/Users/Ollivander/Pictures")
			set picture to someFile
		end tell
	end repeat
end tell