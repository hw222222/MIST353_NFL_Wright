-- Seed data for ConferenceDivision and Team.
-- Run this after the ConferenceDivision and Team tables already exist.

INSERT INTO ConferenceDivision (Conference, Division)
SELECT v.Conference, v.Division
FROM (VALUES
    ('AFC', 'East'),
    ('AFC', 'North'),
    ('AFC', 'South'),
    ('AFC', 'West'),
    ('NFC', 'East'),
    ('NFC', 'North'),
    ('NFC', 'South'),
    ('NFC', 'West')
) AS v(Conference, Division)
WHERE NOT EXISTS (
    SELECT 1
    FROM ConferenceDivision AS cd
    WHERE cd.Conference = v.Conference
      AND cd.Division = v.Division
);

INSERT INTO Team (TeamName, TeamCity, TeamColors, TeamLogo, ConferenceDivisionID)
SELECT
    v.TeamName,
    v.TeamCity,
    v.TeamColors,
    v.TeamLogo,
    cd.ConferenceDivisionID
FROM (VALUES
    ('Buffalo Bills', 'Buffalo', 'Royal Blue, Red, White', 'https://www.nfl.com/teams/buffalo-bills/', 'AFC', 'East'),
    ('Miami Dolphins', 'Miami', 'Aqua, Orange, White', 'https://www.nfl.com/teams/miami-dolphins/', 'AFC', 'East'),
    ('New England Patriots', 'Foxborough', 'Navy, Red, Silver', 'https://www.nfl.com/teams/new-england-patriots/', 'AFC', 'East'),
    ('New York Jets', 'East Rutherford', 'Green, White, Black', 'https://www.nfl.com/teams/new-york-jets/', 'AFC', 'East'),

    ('Baltimore Ravens', 'Baltimore', 'Purple, Black, Gold', 'https://www.nfl.com/teams/baltimore-ravens/', 'AFC', 'North'),
    ('Cincinnati Bengals', 'Cincinnati', 'Black, Orange, White', 'https://www.nfl.com/teams/cincinnati-bengals/', 'AFC', 'North'),
    ('Cleveland Browns', 'Cleveland', 'Brown, Orange, White', 'https://www.nfl.com/teams/cleveland-browns/', 'AFC', 'North'),
    ('Pittsburgh Steelers', 'Pittsburgh', 'Black, Gold, White', 'https://www.nfl.com/teams/pittsburgh-steelers/', 'AFC', 'North'),

    ('Houston Texans', 'Houston', 'Deep Steel Blue, Red, White', 'https://www.nfl.com/teams/houston-texans/', 'AFC', 'South'),
    ('Indianapolis Colts', 'Indianapolis', 'Blue, White', 'https://www.nfl.com/teams/indianapolis-colts/', 'AFC', 'South'),
    ('Jacksonville Jaguars', 'Jacksonville', 'Teal, Black, Gold', 'https://www.nfl.com/teams/jacksonville-jaguars/', 'AFC', 'South'),
    ('Tennessee Titans', 'Nashville', 'Navy, Titan Blue, Red, Silver', 'https://www.nfl.com/teams/tennessee-titans/', 'AFC', 'South'),

    ('Denver Broncos', 'Denver', 'Orange, Navy, White', 'https://www.nfl.com/teams/denver-broncos/', 'AFC', 'West'),
    ('Kansas City Chiefs', 'Kansas City', 'Red, Gold, White', 'https://www.nfl.com/teams/kansas-city-chiefs/', 'AFC', 'West'),
    ('Las Vegas Raiders', 'Las Vegas', 'Silver, Black', 'https://www.nfl.com/teams/las-vegas-raiders/', 'AFC', 'West'),
    ('Los Angeles Chargers', 'Los Angeles', 'Powder Blue, Gold, White', 'https://www.nfl.com/teams/los-angeles-chargers/', 'AFC', 'West'),

    ('Dallas Cowboys', 'Arlington', 'Navy, Silver, White', 'https://www.nfl.com/teams/dallas-cowboys/', 'NFC', 'East'),
    ('New York Giants', 'East Rutherford', 'Blue, Red, White', 'https://www.nfl.com/teams/new-york-giants/', 'NFC', 'East'),
    ('Philadelphia Eagles', 'Philadelphia', 'Midnight Green, Silver, Black', 'https://www.nfl.com/teams/philadelphia-eagles/', 'NFC', 'East'),
    ('Washington Commanders', 'Landover', 'Burgundy, Gold, White', 'https://www.nfl.com/teams/washington-commanders/', 'NFC', 'East'),

    ('Chicago Bears', 'Chicago', 'Navy, Orange, White', 'https://www.nfl.com/teams/chicago-bears/', 'NFC', 'North'),
    ('Detroit Lions', 'Detroit', 'Honolulu Blue, Silver, White', 'https://www.nfl.com/teams/detroit-lions/', 'NFC', 'North'),
    ('Green Bay Packers', 'Green Bay', 'Green, Gold, White', 'https://www.nfl.com/teams/green-bay-packers/', 'NFC', 'North'),
    ('Minnesota Vikings', 'Minneapolis', 'Purple, Gold, White', 'https://www.nfl.com/teams/minnesota-vikings/', 'NFC', 'North'),

    ('Atlanta Falcons', 'Atlanta', 'Black, Red, Silver', 'https://www.nfl.com/teams/atlanta-falcons/', 'NFC', 'South'),
    ('Carolina Panthers', 'Charlotte', 'Process Blue, Black, Silver', 'https://www.nfl.com/teams/carolina-panthers/', 'NFC', 'South'),
    ('New Orleans Saints', 'New Orleans', 'Old Gold, Black, White', 'https://www.nfl.com/teams/new-orleans-saints/', 'NFC', 'South'),
    ('Tampa Bay Buccaneers', 'Tampa', 'Red, Pewter, Orange, Black', 'https://www.nfl.com/teams/tampa-bay-buccaneers/', 'NFC', 'South'),

    ('Arizona Cardinals', 'Glendale', 'Cardinal Red, Black, White', 'https://www.nfl.com/teams/arizona-cardinals/', 'NFC', 'West'),
    ('Los Angeles Rams', 'Los Angeles', 'Royal Blue, Sol, White', 'https://www.nfl.com/teams/los-angeles-rams/', 'NFC', 'West'),
    ('San Francisco 49ers', 'Santa Clara', 'Red, Gold, White', 'https://www.nfl.com/teams/san-francisco-49ers/', 'NFC', 'West'),
    ('Seattle Seahawks', 'Seattle', 'College Navy, Action Green, Wolf Gray', 'https://www.nfl.com/teams/seattle-seahawks/', 'NFC', 'West')
) AS v(TeamName, TeamCity, TeamColors, TeamLogo, Conference, Division)
INNER JOIN ConferenceDivision AS cd
    ON cd.Conference = v.Conference
   AND cd.Division = v.Division
WHERE NOT EXISTS (
    SELECT 1
    FROM Team AS t
    WHERE t.TeamName = v.TeamName
);

SELECT COUNT(*) AS ConferenceDivisionCount FROM ConferenceDivision;
SELECT COUNT(*) AS TeamCount FROM Team;

INSERT INTO AppUser (Firstname, Lastname, Email, [Password], Phone)
SELECT v.Firstname, v.Lastname, v.Email, v.[Password], v.Phone
FROM (VALUES
    ('Tom', 'Brady', 'tom.brady@example.com', 'password123', '555-0101'),
    ('Patrick', 'Mahomes', 'patrick.mahomes@example.com', 'chiefs15', '555-0102'),
    ('Jalen', 'Hurts', 'jalen.hurts@example.com', 'eagles1', '555-0103')
) AS v(Firstname, Lastname, Email, [Password], Phone)
WHERE NOT EXISTS (
    SELECT 1
    FROM AppUser AS au
    WHERE au.Email = v.Email
);

INSERT INTO NFLAdmin (AppUserID)
SELECT au.AppUserID
FROM AppUser AS au
WHERE au.Email = 'tom.brady@example.com'
  AND NOT EXISTS (
      SELECT 1
      FROM NFLAdmin AS na
      WHERE na.AppUserID = au.AppUserID
  );

INSERT INTO NFLFan (AppUserID)
SELECT au.AppUserID
FROM AppUser AS au
WHERE au.Email IN ('patrick.mahomes@example.com', 'jalen.hurts@example.com')
  AND NOT EXISTS (
      SELECT 1
      FROM NFLFan AS nf
      WHERE nf.AppUserID = au.AppUserID
  );

INSERT INTO FanTopTeam (AppUserID, TeamID, PrimaryStatus)
SELECT au.AppUserID, t.TeamID, v.PrimaryStatus
FROM (VALUES
    ('patrick.mahomes@example.com', 'Kansas City Chiefs', 1),
    ('patrick.mahomes@example.com', 'Dallas Cowboys', 0),
    ('jalen.hurts@example.com', 'Philadelphia Eagles', 1),
    ('jalen.hurts@example.com', 'Baltimore Ravens', 0)
) AS v(Email, TeamName, PrimaryStatus)
INNER JOIN AppUser AS au
    ON au.Email = v.Email
INNER JOIN Team AS t
    ON t.TeamName = v.TeamName
WHERE NOT EXISTS (
    SELECT 1
    FROM FanTopTeam AS ftt
    WHERE ftt.AppUserID = au.AppUserID
      AND ftt.TeamID = t.TeamID
);

SELECT COUNT(*) AS AppUserCount FROM AppUser;
SELECT COUNT(*) AS NFLFanCount FROM NFLFan;
SELECT COUNT(*) AS FanTopTeamCount FROM FanTopTeam;
