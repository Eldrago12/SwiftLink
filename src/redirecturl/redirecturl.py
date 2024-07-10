import json
import boto3
from boto3.dynamodb.conditions import Key
import os

tablename = os.environ.get('SWIFTTABLE_TABLE_NAME')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(tablename)

def handler(event, context):
    
    try:
        shortcode = event['pathParameters']['short_code']
        response = table.query(
            IndexName = 'UniqueKeyIndex',
            KeyConditionExpression = Key('shortcode').eq(shortcode)
        )
        print(f'{response}')
        items = response.get('Items', [])
        print(items)

        if items:
            item = items[0]
            origInalUrl = item['originalUrl']
            primaryKey = {'id': item.get('id')}


            table.update_item(
                Key = primaryKey,
                UpdateExpression = "ADD clicks :increment",
                ExpressionAttributeValues = {
                    ':increment': 1
                }
            )

        return {
            'statusCode': 302,
            'headers': {
                'Location': origInalUrl
            },
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 404,
            'body': 'Url not found'
        }