var Sequelize = require('sequelize');

var Module = function() {
};

var truckSchema = {
	truckId: {
		type: Sequelize.BIGINT,
		field: 'truck_id',
		primaryKey: true
	},
	name: {
		type: Sequelize.STRING,
		field: 'name'
	},
	description: {
		type: Sequelize.STRING,
		field: 'description'
	},
	logo: {
		type: Sequelize.STRING,
		field: 'logo'
	}
};

Module.prototype.truckObj = function(sequelize) {
	return sequelize.define('truck', truckSchema, {
		freezeTableName: true, //by default, it uses trucks
		timestamps: false
	});
};

var instance = new Module();
module.exports = instance.truckObj;