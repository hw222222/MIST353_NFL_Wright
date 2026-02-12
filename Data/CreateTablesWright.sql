-- create a database for NFL app
-- create database NFL_RDB_Lastname;
use MIST353_NFL_RDB_Wright;

-- create tables for first iteration

create TABLE ConferenceDivision (
    ConferenceDivisionID INT identity(1,1)
        constraint PK_ConferenceDivision PRIMARY KEY,
    Conference NVARCHAR(50) NOT NULL
        CONSTRAINT CK_ConferenceNames CHECK (Conference IN ('AFC', 'NFC')),
    Division NVARCHAR(50) NOT NULL
        constraint CK_DivisionNames CHECK (Division IN ('East', 'North', 'South', 'West'))
)

create TABLE Team (
    TeamID INT identity(1,1) 
        constraint PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);
