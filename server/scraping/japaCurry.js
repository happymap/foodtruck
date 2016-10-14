var scraperjs = require('scraperjs');
var SchedulePersistence = require('../Schedule/SchedulePersistence');
var utils = require('./utils.js');

scraperjs.StaticScraper.create('http://japacurry.com')
	.scrape(function($) {
		return $(".schedule-grid").map(function() {
			var day = $(this).find(".day").text();
			var time = $(this).find(".time").text();
			var place = $(this).find(".place").text();
			return {
				"day": day,
				"time": time,
				"place": place
			};
		}).get();
	})
	.then(function(schedules) {
		for (var i = 0; i < schedules.length; i++) {
			var schedule = schedules[i];
        	var times = schedule['time'].split('-');
			var startTimes = times[0].split(':');
			var endTimes = times[1].split(':');

			var startTime = parseInt(startTimes[0]) * 3600;
			if (startTimes.length == 2) {
				startTime += parseInt(startTimes[1]) * 60;
			}

			var endTime = (parseInt(endTimes[0]) < parseInt(startTimes[1]) ? parseInt(endTimes[0]) + 12 : parseInt(endTimes[0])) * 3600;
			if (endTimes.length == 2) {
				endTime += parseInt(endTimes[1]) * 60;
			}

			if (isNaN(startTime) || isNaN(endTime)) {
				continue;
			}
			
			saveSchedule(startTime, endTime, schedule['place'], schedule['day']);
		}
	});


function saveSchedule(startTime, endTime, address, day) {
	utils.getFullAddress(address + ", San Francisco, CA", function(geoCoder) {
		var scheduleToSave = {
			'day': getIntFromDay(day),
			'startTime': startTime,
			'endTime': endTime,
			'address': address,
			'city': "San Francisco",
			'state': "CA",
			'zip': "",
			'displayAddress': geoCoder.displayAddress,
			'longitude': geoCoder.longitude,
			'latitude': geoCoder.latitude,
			'truckId': 1
		};

		SchedulePersistence.createSchedule(scheduleToSave, function(schedule) {
			if(schedule) {
				console.log('saved successfully.');
			} else {
				res.send(400);
				console.error('failed to save.');
			}
		});
	});
}

function getIntFromDay(day) {
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
}