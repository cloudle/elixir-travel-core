import React, { Component } from 'react';
import GraphiQL from 'graphiql';

import 'graphiql/graphiql.css';

export default function () {
	return <GraphiQL fetcher={fetcher}>
		<GraphiQL.Toolbar>
			<GraphiQL.ToolbarButton label="Click me!"/>
		</GraphiQL.Toolbar>
	</GraphiQL>
}

function fetcher(graphQLParams) {
	let token = localStorage.getItem('sysConfig'),
		headers = {'Content-Type': 'application/json'};

	if (token) headers['Authorization'] = token;

	// const endPoint = 'http://128.199.235.75:8888/wire';
	const endPoint = window.location.origin + '/wire';
	return fetch(endPoint, {
		method: 'POST',
		headers,
		body: JSON.stringify(graphQLParams),
	}).then(response => response.json());
}
