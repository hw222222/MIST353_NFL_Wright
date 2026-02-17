-- create a database for NFL app
use master;
-- use database NFL_RDB_Lastname;
use MIST353_NFL_RDB_Wright;

-- create tables for first iteration

-- create TABLE ConferenceDivision (
--     ConferenceDivisionID INT identity(1,1)
--         constraint PK_ConferenceDivision PRIMARY KEY,
--     Conference NVARCHAR(50) NOT NULL
--         CONSTRAINT CK_ConferenceNames CHECK (Conference IN ('AFC', 'NFC')),
--     Division NVARCHAR(50) NOT NULL
--         constraint CK_DivisionNames CHECK (Division IN ('East', 'North', 'South', 'West'))
-- )

-- create TABLE Team (
--     TeamID INT identity(1,1) 
--         constraint PK_Team PRIMARY KEY,
--     TeamName NVARCHAR(50) NOT NULL,
--     city VARCHAR(50) NOT NULL
-- );

-- -- 1. Create Base User Table
-- CREATE TABLE AppUser (
--     AppUserID INT PRIMARY KEY IDENTITY(1,1),
--     Firstname NVARCHAR(50),
--     Lastname NVARCHAR(50),
--     Email NVARCHAR(100) UNIQUE,
--     Password NVARCHAR(255),
--     Phone NVARCHAR(20)
-- );

-- 2. Create Sub-types for AppUser (Inheritance)
CREATE TABLE NFLAdmin (
    AppUserID INT PRIMARY KEY,
    FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);

CREATE TABLE NFLFan (
    AppUserID INT PRIMARY KEY,
    FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);

-- 3. Create Conference/Division Lookup
CREATE TABLE ConferenceDivision (
    ConferenceDivisionID INT PRIMARY KEY IDENTITY(1,1),
    Conference NVARCHAR(50),
    Division NVARCHAR(50),
);

-- 4. Create Stadium Table
CREATE TABLE Stadium (
    StadiumID INT PRIMARY KEY IDENTITY(1,1),
    Location NVARCHAR(100)
);

-- 5. Create Team Table
CREATE TABLE Team (
    TeamID INT PRIMARY KEY IDENTITY(1,1),
    TeamName NVARCHAR(100),
    TeamCity NVARCHAR(100),
    TeamColors NVARCHAR(100),
    TeamLogo NVARCHAR(MAX), -- URL or Path
    ConferenceDivisionID INT,
    FOREIGN KEY (ConferenceDivisionID) REFERENCES ConferenceDivision(ConferenceDivisionID)
);

-- 6. Create Game Table
CREATE TABLE Game (
    GameID INT PRIMARY KEY IDENTITY(1,1),
    GameDate DATE,
    GameStartTime TIME,
    GameEndTime TIME,
    HomeTeamScore INT DEFAULT 0,
    StadiumID INT,
    FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

-- 7. Create AdminUpdate (Audit Table)
CREATE TABLE AdminUpdate (
    AdminUpdateID INT PRIMARY KEY IDENTITY(1,1),
    UpdateTime TIME,
    UpdateDate DATE,
    UpdateType NVARCHAR(50),
    UpdatedValues NVARCHAR(MAX),
    AppUserID INT, -- Link to NFLAdmin
    FOREIGN KEY (AppUserID) REFERENCES NFLAdmin(AppUserID)
);

-- 8. Junction Tables for Relationships

-- Linking Fans to their Top Teams
CREATE TABLE FanTopTeam (
    FanTeamID INT PRIMARY KEY IDENTITY(1,1),
    AppUserID INT,
    TeamID INT,
    PrimaryStatus BIT, -- Representing 'Primary'
    FOREIGN KEY (AppUserID) REFERENCES NFLFan(AppUserID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

-- Linking Teams to Stadiums (Many-to-Many via TeamStadium)
CREATE TABLE TeamStadium (
    TeamStadiumID INT PRIMARY KEY IDENTITY(1,1),
    TeamID INT,
    StadiumID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

-- Recursive or Many-to-Many: Team Plays (Another Team)
-- Usually implemented as a junction between Teams and Games
CREATE TABLE TeamGame (
    TeamID INT,
    GameID INT,
    IsHomeTeam BIT,
    Score INT,
    PRIMARY KEY (TeamID, GameID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID)
);