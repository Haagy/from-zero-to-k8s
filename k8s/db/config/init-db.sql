CREATE DATABASE rest_api_db;
CREATE USER rest_api_user WITH ENCRYPTED PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE rest_api_db TO rest_api_user;
