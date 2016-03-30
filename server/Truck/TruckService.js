var TruckPersistence = require('./TruckPersistence');

var Module = function() {
};

Module.prototype.attachRoutes = function(server) {
	server.get('/truck/list', this.getTrucks);
	server.get('/truck/:id', this.getTruckById);
};

Module.prototype.getTrucks = function(req, res, next) {
	var lon = req.query.lon;
	var lat = req.query.lat;
	var day = req.query.day;
	var hour = req.query.hour;
	TruckPersistence.getTrucks(lat, lon, day, hour, function(trucks) {
		if(trucks) {
			res.send(trucks);
		} else {
			res.send(400);
		}
	});
};

Module.prototype.getTruckById = function(req, res, next) {
	var truckId = req.params.id;
	TruckPersistence.getTruckById(truckId, function(truck) {
		if(truck) {
			res.send(truck);
		} else {
			res.send(400);
		}
	});
};

var instance = new Module();
module.exports = instance;