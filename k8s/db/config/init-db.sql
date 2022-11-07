CREATE DATABASE rest_api_db;
CREATE USER rest_api_user WITH ENCRYPTED PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE rest_api_db TO rest_api_user;

CREATE TABLE rest_api_table (
	ID serial PRIMARY KEY,
	SOME_VALUE VARCHAR (255) UNIQUE NOT NULL
);

GRANT ALL PRIVILEGES ON TABLE rest_api_table TO rest_api_user;