create schema dbo;

CREATE TABLE dbo.User
(
    id varchar(30) NOT NULL,
    name VARCHAR(24) NOT NULL,
    email varchar(60) CHECK(email LIKE '%@%') NOT null UNIQUE,
    imageUrl varchar(500),
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

CREATE TABLE dbo.Lobby_User (
  lobby_tag varchar(6),
  uid varchar(30),
  PRIMARY KEY (lobby_tag, uid),
  FOREIGN KEY (uid) REFERENCES dbo.User(id),
  FOREIGN KEY (lobby_tag) REFERENCES dbo.Lobby(tag)
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

CREATE TABLE dbo.Ship
(
    shipId serial NOT null,
    gameTag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
    pos_info jsonb,
    PRIMARY KEY (gameTag, uid, shipId),
    FOREIGN KEY (uid) REFERENCES dbo.User(id),
    FOREIGN KEY (gameTag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.WildIsland
(
    tag varchar(6) NOT NULL,
    islandId INT GENERATED ALWAYS AS IDENTITY,
    x INT NOT NULL,
    y INT NOT NULL,
    radius INT NOT NULL,
    PRIMARY KEY (tag, islandId),
    FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.OwnedIsland
(
    tag varchar(6) NOT NULL,
    islandId INT NOT NULL,
    x INT NOT NULL,
    y INT NOT NULL,
    radius INT NOT NULL,
    incomePerHour INT NOT NULL,
    uid varchar(30) NOT NULL,
    instant INT NOT NULL,
    PRIMARY KEY (tag, islandId),
    FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag),
    FOREIGN KEY (uid) REFERENCES dbo.User(id)
);

CREATE TABLE dbo.PlayerStatistics(
    tag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
    staticCurrency INT NOT NULL,
    PRIMARY KEY (tag, uid),
    FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag),
    FOREIGN KEY (uid) REFERENCES dbo.User(id)
);