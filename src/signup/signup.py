import json
import secretmanager
import firebase_admin
from firebase_admin import credentials, auth, exceptions
import os
import logging
import boto3
from datetime import datetime
from sendemail import sendEmail

logger = logging.getLogger()
logger.setLevel(logging.INFO)

tableName = os.environ.get('USER_TABLE_NAME')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(tableName)
secretName = os.environ.get('SECRET_NAME')
senderEmail = os.environ.get('SENDER_EMAIL')

def initialize_firebase_app():
    if not firebase_admin._apps:
        firebaseCreds = secretmanager.get_secret(secretName)
        cred = credentials.Certificate(firebaseCreds)
        firebase_admin.initialize_app(cred)

def add_user(user_id, email):
    try:
        response = table.put_item(
            Item={
                'id': user_id,
                'email': email,
                'createdAt': datetime.now().isoformat()
            }
        )
    except Exception as e:
        logger.error(f'Error creating the User {e}')

def register(email, pwd, secretName):
    
    try:

        initialize_firebase_app()

        user = auth.create_user(email=email, password=pwd)
        logger.info(f'User Created: {user}')
        verifyLink = auth.generate_email_verification_link(email, action_code_settings=None, app=None)
        logger.info(f'Verification link: {verifyLink}')
        emailMsg = f'To complete registration, please click the link mentioned below: {verifyLink}'
        emailResponse = sendEmail(senderEmail, email, "Verify your email", emailMsg)
        logger.info(f'Email Response: {emailResponse}')
        return {
            'message': 'Successfully created user',
            'user_id': user.uid,
            'verificationLink': verifyLink
        }
    except auth.EmailAlreadyExistsError:
        return {'error': 'user already exists'}
    
    except exceptions.FirebaseError as fe:
        return {'error': str(fe)}
    
    except Exception as e:
        return {'error': str(e)}


def handler(event, context):
    
    body = json.loads(event['body'])
    email = body.get('email')
    pwd = body.get('password')

    if not email or not pwd:
        return {
            'statusCode': 404,
            'body': json.dumps({"message": "Email and Password are required"})
        }
    response = register(email, pwd, secretName)
    logger.info(f'Response from created user: {response}')

    if 'user_id' in response:
        add_user(response['user_id'], email)
    
        return {
                'statusCode': 200,
                'body': json.dumps({"message": "user created successfully", "user_id": response["user_id"]})
            }
    else:
        if 'error' in response and 'already exists' in response['error'].lower():
            return {
                'statusCode': 409,
                'body': json.dumps({"message": "User already exists"})
            }
        return {
            'statusCode': 500,
            'body': json.dumps({"message": response.get('error', 'Unknown error occured')})
        }

