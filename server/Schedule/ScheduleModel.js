var Sequelize = require('sequelize');

var Module = function() {
};

var scheduleSchema = {
	scheduleId: {
		type: Sequelize.BIGINT,
		field: 'schedule_id',
		primaryKey: true
	},
	startTime: {
		type: Sequelize.DATE,
		field: 'start_time'
	},
	endTime: {
		type: Sequelize.DATE,
		field: 'end_time'
	},
	address: {
		type: Sequelize.STRING,
		field: 'address'
	},
	city: {
		type: Sequelize.STRING,
		field: 'city'
	},
	state: {
		type: Sequelize.STRING,
		field: 'state'
	},
	zip: {
		type: Sequelize.STRING,
		field: 'zip'
	},
	displayAddress: {
		type: Sequelize.STRING,
		field: 'display_address'
	},
	longitude: {
		type: Sequelize.FLOAT,
		field: 'longitude'
	},
	latitude: {
		type: Sequelize.FLOAT,
		field: 'latitude'
	},
	truckId: {
		type: Sequelize.BIGINT,
		field: 'truck_id'
	}
};

Module.prototype.scheduleObj = function(sequelize) {
	return sequelize.define('schedule', scheduleSchema, {
		freezeTableName: true, //by default, it uses trucks
		timestamps: false
	});
};

var instance = new Module();
module.exports = instance.scheduleObj;