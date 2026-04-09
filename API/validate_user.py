try:
    from get_db_connection import get_db_connection
except ModuleNotFoundError:
    from API.get_db_connection import get_db_connection


PROCEDURE_NAME = "procValidateUser"


def validate_user(email, password):
    if not email:
        raise ValueError("email is required.")
    if not password:
        raise ValueError("password is required.")

    connection = get_db_connection()
    if connection is None:
        raise RuntimeError("Unable to connect to the database.")

    try:
        cursor = connection.cursor()
        cursor.execute(
            f"EXEC {PROCEDURE_NAME} @Email = ?, @Password = ?",
            email,
            password,
        )

        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        return [dict(zip(columns, row)) for row in rows]
    finally:
        connection.close()
