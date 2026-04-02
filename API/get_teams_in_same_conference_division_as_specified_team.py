try:
    from get_db_connection import get_db_connection
except ModuleNotFoundError:
    from API.get_db_connection import get_db_connection


PROCEDURE_NAME = "procGetTeamsInSameConferenceDivisionAsSpecifiedTeam"



def get_teams_in_same_conference_division_as_specified_team(team_name):
    if not team_name:
        raise ValueError("team_name is required.")

    connection = get_db_connection()
    if connection is None:
        raise RuntimeError("Unable to connect to the database.")

    try:
        cursor = connection.cursor()
        cursor.execute(f"EXEC {PROCEDURE_NAME} @TeamName = ?", team_name)

        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        return [dict(zip(columns, row)) for row in rows]
    finally:
        connection.close()
