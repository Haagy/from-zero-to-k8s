import os
import socket
import psycopg2 as db
from flask import Flask

app = Flask(__name__)

def __get_database_connection():
    return db.connect(
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
        conn = __get_database_connection()
        cur = conn.cursor()
        cur.execute(
            'INSERT INTO mobile (SOME_VALUE) VALUES (%s)',
            some_value
        )
        return f"Added value: [{some_value}] to database [rest_api_table]"

    except (Exception, db.Error) as error:
        return f"Failed to insert record into rest_api_table: {error}"
    finally:
        if conn is not None:
            conn.close()

@app.route("/create-table", methods=['POST'])
def create_table():
    try:
        conn = __get_database_connection()
        cur = conn.cursor()
        cur.execute(
            'CREATE TABLE IF NOT EXISTS rest_api_table (SOME_VALUE VARCHAR (255) UNIQUE NOT NULL);'
        )
        conn.commit()
        return "Created table [rest_api_table]"
    except (Exception, db.Error) as error:
        return f"Failed to create database: {error}"
    finally:
        if conn is not None:
            conn.close()

@app.route("/get-values", methods=['GET'])
def get_all():
    try:
        conn = __get_database_connection()
        cur = conn.cursor()
        cur.execute(
            'SELECT * from rest_api_table'
        )
        records = cur.fetchall()
        all_values = ""
        for row in records:
            all_values += row
        return all_values

    except (Exception, db.Error) as error:
        return f"Failed to get values from rest_api_table: {error}"
    finally:
        if conn is not None:
            conn.close()

if __name__ == "__main__":
    app.run(
        host='0.0.0.0',
        port=5000
    )