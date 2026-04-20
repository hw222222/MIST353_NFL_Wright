try:
    from get_db_connection import get_db_connection
except ModuleNotFoundError:
    from API.get_db_connection import get_db_connection


PROCEDURE_NAME = "procGetTeamsForSpecifiedFan"


def get_teams_for_specified_fan(app_user_id):
    if app_user_id in (None, ""):
        raise ValueError("app_user_id is required.")

    connection = get_db_connection()
    if connection is None:
        raise RuntimeError("Unable to connect to the database.")

    try:
        cursor = connection.cursor()
        cursor.execute(f"EXEC {PROCEDURE_NAME} @AppUserID = ?", app_user_id)

        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        return [dict(zip(columns, row)) for row in rows]
    finally:
        connection.close()
