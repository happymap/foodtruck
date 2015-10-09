var express = require('express');
var app = express();

var services = ['Truck'];

var initDynamicRoutes = function(server) {
	var i, ii;
	for (i = 0, ii = services.length; i < ii; ++i) {
		require('./' + services[i] + '/' + services[i] + 'Service').attachRoutes(server);
	}
};

initDynamicRoutes(app);

var server = app.listen(3000, function() {
	var host = server.address().address;
	var port = server.address().port;


	console.log('app listening at http://%s:%s', host, port);
});