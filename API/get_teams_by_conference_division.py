try:
    from get_db_connection import get_db_connection
except ModuleNotFoundError:
    from API.get_db_connection import get_db_connection


PROCEDURE_NAME = "procGetTeamsByConferenceDivision"



def get_teams_by_conference_division(conference_name=None, division_name=None):
    connection = get_db_connection()
    if connection is None:
        raise RuntimeError("Unable to connect to the database.")

    try:
        cursor = connection.cursor()
        cursor.execute(
            f"EXEC {PROCEDURE_NAME} @ConferenceName = ?, @DivisionName = ?",
            conference_name,
            division_name,
        )

        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        return [dict(zip(columns, row)) for row in rows]
    finally:
        connection.close()
