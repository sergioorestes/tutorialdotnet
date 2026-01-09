-- psql -d "postgres://postgres:postgres@localhost:5432/postgres"

SET ROLE postgres;

CREATE EXTENSION vector;
CREATE EXTENSION IF NOT EXISTS ai CASCADE;

\dx
\q