const fs = require('fs');
const chokidar = require('chokidar');
const decypher = require('decypher/loader');

chokidar.watch('./cyphers.cypher').on('all', (event, path) => {
	const queries = decypher('./cyphers.cypher');
	fs.writeFile("./cyphers.json",
		JSON.stringify(queries),
		function(err) {
			if(err) return console.log(err);
			console.log("Cyphers updated..");
		});
});