#!/bin/bash

echo "

Welcome to the SEC588 Workshop Series, this set of workshops will be updated throughout time. This script will get you started. 

Remember: You will need an X86 Version of Docker to use this workshop series.
"

cd tools

docker build -t sec588-tools .
docker compose build

echo "Open your Webbrowser and point it to: http://localhost:8000"