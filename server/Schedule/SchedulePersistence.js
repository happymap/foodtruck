var sequelize = require('../Core/DBUtil');
var Schedule = require('./ScheduleModel');

var Module = function() {
};

Module.prototype.createSchedule = function(schedule, callback) {
	Schedule(sequelize).create(schedule).then(function(result) {
		callback(result);
	});
};

var instance = new Module();
module.exports = instance;