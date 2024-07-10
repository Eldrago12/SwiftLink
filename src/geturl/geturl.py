import json
import boto3
import os
from boto3.dynamodb.conditions import Key
from decimal import Decimal

tableName = os.environ.get('SWIFTTABLE_TABLE_NAME')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(tableName)
domainParam = os.environ.get('DOMAIN_NAME_PARAM')


def decimal_default(val):
    if isinstance(val, Decimal):
        return int(val)
    raise TypeError


def handler(event, context):
    
    baseUrl = event["headers"]["host"]
    domainName = event["requestContext"]["domainName"]
    stage = event["requestContext"]["stage"]
    email = event['requestContext']['authorizer']['jwt']['claims']['email']
    
    try:
        response = table.query(
            IndexName="createdByIndex",
            KeyConditionExpression=Key('createdBy').eq(email)
        )
        items = response['Items']

        fliterdIteams = [
            {
                'id': item['id'],
                'shortcode': item['shortcode'],
                'originalUrl': item['originalUrl'],
                'clicks': item['clicks'],
                'createdAt': item['createdAt'],
                'shortUrl': f'https://{baseUrl}/{stage}/{item["shortcode"]}' if domainParam not in domainName else f'https://{baseUrl}/{item["shortcode"]}'
            }
            for item in items
        ]

        return {
            'statusCode': 200,
            'body': json.dumps(fliterdIteams, default=decimal_default),
            'headers' : {
                'Content-Type': 'application/json'
            }
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 404,
            'body': json.dumps({'message': 'error featching the urls'}),
            'headers' : {
                'Content-Type': 'application/json'
            }
        }