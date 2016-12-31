var scraperjs = require('scraperjs');
var SchedulePersistence = require('../Schedule/SchedulePersistence');
var utils = require('./utils.js');

scraperjs.StaticScraper.create('http://www.senorsisig.com/')
	.scrape(function($) {
		return $("#loc-wrap section[data-wcal-date!='error']").map(function() {
			var day = $(this).find(".date").text();
			var address = $(this).find(".map-trigger").text();
			var time = $(this).find(".time").text();
			return {
				'day': day.trim(),
				'address': address,
				'time': time
			};
		}).get();
	})
	.then(function(schedules) {
		for (var i = 0; i < schedules.length; i++) {
			var schedule = schedules[i];
			var dayAndDate = schedule['day'].split('\n');
			var day = dayAndDate[0].trim();
			var times = schedule['time'].split('to');
			var startTime = times[0].trim();
			var endTime = times[1].trim();

			var scheduleToSave = {
				'day': utils.getIntFromDay(day),
				'startTime': startTime,
				'endTime': endTime,
				'address': schedule.address,
				'city': "San Francisco",
				'state': "CA",
				'zip': "",
				'displayAddress': geoCoder.displayAddress,
				'longitude': geoCoder.longitude,
				'latitude': geoCoder.latitude,
				'truckId': 2
			};

			console.log(scheduleToSave);

			// SchedulePersistence.createSchedule(scheduleToSave, function(schedule) {
			// 	if(schedule) {
			// 		console.log('saved successfully.');
			// 	} else {
			// 		res.send(400);
			// 		console.error('failed to save.');
			// 	}
			// });
		}

	});