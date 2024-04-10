#!/bin/bash

cd /root
git clone https://github.com/RhinoSecurityLabs/pacu.git
cd /root/pacu
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt

