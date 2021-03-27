CREATE TABLE IF NOT EXISTS songify."plans" (
    "description" TEXT,
    "id" INT,
    "price" INT
);
INSERT INTO songify."plans" VALUES
    ('unlimited songs',1,20),
    ('unlimited songs - promotional rate',2,10),
    ('limited songs per month',3,5);
