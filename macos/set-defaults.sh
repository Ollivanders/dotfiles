true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
"Address Book" \
"Calendar" \
"cfprefsd" \
"Contacts" \
"Dock" \
"Finder" \
"Google Chrome Canary" \
"Google Chrome" \
"Mail" \
"Messages" \
"Opera" \
"Photos" \
"Safari" \
"Terminal" \
"iCal"; do
    killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."