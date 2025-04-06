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
			body: JSON.stringify({
				username: response.Username,
				id: response.UserAttributes.find((attr) => attr.Name === 'custom:id')
					.Value,
				email: response.UserAttributes.find((attr) => attr.Name === 'email')
					.Value,
				phoneNumber: response.UserAttributes.find(
					(attr) => attr.Name === 'phone_number'
				).Value,
			}),
		};
	} catch (error) {
		console.error('Error getting user:', error);
		return {
			statusCode: 500,
			body: JSON.stringify({ error: 'Failed to get user' }),
		};
	}
};
