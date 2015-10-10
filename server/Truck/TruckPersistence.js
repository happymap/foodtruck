var sequelize = require('../Core/DBUtil');
var Truck = require('./TruckModel');

var Module = function() {
};

var nearbyTrucksQuery = function(lat, lng, distance) {
	return "SELECT truck.truck_id, name, description,"
+ "       SQRT(POW(69.1 * (latitude - " + lat + "), 2) "
+ "           + POW(69.1 * (" + lng + " - longitude) * COS(latitude / 57.3), 2)) AS "
+ "       distance "
+ "FROM schedule "
+ "JOIN truck ON schedule.truck_id = truck.truck_id "
+ "HAVING distance < " + distance + " "
+ "ORDER  BY distance ";
};


Module.prototype.getAllTrucks = function(callback) {
	Truck(sequelize).findAll().then(function(trucks) {
		callback(trucks);
	});
};

Module.prototype.getTrucks = function(lat, lng, callback) {
	sequelize.query(nearbyTrucksQuery(lat, lng, 25)).spread(function(results, metadata) {
		callback(results);
	});
};

var instance = new Module();
module.exports = instance;