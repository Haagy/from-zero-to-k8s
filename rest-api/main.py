import os
import socket
import psycopg2
import sys
from flask import Flask

app = Flask(__name__)
connection = None


def __get_database_connection():
    return psycopg2.connect(
        host=os.getenv("POSTGRES_HOST"),
        database=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD")
    )


@app.route("/", methods=['GET'])
def index():
    return f"Hello! Greetings from Pod: {socket.gethostname()}"


@app.route("/write/<some_value>", methods=['POST'])
def write2table(some_value):
    try:
        connection = __get_database_connection()
        cursor = connection.cursor()
        cursor.execute(
            f"INSERT INTO rest_api_table(SOME_VALUE) VALUES ('{some_value}')"
        )
        connection.commit()
        return f"Added value: [{some_value}] to database: [rest_api_table]"

    except (Exception, psycopg2.Error) as error:
        return f"Failed to insert record into rest_api_table: {error}"
    finally:
        if connection is not None:
            connection.close()


@app.route("/get-values", methods=['GET'])
def get_values():
    try:
        connection = __get_database_connection()
        cursor = connection.cursor()
        cursor.execute(
            'SELECT * from rest_api_table'
        )
        records = cursor.fetchall()
        all_values = ""
        for row in records:
            all_values += f'Value: {row} \n'
        return all_values

    except (Exception, psycopg2.Error) as error:
        return f"Failed to get values from rest_api_table: {error}"
    finally:
        if connection is not None:
            connection.close()


if __name__ == "__main__":
    try:
        connection = __get_database_connection()
        cursor = connection.cursor()
        cursor.execute(
            'CREATE TABLE IF NOT EXISTS rest_api_table (SOME_VALUE VARCHAR (255) UNIQUE NOT NULL);'
        )
        connection.commit()
        print("Initialized app with database table [rest_api_table]")
    except (Exception, psycopg2.Error) as error:
        print("Failed to initialize database table")
        sys.exit(error)
    finally:
        if connection is not None:
            connection.close()

    app.run(
        host='0.0.0.0',
        port=5000
    )
