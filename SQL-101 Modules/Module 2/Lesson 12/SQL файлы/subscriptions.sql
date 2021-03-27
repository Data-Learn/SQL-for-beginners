CREATE TABLE IF NOT EXISTS magazine."subscriptions" (
    "subscription_id" INT,
    "description" TEXT,
    "price_per_month" INT,
    "subscription_length" TEXT
);
INSERT INTO magazine."subscriptions" VALUES
    (1,'Politics Magazine',10,'12 months'),
    (2,'Politics Magazine',11,'6 months'),
    (3,'Politics Magazine',12,'3 months'),
    (4,'Fashion Magazine',15,'12 months'),
    (5,'Fashion Magazine',17,'6 months'),
    (6,'Fashion Magazine',19,'3 months'),
    (7,'Sports Magazine',11,'12 months'),
    (8,'Sports Magazine',12,'6 months'),
    (9,'Sports Magazine',13,'3 months');
