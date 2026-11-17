
import json
import os
import boto3
import pymysql

secrets = boto3.client("secretsmanager")

SECRET_ARN = os.environ["SECRET_ARN"]
DB_NAME = os.environ["DB_NAME"]
RDS_HOST = os.environ["RDS_HOST"]


def lambda_handler(event, context):

    connection = None

    try:
        # Retrieve RDS credentials
        response = secrets.get_secret_value(
            SecretId=SECRET_ARN
        )

        credentials = json.loads(
            response["SecretString"]
        )

        # Connect to private MySQL RDS
        connection = pymysql.connect(
            host=RDS_HOST,
            user=credentials["username"],
            password=credentials["password"],
            database=DB_NAME,
            port=3306,
            connect_timeout=10
        )

        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            result = cursor.fetchone()

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Successfully connected to RDS",
                "result": result[0]
            })
        }

    except Exception as error:

        print("RDS Error:", str(error))

        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "RDS connection failed"
            })
        }

    finally:
        if connection:
            connection.close()
