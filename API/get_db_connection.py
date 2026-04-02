import os
import struct
from pathlib import Path

try:
    import pyodbc
except ModuleNotFoundError:
    pyodbc = None

try:
    from dotenv import load_dotenv
except ModuleNotFoundError:
    load_dotenv = None

try:
    from azure.identity import DeviceCodeCredential
except ModuleNotFoundError:
    DeviceCodeCredential = None

if load_dotenv is not None:
    load_dotenv(dotenv_path=Path(__file__).resolve().parents[1] / ".env")

SQL_COPT_SS_ACCESS_TOKEN = 1256
_DEVICE_CODE_CREDENTIAL = None


def _require_env(name):
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"Missing required environment variable: {name}")
    return value


def _resolve_driver():
    configured_driver = os.getenv("DB_DRIVER")
    if configured_driver:
        return configured_driver

    installed_drivers = pyodbc.drivers()
    preferred_drivers = (
        "ODBC Driver 18 for SQL Server",
        "ODBC Driver 17 for SQL Server",
    )

    for driver in preferred_drivers:
        if driver in installed_drivers:
            return driver

    if installed_drivers:
        raise RuntimeError(
            "No supported SQL Server ODBC driver found. Installed drivers: "
            + ", ".join(installed_drivers)
        )

    raise RuntimeError("No ODBC drivers are installed on this machine.")


def _base_connection_string(server, database):
    driver = _resolve_driver()
    timeout = os.getenv("DB_TIMEOUT", "30")
    encrypt = os.getenv("DB_ENCRYPT", "yes")
    trust_cert = os.getenv("DB_TRUST_SERVER_CERTIFICATE", "no")
    return (
        f"DRIVER={{{driver}}};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"Encrypt={encrypt};"
        f"TrustServerCertificate={trust_cert};"
        f"Connection Timeout={timeout};"
    )


def _connect_with_sql_auth(server, database):
    username = _require_env("DB_USER")
    password = _require_env("DB_PASSWORD")
    connection_string = (
        _base_connection_string(server, database)
        + f"UID={username};PWD={password};"
    )
    return pyodbc.connect(connection_string)


def _connect_with_device_code(server, database):
    if DeviceCodeCredential is None:
        raise RuntimeError(
            "Azure device-code authentication requires the 'azure-identity' package."
        )

    global _DEVICE_CODE_CREDENTIAL
    tenant_id = os.getenv("AZURE_TENANT_ID")
    if _DEVICE_CODE_CREDENTIAL is None:
        if tenant_id:
            _DEVICE_CODE_CREDENTIAL = DeviceCodeCredential(tenant_id=tenant_id)
        else:
            _DEVICE_CODE_CREDENTIAL = DeviceCodeCredential()

    token = _DEVICE_CODE_CREDENTIAL.get_token(
        "https://database.windows.net/.default"
    )
    token_bytes = token.token.encode("utf-16-le")
    token_struct = struct.pack("<I", len(token_bytes)) + token_bytes
    connection_string = _base_connection_string(server, database)
    return pyodbc.connect(
        connection_string,
        attrs_before={SQL_COPT_SS_ACCESS_TOKEN: token_struct},
    )


def get_db_connection():
    if pyodbc is None:
        raise RuntimeError("Database connections require the 'pyodbc' package.")

    server = _require_env("DB_SERVER")
    database = _require_env("DB_NAME")
    auth_mode = os.getenv("DB_AUTH_MODE", "entra").strip().lower()

    try:
        if auth_mode in {"entra", "device_code"}:
            if _DEVICE_CODE_CREDENTIAL is None:
                print("Using Microsoft Entra device-code authentication.")
            else:
                print("Using cached Microsoft Entra credential.")
            connection = _connect_with_device_code(server, database)
        elif auth_mode == "sql":
            print("Using SQL username/password authentication.")
            connection = _connect_with_sql_auth(server, database)
        else:
            raise RuntimeError(
                "Unsupported DB_AUTH_MODE. Use 'entra' or 'sql'."
            )
        print("Database connection successful.")
        return connection
    except Exception as exc:
        print(f"Error connecting to database: {exc}")
        return None


def get_db_connections():
    return get_db_connection()
