var morgan = require('morgan');
var path = require('path');
var fs = require('fs');

var SchedulePersistence = require('./SchedulePersistence');

var Module = function() {
};

var sampleSchedule =  {
	startTime: new Date(),
	endTime: new Date(),
	address: "4220 George Ave",
	city: "San Mateo",
	state: "CA",
	zip: "94403",
	displayAddress: "4220 George Ave, San Mateo, CA 94403",
	longitude: -122.3131,
	latitude: 37.5542,
	truckId: 1
};

Module.prototype.attachRoutes = function(server) {

	var accessLogStream = fs.createWriteStream(path.join(__dirname + "/../../", 'access.log'), {flags: 'a'});
	// setup the logger
	server.use(morgan('combined', {stream: accessLogStream}));
	
	server.get('/schedule/:truckId', this.getSchedulesByTruckId);
	server.post('/schedule/crud', this.updateSchedules);
};

Module.prototype.getSchedulesByTruckId = function(req, res, next) {
	res.send("unimplemented");
};

Module.prototype.updateSchedules = function(req, res, next) {
	SchedulePersistence.createSchedule(sampleSchedule, function(schedule) {
		if(schedule) {
			res.send(schedule);
		} else {
			res.send(400);
		}
	});
};

Module.prototype.saveSchedule = function() {
	
}

var instance = new Module();
module.exports = instance;