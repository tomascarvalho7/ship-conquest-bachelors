create schema dbo;

CREATE TABLE dbo.User
(
    id varchar(30) NOT NULL,
    username varchar(16) not null,
    name VARCHAR(24) NOT NULL,
    email varchar(60) CHECK(email LIKE '%@%') NOT null UNIQUE,
    imageUrl varchar(500),
    description varchar(100),
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
  uid varchar(30) not null,
  username varchar(16) not null,
  creationTime bigint not null,
  PRIMARY KEY (tag),
  FOREIGN KEY (uid) REFERENCES dbo.User(id)
);

CREATE TABLE dbo.Game
(
  map jsonb NOT NULL,
  tag VARCHAR(6) NOT NULL,
  PRIMARY KEY (tag),
  FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.Lobby_User (
  tag varchar(6),
  uid varchar(30),
  PRIMARY KEY (tag, uid),
  FOREIGN KEY (uid) REFERENCES dbo.User(id),
  FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.Favorite_Lobbies (
  tag varchar(6),
  uid varchar(30),
  PRIMARY KEY (tag, uid),
  FOREIGN KEY (uid) REFERENCES dbo.User(id),
  FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.PatchNotes (
  title varchar(30),
  details varchar(500),
  PRIMARY KEY (title)
);

CREATE TABLE dbo.Ship
(
    shipId serial NOT null,
    gameTag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
    PRIMARY KEY (gameTag, uid, shipId),
    FOREIGN KEY (uid) REFERENCES dbo.User(id),
    FOREIGN KEY (gameTag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.ShipPath
(
	pid serial not null,
	gameTag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
	sid int not null,
	points jsonb NOT NULL,
	startTime int,
	duration interval,
	PRIMARY KEY (pid),
	FOREIGN KEY (sid, gameTag, uid) REFERENCES dbo.Ship(shipId, gameTag, uid)
);


CREATE TABLE dbo.Event
(
    tag varchar(6) NOT NULL,
    eid serial,
    instant int NOT NULL,
    PRIMARY KEY (tag, eid),
    FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag)
);

CREATE TABLE dbo.FightEvent
(
    sidA INT NOT NULL,
    sidB INT NOT NULL,
    winner INT NOT NULL
) INHERITS (dbo.Event);

CREATE TABLE dbo.IslandEvent
(
    sid INT NOT NULL,
    islandId INT NOT NULL
) INHERITS (dbo.Event);

CREATE TABLE dbo.Island
(
    tag varchar(6) NOT NULL,
    islandId INT GENERATED ALWAYS AS IDENTITY,
    x INT NOT NULL,
    y INT NOT NULL,
    radius INT NOT NULL,
    incomePerHour INT,
    uid varchar(30),
    instant INT,
    FOREIGN KEY (uid) REFERENCES dbo.User(id),
    PRIMARY KEY (tag, islandId),
    FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag)
);
CREATE TABLE dbo.OwnedIsland
(
    incomePerHour INT NOT NULL,
    uid varchar(30) NOT NULL,
    instant INT NOT NULL,
    FOREIGN KEY (uid) REFERENCES dbo.User(id)
) INHERITS (dbo.Island);

CREATE TABLE dbo.PlayerStatistics(
    tag varchar(6) NOT NULL,
    uid varchar(30) NOT NULL,
    staticCurrency INT NOT NULL,
    PRIMARY KEY (tag, uid),
    FOREIGN KEY (tag) REFERENCES dbo.Lobby(tag),
    FOREIGN KEY (uid) REFERENCES dbo.User(id)
);