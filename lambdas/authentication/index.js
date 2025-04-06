const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider({ region: 'us-east-1' });

exports.handler = async (event) => {
	try {
		const { username, password } = JSON.parse(event.body);

		const params = {
			AuthFlow: 'USER_PASSWORD_AUTH',
			ClientId: process.env.CLIENT_ID,
			AuthParameters: {
				USERNAME: username,
				PASSWORD: password,
			},
		};

		const response = await cognito.initiateAuth(params).promise();

		if (response?.ChallengeName) {
			return {
				statusCode: 200,
				headers: {
					'Content-Type': 'application/json',
					'Access-Control-Allow-Origin': '*',
				},
				body: JSON.stringify({
					message: 'Authentication almost successful',
					challenge: response?.ChallengeName,
				}),
			};
		}

		return {
			statusCode: 200,
			body: JSON.stringify({
				accessToken: response.AuthenticationResult.AccessToken,
				refreshToken: response.AuthenticationResult.RefreshToken,
				idToken: response.AuthenticationResult.IdToken,
				expiresIn: response.AuthenticationResult.ExpiresIn,
			}),
		};
	} catch (error) {
		console.error('Authentication error:', error);

		return {
			statusCode: 401,
			body: JSON.stringify({
				error: 'Invalid credentials or authentication failed',
			}),
		};
	}
};
