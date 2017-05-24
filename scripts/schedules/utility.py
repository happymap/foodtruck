import json
import requests
import urllib

from DBUtil import *

GEOCODE_API_KEY = "AIzaSyBc4QTunojKpcQRXLFaXlYi5gBF9Z2irS0"
GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json"

def get_coordinate_by_address(address):
    params = urllib.urlencode({"address": address, "key": GEOCODE_API_KEY})
    url = GEOCODE_URL + "?" + params
    resp = requests.get(url)
    data = json.loads(resp.text)

    if len(data['results']) == 0:
        return

    zip = ""
    address_components = data['results'][0]['address_components']

    for component in address_components:
        if component['types'][0] == "postal_code":
            zip = component['long_name']

    return {
                "latitude": data['results'][0]['geometry']['location']['lat'], 
                "longitude": data['results'][0]['geometry']['location']['lng'],
                "zip": zip
            }

def formalize_address(address):
    params = urllib.urlencode({"address": address, "key": GEOCODE_API_KEY})
    url = GEOCODE_URL + "?" + params
    resp = requests.get(url)
    data = json.loads(resp.text)
    
    if len(data['results']) == 0:
        return

    address = data['results'][0]['formatted_address']
    addressParts = address.split(",")
    result = ""
    for x in range(0, len(addressParts) - 1):
        if x == len(addressParts) - 2:
            result += addressParts[x]   
        else:
            result += addressParts[x] + ","

    return result

def convert_to_pojo(item):
    schedule = Schedule(
        day = item['day'],
        truck_id = item['truck_id'],
        address = item['address'],
        latitude = item['latitude'],
        longitude = item['longitude'],
        city = item['city'],
        state = item['state'],
        zip = item['zip'],
        start_time = item['start_time'],
        end_time = item['end_time'])
    return schedule

# input: 11:00am - 2:00pm
def parse_times_pair_string(timesStr):
    parts = timesStr.split("-")
    return [parse_times_string(parts[0].strip()), parse_times_string(parts[1].strip())]

def parse_times_string(timeStr):
    amOrPm = timeStr[len(timeStr) - 2:]
    time = timeStr[:len(timeStr) - 2]
    hour = int(time.split(":")[0])
    minute = int(time.splt(":")[1])

    if amOrPm == "pm":
        hour += 12
    return hour * 3600 + minute * 60


