var TruckPersistence = require('./TruckPersistence');

var Module = function() {
};

Module.prototype.attachRoutes = function(server) {
	server.get('/truck/list', this.getTrucks);
};

Module.prototype.getTrucks = function(req, res, next) {
	TruckPersistence.getTrucks(function(trucks) {
		if(trucks) {
			res.send(trucks);
		} else {
			res.send(400);
		}
	});
};

var instance = new Module();
module.exports = instance;