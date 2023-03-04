create schema dbo;

CREATE TABLE dbo.user
(
  username VARCHAR(24) NOT NULL,
  id INT NOT NULL,
  PRIMARY KEY (id)
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
  FOREIGN KEY (tag) REFERENCES Lobby(tag)
);