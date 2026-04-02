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
