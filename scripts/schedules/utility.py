import json
import requests
import urllib

GEOCODE_API_KEY = "AIzaSyBc4QTunojKpcQRXLFaXlYi5gBF9Z2irS0"
GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json"

def get_coordinate_by_address(address):
	params = urllib.urlencode({"address": address, "key": GEOCODE_API_KEY})
	url = GEOCODE_URL + "?" + params
	resp = requests.get(url)
	data = json.loads(resp.text)

	if len(data['results']) == 0:
		return

	return [data['results'][0]['geometry']['location']['lat'], data['results'][0]['geometry']['location']['lng']]