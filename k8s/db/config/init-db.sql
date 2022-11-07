CREATE DATABASE rest-api-db;
CREATE USER rest-api-user WITH ENCRYPTED PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE rest-api-db TO rest-api-user;