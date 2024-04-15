#!/bin/bash
cp -p /home/sovol/patch/config/*.cfg /home/sovol/printer_data/config/
python3 /home/sovol/restart_firmware.py
