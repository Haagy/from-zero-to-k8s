import os
import socket
import psycopg2 as db
from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return f"Hello! Greetings from Pod: {socket.gethostname()}"

def get_connection_string():
    db_name = os.getenv("POSTGRES_DB")
    db_user = os.getenv("POSTGRES_USER")

    with open('/secrets/DATABASE_PASSWORD', 'r') as f:
        db_pass = f.read()

    db_host = os.getenv("POSTGRES_HOST")
    db_port = os.getenv("POSTGRES_PORT", 5432)

    return f'postgresql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}'

@app.route("/write")
def write2table():
    conn = db.connect(
        host=os.getenv("POSTGRES_HOST"),
        database=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD")
    )
    # return "Created table 'RNG'"
    return "Table already exists"

if __name__ == "__main__":
    app.run(
        host='0.0.0.0',
        port=5000
    )