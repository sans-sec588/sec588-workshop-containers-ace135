#! /usr/bin/env python3
import requests
import json
import base64
access_token_url = "https://login.microsoftonline.com/3a424560-9ba5-4111-a8b4-f9bf90679a48/oauth2/v2.0/token"
payload='grant_type=client_credentials&client_id=49580668-6a63-40dc-8a80-71760f366f0a&client_secret=rZCz~_T6oFuteQz.LvAqmjd3DqzT1KDloF&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default'
headers = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'SdkVersion': 'postman-graph/v1.0',
  'Cookie': 'fpc=AkOoiO8Q9G5PqMNX0dNY89ByR4N7AQAAABVYZdgOAAAA'
}
response = requests.request("POST", access_token_url, headers=headers, data=payload)
token=json.loads(response.text)
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