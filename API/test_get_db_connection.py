import os
from pathlib import Path

import pyodbc
from dotenv import load_dotenv
from get_db_connection import get_db_connection

load_dotenv(dotenv_path=Path(__file__).resolve().parents[1] / ".env")



def test_get_db_connection():

  # Test 1: Check env vars are loaded
  assert os.getenv("DB_AUTH_MODE") == "entra", "Expected DB_AUTH_MODE=entra"
  print("✅ Required .env values are loaded")



  # Test 2: Connection returns a pyodbc.Connection object

  conn = get_db_connection()

  assert isinstance(conn, pyodbc.Connection), "Expected a pyodbc.Connection"

  print("✅ Connection object returned")



  # Test 3: Connection is usable (run a simple query)

  cursor = conn.cursor()

  cursor.execute("SELECT 1")

  result = cursor.fetchone()

  assert result[0] == 1, "Expected query result of 1"

  print("✅ Connection is live and queryable")



  conn.close()

  print("✅ Connection closed cleanly")

  print("\n🎉 All tests passed!")



if __name__ == "__main__":

  test_get_db_connection()
