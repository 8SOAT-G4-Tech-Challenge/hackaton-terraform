const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider({ region: 'us-east-1' });

exports.handler = async (event) => {
	try {
		const userPoolId = process.env.USER_POOL_ID;
		const username = event.username;
		const phoneNumber = event.phoneNumber;
		const email = event.email;
		const tempPassword = 'TempPass123!';

		await cognito
			.adminCreateUser({
				UserPoolId: userPoolId,
				Username: username,
				UserAttributes: [
					{ Name: 'email', Value: email },
					{ Name: 'email_verified', Value: 'true' },
					{ Name: 'phone_number', Value: phoneNumber },
					{ Name: 'phone_number_verified', Value: 'true' },
				],
				TemporaryPassword: tempPassword,
				MessageAction: 'SUPPRESS',
			})
			.promise();

		await cognito
			.adminSetUserPassword({
				UserPoolId: userPoolId,
				Username: username,
				Password: event.password,
				Permanent: true,
			})
			.promise();

		return {
			statusCode: 200,
			body: JSON.stringify({
				message: 'User created successfully',
			}),
		};
	} catch (error) {
		console.error('Error creating user:', error);
		return {
			statusCode: 500,
			body: JSON.stringify({ error: error.message }),
		};
	}
};
