go


select TeamName, Conference, Division
from Team T inner join ConferenceDivision CD
    on T.ConferenceDivisionID = CD.ConferenceDivisionID
order by TeamName;