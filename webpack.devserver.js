const webpack = require('webpack');
const WebpackDevServer = require('webpack-dev-server');
const config = require('./webpack.config');
const port = process.env.PORT || 3000;
const logMode = process.env.LOG;

new WebpackDevServer(webpack(config), {
	publicPath: config.output.publicPath,
	contentBase: 'web/static',
	hot: true,
	historyApiFallback: {
		index: 'app.html',
	},
	stats: {
		assets:         false,
		colors:         true,
		version:        false,
		hash:           false,
		timings:        true,
		chunks:         true,
		chunkModules:   !!logMode,
	},
	quiet: false,
	noInfo: false,
}).listen(port, '0.0.0.0', function (err, result) {
	if (err) {
		return console.log(err);
	}

	require('./cypher-builder');
	console.log('Listening at http://localhost:'+port);
});
