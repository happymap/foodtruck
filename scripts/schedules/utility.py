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