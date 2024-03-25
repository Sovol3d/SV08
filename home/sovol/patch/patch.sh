#!/bin/bash

# Copy job_status.py, print.py, and system.py to the panels directory
#cp job_status.py ../KlipperScreen/panels/
#cp print.py ../KlipperScreen/panels/
#cp system.py ../KlipperScreen/panels/
#cp plr.py ../KlipperScreen/panels/

#cp screen.py ../KlipperScreen/
#cp screen_panel.py ../KlipperScreen/ks_includes/

cp -p config/*.cfg ../printer_data/config/

cp -p menu.py ../klipper/klippy/extras/display/
cp -p menu.cfg ../klipper/klippy/extras/display/
cp -p display.cfg ../klipper/klippy/extras/display/

# Check if the copy was successful
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to copy files to their respective directories."
    exit 1
fi

echo "Files copied successfully."

