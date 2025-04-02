const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider({ region: 'us-east-1' });

exports.handler = async (event) => {
	try {
		const accessToken = event.accessToken;

		const response = await cognito
			.getUser({
				AccessToken: accessToken,
			})
			.promise();

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
