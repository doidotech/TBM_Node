#!/bin/bash
#-------------------------------------------------------------------------------
#   Copyright (c) DOIDO Technologies
# This script is used to create an Raspiblitz lcd service that starts at boot
# systemd is used.
#-------------------------------------------------------------------------------


# Get user currency
gettingCurrency=true

# Loop until user enters a valid currency
while $gettingCurrency 
	do
    	echo
		read -p "Please Enter Currency Code e.g. USD for US Dollar: " newCurrency
		# Convert to uppercase
		newCurrency=${newCurrency^^}
		echo $newCurrency

		# Check if user entered a valid currency code
		validationResult=$(python3 ./CurrencyData.py ${newCurrency})
		if [ "$validationResult" = "Valid" ]; then
    			echo "Creating Raspiblitz ST7735 LCD Service."
    			gettingCurrency=false
			
				# Get current working directory
				cwd=$(pwd)

# Create A Unit File
sudo echo "[Unit]
Description=Raspiblitz LCD Service
After=multi-user.target
[Service]
Type=idle
ExecStart=/usr/bin/python3 $cwd/RaspiblitzLCD.py $newCurrency
[Install]
WantedBy=multi-user.target" > /lib/systemd/system/raspiBlitzST7735LCD.service

				# The permission on the unit file needs to be set to 644
				sudo chmod 644 /lib/systemd/system/raspiBlitzST7735LCD.service

				# Configure systemd
				sudo systemctl daemon-reload
				sudo systemctl enable raspiBlitzST7735LCD.service

				# Start the service
				sudo systemctl start raspiBlitzST7735LCD.service
				echo "Done Creating raspiBlitzST7735LCD.service."
		else
    			#echo "Entered Currency code is not valid!!!"
    			echo -e "\e[1;31m Entered Currency code is not valid!!! \e[0m"
		fi
	done
