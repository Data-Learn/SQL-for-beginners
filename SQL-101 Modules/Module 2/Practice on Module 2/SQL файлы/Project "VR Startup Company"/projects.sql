CREATE TABLE IF NOT EXISTS vr_startup."projects" (
    "project_id" INT,
    "project_name" TEXT,
    "start_date" TIMESTAMP,
    "end_date" TIMESTAMP
);
INSERT INTO vr_startup."projects" VALUES
    (1,'AlienInvasion','2021-01-09 00:00:00','2022-06-30 00:00:00'),
    (2,'RocketRush','2021-01-26 00:00:00','2022-12-14 00:00:00'),
    (3,'ZombieStorm','2021-05-08 00:00:00','2022-10-02 00:00:00'),
    (4,'BravoBoxing','2021-06-21 00:00:00','2022-07-10 00:00:00'),
    (5,'ExtremeJets','2021-05-20 00:00:00','2022-04-07 00:00:00'),
    (6,'MMA2K','2021-01-06 00:00:00','2022-08-08 00:00:00'),
    (7,'FistsOfFury','2021-01-19 00:00:00','2022-10-30 00:00:00'),
    (8,'CycleScenes','2021-06-18 00:00:00','2022-08-21 00:00:00'),
    (9,'CarnivalCoasters','2021-05-03 00:00:00','2022-05-10 00:00:00'),
    (10,'SparkPoint','2021-03-15 00:00:00','2022-05-02 00:00:00');
