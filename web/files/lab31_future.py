#! /usr/bin/env python3
import requests
import json
import base64
import argparse
import sys

token=""
def login(app_id, token):
    access_token_url = "https://login.microsoftonline.com/3a424560-9ba5-4111-a8b4-f9bf90679a48/oauth2/v2.0/token"
    payload='grant_type=client_credentials&client_id=%s&client_secret=rZCz~_T6oFuteQz.LvAqmjd3DqzT1KDloF&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default' % app_id
    headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'SdkVersion': 'postman-graph/v1.0',
      'Cookie': 'fpc=AkOoiO8Q9G5PqMNX0dNY89ByR4N7AQAAABVYZdgOAAAA'
    }

    response = requests.request("POST", access_token_url, headers=headers, data=payload)

    token=json.loads(response.text)
    return(token)

def get_attachments():
    url = "https://graph.microsoft.com/v1.0/users/summer@sec588.org/messages/AAMkADgyNTEzM2Q5LWYwNmEtNGQ0MS05MDVmLTllYTM2MGYxZGYyMABGAAAAAADPzzHsWhgfRJBKJou7m9EwBwAgX1ypk-b1TK6T0A17wTSGAAAAAAEMAAAgX1ypk-b1TK6T0A17wTSGAAAA3sNLAAA=/attachments"

    payload={}
    headers = {
      'Content-Type': 'application/json',
      'SdkVersion': 'postman-graph/v1.0',
      'Authorization': 'Bearer %s' % token['access_token'],
    }

    response = requests.request("GET", url, headers=headers, data=payload)

    json_blob=json.loads(response.text)
    print(base64.b64decode(json_blob['value'][0]['contentBytes']).decode('utf-8'))

def main():
    try:
        parser = argparse.ArgumentParser(description="This program will use the Microsoft Graph API to serach for a particular email by MessageId and print out the contents.", formatter_class= argparse.RawTextHelpFormatter)
        parser.add_argument("--app-id", dest="app_ip", help="Assign the Application Id", type=str)
        arguments = parser.parse_args()
    
    except SystemExit:
        # Handle exit() from passing --help
        raise
    except Exception:
        print_error("Wrong Option Provided!")
        parser.print_help()
        sys.exit(1)
    
    if not len(sys.argv) > 1:
        parser.print_usage()
        sys.exit(0)

    app_id = arguments.app_id

    login(app_id, token)
    get_attachments

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print_status('CTRL-C, quitting')