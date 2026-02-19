USE MIST353_NFL_RDB_Wright;
GO

-- 1. Insert Conference/Division
IF NOT EXISTS (SELECT 1 FROM ConferenceDivision WHERE Conference = 'AFC' AND Division = 'North')
BEGIN
    INSERT INTO ConferenceDivision (Conference, Division)
    VALUES 
    ('AFC', 'North'), ('AFC', 'East'), ('AFC', 'South'), ('AFC', 'West'),
    ('NFC', 'North'), ('NFC', 'East'), ('NFC', 'South'), ('NFC', 'West');
END

-- 2. Ensure Stadiums and Teams exist
IF NOT EXISTS (SELECT 1 FROM Team WHERE TeamName = 'Pittsburgh Steelers')
BEGIN
    INSERT INTO Stadium (Location) VALUES ('Acrisure Stadium, Pittsburgh, PA');
    DECLARE @StadiumID INT = SCOPE_IDENTITY();

    INSERT INTO Team (TeamName, TeamCity, TeamColors, ConferenceDivisionID)
    VALUES ('Pittsburgh Steelers', 'Pittsburgh', 'Black and Gold', 1);
    DECLARE @TeamID INT = SCOPE_IDENTITY();

    INSERT INTO TeamStadium (TeamID, StadiumID, StartDate)
    VALUES (@TeamID, @StadiumID, '2001-08-18');
END

-- 3. Final Verification
SELECT 'Teams in DB' AS Status, TeamName, TeamCity FROM Team;
SELECT 'Users in DB' AS Status, Firstname, Lastname, Email FROM AppUser;

-- 4. Re-run the Join to see the relationships
SELECT 
    t.TeamName, 
    cd.Conference, 
    cd.Division, 
    s.Location AS HomeStadium
FROM Team t
JOIN ConferenceDivision cd ON t.ConferenceDivisionID = cd.ConferenceDivisionID
LEFT JOIN TeamStadium ts ON t.TeamID = ts.TeamID
LEFT JOIN Stadium s ON ts.StadiumID = s.StadiumID;