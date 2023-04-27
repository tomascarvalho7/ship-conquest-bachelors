create schema dbo;

CREATE TABLE dbo.User
(
    id varchar(30) NOT NULL,
    name VARCHAR(24) NOT NULL,
    email varchar(60) CHECK(email LIKE '%@%') NOT null UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE dbo.Token
(
    token varchar(256) not null primary key,
    uid varchar(30) not null,
    FOREIGN KEY (uid) REFERENCES dbo.user(id)
);

CREATE TABLE dbo.Lobby
(
  tag VARCHAR(6) NOT NULL,
  name VARCHAR(26) NOT NULL,
  PRIMARY KEY (tag)
);

CREATE TABLE dbo.Game
(
  map jsonb NOT NULL,
  tag VARCHAR(6) NOT NULL,
  PRIMARY KEY (tag),
  FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.VisitedPoints
(
    gameTag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
    points jsonb,
    PRIMARY KEY (gameTag, uid),
    FOREIGN KEY (uid) REFERENCES dbo.User(id),
    FOREIGN KEY (gameTag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.ShipPath
(
    gameTag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
    shipId varchar(30) NOT null,
    landmarks jsonb,
    startTime timestamp,
    duration interval,
    PRIMARY KEY (gameTag, uid, shipId),
    FOREIGN KEY (uid) REFERENCES dbo.User(id),
    FOREIGN KEY (gameTag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.ShipPosition
(
    gameTag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
    shipId varchar(30) NOT null,
    static_position jsonb,
    PRIMARY KEY (gameTag, uid, shipId),
    FOREIGN KEY (uid) REFERENCES dbo.User(id),
    FOREIGN KEY (gameTag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.Island
(
    tag varchar(6) NOT NULL,
    islandId INT GENERATED ALWAYS AS IDENTITY,
    x INT NOT NULL,
    y INT NOT NULL,
    radius INT NOT NULL,
    incomePerHour INT,
    uid varchar(30),
    PRIMARY KEY (tag, islandId),
    FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag),
    FOREIGN KEY (uid) REFERENCES dbo.User(id)
);

CREATE TABLE dbo.PlayerStatistics(
    tag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
    currency INT NOT NULL,
    maxCurrency INT NOT NULL,
    PRIMARY KEY (tag, uid),
    FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag),
    FOREIGN KEY (uid) REFERENCES dbo.User(id)
)