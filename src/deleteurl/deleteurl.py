import json
import boto3
import os
from boto3.dynamodb.conditions import Attr

tablename = os.environ.get('SWIFTTABLE_TABLE_NAME')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(tablename)

def handler(event, context):
    
    try:

        email = event['requestContext']['authorizer']['jwt']['claims']['email']

        recordId = event['pathParameters']['id']

        response = table.delete_item(
            Key = {
                'id': recordId
            },
            ConditionExpression=Attr('createdBy').eq(email)
        )
        print(f'response for debugging: {response}')

        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'Deleted url successfully'}),
            'headers': {'Content-Type': 'application/json'}
        }
    
    except table.meta.client.exceptions.ConditionalCheckFailedException:

        return {
            'statusCode': 403,
            'body': json.dumps({'message': 'Not authorized to delete this url'}),
            'headers': {'Content-Type': 'application/json'}
        }
    
    except KeyError:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'failed to delete the record'}),
            'headers': {'Content-Type': 'application/json'}
        }