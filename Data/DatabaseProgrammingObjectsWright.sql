CREATE OR ALTER PROCEDURE procGetTeamsByConferenceDivision
(
    @ConferenceName NVARCHAR(50) = NULL,
    @DivisionName NVARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T.TeamName,
        T.TeamColors,
        CD.Conference,
        CD.Division
    FROM Team AS T
    INNER JOIN ConferenceDivision AS CD
        ON T.ConferenceDivisionID = CD.ConferenceDivisionID
    WHERE (@ConferenceName IS NULL OR CD.Conference = @ConferenceName)
      AND (@DivisionName IS NULL OR CD.Division = @DivisionName)
    ORDER BY T.TeamName;
END;
GO

CREATE OR ALTER PROCEDURE procGetTeamsInSameConferenceDivisionAsSpecifiedTeam
(
    @TeamName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        OtherTeam.TeamName,
        OtherTeam.TeamColors,
        CD.Conference,
        CD.Division
    FROM Team AS SpecifiedTeam
    INNER JOIN ConferenceDivision AS CD
        ON SpecifiedTeam.ConferenceDivisionID = CD.ConferenceDivisionID
    INNER JOIN Team AS OtherTeam
        ON OtherTeam.ConferenceDivisionID = CD.ConferenceDivisionID
    WHERE SpecifiedTeam.TeamName = @TeamName
      AND OtherTeam.TeamName <> @TeamName
    ORDER BY OtherTeam.TeamName;
END;
GO

CREATE OR ALTER PROCEDURE procValidateUser
(
    @Email NVARCHAR(100),
    @Password NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        AU.AppUserID,
        CONCAT(AU.Firstname, ' ', AU.Lastname) AS Fullname,
        CASE
            WHEN NA.AppUserID IS NOT NULL THEN 'Admin'
            WHEN NF.AppUserID IS NOT NULL THEN 'Fan'
            ELSE 'User'
        END AS UserRole
    FROM AppUser AS AU
    LEFT JOIN NFLAdmin AS NA
        ON AU.AppUserID = NA.AppUserID
    LEFT JOIN NFLFan AS NF
        ON AU.AppUserID = NF.AppUserID
    WHERE AU.Email = @Email
      AND AU.[Password] = @Password;
END;
GO

CREATE OR ALTER PROCEDURE procGetTeamsForSpecifiedFan
(
    @AppUserID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T.TeamName,
        T.TeamColors,
        CD.Conference,
        CD.Division,
        FTT.PrimaryStatus
    FROM FanTopTeam AS FTT
    INNER JOIN Team AS T
        ON FTT.TeamID = T.TeamID
    INNER JOIN ConferenceDivision AS CD
        ON T.ConferenceDivisionID = CD.ConferenceDivisionID
    WHERE FTT.AppUserID = @AppUserID
    ORDER BY FTT.PrimaryStatus DESC, T.TeamName;
END;
GO
