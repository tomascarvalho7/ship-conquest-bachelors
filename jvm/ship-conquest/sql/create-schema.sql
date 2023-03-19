create schema dbo;

CREATE TABLE dbo.user
(
    gid INT NOT NULL,
    name VARCHAR(24) NOT NULL,
    email varchar(60) CHECK(email LIKE '%@%') NOT null UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE dbo.Token
(
    token varchar(256) not null primary key,
    uid int not null,
    FOREIGN KEY (uid) REFERENCES dbo.user(gid)
)

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
  FOREIGN KEY (tag) REFERENCES Lobby(tag)
);