var sequelize = require('../Core/DBUtil');
var Truck = require('./TruckModel');

var Module = function() {
};

Module.prototype.getTrucks = function(callback) {
	Truck(sequelize).findAll().then(function(trucks) {
		callback(trucks);
	});
};

var instance = new Module();
module.exports = instance;