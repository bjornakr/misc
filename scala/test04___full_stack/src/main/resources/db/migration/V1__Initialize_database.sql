CREATE TABLE zerg (
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(256),
    type    VARCHAR(256),
    health  SMALLINT
);


INSERT INTO zerg (name, type, health)
VALUES
    ('Gork Bufflestock', 'Zergling', 100),
    ('Tobby Gorbmush', 'Hydralisk', 200),
    ('Swanson Ludicruft', 'Mutalisk', 340),
    ('Anton Burgerud', 'Ultralisk', 999)
    ;