import boto3
from elasticsearch import Elasticsearch
import json

def lambda_handler(event, context):
    # Assume the logs are in JSON format in the S3 event
    opensearch_endpoint = event.get('opensearch_endpoint')
    for record in event['Records']:
        # Retrieve S3 bucket and object key
        s3_bucket = record['s3']['bucket']['name']
        s3_key = record['s3']['object']['key']

        # Download the log file content from S3
        s3 = boto3.client('s3')
        response = s3.get_object(Bucket=s3_bucket, Key=s3_key)
        log_content = response['Body'].read().decode('utf-8')

        # Parse the log content (assuming it's JSON)
        logs = json.loads(log_content)

        # # Index logs into OpenSearch
        opensearch = Elasticsearch([opensearch_endpoint])
        for log in logs:
            # Customize this based on your log structure
            index_document = {
                'timestamp': log['timestamp'],
                'message': log['message']
                # Add more fields as needed
            }

            # Index the document into OpenSearch @todo need to be changed
            opensearch.index(index='app_logs', body=index_document)

    return {
        'statusCode': 200,
        'body': json.dumps('Logs indexed successfully!')
    }
