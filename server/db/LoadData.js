var async = require('async');
var data = require('./SampleData');
var SchedulePersistence = require('../Schedule/SchedulePersistence');
var TruckPersistence = require('../Truck/TruckPersistence');

async.series({
	// insert truck sample data
	one: function(callback) {
		if(data.truck && data.truck.length > 0) {
			data.truck.forEach(function(truck) {
				TruckPersistence.createTruck(truck, function(truck) {
					callback(null, "successfully inserted truck:" + truck.name);
				});
			});
		}
	},
	// insert schedule sample data
	two: function(callback) {
		if(data.schedule && data.schedule.length > 0) {
			data.schedule.forEach(function(schedule) {
				SchedulePersistence.createSchedule(schedule, function(schedule) {
					callback(null, "successfully inserted schdule" + schedule.startTime);
				});
			});
		}
	}
},
function(error, logStatement) {
	console.log(logStatement);
});

