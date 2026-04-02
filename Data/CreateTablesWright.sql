-- Run this while connected to the target database:
-- MIST353_NFL_RDB_Wright

DROP TABLE IF EXISTS TeamGame;
DROP TABLE IF EXISTS TeamStadium;
DROP TABLE IF EXISTS FanTopTeam;
DROP TABLE IF EXISTS AdminUpdate;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Stadium;
DROP TABLE IF EXISTS ConferenceDivision;
DROP TABLE IF EXISTS NFLFan;
DROP TABLE IF EXISTS NFLAdmin;
DROP TABLE IF EXISTS AppUser;
GO

CREATE TABLE AppUser (
    AppUserID INT PRIMARY KEY IDENTITY(1,1),
    Firstname NVARCHAR(50),
    Lastname NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    [Password] NVARCHAR(255),
    Phone NVARCHAR(20)
);
GO

CREATE TABLE NFLAdmin (
    AppUserID INT PRIMARY KEY,
    FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);
GO

CREATE TABLE NFLFan (
    AppUserID INT PRIMARY KEY,
    FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);
GO

CREATE TABLE ConferenceDivision (
    ConferenceDivisionID INT PRIMARY KEY IDENTITY(1,1),
    Conference NVARCHAR(50) NOT NULL,
    Division NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Stadium (
    StadiumID INT PRIMARY KEY IDENTITY(1,1),
    Location NVARCHAR(100)
);
GO

CREATE TABLE Team (
    TeamID INT PRIMARY KEY IDENTITY(1,1),
    TeamName NVARCHAR(100) NOT NULL,
    TeamCity NVARCHAR(100),
    TeamColors NVARCHAR(100),
    TeamLogo NVARCHAR(MAX),
    ConferenceDivisionID INT NOT NULL,
    FOREIGN KEY (ConferenceDivisionID) REFERENCES ConferenceDivision(ConferenceDivisionID)
);
GO

CREATE TABLE Game (
    GameID INT PRIMARY KEY IDENTITY(1,1),
    GameDate DATE,
    GameStartTime TIME,
    GameEndTime TIME,
    HomeTeamScore INT DEFAULT 0,
    StadiumID INT,
    FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);
GO

CREATE TABLE AdminUpdate (
    AdminUpdateID INT PRIMARY KEY IDENTITY(1,1),
    UpdateTime TIME,
    UpdateDate DATE,
    UpdateType NVARCHAR(50),
    UpdatedValues NVARCHAR(MAX),
    AppUserID INT,
    FOREIGN KEY (AppUserID) REFERENCES NFLAdmin(AppUserID)
);
GO

CREATE TABLE FanTopTeam (
    FanTeamID INT PRIMARY KEY IDENTITY(1,1),
    AppUserID INT,
    TeamID INT,
    PrimaryStatus BIT,
    FOREIGN KEY (AppUserID) REFERENCES NFLFan(AppUserID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);
GO

CREATE TABLE TeamStadium (
    TeamStadiumID INT PRIMARY KEY IDENTITY(1,1),
    TeamID INT,
    StadiumID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);
GO

CREATE TABLE TeamGame (
    TeamID INT,
    GameID INT,
    IsHomeTeam BIT,
    Score INT,
    PRIMARY KEY (TeamID, GameID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID)
);
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN (
    'AppUser',
    'NFLAdmin',
    'NFLFan',
    'ConferenceDivision',
    'Stadium',
    'Team',
    'Game',
    'AdminUpdate',
    'FanTopTeam',
    'TeamStadium',
    'TeamGame'
)
ORDER BY TABLE_NAME;
