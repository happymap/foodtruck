var TruckPersistence = require('./TruckPersistence');

var Module = function() {
};

Module.prototype.attachRoutes = function(server) {
	server.get('/truck/map', this.getTruckByRange);
	server.get('/truck/list', this.getTrucks);
	server.get('/truck/:id', this.getTruckById);
};

Module.prototype.getTrucks = function(req, res, next) {
	var lon = req.query.lon;
	var lat = req.query.lat;
	var day = req.query.day;
	// var time = req.query.time;
	var time = 0;

	// validate params
	if (!(lon && lat && day)) {
		res.sendStatus(400);
		return;
	}

	TruckPersistence.getTrucks(lat, lon, day, time, function(trucks) {
		if (trucks) {
			res.send(JSON.stringify(trucks));
		} else {
			res.sendStatus(400);
		}
	});
};

Module.prototype.getTruckById = function(req, res, next) {
	var truckId = req.params.id;
	TruckPersistence.getTruckById(truckId, function(truck) {
		if(truck) {
			res.send(truck);
		} else {
			res.sendStatus(400);
		}
	});
};

Module.prototype.getTruckByRange = function(req, res, next) {
	var maxLat = req.query.maxLat;
	var minLat = req.query.minLat;
	var maxLon = req.query.maxLon;
	var minLon = req.query.minLon;
	var day = req.query.day;
	// var time = req.query.time;
	var time = 0;

	TruckPersistence.getTruckByRange(maxLat, minLat, maxLon, minLon, day, time, function(trucks) {
		if (trucks) {
			res.send(JSON.stringify(trucks));
		} else {
			res.sendStatus(400);
		}
	});

};

var instance = new Module();
module.exports = instance;