/*
Building an Inventory Database with PostgreSQL
In this project you’ll build out a database schema 
that could be used to organize an inventory of 
mechanical parts. This schema will keep track of 
all the parts, their manufacturer, category, location 
in storeroom, available inventory, and other relevant 
information.
*/

DROP SCHEMA IF EXISTS cc_user CASCADE;
CREATE SCHEMA cc_user;
SET search_path = cc_user;

CREATE TABLE cc_user.parts (
    id integer,
    description character varying,
    code character varying,
    manufacturer_id  integer
);

CREATE TABLE cc_user.locations (
    id integer,
    part_id integer,
    location varchar(3),
    qty integer
);

create table cc_user.manufacturers (
    id integer PRIMARY KEY,
    name varchar
);

create table cc_user.reorder_options (
  id integer PRIMARY KEY,
  part_id integer,
  price_usd numeric(8,2),
  quantity integer
);


\copy cc_user.parts FROM 'parts.csv' delimiter ',' NULL AS 'NULL' csv header
\copy cc_user.locations FROM 'locations.csv' delimiter ',' NULL AS 'NULL' csv header
\copy cc_user.manufacturers FROM 'manufacturers.csv' delimiter ',' NULL AS 'NULL' csv header
\copy cc_user.reorder_options FROM 'reorder_options.csv' delimiter ',' NULL AS 'NULL' csv header

--SQL queries
SELECT *
FROM parts
LIMIT 10;

ALTER TABLE parts
ALTER COLUMN code SET NOT NULL;

ALTER TABLE parts
Add UNIQUE(code);

UPDATE parts
SET description = 'Cannot be missing'
WHERE description IS NULL;

INSERT INTO parts (id, code, manufacturer_id) VALUES (54, 'V1-009', 9);

ALTER TABLE reorder_options
ALTER COLUMN price_usd SET NOT NULL;

ALTER TABLE reorder_options
ALTER COLUMN quantity SET NOT NULL;

ALTER TABLE reorder_options
ADD CHECK (price_usd > 0 AND quantity> 0);

ALTER TABLE reorder_options
ADD CHECK (price_usd/quantity > 0.02 AND price_usd/quantity < 25.00);

ALTER TABLE parts
ADD PRIMARY KEY (id);

ALTER TABLE reorder_options
ADD FOREIGN KEY (part_id) REFERENCES parts(id);

ALTER TABLE locations
ADD CHECK (qty > 0);

ALTER TABLE locations
ADD UNIQUE (part_id, location);

ALTER TABLE locations
ADD FOREIGN KEY (part_id) REFERENCES parts (id);

ALTER TABLE parts
ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (id);

INSERT INTO manufacturers(name, id)
VALUES ('Pip -NNC Industrial', 11);

UPDATE parts
SET manufacturer_id = 11
WHERE manufacturer_id = 0 OR manufacturer_id = 1;
