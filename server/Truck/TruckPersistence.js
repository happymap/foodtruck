var sequelize = require('../Core/DBUtil');
var Truck = require('./TruckModel');

var Module = function() {
};

var nearbyTrucksQuery = function(lat, lng, distance, day, time) {
	return "SELECT truck.truck_id, schedule.schedule_id, schedule.address, truck.name, truck.description, truck.logo, schedule.start_time, schedule.end_time, "
+ "schedule.latitude, schedule.longitude, truck.image, "
+ "SQRT(POW(69.1 * (latitude - " + lat + "), 2) "
+ "+ POW(69.1 * (" + lng + " - longitude) * COS(latitude / 57.3), 2)) AS "
+ "distance "
+ "FROM schedule "
+ "JOIN truck ON schedule.truck_id = truck.truck_id "
+ "WHERE day = " + day + " "
+ "and start_time <= " + time + " "
+ "and end_time >= " + time + " "
+ "HAVING distance < " + distance + " "
+ "ORDER  BY distance ";
};

var mapTrucksQuery = function(maxLat, minLat, maxLon, minLon, day, time) {
	return "SELECT truck.truck_id, schedule.schedule_id, schedule.address, truck.name, truck.description, truck.logo, schedule.start_time, schedule.end_time, "
+ "schedule.latitude, schedule.longitude, truck.image "
+ "FROM schedule "
+ "JOIN truck ON schedule.truck_id = truck.truck_id "
+ "WHERE day = " + day + " "
+ "and start_time <= " + time + " "
+ "and end_time >= " + time + " "
+ "and schedule.latitude >= " + minLat + " "
+ "and schedule.latitude <= " + maxLat + " "
+ "and schedule.longitude >= " + minLon + " "
+ "and schedule.longitude <= " + maxLon;
};

Module.prototype.getAllTrucks = function(callback) {
	Truck(sequelize).findAll().then(function(trucks) {
		callback(trucks);
	});
};

Module.prototype.getTrucks = function(lat, lng, day, hour, callback) {
	sequelize.query(nearbyTrucksQuery(lat, lng, 25, day, hour)).spread(function(results, metadata) {
		callback(results);
	});
};

Module.prototype.getTruckById = function(id, callback) {
	Truck(sequelize).findOne({
		where: {
			truckId: id
		}
	}).then(function(truck) {
		callback(truck);
	});
};

Module.prototype.getTruckByRange = function(maxLat, minLat, maxLon, minLon, day, time, callback) {
	sequelize.query(mapTrucksQuery(maxLat, minLat, maxLon, minLon, day, time)).spread(function(results, metadata) {
		callback(results);
	});
};

Module.prototype.createTruck = function(truck, callback) {
	Truck(sequelize).create(truck).then(function(truck) {
		callback(truck);
	});
};

var instance = new Module();
module.exports = instance;