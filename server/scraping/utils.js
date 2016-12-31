var request = require('request');

var Module = function() {
};

const GEOCODING_API_KEY = "AIzaSyCKR_2C2MxXq41kI5s8JhlhOybzgYlekJ4";

Module.prototype.getFullAddress = function(address, cb) {

	address = address.replace('&', ' and ');

	var url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + 
		"&key=" + GEOCODING_API_KEY;

	request(encodeURI(url), function (error, response, body) {
		if (!error && response.statusCode == 200) {
			var locationObj = JSON.parse(body).results[0];
			cb({
				'longitude': locationObj.geometry.location.lng,
				'latitude': locationObj.geometry.location.lat,
				'displayAddress': locationObj.formatted_address
			});
		}
	});
};

Module.prototype.getIntFromDay = function(day) {
	switch(day.toLowerCase()) {
		case 'monday':
			return 0;
		case 'tuesday':
			return 1;
		case 'wednesday':
			return 2;
		case 'thursday':
			return 3;
		case 'friday':
			return 4;
		case 'saturday':
			return 5;
		case 'sunday':
			return 6;	
	}
};

var instance = new Module();
module.exports = instance;