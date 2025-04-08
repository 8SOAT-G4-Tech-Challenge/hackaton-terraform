exports.handler = async (event) => {
	try {
		const claims = event.requestContext.authorizer.jwt.claims;

		const response = {
			username: claims['cognito:username'],
			id: claims['sub'],
			email: claims.email,
			phoneNumber: claims.phone_number,
		};

		return {
			statusCode: 200,
			body: JSON.stringify(response),
		};
	} catch (error) {
		console.error('Error getting user:', error);
		return {
			statusCode: 500,
			body: JSON.stringify({ error: 'Failed to get user' }),
		};
	}
};
