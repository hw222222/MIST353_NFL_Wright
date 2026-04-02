import pandas as pd
import requests
import streamlit as st

FASTAPI_URL = "http://localhost:8000"
REQUEST_TIMEOUT_SECONDS = 60


def fetch_data(endpoint: str, input_params: dict | None = None):
    try:
        response = requests.get(
            f"{FASTAPI_URL}/{endpoint}",
            params=input_params or {},
            timeout=REQUEST_TIMEOUT_SECONDS,
        )
    except requests.RequestException as exc:
        st.error(f"Unable to reach the API: {exc}")
        return None

    if response.status_code == 200:
        payload = response.json()
        if isinstance(payload, list):
            return pd.DataFrame(payload)
        rows = payload.get("data", [])
        return pd.DataFrame(rows)

    detail = ""
    try:
        detail = response.json().get("detail", "")
    except ValueError:
        detail = response.text

    st.error(f"Error fetching data ({response.status_code}): {detail}")
    return None
