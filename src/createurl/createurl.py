import json
import os
import boto3
import uuid
import random
import string
from datetime import datetime, timedelta

tableName = os.environ.get('SWIFTTABLE_TABLE_NAME')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(tableName)
domainParam = os.environ.get('DOMAIN_NAME_PARAM')

def generate_short_code(url, length=6):
    char_pool = string.ascii_lowercase + string.ascii_uppercase + string.digits
    return ''.join(random.sample(char_pool, length))
    

def handler(event, context):
    
    print(event)
    body = json.loads(event["body"])
    print(f'Body from event: {body}')
    originalUrl = body.get('originalUrl')
    domainName = event["requestContext"]["domainName"]
    stage = event["requestContext"]["stage"]
    shortUrlResponse = generate_short_code(originalUrl)

    email = event['requestContext']['authorizer']['jwt']['claims']['email']

    if domainParam not in domainName:
        shortUrl = f'https://{event["headers"]["host"]}/{stage}/{shortUrlResponse}'
    else:   # for custom domain
        shortUrl = f'https://{event["headers"]["host"]}/{shortUrlResponse}'
    data = {
        'id': str(uuid.uuid4()),
        'originalUrl': originalUrl,
        'createdBy': email,
        'shortcode': shortUrlResponse,
        'createdAt': datetime.now().isoformat(),
        'clicks': 0
        # 'shortUrl': shortUrl
    }

    try:
        table.put_item(Item=data)
        return {
            'statusCode': 201,
            'body': json.dumps({
                'shortUrl': shortUrl
            }),
            'headers': {
                'Content-Type': 'application/json',
            }
        }
    except Exception as e:
        response = {
            'statusCode': 403,
            'body': json.dumps({"message": "error saving data"})
        }